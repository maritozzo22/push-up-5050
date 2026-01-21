import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/main.dart' as app;
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Widget Update Integration', () {
    late StorageService storageService;
    late WidgetUpdateService widgetUpdateService;
    late UserStatsProvider userStatsProvider;
    late ActiveWorkoutProvider activeWorkoutProvider;

    setUp(() async {
      // Initialize the app
      app.main();

      // Get real SharedPreferences instance and clear for test isolation
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Initialize services
      storageService = await StorageService.create();
      widgetUpdateService = WidgetUpdateService();
      await widgetUpdateService.initialize();

      // Create providers
      userStatsProvider = UserStatsProvider(
        storage: storageService,
        widgetUpdateService: widgetUpdateService,
      );

      activeWorkoutProvider = ActiveWorkoutProvider(
        storage: storageService,
        widgetUpdateService: widgetUpdateService,
      );
    });

    tearDown(() async {
      // Clean up test data
      await storageService.clearAllData();
    });

    testWidgets('WidgetData serializes and deserializes correctly',
        (tester) async {
      // Arrange
      final originalData = WidgetData(
        todayPushups: 50,
        totalPushups: 1500,
        goalPushups: 5050,
        todayGoalReached: true,
        streakDays: 5,
        lastWorkoutDate: DateTime(2026, 1, 20),
        calendarDays: [
          CalendarDayData(1, true),
          CalendarDayData(2, true),
          CalendarDayData(3, false),
        ],
      );

      // Act
      final jsonString = originalData.toJsonString();
      final restoredData = WidgetData.fromJsonString(jsonString);

      // Assert
      expect(restoredData.todayPushups, originalData.todayPushups);
      expect(restoredData.totalPushups, originalData.totalPushups);
      expect(restoredData.todayGoalReached, originalData.todayGoalReached);
      expect(restoredData.streakDays, originalData.streakDays);
      expect(
        restoredData.lastWorkoutDate?.toIso8601String(),
        originalData.lastWorkoutDate?.toIso8601String(),
      );
      expect(restoredData.calendarDays.length, originalData.calendarDays.length);
    });

    testWidgets('WidgetUpdateService initializes and is available',
        (tester) async {
      // Act
      final isAvailable = widgetUpdateService.isAvailable;

      // Assert
      expect(isAvailable, isTrue);
    });

    testWidgets('WidgetUpdateService handles empty widget data', (tester) async {
      // Arrange
      final emptyData = WidgetData.empty();

      // Act & Assert - should not throw
      final result = await widgetUpdateService.updateAllWidgets(emptyData);

      // Result is bool (may be false on Windows, true on Android)
      expect(result, isA<bool>());
    });

    testWidgets('WidgetUpdateService handles complete widget data',
        (tester) async {
      // Arrange
      final completeData = WidgetData(
        todayPushups: 41,
        totalPushups: 500,
        goalPushups: 5050,
        todayGoalReached: false,
        streakDays: 2,
        lastWorkoutDate: DateTime(2026, 1, 20),
        calendarDays: List.generate(
          30,
          (i) => CalendarDayData(i + 1, i < 5),
        ),
      );

      // Act & Assert - should not throw
      final result = await widgetUpdateService.updateAllWidgets(completeData);

      // Result is bool
      expect(result, isA<bool>());
    });

    testWidgets('UserStatsProvider can be created with widget service',
        (tester) async {
      // Assert - provider was created in setUp without throwing
      expect(userStatsProvider, isNotNull);
      expect(userStatsProvider.isLoading, isTrue);
    });

    testWidgets('UserStatsProvider loadStats completes without error',
        (tester) async {
      // Act
      await userStatsProvider.loadStats();

      // Assert
      expect(userStatsProvider.isLoading, isFalse);
      expect(userStatsProvider.todayPushups, greaterThanOrEqualTo(0));
      expect(userStatsProvider.totalPushupsAllTime, greaterThanOrEqualTo(0));
    });

    testWidgets('ActiveWorkoutProvider can be created with widget service',
        (tester) async {
      // Assert - provider was created in setUp without throwing
      expect(activeWorkoutProvider, isNotNull);
      expect(activeWorkoutProvider.session, isNull);
    });

    testWidgets('ActiveWorkoutProvider workout lifecycle works',
        (tester) async {
      // Act - start workout
      await activeWorkoutProvider.startWorkout(
        startingSeries: 1,
        restTime: 30,
      );

      // Assert
      expect(activeWorkoutProvider.session, isNotNull);
      expect(activeWorkoutProvider.session?.startingSeries, 1);

      // Act - end workout
      await activeWorkoutProvider.endWorkout();

      // Assert
      expect(activeWorkoutProvider.session, isNull);
    });

    testWidgets('App launches without errors', (tester) async {
      // Act - launch app (already done in setUp, just pump and settle)
      await tester.pumpAndSettle();

      // Assert - app renders without crashing
      expect(find.byType(app.MyApp), findsOneWidget);
    });

    testWidgets('WidgetData equality works correctly', (tester) async {
      // Arrange
      final data1 = WidgetData(
        todayPushups: 50,
        totalPushups: 500,
        goalPushups: 5050,
        todayGoalReached: true,
        streakDays: 3,
        lastWorkoutDate: DateTime(2026, 1, 20),
      );

      final data2 = WidgetData(
        todayPushups: 50,
        totalPushups: 500,
        goalPushups: 5050,
        todayGoalReached: true,
        streakDays: 3,
        lastWorkoutDate: DateTime(2026, 1, 20),
      );

      final data3 = WidgetData(
        todayPushups: 25,
        totalPushups: 500,
        goalPushups: 5050,
      );

      // Assert
      expect(data1, equals(data2));
      expect(data1, isNot(equals(data3)));
    });

    testWidgets('WidgetData copyWith creates correct copy', (tester) async {
      // Arrange
      final original = WidgetData(
        todayPushups: 10,
        totalPushups: 100,
        goalPushups: 5050,
        streakDays: 1,
      );

      // Act
      final copy = original.copyWith(todayPushups: 20);

      // Assert
      expect(original.todayPushups, 10);
      expect(copy.todayPushups, 20);
      expect(copy.totalPushups, original.totalPushups);
      expect(copy.streakDays, original.streakDays);
    });
  });
}
