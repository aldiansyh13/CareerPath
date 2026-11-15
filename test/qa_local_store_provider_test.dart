import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/models/career_result.dart';
import 'package:careerpath_ai/models/user_profile.dart';
import 'package:careerpath_ai/services/local_store.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/data/sample_result.dart';

AssessmentRecord _record(String id, DateTime createdAt) {
  final result = CareerResult.fromJson(
    Map<String, dynamic>.from(kSampleResult),
    isSample: true,
  );
  return AssessmentRecord(
    id: id,
    createdAt: createdAt,
    input: <String, dynamic>{
      'profile': <String, dynamic>{'name': 'Uji'}
    },
    result: result,
  );
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('LocalStore (fallback lokal / offline)', () {
    test('profil tersimpan dan termuat ulang', () async {
      final store = LocalStore();
      expect(await store.getProfile(), isNull);

      await store.saveProfile(
        const UserProfile(
            name: 'Sabrina', major: 'Sistem Informasi', semester: 4),
      );
      final loaded = await store.getProfile();
      expect(loaded, isNotNull);
      expect(loaded!.name, 'Sabrina');
      expect(loaded.major, 'Sistem Informasi');
      expect(loaded.semester, 4);
    });

    test('clearProfile menghapus profil', () async {
      final store = LocalStore();
      await store.saveProfile(
        const UserProfile(name: 'Uji', major: 'Manajemen', semester: 2),
      );
      await store.clearProfile();
      expect(await store.getProfile(), isNull);
    });

    test('riwayat tersimpan urut terbaru lebih dulu', () async {
      final store = LocalStore();
      final older = _record('lama', DateTime(2026, 11, 14, 10));
      final newer = _record('baru', DateTime(2026, 11, 14, 12));

      await store.addAssessment(older);
      await store.addAssessment(newer);

      final history = await store.getHistory();
      expect(history.map((r) => r.id), <String>['baru', 'lama']);
      expect(history.first.result.careers.length, 3);
      expect(history.first.result.isSample, isTrue);
    });

    test('clearHistory menghapus riwayat (logout bersih)', () async {
      final store = LocalStore();
      await store.addAssessment(_record('x', DateTime(2026, 11, 14)));
      await store.clearHistory();
      expect(await store.getHistory(), isEmpty);
    });
  });

  group('AssessmentProvider (state asesmen)', () {
    test('kelengkapan minat & skill dihitung per ID', () {
      final provider = AssessmentProvider();
      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'Informatika', semester: 5),
      );
      expect(provider.interestsCompleteFor(<String>{'q1'}), isFalse);

      for (int i = 1; i <= 8; i++) {
        provider.setInterest('q$i', 'Opsi $i');
      }
      for (final skill in provider.activeSkills) {
        provider.setSkill(skill.id, 3);
      }

      expect(provider.interestsComplete, isTrue);
      expect(provider.skillsComplete, isTrue);
      expect(provider.buildInput()['profile'], isA<Map>());
      expect((provider.buildInput()['interests'] as Map).length, 8);
      expect((provider.buildInput()['skills'] as Map).length, 6);
    });

    test('resetAssessment default menyimpan profil, opsi false menghapusnya',
        () {
      final provider = AssessmentProvider();
      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'DKV', semester: 3),
      );
      provider.setInterest('q1', 'A');
      provider.setSkill('logic', 2);

      provider.resetAssessment();
      expect(provider.profile, isNotNull);
      expect(provider.interestAnswers, isEmpty);
      expect(provider.skillRatings, isEmpty);

      provider.resetAssessment(keepProfile: false);
      expect(provider.profile, isNull);
    });

    test('loadSampleInput mengisi profil, 8 minat, 6 skill (mode demo)', () {
      final provider = AssessmentProvider();
      provider.loadSampleInput(Map<String, dynamic>.from(kSampleInput));

      expect(provider.profile?.name, 'Contoh Pengguna');
      expect(provider.interestsComplete, isTrue);
      expect(provider.skillsComplete, isTrue);
      expect(
          provider.skillRatings.values.every((v) => v >= 1 && v <= 5), isTrue);
    });

    test('skenario batas: semua skill 1 dan semua skill 5 tersimpan apa adanya',
        () {
      final provider = AssessmentProvider();

      provider.loadSampleInput(<String, dynamic>{
        'profile': <String, dynamic>{
          'name': 'Uji',
          'major': 'X',
          'semester': 1
        },
        'interests': <String, dynamic>{'q1': 'A'},
        'skills': <String, dynamic>{
          'logic': 1,
          'design': 1,
          'data': 1,
          'communication': 1,
          'coding': 1,
          'leadership': 1,
        },
      });
      expect(provider.skillRatings.values.toSet(), <int>{1});

      for (final key in provider.skillRatings.keys.toList()) {
        provider.setSkill(key, 5);
      }
      expect(provider.skillRatings.values.toSet(), <int>{5});
    });

    test('mengganti kelompok jurusan menghapus minat dan skill lama', () {
      final provider = AssessmentProvider();
      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'Akuntansi', semester: 3),
      );
      provider.setInterest('q1', 'Laporan keuangan');
      provider.setSkill(provider.activeSkills.first.id, 4);

      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'Informatika', semester: 3),
      );

      expect(provider.interestAnswers, isEmpty);
      expect(provider.skillRatings, isEmpty);
      expect(provider.activeSkills.map((skill) => skill.id),
          contains('it_coding'));
    });

    test('mengubah nama jurusan dalam kelompok sama mempertahankan jawaban',
        () {
      final provider = AssessmentProvider();
      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'Akuntansi', semester: 3),
      );
      provider.setInterest('q1', 'Audit');
      provider.setSkill(provider.activeSkills.first.id, 4);

      provider.setProfile(
        const UserProfile(
            name: 'Uji', major: 'Komputerisasi Akuntansi', semester: 4),
      );

      expect(provider.interestAnswers['q1'], 'Audit');
      expect(provider.skillRatings, hasLength(1));
    });

    test('payload AI memuat rating dan label skill jurusan aktif', () {
      final provider = AssessmentProvider();
      provider.setProfile(
        const UserProfile(name: 'Uji', major: 'Akuntansi', semester: 3),
      );
      for (final skill in provider.activeSkills) {
        provider.setSkill(skill.id, 4);
      }

      final input = provider.buildInput();
      final labels = input['skill_labels'] as Map;
      expect((input['skills'] as Map), hasLength(6));
      expect(labels, hasLength(6));
      expect(labels.values, contains('Penyusunan Laporan Keuangan'));
      expect(provider.skillsComplete, isTrue);
    });
  });
}
