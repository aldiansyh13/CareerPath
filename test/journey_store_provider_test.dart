import 'package:careerpath_ai/models/career_journey.dart';
import 'package:careerpath_ai/models/career_result.dart';
import 'package:careerpath_ai/providers/journey_provider.dart';
import 'package:careerpath_ai/services/local_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

CareerJourney _journey(String assessmentId) {
  return CareerJourney.fromRecommendation(
    assessmentId: assessmentId,
    recommendation: const CareerRecommendation(
      title: 'UI/UX Designer',
      matchScore: 88,
      reason: 'Cocok dengan minat desain.',
      skillsOwned: ['Desain visual'],
      skillsMissing: ['User research'],
      roadmap: [
        RoadmapWeek(
          week: 1,
          title: 'Dasar UX',
          actions: ['Pelajari prinsip UX', 'Bedah satu aplikasi'],
        ),
      ],
    ),
    isSample: false,
    now: DateTime.utc(2026, 11, 15),
  );
}

class _FailingStore extends LocalStore {
  bool shouldFail = false;

  @override
  Future<void> saveJourney(CareerJourney journey) async {
    if (shouldFail) throw StateError('disk penuh');
    await super.saveJourney(journey);
  }
}

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  test('empty store returns no active journey', () async {
    expect(await LocalStore().getJourney(), isNull);
  });

  test('journey round trip is isolated between guest and account ids',
      () async {
    await LocalStore().saveJourney(_journey('guest-assessment'));
    await LocalStore(userId: 'user-a').saveJourney(_journey('a-assessment'));

    expect((await LocalStore().getJourney())?.assessmentId, 'guest-assessment');
    expect(
      (await LocalStore(userId: 'user-a').getJourney())?.assessmentId,
      'a-assessment',
    );
    expect(await LocalStore(userId: 'user-b').getJourney(), isNull);
  });

  test('clear journey removes only its storage namespace', () async {
    await LocalStore().saveJourney(_journey('guest-assessment'));
    await LocalStore(userId: 'user-a').saveJourney(_journey('a-assessment'));

    await LocalStore(userId: 'user-a').clearJourney();

    expect((await LocalStore().getJourney())?.assessmentId, 'guest-assessment');
    expect(await LocalStore(userId: 'user-a').getJourney(), isNull);
  });

  test('provider starts, toggles, undoes, and reloads journey', () async {
    var clock = DateTime.utc(2026, 11, 16);
    final store = LocalStore();
    final provider = JourneyProvider(store: store, now: () => clock);

    await provider.load();
    expect(provider.activeJourney, isNull);

    await provider.startJourney(_journey('assessment-1'));
    expect(provider.activeJourney?.career.title, 'UI/UX Designer');

    final firstUndo = await provider.toggleAction('w1-a0');
    expect(provider.activeJourney?.completedActionIds, {'w1-a0'});

    clock = DateTime.utc(2026, 11, 17);
    await provider.undoToggle(firstUndo!);
    expect(provider.activeJourney?.completedActionIds, isEmpty);

    await provider.toggleAction('w1-a0');
    final restored = JourneyProvider(store: store);
    await restored.load();
    expect(restored.activeJourney?.completedActionIds, {'w1-a0'});
  });

  test('unknown action does not create a false undo state', () async {
    final provider = JourneyProvider(store: LocalStore());
    await provider.startJourney(_journey('assessment-1'));

    final undo = await provider.toggleAction('missing');

    expect(undo, isNull);
    expect(provider.activeJourney?.completedActionIds, isEmpty);
  });

  test('switching account storage replaces the visible journey', () async {
    await LocalStore().saveJourney(_journey('guest-assessment'));
    await LocalStore(userId: 'user-a').saveJourney(_journey('a-assessment'));
    final provider = JourneyProvider(store: LocalStore());
    await provider.load();
    expect(provider.activeJourney?.assessmentId, 'guest-assessment');

    await provider.switchStore(LocalStore(userId: 'user-a'));

    expect(provider.activeJourney?.assessmentId, 'a-assessment');
  });

  test('undo token reverses its own action after another toggle', () async {
    final provider = JourneyProvider(store: LocalStore());
    await provider.startJourney(_journey('assessment-1'));

    final undoA = await provider.toggleAction('w1-a0');
    final undoB = await provider.toggleAction('w1-a1');
    await provider.undoToggle(undoA!);

    expect(provider.activeJourney?.completedActionIds, {'w1-a1'});

    await provider.undoToggle(undoB!);
    expect(provider.activeJourney?.completedActionIds, isEmpty);
  });

  test('failed writes roll optimistic state back and expose the error',
      () async {
    final store = _FailingStore();
    final provider = JourneyProvider(store: store);
    store.shouldFail = true;

    await expectLater(
      provider.startJourney(_journey('assessment-1')),
      throwsA(isA<StateError>()),
    );
    expect(provider.activeJourney, isNull);
    expect(provider.lastError, isA<StateError>());

    store.shouldFail = false;
    await provider.startJourney(_journey('assessment-1'));
    store.shouldFail = true;

    await expectLater(
      provider.toggleAction('w1-a0'),
      throwsA(isA<StateError>()),
    );
    expect(provider.activeJourney?.completedActionIds, isEmpty);
  });
}
