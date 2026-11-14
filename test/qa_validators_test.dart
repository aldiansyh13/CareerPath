import 'package:flutter_test/flutter_test.dart';

import 'package:careerpath_ai/data/careers.dart';
import 'package:careerpath_ai/data/questions.dart';
import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/data/skills.dart';
import 'package:careerpath_ai/utils/validators.dart';

Map<String, dynamic> _validResult() {
  return <String, dynamic>{
    'summary': 'Ringkasan contoh untuk pengujian.',
    'careers': <Map<String, dynamic>>[
      _career('UI/UX Designer', 88),
      _career('Frontend Developer', 79),
      _career('Product Manager', 72),
    ],
  };
}

Map<String, dynamic> _career(String title, int score) {
  return <String, dynamic>{
    'title': title,
    'match_score': score,
    'reason': 'Alasan untuk $title berdasarkan jawaban pengguna.',
    'skills_owned': <String>['Komunikasi'],
    'skills_missing': <String>['Portofolio'],
    'roadmap': <Map<String, dynamic>>[
      for (int i = 1; i <= 4; i++)
        <String, dynamic>{
          'week': i,
          'title': 'Minggu $i',
          'actions': <String>['Aksi konkret minggu $i'],
        },
    ],
  };
}

void expectInvalid(Map<String, dynamic> json, String reasonFragment) {
  expect(
    () => validateAndParseResult(json),
    throwsA(isA<ResultValidationException>()),
    reason: reasonFragment,
  );
}

void main() {
  group('Katalog & data tetap MVP', () {
    test('katalog berisi 8 karier unik', () {
      expect(kCareerCatalog.length, 8);
      expect(kCareerCatalog.toSet().length, 8);
    });

    test('8 pertanyaan minat, masing-masing punya pilihan', () {
      expect(kInterestQuestions.length, 8);
      for (final q in kInterestQuestions) {
        expect(q.options, isNotEmpty, reason: 'Pertanyaan ${q.id} tanpa opsi');
      }
    });

    test('6 skill dengan id unik', () {
      expect(kSkillItems.length, 6);
      expect(kSkillItems.map((s) => s.id).toSet().length, 6);
    });
  });

  group('Validasi hasil AI (kontrak PRD)', () {
    test('hasil contoh bawaan lolos validasi dan berlabel contoh', () {
      final result = validateAndParseResult(
        Map<String, dynamic>.from(kSampleResult),
        isSample: true,
      );
      expect(result.isSample, isTrue);
      expect(result.careers.length, 3);
      for (final c in result.careers) {
        expect(kCareerCatalog, contains(c.title));
        expect(c.matchScore, inInclusiveRange(0, 100));
        expect(c.reason.trim(), isNotEmpty);
        expect(c.roadmap.length, 4);
        expect(c.roadmap.map((w) => w.week), <int>[1, 2, 3, 4]);
        for (final w in c.roadmap) {
          expect(w.actions, isNotEmpty);
        }
      }
    });

    test('hasil valid dengan 3 karier lolos', () {
      final result = validateAndParseResult(_validResult());
      expect(result.careers.map((c) => c.title),
          <String>['UI/UX Designer', 'Frontend Developer', 'Product Manager']);
    });

    test('menolak jumlah karier bukan 3', () {
      final json = _validResult();
      (json['careers'] as List).removeLast();
      expectInvalid(json, '2 karier');
    });

    test('menolak karier di luar katalog', () {
      final json = _validResult();
      (json['careers'] as List)[0]['title'] = 'Astronaut';
      expectInvalid(json, 'di luar katalog');
    });

    test('menolak karier duplikat', () {
      final json = _validResult();
      (json['careers'] as List)[1]['title'] = 'UI/UX Designer';
      expectInvalid(json, 'duplikat');
    });

    test('menolak skor di luar 0-100', () {
      final json = _validResult();
      (json['careers'] as List)[0]['match_score'] = 101;
      expectInvalid(json, 'skor > 100');
    });

    test('menolak skor semua 100', () {
      final json = _validResult();
      for (final c in json['careers'] as List) {
        (c as Map)['match_score'] = 100;
      }
      expectInvalid(json, 'semua 100');
    });

    test('menolak roadmap kurang dari 4 minggu', () {
      final json = _validResult();
      ((json['careers'] as List)[0] as Map)['roadmap'] =
          ((json['careers'] as List)[0] as Map)['roadmap'].sublist(0, 3);
      expectInvalid(json, 'roadmap 3 minggu');
    });

    test('menolak minggu roadmap tidak berurutan', () {
      final json = _validResult();
      (((json['careers'] as List)[0] as Map)['roadmap'] as List)[2]['week'] = 5;
      expectInvalid(json, 'urutan minggu');
    });

    test('menolak summary kosong', () {
      final json = _validResult()..['summary'] = '   ';
      expectInvalid(json, 'summary kosong');
    });

    test('menolak aksi roadmap kosong', () {
      final json = _validResult();
      (((json['careers'] as List)[0] as Map)['roadmap'] as List)[0]['actions'] =
          <String>[];
      expectInvalid(json, 'aksi kosong');
    });
  });
}
