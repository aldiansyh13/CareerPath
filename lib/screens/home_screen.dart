import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_result.dart';
import '../providers/assessment_provider.dart';
import '../services/app_backend.dart';
import '../services/local_store.dart';
import 'auth_screen.dart';
import 'interest_screen.dart';
import 'profile_screen.dart';
import 'result_screen.dart';
import 'welcome_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<AssessmentRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _loadHistory();
  }

  Future<List<AssessmentRecord>> _loadHistory() async {
    final backend = AppBackend(LocalStore())..markFirebaseReady();
    return backend.getHistory();
  }

  void _refresh() => setState(() => _historyFuture = _loadHistory());

  Future<void> _signOut() async {
    final backend = AppBackend(LocalStore())..markFirebaseReady();
    await backend.signOut();
    if (mounted) {
      context.read<AssessmentProvider>().resetAssessment(keepProfile: false);
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        (r) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final fbReady = Firebase.apps.isNotEmpty;
    final user = fbReady ? FirebaseAuth.instance.currentUser : null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(onPressed: _refresh, icon: const Icon(Icons.refresh), tooltip: 'Muat ulang'),
          if (user != null)
            IconButton(onPressed: _signOut, icon: const Icon(Icons.logout), tooltip: 'Keluar')
          else
            IconButton(
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthScreen()));
                _refresh();
              },
              icon: const Icon(Icons.login),
              tooltip: 'Masuk',
            ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Siap eksplorasi karier?', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 6),
                  Text(user != null ? 'Masuk sebagai ${user.email}' : 'Mode lokal (login opsional untuk sinkron riwayat cloud).'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                    onPressed: () async {
                      final provider = context.read<AssessmentProvider>();
                      if (provider.profile == null) {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => ProfileScreen(startAssessmentAfter: true)));
                      } else {
                        await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const InterestScreen()));
                      }
                      _refresh();
                    },
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('Mulai / Ulangi Asesmen'),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton(
                    onPressed: () async {
                      await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const ProfileScreen()));
                      _refresh();
                    },
                    child: const Text('Edit profil'),
                  ),
                ]),
              ),
            ),
            const SizedBox(height: 16),
            Text('Riwayat hasil', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            FutureBuilder<List<AssessmentRecord>>(
              future: _historyFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(padding: EdgeInsets.all(24), child: Center(child: CircularProgressIndicator()));
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Belum ada riwayat. Mulai asesmen untuk mendapatkan rekomendasi karier.'),
                    ),
                  );
                }
                return Column(
                  children: items.map((r) {
                    final top = r.result.careers.isNotEmpty ? r.result.careers.first : null;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(top != null ? 'Top: ${top.title} (${top.matchScore}%)' : 'Hasil asesmen'),
                        subtitle: Text('${r.createdAt.toLocal()}${r.result.isSample ? ' • Contoh' : ''}'.split('.').first),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ResultScreen(result: r.result, input: r.input),
                        )),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
