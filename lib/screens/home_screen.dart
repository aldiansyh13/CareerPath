import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_result.dart';
import '../models/career_journey.dart';
import '../providers/assessment_provider.dart';
import '../providers/journey_provider.dart';
import '../services/app_backend.dart';
import '../services/local_store.dart';
import 'career_detail_screen.dart';
import 'interest_screen.dart';
import 'profile_screen.dart';
import 'result_screen.dart';

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
    final backend = AppBackend(LocalStore());
    return backend.getHistory();
  }

  void _refresh() {
    if (mounted) {
      setState(() {
        _historyFuture = _loadHistory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final journeyProvider = context.watch<JourneyProvider?>();
    final journey = journeyProvider?.activeJourney;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beranda'),
        actions: [
          IconButton(
              onPressed: _refresh,
              icon: const Icon(Icons.refresh),
              tooltip: 'Muat ulang'),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (journey != null && journeyProvider != null) ...[
              _ActiveJourneyCard(
                journey: journey,
                provider: journeyProvider,
              ),
              const SizedBox(height: 16),
            ],
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          journey == null
                              ? 'Temukan jalur kariermu'
                              : 'Perbarui arahmu saat dibutuhkan',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 6),
                      const Text(
                          'Profil dan riwayat tersimpan di perangkat ini.'),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        onPressed: () async {
                          final provider = context.read<AssessmentProvider>();
                          provider.resetAssessment();
                          if (provider.profile == null) {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) =>
                                    ProfileScreen(startAssessmentAfter: true)));
                          } else {
                            await Navigator.of(context).push(MaterialPageRoute(
                                builder: (_) => const InterestScreen()));
                          }
                          _refresh();
                        },
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Mulai / Ulangi Asesmen'),
                      ),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => const ProfileScreen()));
                          _refresh();
                        },
                        child: const Text('Edit profil'),
                      ),
                    ]),
              ),
            ),
            const SizedBox(height: 16),
            Text('Riwayat hasil',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            FutureBuilder<List<AssessmentRecord>>(
              future: _historyFuture,
              builder: (context, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const Padding(
                      padding: EdgeInsets.all(24),
                      child: Center(child: CircularProgressIndicator()));
                }
                final items = snap.data ?? const [];
                if (items.isEmpty) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                          'Belum ada riwayat. Mulai asesmen untuk mendapatkan rekomendasi karier.'),
                    ),
                  );
                }
                return Column(
                  children: items.map((r) {
                    final top = r.result.careers.isNotEmpty
                        ? r.result.careers.first
                        : null;
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        title: Text(top != null
                            ? 'Top: ${top.title} (${top.matchScore}%)'
                            : 'Hasil asesmen'),
                        subtitle: Text(
                            '${r.createdAt.toLocal().toString().split('.').first}${r.result.isSample ? ' • Contoh' : ''}'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            Navigator.of(context).push(MaterialPageRoute(
                          builder: (_) => ResultScreen(
                            result: r.result,
                            input: r.input,
                            assessmentId: r.id,
                          ),
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

class _ActiveJourneyCard extends StatelessWidget {
  final CareerJourney journey;
  final JourneyProvider provider;

  const _ActiveJourneyCard({required this.journey, required this.provider});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final nextAction = journey.nextAction;
    final activeWeek = journey.activeWeek;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: scheme.primary.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  journey.isComplete ? 'ROADMAP SELESAI' : 'JALUR AKTIF',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                        color: scheme.onPrimaryContainer,
                      ),
                ),
              ),
              if (journey.isSample)
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: const Text('Contoh'),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  journey.career.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: scheme.onPrimaryContainer,
                      ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${journey.career.matchScore}% cocok',
                style: TextStyle(
                  color: scheme.onPrimaryContainer,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          LinearProgressIndicator(value: journey.progress),
          const SizedBox(height: 8),
          Text(
            '${journey.completedActions} dari ${journey.totalActions} langkah selesai',
            style: TextStyle(
              color: scheme.onPrimaryContainer,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (!journey.isComplete &&
              nextAction != null &&
              activeWeek != null) ...[
            const SizedBox(height: 18),
            Text(
              'MINGGU ${activeWeek.week} · ${activeWeek.title.toUpperCase()}',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                  ),
            ),
            const SizedBox(height: 5),
            Text(
              nextAction.text,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: scheme.onPrimaryContainer,
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 14),
            FilledButton.icon(
              onPressed: () async {
                JourneyUndo? undo;
                try {
                  undo = await provider.toggleAction(nextAction.id);
                } catch (_) {
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Progres belum tersimpan. Coba lagi.'),
                    ),
                  );
                  return;
                }
                if (!context.mounted) return;
                final updatedPercent =
                    ((provider.activeJourney?.progress ?? 0) * 100).round();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Langkah selesai. Progres kini $updatedPercent%.',
                    ),
                    action: SnackBarAction(
                      label: 'Urungkan',
                      onPressed: () async {
                        if (undo == null) return;
                        try {
                          await provider.undoToggle(undo);
                        } catch (_) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Perubahan belum bisa diurungkan.',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.check),
              label: const Text('Tandai selesai'),
            ),
          ],
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => CareerDetailScreen(
                  career: journey.career,
                  assessmentId: journey.assessmentId,
                ),
              ),
            ),
            icon: const Icon(Icons.route),
            label: const Text('Buka roadmap lengkap'),
          ),
        ],
      ),
    );
  }
}
