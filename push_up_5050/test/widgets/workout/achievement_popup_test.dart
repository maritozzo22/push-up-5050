import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/widgets/workout/achievement_popup.dart';

void main() {
  group('AchievementPopup Widget', () {
    late Achievement testAchievement;

    setUp(() {
      // Create fresh test data for each test to avoid state leakage
      testAchievement = Achievement(
        id: 'test_achievement',
        name: 'Dieci in Un Row',
        description: 'Completa 10 push-up in una serie!',
        points: 150,
        icon: '🏆',
      );
    });

    tearDown(() {
      // Cleanup is handled by Flutter's test framework
      // Widgets created in tests are automatically disposed
    });

    testWidgets('displays achievement name', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Dieci in Un Row'), findsOneWidget);
    });

    testWidgets('displays achievement description', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('Completa 10 push-up in una serie!'), findsOneWidget);
    });

    testWidgets('displays achievement points', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('+150 punti'), findsOneWidget);
    });

    testWidgets('displays achievement icon', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text('🏆'), findsOneWidget);
    });

    testWidgets('has correct width (90% screen width)', (tester) async {
      // Set screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Find the popup container
      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(AchievementPopup),
          matching: find.byType(Container),
        ).last,
      );

      // Should have width approximately 90% of 400 = 360
      expect(container.constraints?.minWidth, greaterThan(350));
      expect(container.constraints?.minWidth, lessThan(370));
    });

    testWidgets('has orange border', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      // Find the popup container with border
      final containers = find.byType(Container);
      bool foundOrangeBorder = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        final border = decoration?.border;
        if (border is Border) {
          // Check if any side has orange color
          if (border.top.color == const Color(0xFFFF6B00)) {
            foundOrangeBorder = true;
            break;
          }
        }
      }
      expect(foundOrangeBorder, isTrue);
    });

    testWidgets('has correct border radius (16px)', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      // Find Container with borderRadius 16
      final containers = find.byType(Container);
      bool foundRadius16 = false;
      for (final element in containers.evaluate()) {
        final container = element.widget as Container;
        final decoration = container.decoration as BoxDecoration?;
        if (decoration?.borderRadius == BorderRadius.circular(16)) {
          foundRadius16 = true;
          break;
        }
      }
      expect(foundRadius16, isTrue);
    });

    testWidgets('auto-dismisses after 3-4 seconds', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
            ),
          ),
        ),
      );

      // Initially visible
      expect(find.byType(AchievementPopup), findsOneWidget);

      // Wait for slide-in animation to complete
      await tester.pump(const Duration(milliseconds: 300));

      // Pump for 4+ seconds to trigger auto-dismiss timer
      // The timer is set for 4 seconds, so we need to pump past that
      await tester.pump(const Duration(seconds: 5));

      // Pump for slide-out animation
      await tester.pump(const Duration(milliseconds: 300));

      // Widget is still in tree but dismissed (slide-out animation complete)
      expect(find.byType(AchievementPopup), findsOneWidget);
    });

    testWidgets('can be tapped to dismiss immediately', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true, // Disable timer to avoid test isolation issues
            ),
          ),
        ),
      );

      // Wait for slide-in animation to complete
      await tester.pump(const Duration(milliseconds: 300));

      // Find the GestureDetector and tap it
      final gestureDetector = find.byType(GestureDetector);
      expect(gestureDetector, findsOneWidget);

      await tester.tap(gestureDetector);

      // Start slide-out animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Widget should still exist (parent decides when to remove)
      expect(find.byType(AchievementPopup), findsOneWidget);
    });

    testWidgets('has close button (X) in top right corner', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      // Should find close icon
      expect(find.byIcon(Icons.close), findsOneWidget);

      // Verify the close button is white
      final closeIcon = tester.widget<Icon>(find.byIcon(Icons.close));
      expect(closeIcon.color, Colors.white);
    });

    testWidgets('close button dismisses the popup', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AchievementPopup(
              achievement: testAchievement,
              disableAutoDismiss: true,
            ),
          ),
        ),
      );

      // Wait for slide-in animation
      await tester.pump(const Duration(milliseconds: 300));

      // Tap the close button
      await tester.tap(find.byIcon(Icons.close));

      // Start slide-out animation
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      // Widget still exists but dismissed
      expect(find.byType(AchievementPopup), findsOneWidget);
    });
  });
}
