import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/workout/countdown_circle.dart';

void main() {
  group('CountdownCircle Widget', () {
    testWidgets('displays number at center', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 5,
              subtitle: 'Tocca per Contare',
            ),
          ),
        ),
      );

      expect(find.text('5'), findsOneWidget);
    });

    testWidgets('displays subtitle below number', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 3,
              subtitle: 'Tocca per Contare',
            ),
          ),
        ),
      );

      expect(find.text('Tocca per Contare'), findsOneWidget);
    });

    testWidgets('has correct size (280px)', (tester) async {
      // Set mobile screen size (<600px)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 1,
              subtitle: 'Test',
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(CountdownCircle),
          matching: find.byType(SizedBox),
        ).first,
      );

      expect(sizedBox.width, 280);
      expect(sizedBox.height, 280);
    });

    testWidgets('has radial gradient from secondaryOrange to deepOrangeRed', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 1,
              subtitle: 'Test',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CountdownCircle),
          matching: find.byType(Container),
        ).first,
      );

      final decoration = container.decoration as BoxDecoration?;
      expect(decoration?.shape, BoxShape.circle);

      final gradient = decoration?.gradient as RadialGradient?;
      expect(gradient, isNotNull);
      expect(gradient?.colors.length, 2);
      expect(gradient?.colors.first, const Color(0xFFFF8C00)); // secondaryOrange
      expect(gradient?.colors.last, const Color(0xFFFF4500)); // deepOrangeRed
    });

    testWidgets('number text has correct style (120px, bold, white)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 7,
              subtitle: 'Test',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('7'));
      expect(text.style?.fontSize, 120);
      expect(text.style?.fontWeight, FontWeight.bold);
      expect(text.style?.color, Colors.white);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 1,
              subtitle: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(CountdownCircle));
      expect(tapped, isTrue);
    });

    testWidgets('has outer glow and shadow effects', (tester) async {
      // Set mobile screen size (<600px)
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CountdownCircle(
              number: 1,
              subtitle: 'Test',
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(CountdownCircle),
          matching: find.byType(Container),
        ).first,
      );

      expect(container.constraints?.minWidth, 280);
      expect(container.constraints?.minHeight, 280);

      final decoration = container.decoration as BoxDecoration?;
      // Should have shadows for glow effect
      expect(decoration?.boxShadow?.isNotEmpty, isTrue);
    });
  });
}
