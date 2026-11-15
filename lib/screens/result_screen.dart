import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/career_result.dart';
import '../models/career_journey.dart';
import '../providers/assessment_provider.dart';
import '../providers/journey_provider.dart';
import '../utils/constants.dart';
import '../widgets/career_card.dart';
import 'career_detail_screen.dart';
import 'home_screen.dart';
import 'interest_screen.dart';

class ResultScreen extends StatelessWidget {
  final CareerResult result;
  final Map<String, dynamic> input;
  final bool saveWarning;
  final bool fromSampleExplore;
  final String? assessmentId;

  const ResultScreen({
    super.key,
    required this.result,
    required this.input,
    this.saveWarning = false,
    this.fromSampleExplore = false,
    this.assessmentId,
  });

  @override
  Widget build(BuildContext context) {
    final journeyProvider = context.watch<JourneyProvider?>();
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
                decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12)),
                child: Row(children: const [
                  Icon(Icons.info_outline, color: Colors.blue),
                  SizedBox(width: 8),
                  Expanded(
                      child: Text(
                          '${AppStrings.sampleLabel}: ditampilkan tanpa memanggil Gemini.')),
                ]),
              ),
            if (saveWarning)
              Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(12)),
                child: const Text(
                    'Analisis berhasil, tetapi penyimpanan riwayat gagal. Kamu masih bisa melihat hasil ini sekarang.'),
              ),
            Text(result.summary, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 16),
            Text('3 Rekomendasi Karier',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...result.careers.map((c) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: CareerCard(
                    career: c,
                    isFocused: assessmentId != null &&
                        journeyProvider?.activeJourney?.assessmentId ==
                            assessmentId &&
                        journeyProvider?.activeJourney?.career.title == c.title,
                    onFocus: journeyProvider == null
                        ? null
                        : () async {
                            final journey = CareerJourney.fromRecommendation(
                              assessmentId: assessmentId ??
                                  'local-${DateTime.now().microsecondsSinceEpoch}',
                              recommendation: c,
                              isSample: result.isSample || fromSampleExplore,
                              now: DateTime.now(),
                            );
                            try {
                              await journeyProvider.startJourney(journey);
                            } catch (_) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Roadmap belum berhasil disimpan. Coba lagi.',
                                  ),
                                ),
                              );
                              return;
                            }
                            if (!context.mounted) return;
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => const HomeScreen(),
                              ),
                              (route) => false,
                            );
                          },
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => CareerDetailScreen(
                          career: c,
                          assessmentId: assessmentId,
                        ),
                      ),
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
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () {
                context
                    .read<AssessmentProvider>()
                    .resetAssessment(keepProfile: true);
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
