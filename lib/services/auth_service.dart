import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthFailure implements Exception {
  final String message;
  final String? code;
  AuthFailure(this.message, {this.code});
  @override
  String toString() => message;
}

class AuthService {
  FirebaseAuth get _auth => FirebaseAuth.instance;

  bool get isReady => Firebase.apps.isNotEmpty;
  Stream<User?> get authChanges =>
      isReady ? _auth.authStateChanges() : const Stream<User?>.empty();
  User? get currentUser => isReady ? _auth.currentUser : null;

  String friendlyError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'user-not-found':
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email atau kata sandi salah.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan masuk.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet. Coba lagi.';
      case 'operation-not-allowed':
        return 'Metode masuk email/kata sandi belum diaktifkan di Firebase.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Coba lagi nanti.';
      case 'user-disabled':
        return 'Akun ini dinonaktifkan.';
      default:
        return 'Gagal autentikasi (${e.code}).';
    }
  }

  Future<UserCredential> register(String email, String password) async {
    if (!isReady) {
      throw AuthFailure(
          'Firebase belum dikonfigurasi. Lihat PANDUAN-FIREBASE-GEMINI.md.');
    }
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(friendlyError(e), code: e.code);
    }
  }

  Future<UserCredential> login(String email, String password) async {
    if (!isReady) {
      throw AuthFailure(
          'Firebase belum dikonfigurasi. Lihat PANDUAN-FIREBASE-GEMINI.md.');
    }
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
    } on FirebaseAuthException catch (e) {
      throw AuthFailure(friendlyError(e), code: e.code);
    }
  }

  Future<void> logout() async {
    if (isReady) {
      await _auth.signOut();
    }
  }
}
