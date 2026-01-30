import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/widgets/goal_completion/goal_completion_dialog.dart';

void main() {
  group('GoalCompletionDialog Widget', () {
    late bool onDismissCalled;

    setUp(() {
      onDismissCalled = false;
    });

    tearDown(() {
      // Cleanup is handled by Flutter's test framework
    });

    testWidgets('renders with correct title text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Complimenti!'), findsOneWidget);
    });

    testWidgets('renders with correct message text', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Hai completato il tuo obiettivo di oggi.\nCi vediamo domani!'), findsOneWidget);
    });

    testWidgets('Continua button is present', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Continua'), findsOneWidget);
    });

    testWidgets('onDismiss callback is called when button is tapped', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Tap the Continua button
      await tester.tap(find.text('Continua'));
      await tester.pump();

      expect(onDismissCalled, isTrue);
    });

    testWidgets('auto-dismiss is disabled when disableAutoDismiss=true', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Initially visible
      expect(find.byType(GoalCompletionDialog), findsOneWidget);

      // Pump for 6 seconds (more than the 5-second auto-dismiss timer)
      await tester.pump(const Duration(seconds: 6));

      // Widget should still be present (no auto-dismiss)
      expect(find.byType(GoalCompletionDialog), findsOneWidget);
      expect(onDismissCalled, isFalse);
    });

    testWidgets('has orange border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Find Container with orange border
      final containers = find.byType(Container);
      bool foundOrangeBorder = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        final border = decoration?.border;
        if (border is Border) {
          if (border.top.color == const Color(0xFFFF6B00)) {
            foundOrangeBorder = true;
            break;
          }
        }
      }
      expect(foundOrangeBorder, isTrue);
    });

    testWidgets('has rounded corners (20px radius)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Find Container with borderRadius 20
      final containers = find.byType(Container);
      bool foundRadius20 = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.borderRadius == BorderRadius.circular(20)) {
          foundRadius20 = true;
          break;
        }
      }
      expect(foundRadius20, isTrue);
    });

    testWidgets('has Stack widget for confetti particles', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Confetti particles are rendered in a Stack widget
      expect(find.byType(Stack), findsWidgets);

      // AnimatedBuilder is used for particle animation
      expect(find.byType(AnimatedBuilder), findsWidgets);
    });

    testWidgets('title is orange and 24px', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () => onDismissCalled = true,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for entry animation
      await tester.pump(const Duration(milliseconds: 300));

      // Find the title Text widget
      final titleFinder = find.text('Complimenti!');
      expect(titleFinder, findsOneWidget);

      final titleWidget = tester.widget<Text>(titleFinder);
      expect(titleWidget.style?.color, const Color(0xFFFF6B00));
      expect(titleWidget.style?.fontSize, 24);
      expect(titleWidget.style?.fontWeight, FontWeight.bold);
    });
  });
}
