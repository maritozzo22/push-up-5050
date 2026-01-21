import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Widget Android Integration Tests', () {
    late WidgetUpdateService widgetService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      widgetService = WidgetUpdateService();
      await widgetService.initialize();
    });

    testWidgets('Widget data serialization produces valid JSON for Android',
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

      // Act: Serialize to JSON string
      final jsonString = widgetData.toJsonString();

      // Assert: JSON contains all required fields with correct values
      expect(jsonString, contains('"todayPushups":41'));
      expect(jsonString, contains('"totalPushups":44'));
      expect(jsonString, contains('"goalPushups":5050'));
      expect(jsonString, contains('"todayGoalReached":false'));
      expect(jsonString, contains('"streakDays":2'));
      expect(jsonString, contains('"lastWorkoutDate":"2026-01-21"'));
    });

    testWidgets('Widget JSON can be deserialized back to WidgetData',
        (tester) async {
      // Arrange: Create JSON string
      final jsonString = '''
      {
        "todayPushups": 41,
        "totalPushups": 44,
        "goalPushups": 5050,
        "todayGoalReached": false,
        "streakDays": 2,
        "lastWorkoutDate": "2026-01-21",
        "calendarDays": []
      }
      ''';

      // Act: Deserialize
      final widgetData = WidgetData.fromJsonString(jsonString);

      // Assert: All fields match
      expect(widgetData.todayPushups, 41);
      expect(widgetData.totalPushups, 44);
      expect(widgetData.goalPushups, 5050);
      expect(widgetData.todayGoalReached, false);
      expect(widgetData.streakDays, 2);
      expect(widgetData.lastWorkoutDate?.day, 21);
    });

    testWidgets('Widget data with zero values serializes correctly',
        (tester) async {
      // Arrange: Empty widget data
      final widgetData = WidgetData.empty();

      // Act: Serialize
      final jsonString = widgetData.toJsonString();

      // Assert: Contains zero values
      expect(jsonString, contains('"todayPushups":0'));
      expect(jsonString, contains('"totalPushups":0'));
      expect(jsonString, contains('"todayGoalReached":false'));
    });

    testWidgets('Widget JSON includes calendarDays array',
        (tester) async {
      // Arrange: Widget data with calendar days
      final widgetData = WidgetData(
        todayPushups: 50,
        totalPushups: 150,
        goalPushups: 5050,
        todayGoalReached: true,
        streakDays: 3,
        lastWorkoutDate: DateTime(2026, 1, 21),
        calendarDays: const [
          CalendarDayData(19, true),
          CalendarDayData(20, true),
          CalendarDayData(21, true),
        ],
      );

      // Act: Serialize
      final jsonString = widgetData.toJsonString();

      // Assert: Calendar days are included
      expect(jsonString, contains('"calendarDays"'));
      expect(jsonString, contains('"day":19'));
      expect(jsonString, contains('"completed":true'));
    });

    testWidgets('Widget data round-trip preserves all fields',
        (tester) async {
      // Arrange: Create original widget data
      final original = WidgetData(
        todayPushups: 25,
        totalPushups: 300,
        goalPushups: 5050,
        todayGoalReached: false,
        streakDays: 5,
        lastWorkoutDate: DateTime(2026, 1, 20),
        calendarDays: const [
          CalendarDayData(18, true),
          CalendarDayData(19, false),
          CalendarDayData(20, true),
        ],
      );

      // Act: Serialize then deserialize
      final jsonString = original.toJsonString();
      final restored = WidgetData.fromJsonString(jsonString);

      // Assert: All fields preserved
      expect(restored.todayPushups, original.todayPushups);
      expect(restored.totalPushups, original.totalPushups);
      expect(restored.goalPushups, original.goalPushups);
      expect(restored.todayGoalReached, original.todayGoalReached);
      expect(restored.streakDays, original.streakDays);
      expect(restored.lastWorkoutDate?.day, original.lastWorkoutDate?.day);
      expect(restored.calendarDays.length, original.calendarDays.length);
      expect(restored.calendarDays[0].day, 18);
      expect(restored.calendarDays[0].completed, true);
      expect(restored.calendarDays[1].day, 19);
      expect(restored.calendarDays[1].completed, false);
    });
  });
}
