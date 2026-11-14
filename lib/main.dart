import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'providers/assessment_provider.dart';
import 'providers/journey_provider.dart';
import 'screens/home_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/app_backend.dart';
import 'services/local_store.dart';
import 'utils/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Contoh offline tetap tersedia tanpa konfigurasi Gemini.
  }
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } catch (_) {
    // Platform tanpa konfigurasi Firebase tetap dapat memakai mode lokal.
  }
  runApp(const CareerPathApp());
}

class CareerPathApp extends StatefulWidget {
  const CareerPathApp({super.key});
  @override
  State<CareerPathApp> createState() => _CareerPathAppState();
}

class _CareerPathAppState extends State<CareerPathApp> {
  final _assessment = AssessmentProvider();
  late final JourneyProvider _journey;
  late final Future<void> _ready;

  @override
  void initState() {
    super.initState();
    final userId = Firebase.apps.isNotEmpty
        ? FirebaseAuth.instance.currentUser?.uid
        : null;
    _journey = JourneyProvider(store: LocalStore(userId: userId));
    _ready = _loadAppState();
  }

  Future<void> _loadAppState() async {
    final backend = AppBackend(LocalStore())..markFirebaseReady();
    try {
      final profile = await backend.getProfile();
      if (mounted && profile != null) _assessment.setProfile(profile);
    } catch (_) {
      // Data yang tidak terbaca tidak menghalangi layar awal.
    }
    await _journey.load();
  }

  @override
  void dispose() {
    _assessment.dispose();
    _journey.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _assessment),
        ChangeNotifierProvider.value(value: _journey),
      ],
      child: MaterialApp(
        title: 'CareerPath AI',
        theme: buildAppTheme(),
        home: FutureBuilder<void>(
          future: _ready,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }
            return _assessment.profile == null
                ? const WelcomeScreen()
                : const HomeScreen();
          },
        ),
      ),
    );
  }
}
