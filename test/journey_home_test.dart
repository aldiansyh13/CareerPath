import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/career_journey.dart';
import 'package:careerpath_ai/models/user_profile.dart';
import 'package:careerpath_ai/providers/assessment_provider.dart';
import 'package:careerpath_ai/providers/journey_provider.dart';
import 'package:careerpath_ai/screens/home_screen.dart';
import 'package:careerpath_ai/services/local_store.dart';
import 'package:careerpath_ai/utils/app_theme.dart';
import 'package:careerpath_ai/utils/validators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('home leads with active journey and next action', (tester) async {
    tester.view.physicalSize = const Size(640, 1136);
    tester.view.devicePixelRatio = 2;
    addTearDown(tester.view.reset);

    final result = validateAndParseResult(
      Map<String, dynamic>.from(kSampleResult),
      isSample: true,
    );
    final assessment = AssessmentProvider()
      ..setProfile(const UserProfile(
        name: 'Rina',
        major: 'Sistem Informasi',
        semester: 4,
      ));
    final journey = JourneyProvider(store: LocalStore());
    await journey.startJourney(
      CareerJourney.fromRecommendation(
        assessmentId: 'assessment-1',
        recommendation: result.careers.first,
        isSample: true,
        now: DateTime.utc(2026, 11, 15),
      ),
    );

    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: assessment),
          ChangeNotifierProvider.value(value: journey),
        ],
        child: MaterialApp(theme: buildAppTheme(), home: const HomeScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('JALUR AKTIF'), findsOneWidget);
    expect(find.text('UI/UX Designer'), findsOneWidget);
    expect(find.text('88% cocok'), findsOneWidget);
    expect(find.text('0 dari 8 langkah selesai'), findsOneWidget);
    expect(find.textContaining('MINGGU 1'), findsOneWidget);
    expect(
      find.text('Pelajari prinsip dasar UX (hierarki, kontras, konsistensi)'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);

    await tester.tap(find.text('Tandai selesai'));
    await tester.pumpAndSettle();

    expect(journey.activeJourney?.completedActions, 1);
    expect(find.text('1 dari 8 langkah selesai'), findsOneWidget);
    expect(find.text('Langkah selesai. Progres kini 13%.'), findsOneWidget);
  });
}
