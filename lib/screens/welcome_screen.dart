import 'package:flutter/material.dart';
import '../data/sample_result.dart';
import '../utils/constants.dart';
import '../utils/validators.dart';
import 'auth_screen.dart';
import 'result_screen.dart';
import 'profile_screen.dart';

class WelcomeScreen extends StatelessWidget {
  final bool hasLocalProfile;
  const WelcomeScreen({super.key, this.hasLocalProfile = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        // LayoutBuilder + ConstrainedBox(minHeight): konten tetap terpusat
        // di layar tinggi, dan bisa di-scroll bila tidak muat (layar kecil 5").
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Text(AppStrings.appName,
                            style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(AppStrings.tagline, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.black54)),
                        const SizedBox(height: 24),
                        _Bullet(text: 'Asesmen minat & skill sekitar 2 menit'),
                        _Bullet(text: '3 rekomendasi karier dengan alasan transparan'),
                        _Bullet(text: 'Roadmap belajar 30 hari yang bisa dikerjakan'),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ProfileScreen(startAssessmentAfter: true),
                            ));
                          },
                          child: const Text('Mulai asesmen'),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (_) => const AuthScreen()));
                          },
                          child: const Text('Masuk / Daftar'),
                        ),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            final result = validateAndParseResult(Map<String, dynamic>.from(kSampleResult), isSample: true);
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => ResultScreen(
                                result: result,
                                input: Map<String, dynamic>.from(kSampleInput),
                                fromSampleExplore: true,
                              ),
                            ));
                          },
                          child: const Text('Jelajahi contoh hasil (offline)'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Bullet extends StatelessWidget {
  final String text;
  const _Bullet({required this.text});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('•  ', style: TextStyle(fontSize: 16)),
        Expanded(child: Text(text)),
      ]),
    );
  }
}
