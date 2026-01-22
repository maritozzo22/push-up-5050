import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/start_button_circle.dart';

void main() {
  group('StartButtonCircle', () {
    testWidgets('renders GestureDetector with Container', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(GestureDetector), findsOneWidget);
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('has correct size', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimatedBuilder),
          matching: find.byType(Container),
        ),
      );

      expect(container.constraints?.minWidth, 164);
      expect(container.constraints?.maxWidth, 164);
      expect(container.constraints?.minHeight, 164);
      expect(container.constraints?.maxHeight, 164);
    });

    testWidgets('shows START text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('START'), findsOneWidget);
    });

    testWidgets('has circular shape', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimatedBuilder),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('has correct gradient', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AnimatedBuilder),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.first, const Color(0xFFFFB347));
      expect(gradient.colors.last, const Color(0xFFFF5F1F));
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('has AnimatedScale for press animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(AnimatedScale), findsOneWidget);
    });

    testWidgets('has AnimatedBuilder for glow animation', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      // Should have at least one AnimatedBuilder (for glow animation)
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('has correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StartButtonCircle(
              onTap: () {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('START'));
      expect(textWidget.style?.fontSize, 32);
      expect(textWidget.style?.fontWeight, FontWeight.w900);
      expect(textWidget.style?.letterSpacing, 2.0);
      expect(textWidget.style?.color, Colors.white);
    });
  });
}
