import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/careers.dart';
import '../models/career_result.dart';
import '../utils/validators.dart';

/// Konfigurasi Gemini belum lengkap (key/model kosong).
class GeminiConfigException implements Exception {
  final String message;
  GeminiConfigException(this.message);
  @override
  String toString() => message;
}

/// Kegagalan saat memanggil atau membaca hasil Gemini.
class GeminiException implements Exception {
  final String message;
  const GeminiException(this.message);
  @override
  String toString() => message;
}

/// Respons Gemini valid secara HTTP, tetapi tidak lolos parsing/validasi.
class _InvalidResultException extends GeminiException {
  const _InvalidResultException(super.message);
}

/// Model tertentu tidak dapat dipakai (404 dicabut atau 429 kuota habis).
/// Rotasi boleh mencoba model berikutnya pada GEMINI_MODEL.
class _ModelUnavailableException extends GeminiException {
  const _ModelUnavailableException(super.message);
}

class GeminiService {
  static const Duration defaultTimeout = Duration(seconds: 90);

  /// Mencegah dua permintaan Gemini berjalan bersamaan (klik ganda).
  static bool _requestInFlight = false;

  final http.Client? _client;
  final String? _apiKeyOverride;
  final String? _modelOverride;
  final Duration timeout;
  final void Function()? onRetry;
  final void Function(String from, String to)? onModelSwitch;

  GeminiService({
    http.Client? client,
    String? apiKey,
    String? model,
    Duration? timeout,
    this.onRetry,
    this.onModelSwitch,
  })  : _client = client,
        _apiKeyOverride = apiKey,
        _modelOverride = model,
        timeout = timeout ?? defaultTimeout;

  static const String _systemPrompt =
      'Kamu adalah konselor karier untuk mahasiswa Indonesia.\n'
      'Analisis profil, minat, dan skill pengguna, lalu beri tepat 3 rekomendasi karier berbeda.\n'
      'Aturan wajib:\n'
      '- Jawab sepenuhnya dalam Bahasa Indonesia yang jelas dan suportif.\n'
      '- Hanya pilih dari daftar karier yang diberikan; jangan menambah karier lain.\n'
      '- match_score berupa angka bulat 0-100, realistis dan bervariasi (jangan semuanya 100).\n'
      '- Alasan harus merujuk pada data pengguna (jurusan, semester, minat, atau skor skill), bukan klaim umum.\n'
      '- Roadmap tepat 4 minggu (week 1 sampai 4), tiap minggu punya aksi konkret, realistis, dan bisa diselesaikan mahasiswa dalam 30 hari.\n'
      '- skills_owned dan skills_missing berisi istilah skill konkret yang relevan.\n'
      '- Jangan menjanjikan gaji, jaminan magang, atau jaminan diterima kerja.\n'
      '- Keluarkan HANYA JSON valid sesuai format yang diminta, tanpa penjelasan tambahan.';

