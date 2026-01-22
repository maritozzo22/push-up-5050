import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

void main() {
  group('FrostCard', () {
    testWidgets('renders ClipRRect with BackdropFilter', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: 100,
              child: Text('Test'),
            ),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
      expect(find.byType(BackdropFilter), findsOneWidget);
    });

    testWidgets('has correct height', (tester) async {
      const testHeight = 150.0;

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: testHeight,
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FrostCard),
          matching: find.byType(Container),
        ).last,
      );

      expect(container.constraints?.minHeight, testHeight);
      expect(container.constraints?.maxHeight, testHeight);
    });

    testWidgets('has correct padding', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: 100,
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FrostCard),
          matching: find.byType(Container),
        ).last,
      );

      expect(
        container.padding,
        const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      );
    });

    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: 100,
              child: Text('Test Content'),
            ),
          ),
        ),
      );

      expect(find.text('Test Content'), findsOneWidget);
    });

    testWidgets('has correct border radius', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: 100,
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FrostCard),
          matching: find.byType(Container),
        ).last,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(24));
    });

    testWidgets('has correct border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: FrostCard(
              height: 100,
              child: Text('Test'),
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FrostCard),
          matching: find.byType(Container),
        ).last,
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.border?.top.width, 1);
      expect(
        decoration.border?.top.color,
        Colors.white.withOpacity(0.08),
      );
    });
  });
}
