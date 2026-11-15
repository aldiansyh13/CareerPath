import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_profile.dart';
import '../providers/assessment_provider.dart';
import '../providers/journey_provider.dart';
import '../services/app_backend.dart';
import '../services/local_store.dart';
import '../utils/constants.dart';
import 'interest_screen.dart';
import 'welcome_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool startAssessmentAfter;
  final AppBackend? backend;
  const ProfileScreen(
      {super.key, this.startAssessmentAfter = false, this.backend});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _major = TextEditingController();
  final _semester = TextEditingController();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final p = context.read<AssessmentProvider>().profile;
    if (p != null) {
      _name.text = p.name;
      _major.text = p.major;
      _semester.text = p.semester.toString();
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _major.dispose();
    _semester.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final profile = UserProfile(
      name: _name.text.trim(),
      major: _major.text.trim(),
      semester: int.parse(_semester.text.trim()),
    );
    final backend =
        widget.backend ?? (AppBackend(LocalStore())..markFirebaseReady());
    try {
      await backend.saveProfile(profile);
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text(
            'Profil belum berhasil disimpan sepenuhnya. Periksa koneksi lalu coba lagi.'),
      ));
      return;
    }
    if (!mounted) return;
    context.read<AssessmentProvider>().setProfile(profile);
    setState(() => _saving = false);
    if (widget.startAssessmentAfter) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const InterestScreen()));
    } else {
      Navigator.of(context).pop(true);
    }
  }

  bool get _signedIn =>
      Firebase.apps.isNotEmpty && FirebaseAuth.instance.currentUser != null;

  Future<void> _signOut() async {
    final backend = AppBackend(LocalStore())..markFirebaseReady();
    await backend.signOut();
    if (!mounted) return;
    await context.read<JourneyProvider?>()?.switchStore(LocalStore());
    if (!mounted) return;
    context.read<AssessmentProvider>().resetAssessment(keepProfile: false);
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const WelcomeScreen()),
      (r) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                    'Ceritakan sedikit tentang dirimu agar analisis lebih relevan.'),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _name,
                  decoration:
                      const InputDecoration(labelText: 'Nama panggilan'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _major,
                  decoration: const InputDecoration(
                      labelText: 'Jurusan / program studi'),
                  validator: (v) =>
                      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _semester,
                  decoration: const InputDecoration(labelText: 'Semester'),
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    final n = int.tryParse((v ?? '').trim());
                    if (n == null || n < 1 || n > 14) {
                      return 'Masukkan semester 1-14';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Simpan & lanjut'),
                ),
                if (_signedIn) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: _saving ? null : _signOut,
                    icon: const Icon(Icons.logout),
                    label: const Text('Keluar dari akun'),
                    style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.danger),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
