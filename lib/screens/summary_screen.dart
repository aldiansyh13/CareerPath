import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/questions.dart';
import '../data/skills.dart';
import '../providers/assessment_provider.dart';
import 'analyzing_screen.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({super.key});

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> {
  bool _consent = false;

  @override
  Widget build(BuildContext context) {
    final p = context.watch<AssessmentProvider>();
    final profile = p.profile;
    return Scaffold(
      appBar: AppBar(title: const Text('Ringkasan')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (profile != null)
              Card(
                child: ListTile(
                  title: Text(profile.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${profile.major} • Semester ${profile.semester}'),
                  trailing: TextButton(
                    onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
                    child: const Text('Ubah'),
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Text('Jawaban minat', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            ...kInterestQuestions.map((q) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(q.text),
                  subtitle: Text(p.interestAnswers[q.id] ?? '-'),
                )),
            const Divider(height: 24),
            Text('Penilaian skill', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 6),
            ...kSkillItems.map((s) => ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(s.label),
                  trailing: Text('${p.skillRatings[s.id] ?? '-'} / 5', style: const TextStyle(fontWeight: FontWeight.w700)),
                )),
            const SizedBox(height: 12),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              value: _consent,
              onChanged: (v) => setState(() => _consent = v ?? false),
              title: const Text('Saya memahami jawaban saya akan diproses untuk analisis karier dan dapat disimpan di akun/perangkat saya.'),
              controlAffinity: ListTileControlAffinity.leading,
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: _consent && profile != null
                  ? () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnalyzingScreen()))
                  : null,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Analisis dengan AI'),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AnalyzingScreen(useSample: true))),
              child: const Text('Gunakan contoh hasil (tanpa AI)'),
            ),
          ],
        ),
      ),
    );
  }
}
