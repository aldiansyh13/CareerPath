import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/career_result.dart';
import 'package:careerpath_ai/services/gemini_service.dart';
import 'package:careerpath_ai/services/openai_service.dart';
import 'package:careerpath_ai/services/career_analysis_service.dart';

final result = CareerResult.fromJson(kSampleResult);

class StubGemini extends GeminiService {
  final Future<CareerResult> Function() action;
  StubGemini(this.action);
  @override
  Future<CareerResult> analyzeCareer(Map<String, dynamic> input) => action();
}

class StubOpenAi extends OpenAiService {
  int calls = 0;
  final bool configured;
  final bool fail;
  StubOpenAi({this.configured = true, this.fail = false});
  @override
  bool get isConfigured => configured;
  @override
  Future<CareerResult> analyzeCareer(Map<String, dynamic> input) async {
    calls++;
    if (fail) throw const OpenAiException('OpenAI gagal');
    return result;
  }
}

http.Response response({String status = 'completed', Object? output}) =>
    http.Response(
        jsonEncode({
          'status': status,
          'output': output ??
              [
                {
                  'type': 'message',
                  'content': [
                    {'type': 'output_text', 'text': jsonEncode(kSampleResult)}
                  ]
                }
              ],
        }),
        200,
        headers: {'content-type': 'application/json; charset=utf-8'});

void main() {
  test('Gemini sukses tidak memanggil OpenAI', () async {
    final backup = StubOpenAi();
    expect(
        await CareerAnalysisService(
                gemini: StubGemini(() async => result), openai: backup)
            .analyzeCareer(kSampleInput),
        same(result));
    expect(backup.calls, 0);
  });

  test('Gemini gagal memakai OpenAI dan memberi status fallback', () async {
    final backup = StubOpenAi();
    var notified = false;
    final service = CareerAnalysisService(
      gemini: StubGemini(() async => throw const GeminiException('timeout')),
      openai: backup,
      onFallback: () => notified = true,
    );
    expect(await service.analyzeCareer(kSampleInput), same(result));
    expect(backup.calls, 1);
    expect(notified, isTrue);
  });

  test('Gemini belum dikonfigurasi dapat memakai OpenAI', () async {
    final backup = StubOpenAi();
    await CareerAnalysisService(
            gemini: GeminiService(apiKey: '', model: ''), openai: backup)
        .analyzeCareer(kSampleInput);
    expect(backup.calls, 1);
  });

  test('OpenAI tanpa key mempertahankan error Gemini', () async {
    final backup = StubOpenAi(configured: false);
    await expectLater(
        CareerAnalysisService(
                gemini: StubGemini(
                    () async => throw const GeminiException('timeout')),
                openai: backup)
            .analyzeCareer(kSampleInput),
        throwsA(isA<GeminiException>()));
    expect(backup.calls, 0);
  });

  test('kedua layanan gagal menghasilkan error yang jelas', () async {
    await expectLater(
        CareerAnalysisService(
                gemini: StubGemini(
                    () async => throw const GeminiException('timeout')),
                openai: StubOpenAi(fail: true))
            .analyzeCareer(kSampleInput),
        throwsA(isA<AnalysisException>()));
  });

  test('permintaan ganda tidak memicu fallback', () async {
    final pending = Completer<CareerResult>();
    final backup = StubOpenAi();
    final service = CareerAnalysisService(
        gemini: StubGemini(() => pending.future), openai: backup);
    final first = service.analyzeCareer(kSampleInput);
    await expectLater(
        service.analyzeCareer(kSampleInput), throwsA(isA<AnalysisException>()));
    pending.complete(result);
    await first;
    expect(backup.calls, 0);
  });

  test('layar ditutup tidak mengirim fallback baru', () async {
    final backup = StubOpenAi();
    await expectLater(
        CareerAnalysisService(
            gemini:
                StubGemini(() async => throw const GeminiException('timeout')),
            openai: backup,
            shouldContinue: () => false).analyzeCareer(kSampleInput),
        throwsA(isA<AnalysisException>()));
    expect(backup.calls, 0);
  });

  test('OpenAI memakai Responses API dan memvalidasi hasil', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.openai.com/v1/responses');
      expect(request.headers['authorization'], 'Bearer test-key');
      final body = jsonDecode(request.body) as Map;
      expect(body['store'], false);
      expect(body['text']['format']['type'], 'json_schema');
      expect(request.body, isNot(contains('test-key')));
      return response();
    });
    final parsed = await OpenAiService(
            client: client, apiKey: 'test-key', model: 'test-model')
        .analyzeCareer(kSampleInput);
    expect(parsed.careers, hasLength(3));
    expect(parsed.isSample, isFalse);
  });

  for (final code in [401, 403, 429, 500]) {
    test('OpenAI HTTP $code tidak membocorkan body/key', () async {
      final client = MockClient(
          (_) async => http.Response('test-key secret detail', code));
      await expectLater(
          OpenAiService(client: client, apiKey: 'test-key')
              .analyzeCareer(kSampleInput),
          throwsA(isA<OpenAiException>().having(
              (e) => e.message, 'sanitized', isNot(contains('test-key')))));
    });
  }

  test('OpenAI menolak respons incomplete, refusal, kosong, dan JSON rusak',
      () async {
    for (final reply in [
      response(status: 'incomplete'),
      response(output: [
        {
          'type': 'message',
          'content': [
            {'type': 'refusal', 'refusal': 'No'}
          ]
        }
      ]),
      response(output: []),
      http.Response('not-json', 200),
      response(output: [
        {
          'type': 'message',
          'content': [
            {'type': 'output_text', 'text': '{}'}
          ]
        }
      ])
    ]) {
      final client = MockClient((_) async => reply);
      await expectLater(
          OpenAiService(client: client, apiKey: 'test-key')
              .analyzeCareer(kSampleInput),
          throwsA(isA<OpenAiException>()));
    }
  });

  test('OpenAI timeout dan konfigurasi kosong ditangani', () async {
    final client = MockClient((_) => Completer<http.Response>().future);
    await expectLater(
        OpenAiService(
                client: client,
                apiKey: 'test-key',
                timeout: const Duration(milliseconds: 5))
            .analyzeCareer(kSampleInput),
        throwsA(isA<OpenAiException>()));
    await expectLater(
        OpenAiService(client: client, apiKey: '').analyzeCareer(kSampleInput),
        throwsA(isA<OpenAiException>()));
  });
}
