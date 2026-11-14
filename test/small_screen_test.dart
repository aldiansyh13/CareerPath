import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/user_profile.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/screens/auth_screen.dart';
import 'package:careerpath_ai/screens/career_detail_screen.dart';
import 'package:careerpath_ai/screens/home_screen.dart';
import 'package:careerpath_ai/screens/interest_screen.dart';
import 'package:careerpath_ai/screens/profile_screen.dart';
import 'package:careerpath_ai/screens/result_screen.dart';
import 'package:careerpath_ai/screens/skill_screen.dart';
import 'package:careerpath_ai/screens/summary_screen.dart';
import 'package:careerpath_ai/screens/welcome_screen.dart';
import 'package:careerpath_ai/utils/app_theme.dart';
import 'package:careerpath_ai/utils/validators.dart';

/// Uji layout layar kecil (5 inci, 320x568 logis @2x) — tugas Orang 1:
/// layar utama tidak boleh overflow / memunculkan exception garis kuning-hitam.
/// (Layar Analisis tidak diuji di sini karena otomatis navigasi setelah analisis;
///  dipisah di alur uji manual.)
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  AssessmentProvider providerWithProfile() {
    final p = AssessmentProvider();
    p.setProfile(UserProfile(name: 'Aldi', major: 'Informatika', semester: 4));
    return p;
  }

  Future<void> pumpSmall(WidgetTester tester, Widget home) async {
    tester.view.physicalSize = const Size(640, 1136); // 320x568 logis @2x
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(theme: buildAppTheme(), home: home));
    await tester.pumpAndSettle();
  }

  Future<void> expectNoOverflow(WidgetTester tester) async {
    // Drain semua exception yang terekam selama test; laporkan yang pertama.
    Object? exception;
    while (true) {
      final e = tester.takeException();
      if (e == null) break;
      exception ??= e;
    }
    expect(exception, isNull,
        reason: 'Layout layar kecil melempar exception: $exception');
  }

  Future<void> scrollTo(WidgetTester tester, Finder finder) async {
    // Konten panjang (ListView) hanya membangun yang terlihat; gulir dulu.
    await tester.scrollUntilVisible(finder, 300,
        scrollable: find.byType(Scrollable));
    await tester.pumpAndSettle();
  }

  testWidgets('Welcome aman di layar kecil', (tester) async {
    await pumpSmall(tester, const WelcomeScreen());
    await scrollTo(tester, find.text('Mulai asesmen'));
    await expectNoOverflow(tester);
    expect(find.text('Mulai asesmen'), findsOneWidget);
    expect(find.text('Masuk / Daftar'), findsOneWidget);
    expect(find.text('Jelajahi contoh hasil (offline)'), findsOneWidget);
  });

  testWidgets('Auth aman di layar kecil', (tester) async {
    await pumpSmall(tester, const AuthScreen());
    await expectNoOverflow(tester);
    expect(find.text('Masuk'), findsWidgets);
  });

  testWidgets('Profil aman di layar kecil', (tester) async {
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: const ProfileScreen(),
      ),
    );
    await expectNoOverflow(tester);
    expect(find.text('Simpan & lanjut'), findsOneWidget);
  });

  testWidgets('Asesmen minat aman di layar kecil', (tester) async {
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: const InterestScreen(),
      ),
    );
    await expectNoOverflow(tester);
    expect(find.text('Lanjut ke penilaian skill'), findsOneWidget);
  });

  testWidgets('Penilaian skill aman di layar kecil', (tester) async {
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: const SkillScreen(),
      ),
    );
    await expectNoOverflow(tester);
    expect(find.text('Lihat ringkasan'), findsOneWidget);
  });

  testWidgets('Ringkasan aman di layar kecil', (tester) async {
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: const SummaryScreen(),
      ),
    );
    await scrollTo(tester, find.text('Analisis dengan AI'));
    await expectNoOverflow(tester);
    expect(find.text('Analisis dengan AI'), findsOneWidget);
  });

  testWidgets('Hasil aman di layar kecil', (tester) async {
    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: ResultScreen(
          result: result,
          input: Map<String, dynamic>.from(kSampleInput),
        ),
      ),
    );
    await scrollTo(tester, find.text('Ulangi asesmen'));
    await expectNoOverflow(tester);
    expect(find.text('Ulangi asesmen'), findsOneWidget);
  });

  testWidgets('Detail karier aman di layar kecil', (tester) async {
    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    await pumpSmall(
      tester,
      CareerDetailScreen(career: result.careers.first),
    );
    await scrollTo(tester, find.text('Roadmap 30 hari'));
    await expectNoOverflow(tester);
    expect(find.text('Roadmap 30 hari'), findsOneWidget);
  });

  testWidgets('Beranda aman di layar kecil', (tester) async {
    final p = providerWithProfile();
    await pumpSmall(
      tester,
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: p,
        child: const HomeScreen(),
      ),
    );
    await expectNoOverflow(tester);
    expect(find.text('Riwayat hasil'), findsOneWidget);
  });
}
