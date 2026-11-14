import 'package:flutter_test/flutter_test.dart';

import 'package:careerpath_ai/data/sample_result.dart';
import 'package:careerpath_ai/models/career_result.dart';
import 'package:careerpath_ai/models/user_profile.dart';
import 'package:careerpath_ai/utils/validators.dart';

void main() {
  test('UserProfile serializes and deserializes', () {
    const p = UserProfile(name: 'Budi', major: 'Informatika', semester: 6);
    final json = p.toJson();
    final back = UserProfile.fromJson(json);
    expect(back.name, 'Budi');
    expect(back.major, 'Informatika');
    expect(back.semester, 6);
  });

  test('Sample result passes validator and has 3 careers with 4-week roadmap', () {
    final result = validateAndParseResult(Map<String, dynamic>.from(kSampleResult), isSample: true);
    expect(result.careers.length, 3);
    expect(result.isSample, true);
    for (final c in result.careers) {
      expect(c.matchScore >= 0 && c.matchScore <= 100, true);
      expect(c.roadmap.length, 4);
      expect(c.reason.isNotEmpty, true);
    }
  });

  test('AssessmentRecord round-trip', () {
    final result = validateAndParseResult(Map<String, dynamic>.from(kSampleResult), isSample: true);
    final record = AssessmentRecord(
      id: 'r1',
      createdAt: DateTime.parse('2026-11-14T10:00:00.000Z'),
      input: {'x': 1},
      result: result,
    );
    final back = AssessmentRecord.fromJson(record.toJson());
    expect(back.id, 'r1');
    expect(back.result.careers.length, 3);
  });
}
