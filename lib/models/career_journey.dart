import 'career_result.dart';

class JourneyAction {
  final String id;
  final int week;
  final String weekTitle;
  final String text;

  const JourneyAction({
    required this.id,
    required this.week,
    required this.weekTitle,
    required this.text,
  });
}

class CareerJourney {
  final String assessmentId;
  final CareerRecommendation career;
  final bool isSample;
  final DateTime startedAt;
  final DateTime updatedAt;
  final Set<String> completedActionIds;

  const CareerJourney({
    required this.assessmentId,
    required this.career,
    required this.isSample,
    required this.startedAt,
    required this.updatedAt,
    required this.completedActionIds,
  });

  factory CareerJourney.fromRecommendation({
    required String assessmentId,
    required CareerRecommendation recommendation,
    required bool isSample,
    required DateTime now,
  }) {
    return CareerJourney(
      assessmentId: assessmentId,
      career: recommendation,
      isSample: isSample,
      startedAt: now,
      updatedAt: now,
      completedActionIds: const <String>{},
    );
  }

  static String actionId({required int week, required int actionIndex}) =>
      'w$week-a$actionIndex';

  List<JourneyAction> get actions {
    return [
      for (final roadmapWeek in career.roadmap)
        for (var index = 0; index < roadmapWeek.actions.length; index++)
          JourneyAction(
            id: actionId(week: roadmapWeek.week, actionIndex: index),
            week: roadmapWeek.week,
            weekTitle: roadmapWeek.title,
            text: roadmapWeek.actions[index],
          ),
    ];
  }

  int get totalActions => actions.length;

  int get completedActions =>
      actions.where((action) => completedActionIds.contains(action.id)).length;

  double get progress =>
      totalActions == 0 ? 0 : completedActions / totalActions;

  bool get isComplete => totalActions > 0 && completedActions == totalActions;

  RoadmapWeek? get activeWeek {
    for (final week in career.roadmap) {
      final hasIncompleteAction = week.actions.asMap().entries.any(
            (entry) => !completedActionIds.contains(
              actionId(week: week.week, actionIndex: entry.key),
            ),
          );
      if (hasIncompleteAction) return week;
    }
    return null;
  }

  JourneyAction? get nextAction {
    for (final action in actions) {
      if (!completedActionIds.contains(action.id)) return action;
    }
    return null;
  }

  CareerJourney toggleAction(String id, {required DateTime now}) {
    final validIds = actions.map((action) => action.id).toSet();
    if (!validIds.contains(id)) return this;
    final updatedIds = Set<String>.from(completedActionIds);
    if (!updatedIds.add(id)) updatedIds.remove(id);
    return CareerJourney(
      assessmentId: assessmentId,
      career: career,
      isSample: isSample,
      startedAt: startedAt,
      updatedAt: now,
      completedActionIds: Set.unmodifiable(updatedIds),
    );
  }

  Map<String, dynamic> toJson() => {
        'assessmentId': assessmentId,
        'career': career.toJson(),
        'isSample': isSample,
        'startedAt': startedAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
        'completedActionIds': completedActionIds.toList(),
      };

  factory CareerJourney.fromJson(Map<String, dynamic> json) {
    final careerJson = Map<String, dynamic>.from(
      json['career'] as Map? ?? const <String, dynamic>{},
    );
    final startedAt = DateTime.tryParse(json['startedAt']?.toString() ?? '');
    final updatedAt = DateTime.tryParse(json['updatedAt']?.toString() ?? '');
    return CareerJourney(
      assessmentId: json['assessmentId']?.toString() ?? '',
      career: CareerRecommendation.fromJson(careerJson),
      isSample: json['isSample'] == true,
      startedAt: startedAt ?? DateTime.now(),
      updatedAt: updatedAt ?? startedAt ?? DateTime.now(),
      completedActionIds: Set.unmodifiable(
        (json['completedActionIds'] as List<dynamic>? ?? const <dynamic>[])
            .map((item) => item.toString())
            .toSet(),
      ),
    );
  }
}
