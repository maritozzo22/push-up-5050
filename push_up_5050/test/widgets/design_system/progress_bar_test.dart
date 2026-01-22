import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/design_system/progress_bar.dart';

void main() {
  group('ProgressBar', () {
    testWidgets('renders ClipRRect', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      expect(find.byType(ClipRRect), findsOneWidget);
    });

    testWidgets('has correct height', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      expect(container.constraints?.minHeight, 9);
      expect(container.constraints?.maxHeight, 9);
    });

    testWidgets('has background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      final container = tester.widget<Container>(find.byType(Container).first);
      // Container with color property (not decoration)
      expect(container.color, Colors.white.withOpacity(0.08));
    });

    testWidgets('renders FractionallySizedBox for progress', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      expect(find.byType(FractionallySizedBox), findsOneWidget);
    });

    testWidgets('clamps value to 0-1 range', (tester) async {
      // Test value > 1
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 1.5),
          ),
        ),
      );

      final fractionalBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionalBox.widthFactor, 1.0);

      // Test value < 0
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: -0.5),
          ),
        ),
      );

      final fractionalBox2 = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionalBox2.widthFactor, 0.0);
    });

    testWidgets('has correct width factor for 0.5 value', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      final fractionalBox = tester.widget<FractionallySizedBox>(
        find.byType(FractionallySizedBox),
      );
      expect(fractionalBox.widthFactor, 0.5);
    });

    testWidgets('has gradient fill', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ProgressBar(value: 0.5),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(FractionallySizedBox),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final gradient = decoration.gradient as LinearGradient;
      expect(gradient.colors.first, const Color(0xFFFFB347));
      expect(gradient.colors.last, const Color(0xFFFF7A18));
    });
  });
}
