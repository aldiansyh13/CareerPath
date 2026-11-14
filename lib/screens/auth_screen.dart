import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/journey_provider.dart';
import '../services/auth_service.dart';
import '../services/local_store.dart';

class AuthScreen extends StatefulWidget {
  final AuthService? auth;
  final Future<void> Function()? onAuthenticated;
  const AuthScreen({super.key, this.auth, this.onAuthenticated});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  late final _auth = widget.auth ?? AuthService();
  bool _isLogin = true;
  bool _loading = false;
  String? _error;

  bool get _firebaseReady => _auth.isReady;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_firebaseReady) {
      setState(() => _error =
          'Firebase belum dikonfigurasi di proyek ini. Lihat PANDUAN-FIREBASE-GEMINI.md.');
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      if (_isLogin) {
        await _auth.login(_email.text, _password.text);
      } else {
        await _auth.register(_email.text, _password.text);
      }
      if (Firebase.apps.isNotEmpty && mounted) {
        await context.read<JourneyProvider?>()?.switchStore(
              LocalStore(userId: FirebaseAuth.instance.currentUser?.uid),
            );
      }
      await widget.onAuthenticated?.call();
      if (mounted) Navigator.of(context).pop(true);
    } on AuthFailure catch (e) {
      if (mounted) setState(() => _error = e.message);
    } catch (_) {
      if (mounted) setState(() => _error = 'Terjadi kesalahan. Coba lagi.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Masuk' : 'Daftar')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (!_firebaseReady)
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text(
                        'Mode lokal: Firebase belum disiapkan. Kamu tetap bisa pakai asesmen & contoh hasil. Untuk login/riwayat cloud ikuti PANDUAN-FIREBASE-GEMINI.md.'),
                  ),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => (v == null || !v.contains('@'))
                      ? 'Masukkan email yang valid'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: const InputDecoration(labelText: 'Kata sandi'),
                  obscureText: true,
                  validator: (v) =>
                      (v == null || v.length < 6) ? 'Minimal 6 karakter' : null,
                ),
                const SizedBox(height: 16),
                if (_error != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(_error!,
                        style: const TextStyle(color: Colors.red)),
                  ),
                FilledButton(
                  onPressed: _loading ? null : _submit,
                  child: _loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : Text(_isLogin ? 'Masuk' : 'Daftar'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin
                      ? 'Belum punya akun? Daftar'
                      : 'Sudah punya akun? Masuk'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
