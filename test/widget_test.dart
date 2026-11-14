import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:careerpath_ai/main.dart';

void main() {
  setUp(() {
    // Test berjalan tanpa plugin platform; beri penyimpanan lokal kosong.
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('App boots to welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    expect(find.text('CareerPath AI'), findsOneWidget);
    expect(find.text('Mulai asesmen'), findsOneWidget);
    expect(find.text('Jelajahi contoh hasil (offline)'), findsOneWidget);
  });
}
