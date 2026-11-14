import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/career_journey.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/providers/journey_provider.dart';
import 'package:careerpath_ai/screens/career_detail_screen.dart';
import 'package:careerpath_ai/screens/result_screen.dart';
import 'package:careerpath_ai/services/local_store.dart';
import 'package:careerpath_ai/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('result can become the active sample journey', (tester) async {
    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    final journeyProvider = JourneyProvider(store: LocalStore());

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AssessmentProvider()),
          ChangeNotifierProvider.value(value: journeyProvider),
        ],
        child: MaterialApp(
          home: ResultScreen(
            result: result,
            input: Map<String, dynamic>.from(kSampleInput),
            assessmentId: 'assessment-1',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final focusButton = find.text('Jadikan fokus').first;
    await tester.scrollUntilVisible(
      focusButton,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(focusButton);
    await tester.pumpAndSettle();

    expect(journeyProvider.activeJourney?.assessmentId, 'assessment-1');
    expect(journeyProvider.activeJourney?.career.title, 'UI/UX Designer');
    expect(journeyProvider.activeJourney?.isSample, isTrue);
    expect(find.text('JALUR AKTIF'), findsOneWidget);
    expect(
      (await LocalStore().getJourney())?.career.title,
      'UI/UX Designer',
    );
  });

  testWidgets('roadmap checkbox persists and snackbar undo restores it',
      (tester) async {
    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    final provider = JourneyProvider(store: LocalStore());
    await provider.startJourney(
      CareerJourney.fromRecommendation(
        assessmentId: 'assessment-1',
        recommendation: result.careers.first,
        isSample: true,
        now: DateTime.utc(2026, 11, 15),
      ),
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: provider,
        child: MaterialApp(
          home: CareerDetailScreen(
            career: result.careers.first,
            assessmentId: 'assessment-1',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final firstAction =
        find.text('Pelajari prinsip dasar UX (hierarki, kontras, konsistensi)');
    await tester.scrollUntilVisible(
      firstAction,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    expect(provider.activeJourney?.completedActionIds, contains('w1-a0'));
    expect(find.text('Urungkan'), findsOneWidget);

    await tester.tap(find.text('Urungkan'));
    await tester.pumpAndSettle();

    expect(provider.activeJourney?.completedActionIds, isEmpty);
  });

  testWidgets('same career title from another assessment is not active',
      (tester) async {
    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    final provider = JourneyProvider(store: LocalStore());
    await provider.startJourney(
      CareerJourney.fromRecommendation(
        assessmentId: 'assessment-old',
        recommendation: result.careers.first,
        isSample: true,
        now: DateTime.utc(2026, 11, 15),
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AssessmentProvider()),
          ChangeNotifierProvider.value(value: provider),
        ],
        child: MaterialApp(
          home: ResultScreen(
            result: result,
            input: Map<String, dynamic>.from(kSampleInput),
            assessmentId: 'assessment-new',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final focusButton = find.text('Jadikan fokus').first;
    await tester.scrollUntilVisible(
      focusButton,
      300,
      scrollable: find.byType(Scrollable).last,
    );
    expect(focusButton, findsOneWidget);
  });
}
