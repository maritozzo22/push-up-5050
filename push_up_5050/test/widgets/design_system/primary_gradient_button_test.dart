import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/primary_gradient_button.dart';

void main() {
  group('PrimaryGradientButton', () {
    testWidgets('renders with Container', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test Button',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.text('Test Button'), findsOneWidget);
    });

    testWidgets('displays text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Click Me',
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.text('Click Me'), findsOneWidget);
    });

    testWidgets('has gradient decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test',
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.first, const Color(0xFFFFB347));
      expect(gradient.colors.last, const Color(0xFFFF5F1F));
    });

    testWidgets('has rounded corners', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test',
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GestureDetector),
          matching: find.byType(Container),
        ),
      );

      final decoration = container.decoration as BoxDecoration;
      expect(decoration.borderRadius, BorderRadius.circular(999));
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test',
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('has correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test',
              onTap: () {},
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Test'));
      expect(textWidget.style?.fontWeight, FontWeight.w700);
      expect(textWidget.style?.color, Colors.white);
    });

    testWidgets('is disabled when onTap is null', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: PrimaryGradientButton(
              text: 'Test',
              onTap: null,
            ),
          ),
        ),
      );

      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector),
      );
      expect(gestureDetector.onTap, isNull);
    });
  });
}
