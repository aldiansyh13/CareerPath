// Alat QA manual (peran D): menjalankan 5 skenario uji AI terhadap Gemini asli.
// Tidak pernah mencetak API key atau isi respons mentah.
//
// Pakai:
//   dart run tool/qa_live_gemini.dart
//
// Membaca GEMINI_API_KEY & GEMINI_MODEL dari .env di root repo (file gitignored).
// Keluar dengan kode 1 bila ada skenario yang gagal validasi/koneksi.

import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:careerpath_ai/data/careers.dart';
import 'package:careerpath_ai/data/questions.dart';
import 'package:careerpath_ai/data/skills.dart';
import 'package:careerpath_ai/utils/validators.dart';

const _systemPrompt = 'Kamu adalah konselor karier untuk mahasiswa Indonesia.\n'
    'Analisis profil, minat, dan skill pengguna, lalu beri 3 rekomendasi karier.\n'
    'Aturan:\n'
    '- Jawab dalam Bahasa Indonesia.\n'
    '- Hanya pilih dari daftar karier yang diberikan.\n'
    '- match_score berupa angka 0-100 dan tidak semua boleh 100.\n'
    '- Alasan harus merujuk pada data pengguna, bukan klaim umum.\n'
    '- Roadmap 4 tahap (week 1 sampai 4), tiap minggu punya actions konkret, realistis untuk mahasiswa.\n'
    '- Jangan menjanjikan gaji atau jaminan diterima kerja.\n'
    '- Keluarkan HANYA JSON valid sesuai format yang diminta.';

/// Ringkasan pesan error API untuk diagnosis, tanpa mencetak isi respons mentah
/// atau kredensial.
String _apiErrorDetail(String body) {
  try {
    final data = jsonDecode(body);
    if (data is Map<String, dynamic>) {
      final error = data['error'];
      if (error is Map<String, dynamic>) {
        final status = (error['status'] ?? '').toString().trim();
        final message = (error['message'] ?? '')
            .toString()
            .replaceAll(RegExp(r'\s+'), ' ')
            .trim();
        final combined =
            [status, message].where((part) => part.isNotEmpty).join(': ');
        return combined.length > 180
            ? '${combined.substring(0, 180)}...'
            : combined;
      }
    }
  } catch (_) {
    // Abaikan: detail hanya pelengkap laporan.
  }
  return '';
}

String? _argValue(List<String> args, String name) {
  final prefix = '--$name=';
  for (final arg in args) {
    if (arg.startsWith(prefix)) {
      final value = arg.substring(prefix.length).trim();
      if (value.isNotEmpty) return value;
    }
  }
  return null;
}

Map<String, String> _readEnv() {
  final file = File('.env');
  if (!file.existsSync()) {
    stderr.writeln('GAGAL: .env tidak ditemukan di ${Directory.current.path}');
    exit(2);
  }
  final values = <String, String>{};
  for (final line in file.readAsLinesSync()) {
    final trimmed = line.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) continue;
    final eq = trimmed.indexOf('=');
    if (eq <= 0) continue;
    values[trimmed.substring(0, eq).trim()] = trimmed.substring(eq + 1).trim();
  }
  return values;
}

Map<String, dynamic> _input({
  required String name,
  required String major,
  required int semester,
  required int interestOption,
  required int skillValue,
}) {
  return <String, dynamic>{
    'profile': <String, dynamic>{
      'name': name,
      'major': major,
      'semester': semester,
    },
    'interests': <String, dynamic>{
      for (final q in kInterestQuestions)
        q.id: q.options[interestOption % q.options.length],
    },
    'skills': <String, dynamic>{
      for (final s in kSkillItems) s.id: skillValue,
    },
  };
}

String _prompt(Map<String, dynamic> userData) {
  return 'Daftar karier yang boleh dipilih: ${kCareerCatalog.join(', ')}\n\n'
      'Data pengguna:\n${const JsonEncoder.withIndent('  ').convert(userData)}\n\n'
      'Format JSON yang diminta:\n'
      '{"summary": string, "careers": [{"title": string, "match_score": number,'
      '"reason": string, "skills_owned": [string], "skills_missing": [string],'
      '"roadmap": [{"week": number, "title": string, "actions": [string]}]}]}';
}

