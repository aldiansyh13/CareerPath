import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/career_journey.dart';
import '../models/career_result.dart';
import '../models/user_profile.dart';

/// Penyimpanan lokal sederhana untuk fallback/offline dan riwayat perangkat.
/// (Riwayat cloud Firestore per-akun ditangani terpisah saat Firebase aktif.)
class LocalStore {
  final String? userId;
  LocalStore({this.userId});

  String get _profileKey =>
      userId == null ? 'local_profile' : 'local_profile_$userId';
  String get _historyKey =>
      userId == null ? 'local_history' : 'local_history_$userId';
  String get _journeyKey => userId == null
      ? 'active_career_journey'
      : 'active_career_journey_$userId';

  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(_profileKey, jsonEncode(profile.toJson()))) {
      throw StateError('Profil gagal disimpan di perangkat.');
    }
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
    if (!await prefs.setString(
        _historyKey, jsonEncode(history.map((e) => e.toJson()).toList()))) {
      throw StateError('Riwayat gagal disimpan di perangkat.');
    }
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyKey);
  }

  Future<CareerJourney?> getJourney() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_journeyKey);
    if (raw == null) return null;
    try {
      return CareerJourney.fromJson(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> saveJourney(CareerJourney journey) async {
    final prefs = await SharedPreferences.getInstance();
    if (!await prefs.setString(_journeyKey, jsonEncode(journey.toJson()))) {
      throw StateError('Progres roadmap gagal disimpan di perangkat.');
    }
  }

  Future<void> clearJourney() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_journeyKey);
  }
}
