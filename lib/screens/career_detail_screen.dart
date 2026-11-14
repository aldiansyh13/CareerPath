import 'package:flutter/material.dart';
import '../models/career_result.dart';
import '../utils/constants.dart';

class CareerDetailScreen extends StatelessWidget {
  final CareerRecommendation career;
  const CareerDetailScreen({super.key, required this.career});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(career.title)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Text('${career.matchScore}% cocok',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
            const SizedBox(height: 8),
            Text(career.reason, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            _Section(title: 'Skill yang sudah kamu miliki', items: career.skillsOwned, icon: Icons.check_circle, color: Colors.green),
            const SizedBox(height: 12),
            _Section(title: 'Skill yang perlu dilatih', items: career.skillsMissing, icon: Icons.trending_up, color: Colors.orange),
            const SizedBox(height: 16),
            Text('Roadmap 30 hari', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...career.roadmap.map((w) => Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Minggu ${w.week}: ${w.title}', style: const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        ...w.actions.map((a) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('•  '),
                                Expanded(child: Text(a)),
                              ]),
                            )),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: const Text(AppStrings.disclaimer),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final List<String> items;
  final IconData icon;
  final Color color;
  const _Section({required this.title, required this.items, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          if (items.isEmpty) const Text('-') else
            ...items.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(children: [Icon(icon, size: 18, color: color), const SizedBox(width: 8), Expanded(child: Text(e))]),
                )),
        ]),
      ),
    );
  }
}
