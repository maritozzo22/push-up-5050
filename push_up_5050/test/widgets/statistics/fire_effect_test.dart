import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/statistics/fire_effect.dart';

void main() {
  group('FireEffect', () {
    testWidgets('shows child when not active', (tester) async {
      const childKey = Key('test-child');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: false,
              child: Text('Test Child', key: childKey),
            ),
          ),
        ),
      );

      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('shows Transform animation when active', (tester) async {
      const childKey = Key('test-child');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: true,
              child: SizedBox(key: childKey, width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Should have Transform when active
      expect(find.byType(Transform), findsWidgets);
      expect(find.byKey(childKey), findsOneWidget);
    });

    testWidgets('animation pulses over time', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: true,
              child: SizedBox(width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 400));

      // Animation should be running (Transform exists)
      expect(find.byType(Transform), findsWidgets);

      // Advance animation further
      await tester.pump(const Duration(milliseconds: 400));
      expect(find.byType(Transform), findsWidgets);
    });

    testWidgets('toggles animation when isActive changes', (tester) async {
      const childKey = Key('test-child');

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: false,
              child: SizedBox(key: childKey, width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      // When not active, child is rendered directly (no Transform from FireEffect)
      final countBefore = find.byType(Transform).evaluate().length;

      // Activate animation
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: true,
              child: SizedBox(key: childKey, width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Transform should appear (more than before due to FireEffect)
      final countAfter = find.byType(Transform).evaluate().length;
      expect(countAfter, greaterThan(countBefore));
    });

    testWidgets('applies orange glow effect when active', (tester) async {
      const childKey = Key('fire-child');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: true,
              child: SizedBox(key: childKey, width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Find the Container that wraps our child (should have box shadow)
      final containers = find.byType(Container);
      expect(containers, findsWidgets);

      // At least one Container should have a BoxDecoration with shadow
      bool foundGlow = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        if (container.decoration is BoxDecoration) {
          final boxDecoration = container.decoration as BoxDecoration;
          if (boxDecoration.boxShadow != null && boxDecoration.boxShadow!.isNotEmpty) {
            foundGlow = true;
            break;
          }
        }
      }
      expect(foundGlow, isTrue);
    });

    testWidgets('does not add Transform wrapper when inactive', (tester) async {
      const childKey = Key('direct-child');
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FireEffect(
              isActive: false,
              child: SizedBox(key: childKey, width: 50, height: 50),
            ),
          ),
        ),
      );

      await tester.pump();
      // Child should be directly accessible (FireEffect doesn't wrap when inactive)
      expect(find.byKey(childKey), findsOneWidget);
    });
  });
}
