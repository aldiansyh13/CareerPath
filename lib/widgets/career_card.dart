import 'package:flutter/material.dart';
import '../models/career_result.dart';

class CareerCard extends StatelessWidget {
  final CareerRecommendation career;
  final VoidCallback onTap;
  const CareerCard({super.key, required this.career, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(career.title,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: scheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('${career.matchScore}% cocok',
                        style: TextStyle(color: scheme.onPrimaryContainer, fontWeight: FontWeight.w700)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(career.reason, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 8),
              Text('Lihat detail & roadmap 30 hari →',
                  style: TextStyle(color: scheme.primary, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}
