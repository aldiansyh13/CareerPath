import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_journey.dart';
import '../models/career_result.dart';
import '../providers/journey_provider.dart';
import '../utils/constants.dart';

class CareerDetailScreen extends StatelessWidget {
  final CareerRecommendation career;
  final String? assessmentId;
  const CareerDetailScreen({
    super.key,
    required this.career,
    this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    final journeyProvider = context.watch<JourneyProvider?>();
    final candidateJourney = journeyProvider?.activeJourney;
    final activeJourney = assessmentId != null &&
            candidateJourney?.assessmentId == assessmentId &&
            candidateJourney?.career.title == career.title
        ? candidateJourney
        : null;
    return Scaffold(
      appBar: AppBar(title: Text(career.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (activeJourney != null) ...[
              _JourneyProgress(journey: activeJourney),
              const SizedBox(height: 16),
            ],
            Row(
              children: [
                Text('${career.matchScore}% cocok',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(career.reason, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            _Section(
                title: 'Skill yang sudah kamu miliki',
                items: career.skillsOwned,
                icon: Icons.check_circle,
                color: Colors.green),
            const SizedBox(height: 12),
            _Section(
                title: 'Skill yang perlu dilatih',
                items: career.skillsMissing,
                icon: Icons.trending_up,
                color: Colors.orange),
            const SizedBox(height: 16),
            Text('Roadmap 30 hari',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...career.roadmap.map((w) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minggu ${w.week}: ${w.title}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        ...w.actions.asMap().entries.map((entry) {
                          final actionId = CareerJourney.actionId(
                            week: w.week,
                            actionIndex: entry.key,
                          );
                          final completed = activeJourney?.completedActionIds
                                  .contains(actionId) ??
                              false;
                          if (activeJourney == null ||
                              journeyProvider == null) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('•  '),
                                  Expanded(child: Text(entry.value)),
                                ],
                              ),
                            );
                          }
                          return CheckboxListTile(
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            value: completed,
                            title: Text(entry.value),
                            onChanged: (_) async {
                              JourneyUndo? undo;
                              try {
                                undo = await journeyProvider
                                    .toggleAction(actionId);
                              } catch (_) {
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Progres belum tersimpan. Coba lagi.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(completed
                                      ? 'Langkah ditandai belum selesai.'
                                      : 'Langkah selesai. Progresmu tersimpan.'),
                                  action: SnackBarAction(
                                    label: 'Urungkan',
                                    onPressed: () async {
                                      if (undo == null) return;
                                      try {
                                        await journeyProvider.undoToggle(undo);
                                      } catch (_) {
                                        if (!context.mounted) return;
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
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
                          );
                        }),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12)),
              child: const Text(AppStrings.disclaimer),
            ),
          ],
        ),
      ),
    );
  }
}

class _JourneyProgress extends StatelessWidget {
  final CareerJourney journey;
  const _JourneyProgress({required this.journey});

  @override
  Widget build(BuildContext context) {
    final percent = (journey.progress * 100).round();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            journey.isComplete ? 'ROADMAP SELESAI' : 'JALUR AKTIF',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.1,
                ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(value: journey.progress),
          const SizedBox(height: 8),
          Text(
            '${journey.completedActions} dari ${journey.totalActions} langkah selesai · $percent%',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          if (journey.isSample) ...[
            const SizedBox(height: 6),
            const Text('Contoh · progres demo tersimpan di perangkat'),
          ],
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;
  const _Section(
      {required this.title,
      required this.items,
      required this.icon,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (items.isEmpty)
            const Text('-')
          else
            ...items.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [
                    Icon(icon, size: 18, color: color),
                    const SizedBox(width: 8),
                    Expanded(child: Text(e))
                  ]),
                )),
        ]),
      ),
    );
  }
}
