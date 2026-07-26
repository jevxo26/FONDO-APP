import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fondo/app.dart';

void main() {
  testWidgets('App smoke test initializes FondoApp', (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: FondoApp(),
      ),
    );
    expect(find.byType(FondoApp), findsOneWidget);
  });
}
