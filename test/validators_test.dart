import 'dart:convert';

import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/utils/validators.dart';
import 'package:flutter_test/flutter_test.dart';

Map<String, dynamic> sampleJson() {
  return Map<String, dynamic>.from(
    jsonDecode(jsonEncode(kSampleResult)) as Map,
  );
}

Matcher throwsValidation(String fragment) {
  return throwsA(
    isA<ResultValidationException>().having(
      (e) => e.message,
      'message',
      contains(fragment),
    ),
  );
}

void main() {
  group('validateAndParseResult', () {
    test('menerima contoh hasil PRD dan mengembalikan 3 karier', () {
      final result = validateAndParseResult(sampleJson(), isSample: true);

      expect(result.isSample, isTrue);
      expect(result.careers, hasLength(3));
      expect(result.careers.first.title, 'UI/UX Designer');
      expect(result.careers.first.roadmap, hasLength(4));
      expect(result.careers.first.roadmap.first.actions, isNotEmpty);
    });

    test('menormalkan judul karier yang beda spasi/kapitalisasi', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['title'] = '  ui/ux designer  ';

      final result = validateAndParseResult(json);

      expect(result.careers.first.title, 'UI/UX Designer');
    });

    test('mengurutkan karier dari skor tertinggi', () {
      final json = sampleJson();
      final careers = json['careers'] as List;
      careers[0]['match_score'] = 70;
      careers[1]['match_score'] = 92;
      careers[2]['match_score'] = 85;

      final result = validateAndParseResult(json);

      expect(result.careers.map((c) => c.matchScore), [92, 85, 70]);
    });

    test('menolak karier di luar katalog', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['title'] = 'Astronaut';

      expect(() => validateAndParseResult(json), throwsValidation('katalog'));
    });

    test('menolak karier duplikat', () {
      final json = sampleJson();
      final careers = json['careers'] as List;
      careers[1]['title'] = careers[0]['title'];

      expect(() => validateAndParseResult(json), throwsValidation('duplikat'));
    });

    test('menolak jumlah karier selain 3', () {
      final json = sampleJson();
      (json['careers'] as List).removeLast();

      expect(() => validateAndParseResult(json), throwsValidation('tepat 3'));
    });

    test('menolak skor di luar 0-100', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['match_score'] = 101;

      expect(() => validateAndParseResult(json), throwsValidation('0-100'));
    });

    test('menolak skor yang semuanya 100', () {
      final json = sampleJson();
      for (final career in json['careers'] as List) {
        career['match_score'] = 100;
      }

      expect(
          () => validateAndParseResult(json), throwsValidation('semuanya 100'));
    });

    test('menolak skills_owned yang bukan daftar', () {
      final json = sampleJson();
      (json['careers'] as List)[0].remove('skills_owned');

      expect(
        () => validateAndParseResult(json),
        throwsValidation('skills_owned'),
      );
    });

    test('menolak skills_missing kosong', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['skills_missing'] = <String>[];

      expect(
        () => validateAndParseResult(json),
        throwsValidation('tidak boleh kosong'),
      );
    });

    test('menolak roadmap yang bukan 4 minggu', () {
      final json = sampleJson();
      (((json['careers'] as List)[0]['roadmap'] as List).removeLast());

      expect(() => validateAndParseResult(json), throwsValidation('4 minggu'));
    });

    test('menolak urutan week roadmap yang salah', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['roadmap'][2]['week'] = 5;

      expect(
        () => validateAndParseResult(json),
        throwsValidation('week 1-4'),
      );
    });

    test('menolak aksi roadmap kosong', () {
      final json = sampleJson();
      (json['careers'] as List)[0]['roadmap'][0]['actions'] = <String>[];

      expect(
          () => validateAndParseResult(json), throwsValidation('Aksi roadmap'));
    });
  });
}
