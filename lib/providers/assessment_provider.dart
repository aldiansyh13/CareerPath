import 'package:flutter/foundation.dart';

import '../models/user_profile.dart';

class AssessmentProvider extends ChangeNotifier {
  UserProfile? _profile;
  final Map<String, String> _interestAnswers = {};
  final Map<String, int> _skillRatings = {};

  UserProfile? get profile => _profile;
  Map<String, String> get interestAnswers => Map.unmodifiable(_interestAnswers);
  Map<String, int> get skillRatings => Map.unmodifiable(_skillRatings);

  void setProfile(UserProfile profile) {
    final previousMajor = _profile?.major.trim().toLowerCase();
    final nextMajor = profile.major.trim().toLowerCase();
    // Pertanyaan minat mengikuti jurusan, jadi jawaban lama tidak boleh
    // dipakai ulang saat jurusan berubah.
    if (previousMajor != nextMajor) {
      _interestAnswers.clear();
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
  bool get skillsComplete => _skillRatings.length >= 6;

  bool interestsCompleteFor(Set<String> ids) =>
      ids.every(_interestAnswers.containsKey);
  bool skillsCompleteFor(Set<String> ids) =>
      ids.every(_skillRatings.containsKey);

  Map<String, dynamic> buildInput() {
    return {
      'profile': _profile?.toJson(),
      'interests': Map<String, String>.from(_interestAnswers),
      'skills': Map<String, int>.from(_skillRatings),
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