  String get _apiKey {
    if (_apiKeyOverride != null) return _apiKeyOverride.trim();
    if (!dotenv.isInitialized) return '';
    return (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
  }

  /// Daftar model dari GEMINI_MODEL (dipisah koma) untuk rotasi otomatis.
  /// Urutan percobaan mengikuti urutan di konfigurasi.
  List<String> get _models {
    final String raw;
    if (_modelOverride != null) {
      raw = _modelOverride.trim();
    } else if (dotenv.isInitialized) {
      raw = (dotenv.env['GEMINI_MODEL'] ?? '').trim();
    } else {
      raw = '';
    }
    return raw
        .split(',')
        .map((entry) => entry.trim())
        .where((entry) => entry.isNotEmpty)
        .toList(growable: false);
  }

  bool get isConfigured => _apiKey.isNotEmpty && _models.isNotEmpty;

  Future<CareerResult> analyzeCareer(Map<String, dynamic> userData) async {
    final apiKey = _apiKey;
    final models = _models;
    if (apiKey.isEmpty || models.isEmpty) {
      throw GeminiConfigException(
        'Gemini belum dikonfigurasi. Isi GEMINI_API_KEY dan GEMINI_MODEL di file .env (jalur A).',
      );
    }
    if (_requestInFlight) {
      throw const GeminiException(
        'Analisis sebelumnya masih berjalan. Tunggu sampai selesai lalu coba lagi.',
      );
    }

    _requestInFlight = true;
    final client = _client ?? http.Client();
    final shouldCloseClient = _client == null;

    try {
      for (var index = 0; index < models.length; index++) {
        final model = models[index];
        try {
          return await _analyzeWithModel(client, apiKey, model, userData);
        } on _ModelUnavailableException catch (error) {
          if (index >= models.length - 1) {
            if (models.length > 1) {
              throw GeminiException(
                'Semua ${models.length} model Gemini yang dikonfigurasi gagal. '
                '${error.message}',
              );
            }
            rethrow;
          }
          onModelSwitch?.call(model, models[index + 1]);
        }
      }
      throw const GeminiException(
        'Gemini tidak menghasilkan analisis yang valid. Coba lagi atau gunakan contoh hasil.',
      );
    } finally {
      if (shouldCloseClient) client.close();
      _requestInFlight = false;
    }
  }

  Future<CareerResult> _analyzeWithModel(
    http.Client client,
    String apiKey,
    String model,
    Map<String, dynamic> userData,
  ) async {
    final url = Uri.parse(
      'https://generativelanguage.googleapis.com/v1beta/models/$model:generateContent',
    );
    var body = _buildBody(userData);
    var busyRetryUsed = false;

    Future<http.Response> send() async {
      var response = await _post(client, url, apiKey, body);
      // Satu retry 503 untuk seluruh analisis, termasuk perbaikan JSON/schema.
      // Timeout tidak diulang otomatis: server mungkin masih memprosesnya.
      if (response.statusCode == 503 && !busyRetryUsed) {
        busyRetryUsed = true;
        onRetry?.call();
        await Future<void>.delayed(const Duration(seconds: 2));
        response = await _post(client, url, apiKey, body);
      }
      return response;
    }

    // Model kadang melanggar kontrak JSON. Satu percobaan perbaikan dengan
    // instruksi tambahan membuat hasil jauh lebih stabil tanpa mengulang
    // error jaringan/kuota.
    for (var attempt = 1; attempt <= 2; attempt++) {
      var response = await send();

      // Sebagian model/versi API menolak responseSchema. Coba sekali lagi
      // tanpa schema agar prompt + responseMimeType tetap dipakai.
      if (response.statusCode == 400 &&
          _looksLikeSchemaError(_bodyText(response))) {
        body = _withoutResponseSchema(body);
        response = await send();
      }

      if (response.statusCode != 200) {
        final message = _describeHttpError(response, apiKey);
        // 404 (model dicabut) dan 429 (kuota harian habis) bersifat per-model:
        // model berikutnya pada GEMINI_MODEL masih punya peluang.
        if (response.statusCode == 404 || response.statusCode == 429) {
          throw _ModelUnavailableException(message);
        }
        throw GeminiException(message);
      }

      final text = _extractText(_bodyText(response));

      try {
        final decoded = _decodeJsonObject(_stripCodeFence(text));
        return validateAndParseResult(decoded);
      } on ResultValidationException catch (e) {
        if (attempt == 1) {
          body = _buildBody(userData, correction: e.message);
          continue;
        }
        throw GeminiException(
          'Hasil analisis tidak sesuai format: ${e.message} '
          'Coba lagi atau gunakan contoh hasil.',
        );
      } on _InvalidResultException catch (e) {
        if (attempt == 1) {
          body = _buildBody(userData, correction: e.message);
          continue;
        }
        throw GeminiException(
          'Hasil analisis tidak sesuai format: ${e.message} '
          'Coba lagi atau gunakan contoh hasil.',
        );
      }
    }

    throw const GeminiException(
      'Gemini tidak menghasilkan analisis yang valid. Coba lagi atau gunakan contoh hasil.',
    );
  }

  Future<http.Response> _post(
    http.Client client,
    Uri url,
    String apiKey,
    Map<String, dynamic> body,
  ) async {
    try {
      return await client
          .post(
            url,
            headers: {
              'Content-Type': 'application/json',
              'x-goog-api-key': apiKey,
            },
            body: jsonEncode(body),
          )
          .timeout(timeout);
    } on TimeoutException {
      throw GeminiException(
        'Permintaan ke Gemini melebihi batas waktu ${timeout.inSeconds} detik. '
        'Server mungkin sedang sibuk atau koneksi lambat. '
        'Coba lagi nanti atau gunakan contoh hasil.',
      );
    } on HandshakeException {
      throw const GeminiException(
        'Koneksi aman ke Gemini gagal. Periksa jaringan lalu coba lagi.',
      );
    } on SocketException {
      throw const GeminiException(
        'Tidak ada koneksi internet. Sambungkan perangkat lalu coba lagi.',
      );
    } on http.ClientException {
      throw const GeminiException(
        'Koneksi ke Gemini gagal. Periksa internet lalu coba lagi.',
      );
    }
  }

  Map<String, dynamic> _buildBody(
    Map<String, dynamic> userData, {
    String? correction,
  }) {
    final prompt =
        'Daftar karier yang boleh dipilih: ${kCareerCatalog.join(', ')}\n\n'
        'Data pengguna:\n${const JsonEncoder.withIndent('  ').convert(userData)}\n\n'
        'Format JSON yang diminta:\n'
        '{"summary": string, "careers": [{"title": string, "match_score": number,'
        '"reason": string, "skills_owned": [string], "skills_missing": [string],'
        '"roadmap": [{"week": number, "title": string, "actions": [string]}]}]}\n\n'
        'Ketentuan tambahan:\n'
        '- Pilih tepat 3 karier berbeda dari daftar di atas, urut dari skor tertinggi.\n'
        '- Tulis summary 2-3 kalimat tentang potensi pengguna.\n'
        '- Setiap reason minimal 2 kalimat dan menyebut minimal satu data pengguna.\n'
        '- Isi skills_owned dan skills_missing masing-masing minimal 2 item.\n'
        '- Roadmap harus berisi week 1, 2, 3, dan 4; tiap minggu minimal 2 actions konkret.\n'
        '- Jangan mengarang karier, gaji, atau jaminan pekerjaan.'
        '${correction == null ? '' : '\n\nPERBAIKAN WAJIB: hasil sebelumnya tidak lolos validasi '
            '($correction). Tulis ulang seluruh JSON dari awal. Pastikan roadmap tepat '
            'week 1 sampai 4, semua field wajib terisi, dan tidak ada data yang kosong.'}';

    return {
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
        'responseSchema': _responseSchema,
        'temperature': correction == null ? 0.4 : 0.2,
        'topP': 0.9,
      },
    };
  }

  Map<String, dynamic> get _responseSchema => {
        'type': 'OBJECT',
        'properties': {
          'summary': {'type': 'STRING'},
          'careers': {
            'type': 'ARRAY',
            'minItems': 3,
            'maxItems': 3,
            'items': {
              'type': 'OBJECT',
              'properties': {
                'title': {'type': 'STRING', 'enum': kCareerCatalog},
                'match_score': {
                  'type': 'INTEGER',
                  'minimum': 0,
                  'maximum': 100,
                },
                'reason': {'type': 'STRING'},
                'skills_owned': {
                  'type': 'ARRAY',
                  'minItems': 2,
                  'items': {'type': 'STRING'},
                },
                'skills_missing': {
                  'type': 'ARRAY',
                  'minItems': 2,
                  'items': {'type': 'STRING'},
                },
                'roadmap': {
                  'type': 'ARRAY',
                  'minItems': 4,
                  'maxItems': 4,
                  'items': {
                    'type': 'OBJECT',
                    'properties': {
                      'week': {'type': 'INTEGER'},
                      'title': {'type': 'STRING'},
                      'actions': {
                        'type': 'ARRAY',
                        'minItems': 2,
                        'items': {'type': 'STRING'},
                      },
                    },
                    'required': ['week', 'title', 'actions'],
                  },
                },
              },
              'required': [
                'title',
                'match_score',
                'reason',
                'skills_owned',
                'skills_missing',
                'roadmap',
              ],
            },
          },
        },
        'required': ['summary', 'careers'],
      };

  Map<String, dynamic> _withoutResponseSchema(Map<String, dynamic> body) {
    final copy = Map<String, dynamic>.from(body);
    final generation = Map<String, dynamic>.from(
      copy['generationConfig'] as Map? ?? const {},
    )..remove('responseSchema');
    copy['generationConfig'] = generation;
    return copy;
  }

  bool _looksLikeSchemaError(String body) {
    final lower = body.toLowerCase();
    return lower.contains('response_schema') ||
        lower.contains('responseschema') ||
        lower.contains('schema') ||
        lower.contains('enum') ||
        lower.contains('minitems') ||
        lower.contains('maxitems') ||
        lower.contains('minimum') ||
        lower.contains('maximum') ||
        lower.contains('unknown name');
  }

  String _extractText(String responseBody) {
    final data = _decodeJsonObject(responseBody);
    final error = data['error'];
    if (error is Map) {
      final message = (error['message'] ?? '').toString().trim();
      throw GeminiException(
        message.isEmpty
            ? 'Gemini menolak permintaan. Coba lagi.'
            : 'Gemini menolak permintaan: $message',
      );
    }

    final promptFeedback = data['promptFeedback'];
    if (promptFeedback is Map && promptFeedback['blockReason'] != null) {
      throw GeminiException(
        'Permintaan diblokir oleh filter keamanan Gemini '
        '(${promptFeedback['blockReason']}). Ubah jawaban lalu coba lagi.',
      );
    }

    final candidates = data['candidates'];
    if (candidates is! List || candidates.isEmpty) {
      throw const GeminiException(
        'Gemini tidak mengembalikan hasil. Coba lagi atau gunakan contoh hasil.',
      );
    }

    final candidate = candidates.first;
    if (candidate is! Map) {
      throw const GeminiException(
          'Respons Gemini tidak dapat dibaca. Coba lagi.');
    }

    final finishReason = candidate['finishReason'];
    if (finishReason != null && finishReason != 'STOP') {
      if (finishReason == 'MAX_TOKENS') {
        throw const GeminiException(
          'Hasil Gemini terpotong karena terlalu panjang. Coba lagi.',
        );
      }
      throw GeminiException(
        'Gemini menghentikan respons ($finishReason). Coba lagi atau gunakan contoh hasil.',
      );
    }

    final content = candidate['content'];
    final parts = content is Map ? content['parts'] : null;
    if (parts is! List) {
      throw const GeminiException(
        'Gemini tidak mengembalikan isi analisis. Coba lagi.',
      );
    }

    final buffer = StringBuffer();
    for (final part in parts) {
      if (part is Map && part['text'] is String) {
        buffer.write(part['text']);
      }
    }
    final text = buffer.toString().trim();
    if (text.isEmpty) {
      throw const GeminiException(
        'Respons Gemini kosong. Coba lagi atau gunakan contoh hasil.',
      );
    }
    return text;
  }

  String _stripCodeFence(String text) {
    var value = text.trim();
    if (value.startsWith('```')) {
      final firstNewline = value.indexOf('\n');
      if (firstNewline != -1) {
        value = value.substring(firstNewline + 1);
      }
      if (value.endsWith('```')) {
        value = value.substring(0, value.length - 3);
      }
    }
    final start = value.indexOf('{');
    final end = value.lastIndexOf('}');
    if (start >= 0 && end > start) {
      value = value.substring(start, end + 1);
    }
    return value.trim();
  }

  Map<String, dynamic> _decodeJsonObject(String text) {
    dynamic decoded;
    try {
      decoded = jsonDecode(text);
    } on FormatException {
      throw const _InvalidResultException(
        'Format JSON dari Gemini tidak valid.',
      );
    }
    if (decoded is! Map) {
      throw const _InvalidResultException(
        'Format hasil Gemini tidak valid.',
      );
    }
    return Map<String, dynamic>.from(decoded);
  }

  String _bodyText(http.Response response) {
    try {
      return utf8.decode(response.bodyBytes, allowMalformed: true);
    } catch (_) {
      return response.body;
    }
  }

  String _describeHttpError(http.Response response, String apiKey) {
    var detail = '';
    try {
      final decoded = jsonDecode(_bodyText(response));
      if (decoded is Map && decoded['error'] is Map) {
        detail = (decoded['error']['message'] ?? '').toString().trim();
      }
    } catch (_) {
      // Body bukan JSON: pesan generik di bawah tetap dipakai.
    }
    if (detail.isNotEmpty && apiKey.isNotEmpty) {
      detail = detail.replaceAll(apiKey, '[REDACTED]');
    }
    if (detail.length > 180) {
      detail = '${detail.substring(0, 180)}...';
    }
    final suffix = detail.isEmpty ? '' : ' Detail: $detail';

    switch (response.statusCode) {
      case 400:
        return 'Permintaan ke Gemini tidak valid. Periksa GEMINI_MODEL di .env.$suffix';
      case 401:
      case 403:
        return 'API key Gemini tidak valid atau tidak punya akses. Periksa GEMINI_API_KEY.$suffix';
      case 404:
        return 'Model Gemini tidak ditemukan. Periksa GEMINI_MODEL di .env.$suffix';
      case 429:
        return 'Kuota/batas permintaan Gemini tercapai. Coba lagi nanti atau gunakan contoh hasil.$suffix';
      case 503:
        return 'Server Gemini sedang sibuk (503). Percobaan ulang belum berhasil. '
            'Coba lagi nanti atau gunakan contoh hasil.';
      default:
        if (response.statusCode >= 500) {
          return 'Server Gemini sedang bermasalah (${response.statusCode}). Coba lagi.$suffix';
        }
        return 'Gemini error ${response.statusCode}.$suffix';
    }
  }
}
