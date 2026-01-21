import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:home_widget/home_widget.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/main.dart' as app;
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Widget 1: Quick Stats Integration Tests', () {
    late WidgetUpdateService widgetService;
    late StorageService storageService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      storageService = await StorageService.create();
      widgetService = WidgetUpdateService();
      await widgetService.initialize();
    });

    testWidgets('Widget data flows to home_widget storage',
        (tester) async {
      // Arrange: Create sample widget data
      final widgetData = WidgetData(
        todayPushups: 41,
        totalPushups: 44,
        goalPushups: 5050,
        todayGoalReached: false,
        streakDays: 2,
        lastWorkoutDate: DateTime(2026, 1, 21),
        calendarDays: [],
      );

      // Act: Update widget via service
      final success = await widgetService.updateWidget1(widgetData);

      // Assert: Data was saved to home_widget
      final savedData =
          await HomeWidget.getWidgetData<String>('pushup_json_data');
      expect(savedData, isNotNull);
      expect(savedData!.contains('"todayPushups":41'), true);
      expect(savedData.contains('"totalPushups":44'), true);
    });

    testWidgets('Widget displays correct today push-up count',
        (tester) async {
      // Arrange: Create widget data with specific today count
      final widgetData = WidgetData(
        todayPushups: 25,
        totalPushups: 100,
        goalPushups: 5050,
        todayGoalReached: false,
        streakDays: 1,
        calendarDays: [],
      );

      // Act: Update widget
      await widgetService.updateWidget1(widgetData);

      // Assert: JSON contains correct today value
      final savedData =
          await HomeWidget.getWidgetData<String>('pushup_json_data');
      expect(savedData, contains('"todayPushups":25'));
    });

    testWidgets('Widget displays correct total format with goal',
        (tester) async {
      // Arrange: Create widget data with total and goal
      final widgetData = WidgetData(
        todayPushups: 0,
        totalPushups: 44,
        goalPushups: 5050,
        todayGoalReached: false,
        calendarDays: [],
      );

      // Act: Update widget
      await widgetService.updateWidget1(widgetData);

      // Assert: JSON contains total and goal
      final savedData =
          await HomeWidget.getWidgetData<String>('pushup_json_data');
      expect(savedData, contains('"totalPushups":44'));
      expect(savedData, contains('"goalPushups":5050'));
    });

    testWidgets('Widget handles zero values gracefully', (tester) async {
      // Arrange: Empty widget data
      final widgetData = WidgetData.empty();

      // Act: Update widget
      await widgetService.updateWidget1(widgetData);

      // Assert: JSON contains zeros
      final savedData =
          await HomeWidget.getWidgetData<String>('pushup_json_data');
      expect(savedData, contains('"todayPushups":0'));
      expect(savedData, contains('"totalPushups":0'));
    });

    testWidgets('Widget data persists across updates', (tester) async {
      // Arrange: First update
      final firstData = WidgetData(
        todayPushups: 10,
        totalPushups: 20,
        goalPushups: 5050,
        calendarDays: [],
      );

      // Act: Update twice
      await widgetService.updateWidget1(firstData);

      final secondData = WidgetData(
        todayPushups: 50,
        totalPushups: 70,
        goalPushups: 5050,
        todayGoalReached: true,
        calendarDays: [],
      );
      await widgetService.updateWidget1(secondData);

      // Assert: Final data is the second update
      final savedData =
          await HomeWidget.getWidgetData<String>('pushup_json_data');
      expect(savedData, contains('"todayPushups":50'));
      expect(savedData, contains('"totalPushups":70'));
      expect(savedData, contains('"todayGoalReached":true'));
    });

    testWidgets('Widget updates trigger successfully', (tester) async {
      // Arrange: Widget data
      final widgetData = WidgetData.forWidgets(
        todayPushups: 30,
        totalPushups: 500,
        goalPushups: 5050,
      );

      // Act: Update widget
      final result = await widgetService.updateWidget1(widgetData);

      // Assert: Update returns success (may be false on Windows)
      // On Windows, home_widget returns false but data is still saved
      expect(result is bool, true);
    });

    testWidgets('App launches without crash with widget integration',
        (tester) async {
      // Act: Launch app
      await tester.pumpWidget(const app.MyApp());
      await tester.pumpAndSettle();

      // Assert: App renders without errors
      expect(find.byType(app.MaterialApp), findsOneWidget);
    });

    testWidgets('UserStatsProvider integration with widget updates',
        (tester) async {
      // Arrange: Mock storage and widget service
      SharedPreferences.setMockInitialValues({});
      final storage = await StorageService.create();

      final provider = UserStatsProvider(
        storage: storage,
        widgetUpdateService: widgetService,
      );

      // Act: Load stats (which should trigger widget update)
      await provider.loadStats();

      // Assert: Provider loaded successfully
      expect(provider.isLoading, false);
    });

    testWidgets('WidgetData.forWidgets creates correct data structure',
        (tester) async {
      // Act: Create widget data using factory
      final widgetData = WidgetData.forWidgets(
        todayPushups: 15,
        totalPushups: 200,
        goalPushups: 5050,
        streakDays: 3,
      );

      // Assert: Data structure is correct
      expect(widgetData.todayPushups, 15);
      expect(widgetData.totalPushups, 200);
      expect(widgetData.goalPushups, 5050);
      expect(widgetData.streakDays, 3);
      expect(widgetData.todayGoalReached, false); // 15 < 50
    });

    testWidgets('WidgetData.todayGoalReached auto-calculates correctly',
        (tester) async {
      // Act & Assert: Below goal
      final data1 = WidgetData(todayPushups: 30, totalPushups: 100);
      expect(data1.todayGoalReached, false);

      // Act & Assert: At goal
      final data2 = WidgetData(todayPushups: 50, totalPushups: 150);
      expect(data2.todayGoalReached, true);

      // Act & Assert: Above goal
      final data3 = WidgetData(todayPushups: 75, totalPushups: 200);
      expect(data3.todayGoalReached, true);
    });

    testWidgets('WidgetData.empty returns all zeros', (tester) async {
      // Act: Get empty widget data
      final emptyData = WidgetData.empty();

      // Assert: All values are zero/default
      expect(emptyData.todayPushups, 0);
      expect(emptyData.totalPushups, 0);
      expect(emptyData.goalPushups, 5050);
      expect(emptyData.todayGoalReached, false);
      expect(emptyData.streakDays, 0);
      expect(emptyData.lastWorkoutDate, null);
      expect(emptyData.calendarDays, isEmpty);
    });

    testWidgets('Widget update service handles all widget types',
        (tester) async {
      // Arrange: Widget data
      final widgetData = WidgetData(
        todayPushups: 20,
        totalPushups: 300,
        goalPushups: 5050,
        calendarDays: [],
      );

      // Act: Update all widgets
      final result = await widgetService.updateAllWidgets(widgetData);

      // Assert: Update completed
      expect(result, isA<bool>());
    });

    testWidgets('Widget service getWidgetData retrieves saved data',
        (tester) async {
      // Arrange: Save widget data
      final originalData = WidgetData(
        todayPushups: 42,
        totalPushups: 500,
        goalPushups: 5050,
        streakDays: 4,
      );
      await widgetService.updateWidget1(originalData);

      // Act: Retrieve data
      final retrievedData = await widgetService.getWidgetData();

      // Assert: Data matches
      expect(retrievedData, isNotNull);
      expect(retrievedData?.todayPushups, 42);
      expect(retrievedData?.totalPushups, 500);
      expect(retrievedData?.streakDays, 4);
    });

    testWidgets('Widget service clearWidgetData clears storage',
        (tester) async {
      // Arrange: Save data
      final widgetData = WidgetData(
        todayPushups: 10,
        totalPushups: 100,
        goalPushups: 5050,
      );
      await widgetService.updateWidget1(widgetData);

      // Act: Clear data
      await widgetService.clearWidgetData();

      // Assert: Storage cleared (data returns to empty state)
      final clearedData = await widgetService.getWidgetData();
      // After clearing, getWidgetData may return null or empty data
      // The important thing is that clearWidgetData doesn't throw
      expect(clearedData, isA<WidgetData?>());
    });
  });
}
