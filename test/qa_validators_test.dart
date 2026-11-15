import 'package:flutter_test/flutter_test.dart';

import 'package:careerpath_ai/data/careers.dart';
import 'package:careerpath_ai/data/major_groups.dart';
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
    test('katalog berisi minimal 8 karier unik lintas jurusan', () {
      expect(kCareerCatalog.length, greaterThanOrEqualTo(8));
      expect(kCareerCatalog.toSet().length, kCareerCatalog.length);
      expect(
          kCareerCatalog,
          containsAll(<String>[
            'UI/UX Designer',
            'Accountant',
            'Financial Analyst',
            'Teacher',
            'Nurse',
            'Legal Officer',
            'Civil Engineer',
          ]));
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

    test('pertanyaan mengikuti jurusan, bukan selalu IT', () {
      final accounting = interestQuestionsForMajor('Akuntansi');
      expect(accounting.length, 8);
      final accountingText =
          accounting.expand((q) => q.options).join(' ').toLowerCase();
      expect(accountingText, contains('laporan keuangan'));
      expect(accountingText, isNot(contains('pemrograman')));
      expect(accountingText, isNot(contains('aplikasi')));

      final it = interestQuestionsForMajor('Teknik Informatika');
      final itText = it.expand((q) => q.options).join(' ').toLowerCase();
      expect(itText, contains('pemrograman'));

      final unknown = interestQuestionsForMajor('Jurusan Tidak Dikenal');
      expect(unknown, same(kInterestQuestions));
    });

    test('pertanyaan dan skill mengikuti sembilan kelompok jurusan', () {
      final cases = <String, (MajorGroup, String)>{
        'Teknik Informatika': (MajorGroup.it, 'pemrograman'),
        'Akuntansi': (MajorGroup.accounting, 'laporan keuangan'),
        'Keperawatan': (MajorGroup.health, 'pasien'),
        'Ilmu Hukum': (MajorGroup.law, 'hukum'),
        'Pendidikan Guru Sekolah Dasar': (MajorGroup.education, 'mengajar'),
        'Psikologi': (MajorGroup.psychology, 'konseling'),
        'Desain Komunikasi Visual': (MajorGroup.communication, 'konten'),
        'Teknik Sipil': (MajorGroup.engineering, 'teknik'),
        'Manajemen Bisnis': (MajorGroup.business, 'bisnis'),
      };

      for (final entry in cases.entries) {
        final questions = interestQuestionsForMajor(entry.key);
        final skills = skillItemsForMajor(entry.key);
        final searchable = [
          ...questions.map((question) => question.text),
          ...questions.expand((question) => question.options),
          ...skills.map((skill) => skill.label),
          ...skills.map((skill) => skill.hint),
        ].join(' ').toLowerCase();

        expect(majorGroupForMajor(entry.key), entry.value.$1,
            reason: entry.key);
        expect(questions, hasLength(8), reason: entry.key);
        expect(skills, hasLength(6), reason: entry.key);
        expect(skills.map((skill) => skill.id).toSet(), hasLength(6),
            reason: entry.key);
        expect(searchable, contains(entry.value.$2), reason: entry.key);
      }
    });

    test('resolver memprioritaskan jurusan spesifik dan fallback umum', () {
      expect(majorGroupForMajor('  KOMPUTERISASI AKUNTANSI  '),
          MajorGroup.accounting);
      expect(majorGroupForMajor(''), MajorGroup.general);
      expect(majorGroupForMajor('Jurusan Tidak Dikenal'), MajorGroup.general);
      expect(skillItemsForMajor('Jurusan Tidak Dikenal'), same(kSkillItems));
      final fallbackText = kSkillItems
          .expand((skill) => [skill.label, skill.hint])
          .join(' ')
          .toLowerCase();
      expect(fallbackText, isNot(contains('pemrograman')));
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
      (((json['careers'] as List)[0] as Map)['roadmap'] as List)[0]
          ['actions'] = <String>[];
      expectInvalid(json, 'aksi kosong');
    });
  });
}
