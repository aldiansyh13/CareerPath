import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/careers.dart';
import '../models/career_result.dart';
import '../utils/validators.dart';

class GeminiConfigException implements Exception {
  final String message;
  GeminiConfigException(this.message);
  @override
  String toString() => message;
}

class GeminiService {
  static const String _systemPrompt =
      'Kamu adalah konselor karier untuk mahasiswa Indonesia.\n'
      'Analisis profil, minat, dan skill pengguna, lalu beri 3 rekomendasi karier.\n'
      'Aturan:\n'
      '- Jawab dalam Bahasa Indonesia.\n'
      '- Hanya pilih dari daftar karier yang diberikan.\n'
      '- match_score berupa angka 0-100 dan tidak semua boleh 100.\n'
      '- Alasan harus merujuk pada data pengguna, bukan klaim umum.\n'
      '- Roadmap 4 tahap (week 1 sampai 4), tiap minggu punya actions konkret, realistis untuk mahasiswa.\n'
      '- Jangan menjanjikan gaji atau jaminan diterima kerja.\n'
      '- Keluarkan HANYA JSON valid sesuai format yang diminta.';

  bool get isConfigured {
    final key = dotenv.env['GEMINI_API_KEY']?.trim() ?? '';
    final model = dotenv.env['GEMINI_MODEL']?.trim() ?? '';
    return key.isNotEmpty && model.isNotEmpty;
  }

  Future<CareerResult> analyzeCareer(Map<String, dynamic> userData) async {
    final apiKey = dotenv.env['GEMINI_API_KEY']?.trim();
    final model = dotenv.env['GEMINI_MODEL']?.trim();
    if (apiKey == null || apiKey.isEmpty || model == null || model.isEmpty) {
      throw GeminiConfigException(
        'Gemini belum dikonfigurasi. Isi GEMINI_API_KEY dan GEMINI_MODEL di file .env (jalur A).',
      );
    }

    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
    );

    final prompt = 'Daftar karier yang boleh dipilih: ${kCareerCatalog.join(', ')}\n\n'
        'Data pengguna:\n${const JsonEncoder.withIndent('  ').convert(userData)}\n\n'
        'Format JSON yang diminta:\n'
        '{"summary": string, "careers": [{"title": string, "match_score": number,'
        '"reason": string, "skills_owned": [string], "skills_missing": [string],'
        '"roadmap": [{"week": number, "title": string, "actions": [string]}]}]}';

    final body = {
      'systemInstruction': {
        'parts': [
          {'text': _systemPrompt}
        ]
      },
      'contents': [
        {
          'role': 'user',
          'parts': [
            {'text': prompt}
          ]
        }
      ],
      'generationConfig': {
        'responseMimeType': 'application/json',
        'temperature': 0.4,
      },
    };

    final response = await http
        .post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'x-goog-api-key': apiKey,
          },
          body: jsonEncode(body),
        )
        .timeout(const Duration(seconds: 40));

    if (response.statusCode == 429) {
      throw Exception('Kuota/batas permintaan Gemini tercapai (429). Coba lagi nanti atau gunakan contoh hasil.');
    }
    if (response.statusCode != 200) {
      throw Exception('Gemini error ${response.statusCode}. Periksa model, key, dan kuota.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final candidates = data['candidates'] as List<dynamic>?;
    if (candidates == null || candidates.isEmpty) {
      throw Exception('Respons Gemini kosong.');
    }
    final content = candidates[0]['content'] as Map<String, dynamic>?;
    final parts = content?['parts'] as List<dynamic>?;
    final text = parts != null && parts.isNotEmpty ? parts[0]['text'] as String? : null;
    if (text == null || text.trim().isEmpty) {
      throw Exception('Respons Gemini tidak berisi teks.');
    }
    final jsonResult = jsonDecode(text) as Map<String, dynamic>;
    return validateAndParseResult(jsonResult);
  }
}
