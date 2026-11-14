import 'package:careerpath_ai/models/career_journey.dart';
import 'package:careerpath_ai/models/career_result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final recommendation = CareerRecommendation(
    title: 'UI/UX Designer',
    matchScore: 88,
    reason: 'Kamu kuat di desain dan komunikasi.',
    skillsOwned: const ['Desain visual'],
    skillsMissing: const ['User research'],
    roadmap: const [
      RoadmapWeek(
        week: 1,
        title: 'Dasar UX',
        actions: ['Pelajari prinsip UX', 'Bedah satu aplikasi'],
      ),
      RoadmapWeek(
        week: 2,
        title: 'Riset pengguna',
        actions: ['Wawancarai dua teman'],
      ),
    ],
  );

  test('action ids stay stable and independent from action copy', () {
    expect(CareerJourney.actionId(week: 1, actionIndex: 0), 'w1-a0');
    expect(CareerJourney.actionId(week: 2, actionIndex: 0), 'w2-a0');
  });

  test('new journey snapshots recommendation and exposes next action', () {
    final journey = CareerJourney.fromRecommendation(
      assessmentId: 'assessment-1',
      recommendation: recommendation,
      isSample: true,
      now: DateTime.utc(2026, 11, 15),
    );

    expect(journey.career.title, 'UI/UX Designer');
    expect(journey.career.roadmap.length, 2);
    expect(journey.isSample, isTrue);
    expect(journey.totalActions, 3);
    expect(journey.completedActions, 0);
    expect(journey.progress, 0);
    expect(journey.activeWeek?.week, 1);
    expect(journey.nextAction?.text, 'Pelajari prinsip UX');
    expect(journey.nextAction?.id, 'w1-a0');
    expect(journey.isComplete, isFalse);
  });

  test('toggle advances progress and active week in roadmap order', () {
    var journey = CareerJourney.fromRecommendation(
      assessmentId: 'assessment-1',
      recommendation: recommendation,
      isSample: false,
      now: DateTime.utc(2026, 11, 15),
    );

    journey = journey.toggleAction('w1-a0', now: DateTime.utc(2026, 11, 16));
    expect(journey.completedActions, 1);
    expect(journey.progress, closeTo(1 / 3, 0.0001));
    expect(journey.activeWeek?.week, 1);
    expect(journey.nextAction?.id, 'w1-a1');

    journey = journey.toggleAction('w1-a1', now: DateTime.utc(2026, 11, 16));
    expect(journey.activeWeek?.week, 2);
    expect(journey.nextAction?.id, 'w2-a0');

    journey = journey.toggleAction('w2-a0', now: DateTime.utc(2026, 11, 16));
    expect(journey.progress, 1);
    expect(journey.activeWeek, isNull);
    expect(journey.nextAction, isNull);
    expect(journey.isComplete, isTrue);
  });

  test('toggling a completed action undoes it', () {
    final original = CareerJourney.fromRecommendation(
      assessmentId: 'assessment-1',
      recommendation: recommendation,
      isSample: false,
      now: DateTime.utc(2026, 11, 15),
    );
    final completed = original.toggleAction(
      'w1-a0',
      now: DateTime.utc(2026, 11, 16),
    );
    final undone = completed.toggleAction(
      'w1-a0',
      now: DateTime.utc(2026, 11, 17),
    );

    expect(undone.completedActionIds, isEmpty);
    expect(undone.nextAction?.id, 'w1-a0');
  });

  test('json round trip preserves complete recommendation snapshot', () {
    final journey = CareerJourney.fromRecommendation(
      assessmentId: 'assessment-1',
      recommendation: recommendation,
      isSample: true,
      now: DateTime.utc(2026, 11, 15),
    ).toggleAction('w1-a0', now: DateTime.utc(2026, 11, 16));

    final restored = CareerJourney.fromJson(journey.toJson());

    expect(restored.assessmentId, 'assessment-1');
    expect(restored.career.reason, recommendation.reason);
    expect(restored.career.skillsOwned, recommendation.skillsOwned);
    expect(restored.career.skillsMissing, recommendation.skillsMissing);
    expect(restored.career.roadmap.first.actions,
        recommendation.roadmap.first.actions);
    expect(restored.completedActionIds, {'w1-a0'});
    expect(restored.startedAt, DateTime.utc(2026, 11, 15));
    expect(restored.updatedAt, DateTime.utc(2026, 11, 16));
  });

  test('empty roadmap has zero progress without division by zero', () {
    final journey = CareerJourney.fromRecommendation(
      assessmentId: 'assessment-empty',
      recommendation: const CareerRecommendation(
        title: 'Empty',
        matchScore: 0,
        reason: '-',
        skillsOwned: [],
        skillsMissing: [],
        roadmap: [],
      ),
      isSample: false,
      now: DateTime.utc(2026, 11, 15),
    );

    expect(journey.progress, 0);
    expect(journey.isComplete, isFalse);
  });
}
