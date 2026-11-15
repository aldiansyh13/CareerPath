import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'providers/assessment_provider.dart';
import 'services/app_backend.dart';
import 'services/local_store.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';

// Jika `flutterfire configure` sudah dijalankan, file ini akan ada.
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // .env opsional untuk mode lokal/contoh; Gemini butuh key & model saat analisis AI.
  }
  runApp(const CareerPathApp());
}

class CareerPathApp extends StatelessWidget {
  const CareerPathApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AssessmentProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const _EntryGate(),
      ),
    );
  }
}

class _EntryGate extends StatefulWidget {
  const _EntryGate();

  @override
  State<_EntryGate> createState() => _EntryGateState();
}

class _EntryGateState extends State<_EntryGate> {
  late Future<bool> _hasProfileFuture;

  @override
  void initState() {
    super.initState();
    final backend = AppBackend(LocalStore());
    _hasProfileFuture = backend.getProfile().then((p) {
      if (p != null && mounted) {
        context.read<AssessmentProvider>().setProfile(p);
      }
      return p != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _hasProfileFuture,
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Scaffold(
              body: Center(child: CircularProgressIndicator()));
        }
        final hasProfile = snap.data == true;
        // Sesi baru: welcome. Jika profil lokal/cloud sudah ada: beranda.
        return hasProfile ? const HomeScreen() : const WelcomeScreen();
      },
    );
  }
}
