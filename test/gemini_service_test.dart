import 'dart:async';
import 'dart:convert';

import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/services/gemini_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

Map<String, dynamic> sampleJson() {
  return Map<String, dynamic>.from(
    jsonDecode(jsonEncode(kSampleResult)) as Map,
  );
}

http.Response successResponse(Object result) {
  return http.Response(
    jsonEncode({
      'candidates': [
        {
          'content': {
            'parts': [
              {'text': jsonEncode(result)}
            ]
          },
          'finishReason': 'STOP',
        }
      ]
    }),
    200,
    headers: {'content-type': 'application/json; charset=utf-8'},
  );
}

GeminiService serviceWith(http.Client client, {Duration? timeout}) {
  return GeminiService(
    client: client,
    apiKey: 'test-key',
    model: 'test-model',
    timeout: timeout,
  );
}

Matcher throwsGemini(String fragment) {
  return throwsA(
    isA<GeminiException>().having(
      (e) => e.message,
      'message',
      contains(fragment),
    ),
  );
}

void main() {
  group('GeminiService.analyzeCareer', () {
    test('mem-parse respons valid menjadi CareerResult', () async {
      late http.Request captured;
      final client = MockClient((request) async {
        captured = request;
        return successResponse(sampleJson());
      });

      final result = await serviceWith(client).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(result.careers.first.title, 'UI/UX Designer');
      expect(result.isSample, isFalse);
      expect(captured.url.toString(), contains('test-model:generateContent'));
      expect(captured.headers['x-goog-api-key'], 'test-key');
      expect(captured.headers['Content-Type'], contains('application/json'));
      expect(captured.body, contains('responseMimeType'));
      expect(captured.body, contains('responseSchema'));
      expect(captured.body, contains('UI/UX Designer'));
    });

    test('membersihkan pembungkus markdown ```json', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {
                      'text': '```json\n${jsonEncode(sampleJson())}\n```',
                    }
                  ]
                },
                'finishReason': 'STOP',
              }
            ]
          }),
          200,
          headers: {'content-type': 'application/json; charset=utf-8'},
        );
      });

      final result = await serviceWith(client).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
    });

    test('menolak teks yang bukan JSON dengan pesan jelas', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {'text': 'Maaf, saya tidak bisa membantu.'}
                  ]
                },
                'finishReason': 'STOP',
              }
            ]
          }),
          200,
        );
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('JSON'),
      );
    });

    test('menolak hasil yang melanggar kontrak katalog', () async {
      final broken = sampleJson();
      (broken['careers'] as List)[0]['title'] = 'Astronaut';
      final client = MockClient((_) async => successResponse(broken));

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('tidak sesuai format'),
      );
    });

    test('mencoba ulang sekali saat hasil pertama melanggar kontrak', () async {
      final broken = sampleJson();
      (broken['careers'] as List)[0]['title'] = 'Astronaut';
      final bodies = <String>[];
      var call = 0;
      final client = MockClient((request) async {
        bodies.add(request.body);
        call++;
        return successResponse(call == 1 ? broken : sampleJson());
      });

      final result = await serviceWith(client).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(bodies, hasLength(2));
      expect(bodies.last, contains('PERBAIKAN WAJIB'));
      expect(bodies.last, contains('katalog'));
    });

    test('memetakan kuota 429 ke pesan Indonesia', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'error': {'message': 'Quota exceeded'}
          }),
          429,
        );
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('Kuota'),
      );
    });

    test('memetakan API key tidak valid (401)', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'error': {'message': 'API key not valid'}
          }),
          401,
        );
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('API key'),
      );
    });

    test('menangani permintaan yang diblokir filter keamanan', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'promptFeedback': {'blockReason': 'SAFETY'}
          }),
          200,
        );
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('diblokir'),
      );
    });

    test('menangani respons terpotong (MAX_TOKENS)', () async {
      final client = MockClient((_) async {
        return http.Response(
          jsonEncode({
            'candidates': [
              {
                'content': {
                  'parts': [
                    {'text': '{"summary": "terpotong'}
                  ]
                },
                'finishReason': 'MAX_TOKENS',
              }
            ]
          }),
          200,
        );
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('terpotong'),
      );
    });

    test('menolak konfigurasi kosong tanpa memanggil jaringan', () async {
      final service = GeminiService(apiKey: '', model: '');

      expect(service.isConfigured, isFalse);
      await expectLater(
        service.analyzeCareer(kSampleInput),
        throwsA(isA<GeminiConfigException>()),
      );
    });

    test('menolak panggilan ganda saat permintaan pertama berjalan', () async {
      final completer = Completer<http.Response>();
      final client = MockClient((_) => completer.future);
      final service = serviceWith(client);

      final first = service.analyzeCareer(kSampleInput);
      await expectLater(
        service.analyzeCareer(kSampleInput),
        throwsGemini('masih berjalan'),
      );

      completer.complete(successResponse(sampleJson()));
      final result = await first;
      expect(result.careers, hasLength(3));
    });

    test('mengubah timeout menjadi pesan yang dapat dipahami', () async {
      final client = MockClient((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        return successResponse(sampleJson());
      });
      final service = serviceWith(
        client,
        timeout: const Duration(milliseconds: 20),
      );

      await expectLater(
        service.analyzeCareer(kSampleInput),
        throwsGemini('batas waktu'),
      );
    });

    test('mencoba ulang tanpa responseSchema bila API menolak schema',
        () async {
      final bodies = <String>[];
      var call = 0;
      final client = MockClient((request) async {
        bodies.add(request.body);
        call++;
        if (call == 1) {
          return http.Response(
            jsonEncode({
              'error': {'message': 'Invalid response_schema'}
            }),
            400,
          );
        }
        return successResponse(sampleJson());
      });

      final result = await serviceWith(client).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(bodies, hasLength(2));
      expect(bodies.first, contains('responseSchema'));
      expect(bodies.last, isNot(contains('responseSchema')));
      expect(bodies.last, contains('responseMimeType'));
    });
  });
}
