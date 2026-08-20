import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fondo/core/widgets/glass_tab_bar.dart';

void main() {
  const barWidth = 400.0;
  const innerPad = 14.0;

  Finder pill() => find.byKey(const ValueKey('glassTabActivePill'));

  Future<void> pumpBar(WidgetTester tester, int index) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: barWidth,
                height: 100,
                child: GlassTabBar(currentIndex: index, onTap: (_) {}),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  for (var i = 0; i < 4; i++) {
    testWidgets('pill is centered on tab $i', (tester) async {
      await pumpBar(tester, i);

      final innerWidth = barWidth - innerPad * 2;
      final cellWidth = innerWidth / 4;
      final expectedCenter = innerPad + (i + 0.5) * cellWidth;

      final center = tester.getCenter(pill());
      expect(center.dx, closeTo(expectedCenter, 0.5));
    });
  }
}
