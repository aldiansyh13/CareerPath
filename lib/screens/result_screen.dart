import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_result.dart';
import '../providers/assessment_provider.dart';
import '../utils/constants.dart';
import '../widgets/career_card.dart';
import 'career_detail_screen.dart';
import 'interest_screen.dart';

class ResultScreen extends StatelessWidget {
  final CareerResult result;
  final Map<String, dynamic> input;
  final bool saveWarning;
  final bool fromSampleExplore;

  const ResultScreen({
    super.key,
    required this.result,
    required this.input,
    this.saveWarning = false,
    this.fromSampleExplore = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hasil Rekomendasi')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            if (result.isSample || fromSampleExplore)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(children: const [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(child: Text('${AppStrings.sampleLabel}: ditampilkan tanpa memanggil Gemini.')),
                ]),
              ),
            if (saveWarning)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12)),
                child: const Text('Analisis berhasil, tetapi penyimpanan riwayat gagal. Kamu masih bisa melihat hasil ini sekarang.'),
              ),
            Text(result.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('3 Rekomendasi Karier', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...result.careers.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CareerCard(
                    career: c,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CareerDetailScreen(career: c)),
                    ),
                  ),
                )),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(12)),
              child: const Text(AppStrings.disclaimer),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                context.read<AssessmentProvider>().resetAssessment(keepProfile: true);
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const InterestScreen()),
                  (r) => r.isFirst,
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Ulangi asesmen'),
            ),
          ],
        ),
      ),
    );
  }
}
