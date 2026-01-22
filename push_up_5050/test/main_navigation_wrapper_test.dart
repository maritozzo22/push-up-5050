import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/main_navigation_wrapper.dart';
import 'package:push_up_5050/screens/home/home_screen.dart';
import 'package:push_up_5050/screens/statistics/statistics_screen.dart';
import 'package:push_up_5050/screens/profile/profile_screen.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';
import 'package:push_up_5050/screens/workout_execution/workout_execution_screen.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/widgets/design_system/start_button_circle.dart';
import 'test_helpers.dart';

void main() {
  group('MainNavigationWrapper', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider userStatsProvider;

    setUpAll(() {
      // Disable animations in tests to prevent pumpAndSettle timeout
      StartButtonCircle.testMode = true;
    });

    setUp(() async {
      fakeStorage = FakeStorageService();
      userStatsProvider = UserStatsProvider(storage: fakeStorage);
      // Pre-load data to avoid loading state
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);
      await userStatsProvider.loadStats();
    });

    testWidgets('initializes with Home screen (index 0)', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const MainNavigationWrapper(),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(StatisticsScreen), findsNothing);
      expect(find.byType(ProfileScreen), findsNothing);
    });

    testWidgets('switches to Stats when index 1 selected via callback',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: MainNavigationWrapper(
            key: GlobalKey(),
          ),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      // Find the wrapper and trigger tab change
      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      wrapperState.onTabTap(1);
      await tester.pumpAndSettle();

      expect(find.byType(StatisticsScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('switches to Profile when index 2 selected via callback',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: MainNavigationWrapper(
            key: GlobalKey(),
          ),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      wrapperState.onTabTap(2);
      await tester.pumpAndSettle();

      expect(find.byType(ProfileScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('can navigate to Series Selection (push)', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: MainNavigationWrapper(
            key: GlobalKey(),
          ),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      wrapperState.navigateToSeriesSelection();
      await tester.pumpAndSettle();

      expect(find.byType(SeriesSelectionScreen), findsOneWidget);
    });

    testWidgets('can navigate to Workout Execution (push)', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: MainNavigationWrapper(
            key: GlobalKey(),
          ),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      final wrapperState = tester.state<MainNavigationWrapperState>(
        find.byType(MainNavigationWrapper),
      );

      wrapperState.navigateToWorkout();
      await tester.pumpAndSettle();

      expect(find.byType(WorkoutExecutionScreen), findsOneWidget);
    });

    testWidgets('Home tab is selected by default (currentIndex 0)',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(
          child: const MainNavigationWrapper(),
          userStatsProvider: userStatsProvider,
        ),
      );
      await tester.pumpAndSettle();

      final bottomNavBar = tester.widget<BottomNavigationBar>(
        find.byType(BottomNavigationBar),
      );
      expect(bottomNavBar.currentIndex, 0);
    });
  });
}
