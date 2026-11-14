import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions.dart';
import '../providers/assessment_provider.dart';
import '../widgets/progress_header.dart';
import 'skill_screen.dart';

class InterestScreen extends StatelessWidget {
  const InterestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentProvider>();
    final answered = kInterestQuestions.where((q) => provider.interestAnswers.containsKey(q.id)).length;
    final allDone = answered == kInterestQuestions.length;
    return Scaffold(
      appBar: AppBar(title: const Text('Minat')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: ProgressHeader(
                title: 'Kuesioner Minat',
                subtitle: '$answered dari ${kInterestQuestions.length} pertanyaan terisi',
                progress: answered / kInterestQuestions.length,
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: kInterestQuestions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, i) {
                  final q = kInterestQuestions[i];
                  final selected = provider.interestAnswers[q.id];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${i + 1}. ${q.text}', style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          Column(
                            children: [
                              for (final opt in q.options)
                                RadioListTile<String>(
                                  contentPadding: EdgeInsets.zero,
                                  dense: true,
                                  title: Text(opt),
                                  value: opt,
                                  groupValue: selected,
                                  onChanged: (v) {
                                    if (v != null) context.read<AssessmentProvider>().setInterest(q.id, v);
                                  },
                                ),
                            ],
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
                    ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SkillScreen()))
                    : null,
                child: const Text('Lanjut ke penilaian skill'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
