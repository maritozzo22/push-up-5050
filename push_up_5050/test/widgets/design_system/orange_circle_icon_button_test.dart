import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/orange_circle_icon_button.dart';

void main() {
  group('OrangeCircleIconButton', () {
    testWidgets('renders with Container and Icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byType(Container), findsWidgets);
      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('displays correct icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.home,
              onTap: () {},
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('has circular shape', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
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
      expect(decoration.shape, BoxShape.circle);
    });

    testWidgets('has gradient decoration', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
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

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, true);
    });

    testWidgets('does not call onTap when disabled', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
              onTap: () => tapped = true,
              disabled: true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(GestureDetector));
      expect(tapped, false);
    });

    testWidgets('shows opacity change when disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OrangeCircleIconButton(
              icon: Icons.arrow_back,
              onTap: () {},
              disabled: true,
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

      // When disabled, container should have Opacity parent
      expect(find.byType(Opacity), findsOneWidget);
    });
  });
}
