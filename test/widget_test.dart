import 'package:flutter_test/flutter_test.dart';

import 'package:careerpath_ai/main.dart';

void main() {
  testWidgets('App boots to welcome screen', (WidgetTester tester) async {
    await tester.pumpWidget(const CareerPathApp());
    await tester.pumpAndSettle();

    expect(find.text('CareerPath AI'), findsOneWidget);
    expect(find.text('Mulai asesmen'), findsOneWidget);
  });
}
