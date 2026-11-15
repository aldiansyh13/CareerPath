import 'package:flutter/foundation.dart';

import '../data/major_groups.dart';
import '../data/skills.dart';
import '../models/user_profile.dart';

class AssessmentProvider extends ChangeNotifier {
  UserProfile? _profile;
  final Map<String, String> _interestAnswers = {};
  final Map<String, int> _skillRatings = {};

  UserProfile? get profile => _profile;
  Map<String, String> get interestAnswers => Map.unmodifiable(_interestAnswers);
  Map<String, int> get skillRatings => Map.unmodifiable(_skillRatings);
  List<SkillItem> get activeSkills => skillItemsForMajor(_profile?.major);

  void setProfile(UserProfile profile) {
    final previousGroup = majorGroupForMajor(_profile?.major);
    final nextGroup = majorGroupForMajor(profile.major);
    // Pertanyaan dan skill mengikuti bidang jurusan, jadi jawaban lama tidak
    // boleh dipakai ulang ketika pengguna berpindah bidang.
    if (_profile != null && previousGroup != nextGroup) {
      _interestAnswers.clear();
      _skillRatings.clear();
    }
    _profile = profile;
    notifyListeners();
  }

  void setInterest(String questionId, String answer) {
    _interestAnswers[questionId] = answer;
    notifyListeners();
  }

  void setSkill(String skillId, int value) {
    _skillRatings[skillId] = value;
    notifyListeners();
  }

  bool get interestsComplete => _interestAnswers.length >= 8; // expects 8 ids
  bool get skillsComplete =>
      activeSkills.every((skill) => _skillRatings.containsKey(skill.id));

  bool interestsCompleteFor(Set<String> ids) =>
      ids.every(_interestAnswers.containsKey);
  bool skillsCompleteFor(Set<String> ids) =>
      ids.every(_skillRatings.containsKey);

  Map<String, dynamic> buildInput() {
    return {
      'profile': _profile?.toJson(),
      'interests': Map<String, String>.from(_interestAnswers),
      'skills': Map<String, int>.from(_skillRatings),
      'skill_labels': <String, String>{
        for (final skill in activeSkills) skill.id: skill.label,
      },
    };
  }

  void resetAssessment({bool keepProfile = true}) {
    _interestAnswers.clear();
    _skillRatings.clear();
    if (!keepProfile) _profile = null;
    notifyListeners();
  }

  void loadSampleInput(Map<String, dynamic> sampleInput) {
    final p = sampleInput['profile'];
    if (p is Map) {
      _profile = UserProfile.fromJson(Map<String, dynamic>.from(p));
    }
    final interests = sampleInput['interests'];
    if (interests is Map) {
      _interestAnswers
        ..clear()
        ..addAll(interests.map((k, v) => MapEntry(k.toString(), v.toString())));
    }
    final skills = sampleInput['skills'];
    if (skills is Map) {
      _skillRatings
        ..clear()
        ..addAll(
            skills.map((k, v) => MapEntry(k.toString(), (v as num).toInt())));
    }
    notifyListeners();
  }
}
