class RoadmapWeek {
  final int week;
  final String title;
  final List<String> actions;

  const RoadmapWeek({required this.week, required this.title, required this.actions});

  factory RoadmapWeek.fromJson(Map<String, dynamic> json) {
    return RoadmapWeek(
      week: (json['week'] as num?)?.toInt() ?? 0,
      title: (json['title'] ?? '') as String,
      actions: (json['actions'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'week': week, 'title': title, 'actions': actions};
}

class CareerRecommendation {
  final String title;
  final int matchScore;
  final String reason;
  final List<String> skillsOwned;
  final List<String> skillsMissing;
  final List<RoadmapWeek> roadmap;

  const CareerRecommendation({
    required this.title,
    required this.matchScore,
    required this.reason,
    required this.skillsOwned,
    required this.skillsMissing,
    required this.roadmap,
  });

  factory CareerRecommendation.fromJson(Map<String, dynamic> json) {
    return CareerRecommendation(
      title: (json['title'] ?? '') as String,
      matchScore: (json['match_score'] as num?)?.toInt() ?? 0,
      reason: (json['reason'] ?? '') as String,
      skillsOwned: (json['skills_owned'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      skillsMissing: (json['skills_missing'] as List<dynamic>? ?? const [])
          .map((e) => e.toString())
          .toList(),
      roadmap: (json['roadmap'] as List<dynamic>? ?? const [])
          .whereType<Map>()
          .map((e) => RoadmapWeek.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'title': title,
        'match_score': matchScore,
        'reason': reason,
        'skills_owned': skillsOwned,
        'skills_missing': skillsMissing,
        'roadmap': roadmap.map((e) => e.toJson()).toList(),
      };
}

class CareerResult {
  final String summary;
  final List<CareerRecommendation> careers;
  final bool isSample;

  const CareerResult({required this.summary, required this.careers, this.isSample = false});

  factory CareerResult.fromJson(Map<String, dynamic> json, {bool isSample = false}) {
    final careers = (json['careers'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => CareerRecommendation.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return CareerResult(
      summary: (json['summary'] ?? '') as String,
      careers: careers,
      isSample: isSample,
    );
  }

  Map<String, dynamic> toJson() => {
        'summary': summary,
        'careers': careers.map((e) => e.toJson()).toList(),
      };
}

class AssessmentRecord {
  final String id;
  final DateTime createdAt;
  final Map<String, dynamic> input;
  final CareerResult result;

  const AssessmentRecord({
    required this.id,
    required this.createdAt,
    required this.input,
    required this.result,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'input': input,
        'result': result.toJson(),
        'isSample': result.isSample,
      };

  factory AssessmentRecord.fromJson(Map<String, dynamic> json) {
    final resultMap = Map<String, dynamic>.from(json['result'] as Map? ?? const {});
    return AssessmentRecord(
      id: (json['id'] ?? '') as String,
      createdAt: DateTime.tryParse((json['createdAt'] ?? '') as String) ?? DateTime.now(),
      input: Map<String, dynamic>.from(json['input'] as Map? ?? const {}),
      result: CareerResult.fromJson(resultMap, isSample: json['isSample'] == true),
    );
  }
}
