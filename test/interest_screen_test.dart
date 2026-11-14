import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:careerpath_ai/data/questions.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/screens/interest_screen.dart';

/// Uji UI layar asesmen minat (tugas Orang 1): 8 pertanyaan tampil,
/// tombol lanjut hanya aktif setelah 8/8 terjawab, jawaban tersimpan.
void main() {
  testWidgets('Tombol lanjut aktif hanya setelah 8/8 pertanyaan terjawab',
      (WidgetTester tester) async {
    final provider = AssessmentProvider();
    await tester.pumpWidget(
      ChangeNotifierProvider<AssessmentProvider>.value(
        value: provider,
        child: const MaterialApp(home: InterestScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('0 dari ${kInterestQuestions.length} pertanyaan terisi'),
        findsOneWidget);
    final nextButton = find.widgetWithText(
        FilledButton, 'Lanjut ke penilaian skill');
    expect(tester.widget<FilledButton>(nextButton).onPressed, isNull,
        reason: 'Tombol lanjut harus nonaktif sebelum semua pertanyaan terisi');

    for (var i = 0; i < kInterestQuestions.length; i++) {
      final q = kInterestQuestions[i];
      // Teks soal ditampilkan dengan prefix nomor ("1. ...").
      final option = find.descendant(
        of: find.ancestor(
            of: find.text('${i + 1}. ${q.text}'), matching: find.byType(Card)),
        matching: find.widgetWithText(RadioListTile<String>, q.options.first),
      );
      expect(option, findsOneWidget,
          reason: 'Pilihan pertama untuk soal "${q.text}" harus ada');
      await tester.ensureVisible(option);
      await tester.pumpAndSettle();
      await tester.tap(option);
      await tester.pumpAndSettle();
    }

    expect(provider.interestAnswers.length, kInterestQuestions.length);
    expect(
        find.text(
            '${kInterestQuestions.length} dari ${kInterestQuestions.length} pertanyaan terisi'),
        findsOneWidget);
    expect(tester.widget<FilledButton>(nextButton).onPressed, isNotNull,
        reason: 'Tombol lanjut harus aktif setelah 8/8 terjawab');
  });
}
