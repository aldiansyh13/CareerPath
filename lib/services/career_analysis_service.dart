import '../models/career_result.dart';
import '../utils/validators.dart';
import 'gemini_service.dart';
import 'openai_service.dart';

class AnalysisException implements Exception {
  final String message;
  const AnalysisException(this.message);
  @override
  String toString() => message;
}

/// Gemini tetap utama; OpenAI hanya dipanggil setelah kegagalan yang dikenal.
class CareerAnalysisService {
  static bool _inFlight = false;
  final GeminiService gemini;
  final OpenAiService openai;
  final void Function()? onFallback;
  final bool Function()? shouldContinue;

  CareerAnalysisService(
      {GeminiService? gemini,
      OpenAiService? openai,
      this.onFallback,
      this.shouldContinue})
      : gemini = gemini ?? GeminiService(),
        openai = openai ?? OpenAiService();

  Future<CareerResult> analyzeCareer(Map<String, dynamic> input) async {
    if (_inFlight) {
      throw const AnalysisException(
          'Analisis sebelumnya masih berjalan. Tunggu sampai selesai.');
    }
    _inFlight = true;
    try {
      try {
        return await gemini.analyzeCareer(input);
      } catch (error) {
        if (error is! GeminiException &&
            error is! GeminiConfigException &&
            error is! ResultValidationException) {
          rethrow;
        }
        if (!openai.isConfigured) rethrow;
        if (shouldContinue != null && !shouldContinue!()) {
          throw const AnalysisException(
              'Analisis dibatalkan karena layar sudah ditutup.');
        }
        onFallback?.call();
        try {
          return await openai.analyzeCareer(input);
        } on OpenAiException catch (fallbackError) {
          throw AnalysisException(
              'Gemini gagal dan cadangan OpenAI belum berhasil. ${fallbackError.message} Kamu dapat menggunakan contoh hasil.');
        }
      }
    } finally {
      _inFlight = false;
    }
  }
}
