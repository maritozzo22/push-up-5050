import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/common/statistics_badge.dart';

void main() {
  group('StatisticsBadge Widget', () {
    testWidgets('displays label and value correctly', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Push-up Oggi',
              value: '15 / 50',
            ),
          ),
        ),
      );

      expect(find.text('Push-up Oggi: 15 / 50'), findsOneWidget);
    });

    testWidgets('displays orange circle icon with white border', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Test',
              value: '0',
            ),
          ),
        ),
      );

      // Find the icon container (small square container)
      final iconContainers = find.byType(Container);
      // The icon container should have width and height of 12
      bool foundIconContainer = false;
      for (final element in iconContainers.evaluate()) {
        final widget = element.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        if (decoration?.shape == BoxShape.circle &&
            widget.constraints?.minWidth == 12 &&
            widget.constraints?.minHeight == 12) {
          foundIconContainer = true;
          expect(decoration?.color, const Color(0xFFFF6B00)); // Primary orange
          expect(decoration?.border?.top.width, 2); // White border width
          break;
        }
      }
      expect(foundIconContainer, isTrue);
    });

    testWidgets('has correct padding and size constraints', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Test',
              value: '0',
            ),
          ),
        ),
      );

      // Find the main badge container (largest one)
      final containers = find.byType(Container);
      bool foundMainContainer = false;
      for (final element in containers.evaluate()) {
        final widget = element.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        // The main container has border radius of 20
        if (decoration?.borderRadius != null) {
          foundMainContainer = true;
          expect(widget.padding, const EdgeInsets.symmetric(horizontal: 12, vertical: 12));
          expect(widget.constraints?.minHeight, 40);
          break;
        }
      }
      expect(foundMainContainer, isTrue);
    });

    testWidgets('has correct border radius (20px)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Test',
              value: '0',
            ),
          ),
        ),
      );

      // Find the main badge container with borderRadius
      final containers = find.byType(Container);
      bool foundContainerWithRadius = false;
      for (final element in containers.evaluate()) {
        final widget = element.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        if (decoration?.borderRadius == BorderRadius.circular(20)) {
          foundContainerWithRadius = true;
          break;
        }
      }
      expect(foundContainerWithRadius, isTrue);
    });

    testWidgets('has correct background color', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Test',
              value: '0',
            ),
          ),
        ),
      );

      // Find the main badge container with card background color
      final containers = find.byType(Container);
      bool foundCorrectBackground = false;
      for (final element in containers.evaluate()) {
        final widget = element.widget as Container;
        final decoration = widget.decoration as BoxDecoration?;
        if (decoration?.color == const Color(0xFF2A2A2A)) {
          foundCorrectBackground = true;
          break;
        }
      }
      expect(foundCorrectBackground, isTrue);
    });

    testWidgets('text has correct style (18px, white)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: StatisticsBadge(
              label: 'Test',
              value: '0',
            ),
          ),
        ),
      );

      final text = tester.widget<Text>(find.text('Test: 0'));
      expect(text.style?.fontSize, 18);
      expect(text.style?.color, Colors.white);
    });
  });
}
