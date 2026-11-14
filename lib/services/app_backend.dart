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
  User? get currentUser => _firebaseReady ? FirebaseAuth.instance.currentUser : null;
  bool get isSignedIn => currentUser != null;

  void markFirebaseReady() {
    _firebaseReady = Firebase.apps.isNotEmpty;
  }

  Future<void> saveProfile(UserProfile profile) async {
    await local.saveProfile(profile);
    final user = currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
        {
          ...profile.toJson(),
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
        final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
        final data = doc.data();
        if (data != null) {
          return UserProfile.fromJson(Map<String, dynamic>.from(data));
        }
      } catch (e) {
        debugPrint('getProfile firestore error: $e');
      }
    }
    return local.getProfile();
  }

  Future<String> saveAssessment({required Map<String, dynamic> input, required CareerResult result}) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final record = AssessmentRecord(id: id, createdAt: DateTime.now(), input: input, result: result);
    await local.addAssessment(record);

    final user = currentUser;
    if (user != null) {
      try {
        final ref = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('assessments')
            .add({
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
    if (user != null) {
      try {
        final snap = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('assessments')
            .orderBy('createdAt', descending: true)
            .get();
        if (snap.docs.isNotEmpty) {
          return snap.docs.map((d) {
            final data = Map<String, dynamic>.from(d.data());
            final created = data['createdAt'];
            DateTime createdAt = DateTime.now();
            if (created is Timestamp) createdAt = created.toDate();
            final resultMap = Map<String, dynamic>.from(data['result'] as Map? ?? const {});
            return AssessmentRecord(
              id: d.id,
              createdAt: createdAt,
              input: Map<String, dynamic>.from(data['input'] as Map? ?? const {}),
              result: CareerResult.fromJson(resultMap, isSample: data['isSample'] == true),
            );
          }).toList();
        }
      } catch (e) {
        debugPrint('getHistory firestore error: $e');
      }
    }
    return local.getHistory();
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
