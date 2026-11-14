import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/main.dart';
import 'package:careerpath_ai/data/questions.dart';
import 'package:careerpath_ai/screens/interest_screen.dart';
import 'package:careerpath_ai/widgets/career_card.dart';

/// Layar uji diperbesar agar seluruh konten ListView ikut dibangun.
void _setupView(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

/// Alur QA end-to-end mode lokal (tanpa Gemini) memakai hasil contoh.
Future<void> _startAndFillProfile(WidgetTester tester) async {
  await tester.tap(find.text('Mulai asesmen'));
  await tester.pumpAndSettle();

  final fields = find.byType(TextFormField);
  expect(fields, findsNWidgets(3));
  await tester.enterText(fields.at(0), 'Mahasiswa Uji');
  await tester.enterText(fields.at(1), 'Informatika');
  await tester.enterText(fields.at(2), '4');

  await tester.tap(find.text('Simpan & lanjut'));
  await tester.pumpAndSettle();
  expect(find.byType(InterestScreen), findsOneWidget);
}

Future<void> _answerAllInterests(WidgetTester tester) async {
  for (final q in kInterestQuestions) {
    final option = find.text(q.options.first);
    await tester.scrollUntilVisible(
      option,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(option);
    await tester.pumpAndSettle();
  }
}

Future<void> _rateAllSkillsWithDefault(WidgetTester tester) async {
  for (int i = 0; i < 6; i++) {
    final button = find.text('Tetapkan nilai ini').first;
    await tester.scrollUntilVisible(
      button,
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(button);
    await tester.pumpAndSettle();
  }
}

Future<void> _scrollTo(WidgetTester tester, Finder finder) async {
  await tester.scrollUntilVisible(
    finder,
    250,
    scrollable: find.byType(Scrollable).last,
  );
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
}

Future<void> _runSampleAnalysis(WidgetTester tester) async {
  final sampleButton = find.text('Gunakan contoh hasil (tanpa AI)');
  await _scrollTo(tester, sampleButton);
  await tester.tap(sampleButton);
  await tester.pumpAndSettle();
  expect(find.text('3 Rekomendasi Karier'), findsOneWidget);
}

Future<void> _completeAssessmentWithSample(WidgetTester tester) async {
  await _startAndFillProfile(tester);
  await _answerAllInterests(tester);
  await tester.tap(find.text('Lanjut ke penilaian skill'));
  await tester.pumpAndSettle();
  await _rateAllSkillsWithDefault(tester);
  await tester.tap(find.text('Lihat ringkasan'));
  await tester.pumpAndSettle();
  await _runSampleAnalysis(tester);
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('Alur lengkap lokal: profil → 8 minat → 6 skill → hasil contoh',
      (WidgetTester tester) async {
    _setupView(tester);
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    await _completeAssessmentWithSample(tester);

    // Tepat 3 kartu karier dengan skor & alasan.
    expect(find.byType(CareerCard), findsNWidgets(3));
    expect(find.text('UI/UX Designer'), findsOneWidget);
    expect(find.text('Frontend Developer'), findsOneWidget);
    expect(find.text('Product Manager'), findsOneWidget);
    expect(find.text('88% cocok'), findsOneWidget);

    // Label contoh/offline + disclaimer PRD tampil.
    expect(find.textContaining('Contoh hasil (offline)'), findsOneWidget);
    final disclaimer = find.textContaining('bukan keputusan karier final');
    await _scrollTo(tester, disclaimer);
    expect(disclaimer, findsOneWidget);

    // Detail menampilkan skill dimiliki/kurang dan roadmap 4 minggu.
    await tester.tap(find.byType(CareerCard).first);
    await tester.pumpAndSettle();
    expect(find.text('Skill yang sudah kamu miliki'), findsOneWidget);
    expect(find.text('Skill yang perlu dilatih'), findsOneWidget);
    final roadmapTitle = find.text('Roadmap 30 hari');
    await _scrollTo(tester, roadmapTitle);
    expect(roadmapTitle, findsOneWidget);
    for (int week = 1; week <= 4; week++) {
      final weekText = find.textContaining('Minggu $week:');
      await _scrollTo(tester, weekText);
      expect(weekText, findsOneWidget);
    }
  });

  testWidgets('Tombol analisis terkunci sampai persetujuan data dicentang',
      (WidgetTester tester) async {
    _setupView(tester);
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    await _startAndFillProfile(tester);
    await _answerAllInterests(tester);
    await tester.tap(find.text('Lanjut ke penilaian skill'));
    await tester.pumpAndSettle();
    await _rateAllSkillsWithDefault(tester);
    await tester.tap(find.text('Lihat ringkasan'));
    await tester.pumpAndSettle();

    FilledButton analyzeButton() => tester.widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Analisis dengan AI'),
        );

    await _scrollTo(tester, find.text('Analisis dengan AI'));
    expect(analyzeButton().onPressed, isNull);

    await tester.tap(find.byType(Checkbox));
    await tester.pumpAndSettle();

    expect(analyzeButton().onPressed, isNotNull);
  });

  testWidgets('Riwayat lokal tersimpan dan terbuka tanpa memanggil Gemini',
      (WidgetTester tester) async {
    _setupView(tester);
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    await _completeAssessmentWithSample(tester);

    // Buka ulang aplikasi: profil lokal ada → Beranda dengan riwayat.
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    expect(find.text('Riwayat hasil'), findsOneWidget);
    expect(find.text('Top: UI/UX Designer (88%)'), findsOneWidget);

    await tester.tap(find.text('Top: UI/UX Designer (88%)'));
    await tester.pumpAndSettle();
    expect(find.text('3 Rekomendasi Karier'), findsOneWidget);
    expect(find.textContaining('Contoh hasil (offline)'), findsOneWidget);
  });

  testWidgets('Ulangi asesmen mengosongkan jawaban lama', (WidgetTester tester) async {
    _setupView(tester);
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    await _completeAssessmentWithSample(tester);

    await _scrollTo(tester, find.text('Ulangi asesmen'));
    await tester.tap(find.text('Ulangi asesmen'));
    await tester.pumpAndSettle();
    expect(find.byType(InterestScreen), findsOneWidget);
    expect(find.text('0 dari 8 pertanyaan terisi'), findsOneWidget);
  });
}
