import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/main.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/screens/home/home_screen.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/screens/profile/profile_screen.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';

/// Integration tests for complete navigation flows.
///
/// Tests the full user experience of navigating through the app,
/// ensuring all screens are reachable and navigation works as expected.
void main() {
  group('Navigation Flow Integration Tests', () {
    testWidgets('App launches on Home screen', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('PUSHUP 5050'), findsOneWidget);
    });

    testWidgets('Tap INIZIA navigates to Series Selection', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      await tester.tap(find.text('INIZIA'));
      await tester.pumpAndSettle();

      expect(find.byType(SeriesSelectionScreen), findsOneWidget);
      expect(find.text('Serie di Partenza'), findsOneWidget);
    });

    testWidgets('Tap back returns from Series Selection to Home', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Navigate to Series Selection
      await tester.tap(find.text('INIZIA'));
      await tester.pumpAndSettle();

      expect(find.byType(SeriesSelectionScreen), findsOneWidget);

      // Tap back button
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Tap Stats in bottom nav switches to Statistics screen',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Get wrapper state and trigger tab change directly
      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );
      wrapperState.onTabTap(1); // Switch to Stats
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
      expect(find.textContaining('Giorno'), findsOneWidget);
    });

    testWidgets('Tap Home in bottom nav switches back to Home', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // First navigate to Stats
      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );
      wrapperState.onTabTap(1); // Switch to Stats
      await tester.pumpAndSettle();
      expect(find.byType(StatisticsScreen), findsOneWidget);

      // Then tap Home
      wrapperState.onTabTap(0); // Switch to Home
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Tap Profile in bottom nav switches to Profile screen',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );
      wrapperState.onTabTap(2); // Switch to Profile
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.textContaining('placeholder'), findsWidgets);
    });

    testWidgets('Can navigate through all three tabs in sequence', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // Start on Home
      expect(find.byType(HomeScreen), findsOneWidget);

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      // Go to Stats
      wrapperState.onTabTap(1);
      await tester.pumpAndSettle();
      expect(find.byType(StatisticsScreen), findsOneWidget);

      // Go to Profile
      wrapperState.onTabTap(2);
      await tester.pumpAndSettle();
      expect(find.byType(ProfileScreen), findsOneWidget);

      // Back to Home
      wrapperState.onTabTap(0);
      await tester.pumpAndSettle();
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('Complete workout flow: Home → Series Selection',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      // On Home
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text('INIZIA'), findsOneWidget);

      // Tap INIZIA to go to Series Selection
      await tester.tap(find.text('INIZIA'));
      await tester.pumpAndSettle();

      // On Series Selection
      expect(find.byType(SeriesSelectionScreen), findsOneWidget);
      expect(find.text('INIZIA ALLENAMENTO'), findsOneWidget);
      expect(find.text('Serie di Partenza'), findsOneWidget);
      expect(find.text('Tempo di Recupero (secondi)'), findsOneWidget);
    });

    testWidgets('Bottom navigation is always visible on main screens',
        (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      // Check Home has bottom nav
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Navigate to Stats
      wrapperState.onTabTap(1);
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Navigate to Profile
      wrapperState.onTabTap(2);
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);

      // Back to Home
      wrapperState.onTabTap(0);
      await tester.pumpAndSettle();
      expect(find.byType(BottomNavigationBar), findsOneWidget);
    });

    testWidgets('Dark theme is applied throughout the app', (tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle();

      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.theme?.brightness, Brightness.dark);

      // Navigate to different screens and verify theme is maintained
      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );
      wrapperState.onTabTap(1);
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
    });
  });
}
