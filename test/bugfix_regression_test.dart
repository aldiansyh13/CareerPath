import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/career_result.dart';
import 'package:careerpath_ai/models/user_profile.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/screens/auth_screen.dart';
import 'package:careerpath_ai/screens/home_screen.dart';
import 'package:careerpath_ai/screens/profile_screen.dart';
import 'package:careerpath_ai/services/app_backend.dart';
import 'package:careerpath_ai/services/auth_service.dart';
import 'package:careerpath_ai/services/local_store.dart';

class FailingBackend extends AppBackend {
  FailingBackend() : super(LocalStore());
  @override
  Future<void> saveProfile(UserProfile profile) async =>
      throw StateError('disk full');
}

class PendingAuth extends AuthService {
  final completion = Completer<UserCredential>();
  @override
  bool get isReady => true;
  @override
  Future<UserCredential> login(String email, String password) =>
      completion.future;
}

AssessmentRecord record(String id, int day) => AssessmentRecord(
      id: id,
      createdAt: DateTime(2026, 11, day),
      input: const {},
      result: CareerResult.fromJson(kSampleResult, isSample: true),
    );

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('Riwayat lokal tetap ada saat cloud kosong dan duplikasi dihapus', () {
    final local = record('pending', 14);
    expect(AppBackend.mergeHistory([local], []), [local]);
    final cloud = record('synced', 13);
    final result =
        AppBackend.mergeHistory([local, record('synced', 12)], [cloud]);
    expect(result.map((r) => r.id), ['pending', 'synced']);
    expect(result.last, same(cloud));
  });

  test('Cache akun terpisah dari akun lain dan tamu', () async {
    final a = LocalStore(userId: 'A');
    final b = LocalStore(userId: 'B');
    await a.addAssessment(record('private-A', 14));
    await a.saveProfile(const UserProfile(name: 'A', major: 'TI', semester: 2));
    expect(await b.getHistory(), isEmpty);
    expect(await b.getProfile(), isNull);
    expect(await LocalStore().getHistory(), isEmpty);
    expect((await a.getHistory()).single.id, 'private-A');
  });

  testWidgets(
      'Gagal menyimpan profil tetap di form dan tidak mengubah provider',
      (tester) async {
    final provider = AssessmentProvider();
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: provider,
      child: MaterialApp(
          home: ProfileScreen(
              startAssessmentAfter: true, backend: FailingBackend())),
    ));
    final fields = find.byType(TextFormField);
    await tester.enterText(fields.at(0), 'Habib');
    await tester.enterText(fields.at(1), 'Informatika');
    await tester.enterText(fields.at(2), '4');
    await tester.ensureVisible(find.text('Simpan & lanjut'));
    await tester.tap(find.text('Simpan & lanjut'));
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(
        find.textContaining('Profil belum berhasil disimpan'), findsOneWidget);
    expect(provider.profile, isNull);
  });

  testWidgets('Login gagal setelah layar ditutup tidak memanggil setState',
      (tester) async {
    final auth = PendingAuth();
    await tester.pumpWidget(MaterialApp(home: AuthScreen(auth: auth)));
    await tester.enterText(
        find.byType(TextFormField).at(0), 'test@example.com');
    await tester.enterText(find.byType(TextFormField).at(1), 'password');
    await tester.tap(find.widgetWithText(FilledButton, 'Masuk'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    auth.completion.completeError(AuthFailure('Jaringan gagal'));
    await tester.pump();
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'Ulangi dari beranda mengosongkan jawaban dan label contoh terlihat',
      (tester) async {
    await LocalStore().addAssessment(record('sample', 14));
    final provider = AssessmentProvider()..loadSampleInput(kSampleInput);
    await tester.pumpWidget(ChangeNotifierProvider.value(
      value: provider,
      child: const MaterialApp(home: HomeScreen()),
    ));
    await tester.pumpAndSettle();
    expect(find.textContaining('• Contoh'), findsOneWidget);
    await tester.tap(find.text('Mulai / Ulangi Asesmen'));
    await tester.pumpAndSettle();
    expect(provider.interestAnswers, isEmpty);
    expect(provider.skillRatings, isEmpty);
    expect(provider.profile, isNotNull);
  });
}
