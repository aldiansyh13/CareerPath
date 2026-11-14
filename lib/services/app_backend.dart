import 'package:flutter/foundation.dart';

import '../models/career_result.dart';
import '../models/user_profile.dart';
import 'local_store.dart';

// Firebase imports are optional at runtime; initialized only if configured.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

/// Abstraksi backend: mencoba Firebase bila sudah diinisialisasi, selain itu lokal.
class AppBackend {
  final LocalStore local;
  bool _firebaseReady = false;

  AppBackend(this.local);

  bool get firebaseReady => _firebaseReady;
  User? get currentUser =>
      _firebaseReady ? FirebaseAuth.instance.currentUser : null;
  bool get isSignedIn => currentUser != null;

  LocalStore _storeFor(User? user) =>
      user == null ? local : LocalStore(userId: user.uid);

  /// Cloud menang untuk ID yang sama; hasil lokal yang belum tersinkron tetap ada.
  static List<AssessmentRecord> mergeHistory(
    List<AssessmentRecord> localRecords,
    List<AssessmentRecord> cloudRecords,
  ) {
    final records = <String, AssessmentRecord>{
      for (final record in localRecords) record.id: record,
      for (final record in cloudRecords) record.id: record,
    }.values.toList();
    records.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return records;
  }

  void markFirebaseReady() {
    _firebaseReady = Firebase.apps.isNotEmpty;
  }

  Future<void> saveProfile(UserProfile profile) async {
    // Selalu simpan lokal agar profil tetap tersedia saat offline/fallback.
    final user = currentUser;
    await _storeFor(user).saveProfile(profile);
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          ...profile.toJson(),
          'updatedAt': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );
    }
  }

  Future<UserProfile?> getProfile() async {
    final user = currentUser;
    if (user != null) {
      try {
        final doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        final data = doc.data();
        if (data != null) {
          return UserProfile.fromJson(Map<String, dynamic>.from(data));
        }
      } catch (e) {
        debugPrint('getProfile firestore error: $e');
      }
    }
    return _storeFor(user).getProfile();
  }

  Future<String> saveAssessment(
      {required Map<String, dynamic> input,
      required CareerResult result}) async {
    final user = currentUser;
    final ref = user == null
        ? null
        : FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('assessments')
            .doc();
    final id = ref?.id ?? DateTime.now().microsecondsSinceEpoch.toString();
    final record = AssessmentRecord(
        id: id, createdAt: DateTime.now(), input: input, result: result);
    await _storeFor(user).addAssessment(record);

    if (ref != null) {
      try {
        await ref.set({
          'createdAt': FieldValue.serverTimestamp(),
          'input': input,
          'result': result.toJson(),
          'isSample': result.isSample,
        });
        return ref.id;
      } catch (e) {
        debugPrint('saveAssessment firestore error: $e');
        rethrow; // agar UI bisa tampilkan "gagal menyimpan" tapi analisis sudah ada
      }
    }
    return id;
  }

  Future<List<AssessmentRecord>> getHistory() async {
    final user = currentUser;
    final localRecords = await _storeFor(user).getHistory();
    // Riwayat tamu tetap milik perangkat; tidak diunggah ke akun otomatis.
    final deviceRecords = user == null
        ? localRecords
        : mergeHistory(await local.getHistory(), localRecords);
    if (user != null) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('assessments')
            .orderBy('createdAt', descending: true)
            .get();
        final cloudRecords = snap.docs.map((d) {
          final data = Map<String, dynamic>.from(d.data());
          final created = data['createdAt'];
          DateTime createdAt = DateTime.now();
          if (created is Timestamp) {
            createdAt = created.toDate();
          } else if (created is String) {
            createdAt = DateTime.tryParse(created) ?? DateTime.now();
          }
          final resultMap =
              Map<String, dynamic>.from(data['result'] as Map? ?? const {});
          return AssessmentRecord(
            id: d.id,
            createdAt: createdAt,
            input: Map<String, dynamic>.from(data['input'] as Map? ?? const {}),
            result: CareerResult.fromJson(resultMap,
                isSample: data['isSample'] == true),
          );
        }).toList();
        return mergeHistory(deviceRecords, cloudRecords);
      } catch (e) {
        debugPrint('getHistory firestore error: $e');
        // Jatuh ke riwayat lokal agar UI tetap bisa menampilkan cache perangkat.
      }
    }
    return deviceRecords;
  }

  Future<void> signOut() async {
    if (_firebaseReady) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {}
    }
    await local.clearProfile();
    await local.clearHistory();
  }
}
