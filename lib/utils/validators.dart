import '../data/careers.dart';
import '../models/career_result.dart';

class ResultValidationException implements Exception {
  final String message;
  ResultValidationException(this.message);
  @override
  String toString() => message;
}

/// Memvalidasi kontrak JSON hasil analisis sesuai PRD lalu mengubahnya ke model.
/// Melempar [ResultValidationException] bila struktur tidak aman ditampilkan.
CareerResult validateAndParseResult(
  Map<String, dynamic> json, {
  bool isSample = false,
}) {
  final summaryRaw = json['summary'];
  if (summaryRaw is! String || summaryRaw.trim().isEmpty) {
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
    if (item is! Map) {
      throw ResultValidationException('Item karier tidak valid.');
    }
    final map = Map<String, dynamic>.from(item);

    final title = _canonicalCareerTitle(map['title']);
    if (title == null) {
      throw ResultValidationException(
        'Karier "${map['title'] ?? ''}" tidak ada di katalog.',
      );
    }
    if (!titles.add(title)) {
      throw ResultValidationException('Karier "$title" duplikat.');
    }

    final scoreRaw = map['match_score'];
    final score = scoreRaw is num
        ? scoreRaw.toInt()
        : int.tryParse(scoreRaw?.toString().trim() ?? '');
    if (score == null || score < 0 || score > 100) {
      throw ResultValidationException('Skor "$title" harus 0-100.');
    }
    scores.add(score);

    final reasonRaw = map['reason'];
    if (reasonRaw is! String || reasonRaw.trim().isEmpty) {
      throw ResultValidationException('Alasan untuk "$title" kosong.');
    }

    final skillsOwned = _stringList(
      map['skills_owned'],
      'skills_owned',
      title,
      requireNotEmpty: true,
    );
    final skillsMissing = _stringList(
      map['skills_missing'],
      'skills_missing',
      title,
      requireNotEmpty: true,
    );
    final roadmap = _roadmap(map['roadmap'], title);

    parsed.add(
      CareerRecommendation.fromJson({
        ...map,
        'title': title,
        'match_score': score,
        'reason': reasonRaw.trim(),
        'skills_owned': skillsOwned,
        'skills_missing': skillsMissing,
        'roadmap': roadmap,
      }),
    );
  }

  if (scores.every((score) => score == 100)) {
    throw ResultValidationException('Skor tidak boleh semuanya 100.');
  }

  // Selalu tampilkan urutan dari kecocokan tertinggi.
  parsed.sort((a, b) => b.matchScore.compareTo(a.matchScore));

  return CareerResult(
    summary: summaryRaw.trim(),
    careers: parsed,
    isSample: isSample,
  );
}

String? _canonicalCareerTitle(dynamic raw) {
  if (raw is! String) return null;
  final value = raw.trim();
  if (value.isEmpty) return null;
  for (final career in kCareerCatalog) {
    if (career == value) return career;
  }
  final lower = value.toLowerCase();
  for (final career in kCareerCatalog) {
    if (career.toLowerCase() == lower) return career;
  }
  return null;
}

List<String> _stringList(
  dynamic raw,
  String field,
  String title, {
  bool requireNotEmpty = false,
}) {
  if (raw is! List) {
    throw ResultValidationException(
      'Field "$field" untuk "$title" harus berupa daftar.',
    );
  }
  final values = <String>[];
  for (final item in raw) {
    if (item is! String || item.trim().isEmpty) {
      throw ResultValidationException(
        'Isi "$field" untuk "$title" harus teks tidak kosong.',
      );
    }
    values.add(item.trim());
  }
  if (requireNotEmpty && values.isEmpty) {
    throw ResultValidationException(
      'Field "$field" untuk "$title" tidak boleh kosong.',
    );
  }
  return values;
}

List<Map<String, dynamic>> _roadmap(dynamic raw, String title) {
  if (raw is! List) {
    throw ResultValidationException(
        'Roadmap "$title" harus berupa daftar 4 minggu.');
  }
  if (raw.length != 4) {
    throw ResultValidationException(
      'Roadmap "$title" harus 4 minggu (diterima ${raw.length}).',
    );
  }

  final weeks = <Map<String, dynamic>>[];
  for (var i = 0; i < raw.length; i++) {
    final item = raw[i];
    if (item is! Map) {
      throw ResultValidationException('Roadmap minggu tidak valid.');
    }
    final week = Map<String, dynamic>.from(item);

    final weekRaw = week['week'];
    final weekNumber = weekRaw is num
        ? weekRaw.toInt()
        : int.tryParse(weekRaw?.toString().trim() ?? '');
    if (weekNumber != i + 1) {
      throw ResultValidationException(
        'Roadmap "$title" harus week 1-4 berurutan.',
      );
    }

    final weekTitleRaw = week['title'];
    if (weekTitleRaw is! String || weekTitleRaw.trim().isEmpty) {
      throw ResultValidationException(
        'Judul roadmap "$title" minggu ${i + 1} kosong.',
      );
    }

    final actionsRaw = week['actions'];
    if (actionsRaw is! List || actionsRaw.isEmpty) {
      throw ResultValidationException(
        'Aksi roadmap "$title" minggu ${i + 1} kosong.',
      );
    }
    final actions = <String>[];
    for (final action in actionsRaw) {
      if (action is! String || action.trim().isEmpty) {
        throw ResultValidationException(
          'Aksi roadmap "$title" minggu ${i + 1} tidak valid.',
        );
      }
      actions.add(action.trim());
    }

    weeks.add({
      'week': i + 1,
      'title': weekTitleRaw.trim(),
      'actions': actions,
    });
  }
  return weeks;
}
