import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fondo/app.dart';
import 'package:fondo/router/app_router.dart';
import 'package:fondo/router/routes.dart';

/// Regression test for the go_router StatefulShellRoute bug where, after
/// logging in as a customer (navigating into the shell from outside via
/// `context.go('/home')`), taps are dead until a hot reload.
void main() {
  Future<void> loginAsCustomer(WidgetTester tester) async {
    appRouter.go(AppRoutes.splash);
    await tester.pumpWidget(const ProviderScope(child: FondoApp()));
    await tester.pump(const Duration(milliseconds: 900));
    await tester.pumpAndSettle();

    expect(find.text('Log in'), findsOneWidget);

    final textFields = find.byType(TextField);
    expect(textFields, findsNWidgets(2));
    await tester.enterText(textFields.at(0), 'test@fondo.com');
    await tester.enterText(textFields.at(1), 'test123');

    await tester.tap(find.text('Log in'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pumpAndSettle();
  }

  testWidgets('customer can interact with home after login', (tester) async {
    await loginAsCustomer(tester);

    expect(find.text('Explore Categories'), findsOneWidget);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
    expect(find.text('Breakfast'), findsWidgets);
  });

  testWidgets('customer can navigate into catalog after login', (tester) async {
    await loginAsCustomer(tester);

    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Breakfast').first);
    await tester.pumpAndSettle();

    expect(find.widgetWithText(AppBar, 'Breakfast'), findsOneWidget);
  });

  testWidgets('customer can switch bottom tabs after login', (tester) async {
    await loginAsCustomer(tester);

    await tester.tap(find.text('Packages'));
    await tester.pumpAndSettle();

    expect(find.text('Meal Packages'), findsOneWidget);
  });
}
