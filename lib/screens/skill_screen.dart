import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/assessment_provider.dart';
import '../widgets/progress_header.dart';
import 'summary_screen.dart';

class SkillScreen extends StatelessWidget {
  const SkillScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentProvider>();
    final skills = provider.activeSkills;
    final rated =
        skills.where((s) => provider.skillRatings.containsKey(s.id)).length;
    final allDone = rated == skills.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Skill')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: ProgressHeader(
                title: 'Penilaian Skill',
                subtitle:
                    'Nilai kemampuanmu saat ini (1 = pemula, 5 = mahir). $rated/${skills.length} terisi.',
                progress: rated / skills.length,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: skills.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final s = skills[i];
                  final value = provider.skillRatings[s.id] ?? 3;
                  final isSet = provider.skillRatings.containsKey(s.id);
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.label,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(s.hint,
                              style: const TextStyle(color: Colors.black54)),
                          Row(
                            children: [
                              const Text('1'),
                              Expanded(
                                child: Slider(
                                  value: value.toDouble(),
                                  min: 1,
                                  max: 5,
                                  divisions: 4,
                                  label: value.toString(),
                                  onChanged: (v) => context
                                      .read<AssessmentProvider>()
                                      .setSkill(s.id, v.round()),
                                ),
                              ),
                              const Text('5'),
                              SizedBox(
                                width: 32,
                                child: Text(isSet ? '$value' : '-',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w700)),
                              ),
                            ],
                          ),
                          if (!isSet)
                            Align(
                              alignment: Alignment.centerLeft,
                              child: TextButton(
                                onPressed: () => context
                                    .read<AssessmentProvider>()
                                    .setSkill(s.id, value),
                                child: const Text('Tetapkan nilai ini'),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: FilledButton(
                onPressed: allDone
                    ? () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => const SummaryScreen()))
                    : null,
                child: const Text('Lihat ringkasan'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