Future<void> main(List<String> args) async {
  final env = _readEnv();
  final apiKey = env['GEMINI_API_KEY'] ?? '';
  final model = env['GEMINI_MODEL'] ?? '';
  if (apiKey.isEmpty || model.isEmpty) {
    stderr.writeln('GAGAL: GEMINI_API_KEY/GEMINI_MODEL kosong di .env.');
    exit(2);
  }

  // Opsional: `dart run tool/qa_live_gemini.dart --only=1 --timeout=90`
  final onlyArg = _argValue(args, 'only');
  final timeoutArg = _argValue(args, 'timeout');
  final only = onlyArg == null ? null : int.tryParse(onlyArg);
  final timeout = Duration(seconds: int.tryParse(timeoutArg ?? '') ?? 45);

  final scenarios = <MapEntry<String, Map<String, dynamic>>>[
    MapEntry(
      '1. Profil teknis (Informatika, logika/analisis tinggi)',
      _input(
        name: 'QA Teknis',
        major: 'Informatika',
        semester: 5,
        interestOption: 1,
        skillValue: 4,
      )..['skills'] = <String, dynamic>{
          'logic': 5,
          'design': 2,
          'data': 4,
          'communication': 3,
          'coding': 5,
          'leadership': 2,
        },
    ),
    MapEntry(
      '2. Profil kreatif (DKV, desain/komunikasi tinggi)',
      _input(
        name: 'QA Kreatif',
        major: 'Desain Komunikasi Visual',
        semester: 4,
        interestOption: 0,
        skillValue: 4,
      )..['skills'] = <String, dynamic>{
          'logic': 3,
          'design': 5,
          'data': 2,
          'communication': 5,
          'coding': 2,
          'leadership': 3,
        },
    ),
    MapEntry(
      '3. Profil non-teknis (Manajemen, komunikasi/kepemimpinan tinggi)',
      _input(
        name: 'QA Manajemen',
        major: 'Manajemen',
        semester: 6,
        interestOption: 3,
        skillValue: 4,
      )..['skills'] = <String, dynamic>{
          'logic': 3,
          'design': 2,
          'data': 3,
          'communication': 5,
          'coding': 1,
          'leadership': 5,
        },
    ),
    MapEntry(
      '4. Semua skill dinilai 1',
      _input(
        name: 'QA Skill Rendah',
        major: 'Teknik Sipil',
        semester: 2,
        interestOption: 1,
        skillValue: 1,
      ),
    ),
    MapEntry(
      '5. Semua skill dinilai 5',
      _input(
        name: 'QA Skill Tinggi',
        major: 'Sistem Informasi',
        semester: 7,
        interestOption: 1,
        skillValue: 5,
      ),
    ),
  ];

  final client = http.Client();
  var failed = 0;
  var ran = 0;
  var quotaExhausted = false;
  final startedAt = DateTime.now();

  print('Model: $model • katalog ${kCareerCatalog.length} karier • '
      '${scenarios.length} skenario\n');

  for (final scenario in scenarios) {
    final scenarioNumber = int.tryParse(scenario.key.split('.').first);
    if (only != null && scenarioNumber != only) continue;
    ran++;
    final watch = Stopwatch()..start();
    try {
      final response = await client
          .post(
            Uri.parse(
              'https://generativelanguage.googleapis.com/v1beta/models/'
              '$model:generateContent',
            ),
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode(<String, dynamic>{
              'systemInstruction': <String, dynamic>{
                'parts': <Map<String, String>>[
                  {'text': _systemPrompt},
                ],
              },
              'contents': <Map<String, dynamic>>[
                <String, dynamic>{
                  'role': 'user',
                  'parts': <Map<String, String>>[
                    {'text': _prompt(scenario.value)},
                  ],
                },
              ],
              'generationConfig': <String, dynamic>{
                'responseMimeType': 'application/json',
                'temperature': 0.4,
              },
            }),
          )
          .timeout(timeout);

      watch.stop();
      if (response.statusCode != 200) {
        failed++;
        final detail = _apiErrorDetail(response.body);
        if (response.statusCode == 429) {
          print('GAGAL  ${scenario.key} → HTTP 429: kuota/limit API key habis '
              '(${watch.elapsedMilliseconds} ms)'
              '${detail.isEmpty ? '' : '\n       detail: $detail'}');
          quotaExhausted = true;
          break;
        }
        final hint = response.statusCode == 503
            ? ' — layanan Gemini sedang sibuk, coba lagi nanti'
            : '';
        print('GAGAL  ${scenario.key} → HTTP ${response.statusCode} '
            '(${watch.elapsedMilliseconds} ms)$hint'
            '${detail.isEmpty ? '' : '\n       detail: $detail'}');
        continue;
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      final candidates = data['candidates'] as List<dynamic>?;
      final text = (candidates != null && candidates.isNotEmpty)
          ? (candidates[0]['content']?['parts'] as List<dynamic>?)
              ?.first['text'] as String?
          : null;
      if (text == null || text.trim().isEmpty) {
        failed++;
        print('GAGAL  ${scenario.key} → respons kosong');
        continue;
      }

      final result = validateAndParseResult(
        jsonDecode(text) as Map<String, dynamic>,
      );
      final scores = result.careers.map((c) => c.matchScore).toList();
      final uniqueScores = scores.toSet().length;
      final allCatalog =
          result.careers.every((c) => kCareerCatalog.contains(c.title));
      final ok = result.careers.length == 3 &&
          allCatalog &&
          uniqueScores > 1 &&
          scores.every((s) => s >= 0 && s <= 100);

      if (!ok) failed++;
      print('${ok ? "LULUS" : "GAGAL"}  ${scenario.key} '
          '(${watch.elapsedMilliseconds} ms)\n'
          '       karier: ${result.careers.map((c) => "${c.title} (${c.matchScore})").join(", ")}\n'
          '       skor unik: $uniqueScores/3 • roadmap 4 minggu: '
          '${result.careers.every((c) => c.roadmap.length == 4)}\n'
          '       alasan merujuk data: ${result.careers.every((c) => c.reason.length > 40)} • '
          'semua dari katalog: $allCatalog');
    } on ResultValidationException catch (e) {
      failed++;
      print('GAGAL  ${scenario.key} → validasi: $e');
    } catch (e) {
      failed++;
      print('GAGAL  ${scenario.key} → ${e.runtimeType}: $e');
    }
  }

  final totalSeconds = DateTime.now().difference(startedAt).inSeconds;
  print('\nRingkasan: ${ran - failed}/$ran lulus, '
      'total $totalSeconds detik.');
  if (quotaExhausted) {
    print(
        'CATATAN: pengujian dihentikan karena kuota API key habis (HTTP 429). '
        'Minta pemilik proyek mengganti key/menambah kuota, lalu jalankan ulang.');
  }
  client.close();
  exit(failed == 0 ? 0 : 1);
}
