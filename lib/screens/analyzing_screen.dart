import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sample_result.dart';
import '../models/career_result.dart';
import '../providers/assessment_provider.dart';
import '../services/app_backend.dart';
import '../services/gemini_service.dart';
import '../services/local_store.dart';
import '../utils/validators.dart';
import 'result_screen.dart';

class AnalyzingScreen extends StatefulWidget {
  final bool useSample;
  const AnalyzingScreen({super.key, this.useSample = false});

  @override
  State<AnalyzingScreen> createState() => _AnalyzingScreenState();
}

class _AnalyzingScreenState extends State<AnalyzingScreen> {
  String _status = 'Menganalisis potensi kamu...';
  String? _error;
  bool _savingError = false;
  bool _running = true;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _run();
  }

  Future<void> _run() async {
    if (_busy) return;
    _busy = true;
    setState(() {
      _running = true;
      _error = null;
      _savingError = false;
      _status = widget.useSample
          ? 'Menyiapkan contoh hasil...'
          : 'Menganalisis potensi kamu...';
    });
    final provider = context.read<AssessmentProvider>();
    final input = provider.buildInput();
    final backend = AppBackend(LocalStore())..markFirebaseReady();

    try {
      CareerResult result;
      if (widget.useSample) {
        await Future<void>.delayed(const Duration(milliseconds: 600));
        result = validateAndParseResult(
            Map<String, dynamic>.from(kSampleResult),
            isSample: true);
      } else {
        final gemini = GeminiService();
        if (!gemini.isConfigured) {
          throw GeminiConfigException(
              'Gemini belum dikonfigurasi (GEMINI_API_KEY/GEMINI_MODEL kosong).');
        }
        result = await gemini.analyzeCareer(input);
      }
      setState(() => _status = 'Menyimpan hasil...');
      try {
        await backend.saveAssessment(input: input, result: result);
      } catch (e) {
        // Analisis berhasil tapi simpan gagal: tetap tampilkan hasil
        if (mounted) {
          setState(() {
            _savingError = true;
            _status =
                'Hasil siap, namun gagal menyimpan ke penyimpanan cloud/lokal.';
          });
        }
      }
      if (!mounted) return;
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => ResultScreen(
            result: result, input: input, saveWarning: _savingError),
      ));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _running = false;
        _error = _friendlyMessage(e);
      });
    } finally {
      _busy = false;
    }
  }

  String _friendlyMessage(Object error) {
    if (error is GeminiConfigException ||
        error is GeminiException ||
        error is ResultValidationException) {
      return error.toString();
    }
    return 'Analisis gagal karena kesalahan tak terduga. Periksa koneksi lalu coba lagi.';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Analisis')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: _running
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                          width: 56,
                          height: 56,
                          child: CircularProgressIndicator()),
                      const SizedBox(height: 20),
                      Text(_status,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 8),
                      const Text('Ini bisa memakan waktu beberapa detik.',
                          textAlign: TextAlign.center),
                    ],
                  )
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 48, color: Colors.redAccent),
                      const SizedBox(height: 12),
                      Text('Analisis gagal',
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      Text(_error ?? 'Terjadi kesalahan.',
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      FilledButton(
                          onPressed: _run, child: const Text('Coba lagi')),
                      const SizedBox(height: 8),
                      OutlinedButton(
                        onPressed: () {
                          Navigator.of(context)
                              .pushReplacement(MaterialPageRoute(
                            builder: (_) =>
                                const AnalyzingScreen(useSample: true),
                          ));
                        },
                        child:
                            const Text('Lihat contoh hasil sebagai cadangan'),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Kembali ke ringkasan')),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
