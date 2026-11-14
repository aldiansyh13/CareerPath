import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/career_result.dart';
import '../models/user_profile.dart';

/// Penyimpanan lokal sederhana untuk fallback/offline dan riwayat perangkat.
/// (Riwayat cloud Firestore per-akun ditangani terpisah saat Firebase aktif.)
class LocalStore {
  static const _profileKey = 'local_profile';
  static const _historyKey = 'local_history';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileKey, jsonEncode(profile.toJson()));
  }

  Future<UserProfile?> getProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_profileKey);
    if (raw == null) return null;
    return UserProfile.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }

  Future<List<AssessmentRecord>> getHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null) return [];
    final list = (jsonDecode(raw) as List<dynamic>).whereType<Map>().toList();
    final records = list
        .map((e) => AssessmentRecord.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  Future<void> addAssessment(AssessmentRecord record) async {
    final history = await getHistory();
    history.insert(0, record);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_historyKey, jsonEncode(history.map((e) => e.toJson()).toList()));
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }
}
