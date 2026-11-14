import '../data/careers.dart';
import '../models/career_result.dart';

class ResultValidationException implements Exception {
  final String message;
  ResultValidationException(this.message);
  @override
  String toString() => message;
}

CareerResult validateAndParseResult(Map<String, dynamic> json, {bool isSample = false}) {
  if (json['summary'] is! String || (json['summary'] as String).trim().isEmpty) {
    throw ResultValidationException('Field "summary" tidak valid.');
  }
  final careersRaw = json['careers'];
  if (careersRaw is! List) {
    throw ResultValidationException('Field "careers" harus berupa daftar.');
  }
  if (careersRaw.length != 3) {
    throw ResultValidationException('Harus ada tepat 3 rekomendasi karier.');
  }
  final titles = <String>{};
  final scores = <int>[];
  final parsed = <CareerRecommendation>[];
  for (final item in careersRaw) {
    if (item is! Map) throw ResultValidationException('Item karier tidak valid.');
    final map = Map<String, dynamic>.from(item);
    final title = (map['title'] ?? '') as String;
    if (!kCareerCatalog.contains(title)) {
      throw ResultValidationException('Karier "$title" tidak ada di katalog.');
    }
    if (!titles.add(title)) {
      throw ResultValidationException('Karier "$title" duplikat.');
    }
    final score = (map['match_score'] as num?)?.toInt();
    if (score == null || score < 0 || score > 100) {
      throw ResultValidationException('Skor "$title" harus 0-100.');
    }
    scores.add(score);
    if ((map['reason'] ?? '') is! String || (map['reason'] as String).trim().isEmpty) {
      throw ResultValidationException('Alasan untuk "$title" kosong.');
    }
    final roadmap = map['roadmap'];
    if (roadmap is! List || roadmap.length != 4) {
      throw ResultValidationException('Roadmap "$title" harus 4 minggu.');
    }
    for (int i = 0; i < roadmap.length; i++) {
      final w = roadmap[i];
      if (w is! Map) throw ResultValidationException('Roadmap minggu tidak valid.');
      final weekNum = (w['week'] as num?)?.toInt();
      if (weekNum != i + 1) {
        throw ResultValidationException('Roadmap "$title" harus week 1-4 berurutan.');
      }
      final actions = w['actions'];
      if (actions is! List || actions.isEmpty) {
        throw ResultValidationException('Aksi roadmap "$title" minggu ${i + 1} kosong.');
      }
    }
    parsed.add(CareerRecommendation.fromJson(map));
  }
  if (scores.toSet().length == 1 && scores.first == 100) {
    throw ResultValidationException('Skor tidak boleh semuanya 100.');
  }
  return CareerResult(summary: json['summary'] as String, careers: parsed, isSample: isSample);
}
