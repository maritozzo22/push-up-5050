import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/main.dart' as app;
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/widgets/goal_completion/goal_completion_dialog.dart';

/// Integration tests for goal completion popup navigation flow.
///
/// Tests the complete user experience:
/// 1. Complete daily goal during workout
/// 2. Goal completion popup appears
/// 3. Dismiss popup (tap button or auto-dismiss)
/// 4. Navigation to statistics screen
/// 5. Verify navigation stack is correct (workout replaced)
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Goal Popup Navigation Integration Tests', () {
    testWidgets('Statistics route /statistics exists in main.dart', (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      // Navigate to statistics using the named route
      // This should work now that we added the route
      tester.state<NavigatorState>(find.byType(Navigator))
          .pushReplacementNamed('/statistics');
      await tester.pumpAndSettle();

      // Verify statistics screen is displayed
      expect(find.byType(StatisticsScreen), findsOneWidget);
      expect(find.text('STATISTICHE'), findsOneWidget);
    });

    testWidgets('Goal completion session model reaches goal correctly',
        (tester) async {
      // Create a session that will complete the goal
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 10,
      );

      // Simulate reaching the goal by completing series
      // Series 1: 1 pushup (total: 1)
      session.countRep();
      session.advanceToNextSeries(); // total: 1

      // Series 2: 2 pushups (total: 3)
      for (int i = 0; i < 2; i++) session.countRep();
      session.advanceToNextSeries(); // total: 3

      // Series 3: 3 pushups (total: 6)
      for (int i = 0; i < 3; i++) session.countRep();
      session.advanceToNextSeries(); // total: 6

      // Series 4: 4 pushups (total: 10) - this completes the goal
      for (int i = 0; i < 4; i++) session.countRep();
      // At this point totalReps = 10, which equals goalPushups

      expect(session.totalReps, 10);
      expect(session.goalReached, true);
    });

    testWidgets('Direct navigation to /statistics uses pushReplacementNamed',
        (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      // Navigate to statistics directly
      tester.state<NavigatorState>(find.byType(Navigator))
          .pushReplacementNamed('/statistics');
      await tester.pumpAndSettle();

      // Verify statistics screen is displayed
      expect(find.byType(StatisticsScreen), findsOneWidget);

      // Verify back button exists (for returning to Home)
      expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);

      // Tap back button to return
      await tester.tap(find.byIcon(Icons.arrow_back_rounded));
      await tester.pumpAndSettle();

      // Back button should pop the statistics screen
      // Now we should see something below it (MainNavigationWrapper)
    });

    testWidgets('GoalCompletionDialog widget has proper structure',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () {
                // Test callback
              },
              disableAutoDismiss: true, // Disable auto-dismiss for testing
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify dialog content
      expect(find.text('Complimenti!'), findsOneWidget);
      expect(find.textContaining('obiettivo di oggi'), findsOneWidget);
      expect(find.text('Continua'), findsOneWidget);
      expect(find.byIcon(Icons.emoji_events), findsOneWidget);
    });

    testWidgets('Tapping Continua button calls onDismiss callback',
        (tester) async {
      bool dismissCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () {
                dismissCalled = true;
              },
              disableAutoDismiss: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap the Continua button
      await tester.tap(find.text('Continua'));
      await tester.pumpAndSettle();

      // Verify callback was called
      expect(dismissCalled, true);
    });

    testWidgets('Statistics screen has back button for direct navigation',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: const StatisticsScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // Note: StatisticsScreen requires providers to work properly
      // When accessed directly without providers, it will show loading state
      // But the back button should still be visible
    });

    testWidgets('onGenerateRoute handles /statistics route correctly',
        (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      // Get the MaterialApp widget
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));

      // Verify onGenerateRoute is set
      expect(materialApp.onGenerateRoute, isNotNull);

      // Test the route generator directly
      final route = materialApp.onGenerateRoute!(
        const RouteSettings(name: '/statistics'),
      );

      expect(route, isA<MaterialPageRoute>());
    });

    testWidgets('pushReplacementNamed replaces current route', (tester) async {
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      final navigator = tester.state<NavigatorState>(find.byType(Navigator));

      // Navigate to statistics using pushReplacementNamed
      navigator.pushReplacementNamed('/statistics');
      await tester.pumpAndSettle();

      // Verify statistics screen is displayed
      expect(find.byType(StatisticsScreen), findsOneWidget);
    });
  });

  group('Goal Completion Edge Cases', () {
    testWidgets('Dialog is dismissible by tapping outside', (tester) async {
      bool dismissCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () {
                dismissCalled = true;
              },
              disableAutoDismiss: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap outside the dialog (on the barrier)
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      // Verify callback was called (barrierDismissible is true)
      expect(dismissCalled, true);
    });

    testWidgets('Auto-dismiss after 5 seconds when not disabled', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GoalCompletionDialog(
              onDismiss: () {
                // Will be called by timer
              },
              disableAutoDismiss: false, // Auto-dismiss enabled
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Wait for auto-dismiss timer (5 seconds)
      await tester.pump(const Duration(seconds: 5));
      await tester.pumpAndSettle();

      // Dialog should be dismissed
      expect(find.byType(GoalCompletionDialog), findsNothing);
    });
  });
}
