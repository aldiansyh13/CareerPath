import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    // Plugin shared_preferences wajib di-mock di widget test:
    // tanpa mock handler, balasan platform message tidak diproses di zona
    // FakeAsync sehingga loading awal (entry gate) menggantung selamanya.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App boots to welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    expect(find.text('CareerPath AI'), findsOneWidget);
    expect(find.text('Mulai asesmen'), findsOneWidget);
    expect(find.text('Masuk / Daftar'), findsOneWidget);
    expect(find.text('Jelajahi contoh hasil (offline)'), findsOneWidget);
  });
}
