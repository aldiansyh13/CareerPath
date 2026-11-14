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

GeminiService serviceWith(
  http.Client client, {
  Duration? timeout,
  String model = 'test-model',
  void Function(String from, String to)? onModelSwitch,
}) {
  return GeminiService(
    client: client,
    apiKey: 'test-key',
    model: model,
    timeout: timeout,
    onModelSwitch: onModelSwitch,
  );
}

http.Response errorResponse(int status, [String message = 'error']) {
  return http.Response(
    jsonEncode({
      'error': {'message': message}
    }),
    status,
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
    test('memberi waktu 90 detik untuk respons model yang lambat', () {
      expect(GeminiService.defaultTimeout, const Duration(seconds: 90));
    });

    test('mencoba ulang sekali saat server sibuk 503 lalu berhasil', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return calls == 1
            ? http.Response('{}', 503)
            : successResponse(sampleJson());
      });
      final result = await serviceWith(client).analyzeCareer(kSampleInput);
      expect(result.careers, hasLength(3));
      expect(calls, 2);
    });

    test('berhenti setelah satu retry ketika server tetap sibuk', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return http.Response('{}', 503);
      });
      await expectLater(
          serviceWith(client).analyzeCareer(kSampleInput), throwsGemini('503'));
      expect(calls, 2);
    });

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
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
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
      expect(calls, 1);
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
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
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
      expect(calls, 1);
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

  group('GeminiService rotasi model', () {
    test('lanjut ke model berikutnya saat 404 lalu berhasil', () async {
      final urls = <String>[];
      final switches = <String>[];
      final client = MockClient((request) async {
        urls.add(request.url.toString());
        if (urls.length == 1) {
          return errorResponse(404, 'model is no longer available');
        }
        return successResponse(sampleJson());
      });

      final result = await serviceWith(
        client,
        model: 'model-a, model-b',
        onModelSwitch: (from, to) => switches.add('$from>$to'),
      ).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(urls, hasLength(2));
      expect(urls[0], contains('model-a:generateContent'));
      expect(urls[1], contains('model-b:generateContent'));
      expect(switches, ['model-a>model-b']);
    });

    test('melewati dua model berkuota habis (429) menuju model ketiga',
        () async {
      var calls = 0;
      final switches = <String>[];
      final client = MockClient((_) async {
        calls++;
        return calls < 3
            ? errorResponse(429, 'Quota exceeded')
            : successResponse(sampleJson());
      });

      final result = await serviceWith(
        client,
        model: 'm1,m2,m3',
        onModelSwitch: (from, to) => switches.add('$from>$to'),
      ).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(calls, 3);
      expect(switches, ['m1>m2', 'm2>m3']);
    });

    test('gagal dengan jelas ketika semua model habis', () async {
      final client =
          MockClient((_) async => errorResponse(429, 'Quota exceeded'));

      await expectLater(
        serviceWith(client, model: 'm1,m2').analyzeCareer(kSampleInput),
        throwsA(isA<GeminiException>().having(
          (e) => e.message,
          'message',
          allOf(contains('Semua 2 model'), contains('Kuota')),
        )),
      );
    });

    test('model tunggal 404 tetap memberi pesan lama tanpa rotasi', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return errorResponse(404, 'not found');
      });

      await expectLater(
        serviceWith(client).analyzeCareer(kSampleInput),
        throwsGemini('Model Gemini tidak ditemukan'),
      );
      expect(calls, 1);
    });

    test('tidak mengrotasi untuk error selain 404/429', () async {
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        return errorResponse(401, 'API key not valid');
      });

      await expectLater(
        serviceWith(client, model: 'm1,m2').analyzeCareer(kSampleInput),
        throwsGemini('API key'),
      );
      expect(calls, 1);
    });

    test('tidak memanggil onModelSwitch saat model pertama berhasil', () async {
      var calls = 0;
      var switched = false;
      final client = MockClient((_) async {
        calls++;
        return successResponse(sampleJson());
      });

      await serviceWith(
        client,
        model: 'm1,m2',
        onModelSwitch: (_, __) => switched = true,
      ).analyzeCareer(kSampleInput);

      expect(calls, 1);
      expect(switched, isFalse);
    });

    test('membersihkan spasi dan entri kosong pada daftar model', () async {
      final urls = <String>[];
      final client = MockClient((request) async {
        urls.add(request.url.toString());
        if (urls.length == 1) return errorResponse(404, 'not found');
        return successResponse(sampleJson());
      });

      await serviceWith(client, model: ' model-a , , model-b ')
          .analyzeCareer(kSampleInput);

      expect(urls, hasLength(2));
      expect(urls[0], contains('model-a:generateContent'));
      expect(urls[1], contains('model-b:generateContent'));
    });

    test('retry 503 tetap berlaku pada model hasil rotasi', () async {
      final switches = <String>[];
      var calls = 0;
      final client = MockClient((_) async {
        calls++;
        if (calls == 1) return errorResponse(404, 'not found');
        if (calls == 2) return http.Response('{}', 503);
        return successResponse(sampleJson());
      });

      final result = await serviceWith(
        client,
        model: 'm1,m2',
        onModelSwitch: (from, to) => switches.add('$from>$to'),
      ).analyzeCareer(kSampleInput);

      expect(result.careers, hasLength(3));
      expect(calls, 3);
      expect(switches, ['m1>m2']);
    });

    test('daftar model yang hanya pemisah dianggap belum dikonfigurasi', () {
      final service = GeminiService(apiKey: 'key', model: ' , ');
      expect(service.isConfigured, isFalse);
    });
  });
}
