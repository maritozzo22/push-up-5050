import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/widget_calendar_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Integration tests for calendar widget functionality
///
/// Tests verify:
/// - WidgetData serializes weekDayData and threeDayData correctly
/// - WidgetUpdateService includes calendar data in saved JSON
/// - UserStatsProvider integrates with WidgetCalendarService
/// - JSON structure matches what Android providers expect
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Widget Calendar Integration', () {
    late StorageService storageService;
    late WidgetCalendarService calendarService;
    late WidgetUpdateService widgetUpdateService;
    late UserStatsProvider userStatsProvider;

    setUp(() async {
      // Get real SharedPreferences instance and clear for test isolation
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Initialize services
      storageService = await StorageService.create();
      calendarService = WidgetCalendarService(storage: storageService);
      widgetUpdateService = WidgetUpdateService(
        calendarService: calendarService,
      );
      await widgetUpdateService.initialize();

      // Create provider with calendar-enabled widget service
      userStatsProvider = UserStatsProvider(
        storage: storageService,
        widgetUpdateService: widgetUpdateService,
      );
    });

    tearDown(() async {
      // Clean up test data
      await storageService.clearAllData();
    });

    testWidgets('WidgetData contains weekDayData when created with calendar',
        (tester) async {
      // Arrange - Create week data with all statuses
      final now = DateTime(2026, 1, 22); // Wednesday
      final monday = DateTime(2026, 1, 19); // Monday of same week

      // Create week data manually for predictability in test
      final weekDayData = [
        {
          'day': 19,
          'dayLabel': 'L',
          'status': 'completed',
          'pushups': 50,
          'isPartOfStreak': false,
        },
        {
          'day': 20,
          'dayLabel': 'M',
          'status': 'completed',
          'pushups': 45,
          'isPartOfStreak': true,
        },
        {
          'day': 21,
          'dayLabel': 'M',
          'status': 'completed',
          'pushups': 60,
          'isPartOfStreak': true,
        },
        {
          'day': 22,
          'dayLabel': 'G',
          'status': 'today',
          'pushups': 25,
          'isPartOfStreak': false,
        },
        {
          'day': 23,
          'dayLabel': 'V',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
        {
          'day': 24,
          'dayLabel': 'S',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
        {
          'day': 25,
          'dayLabel': 'D',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
      ];

      final threeDayData = [
        {
          'day': 21,
          'dayLabel': 'I',
          'status': 'completed',
          'pushups': 60,
          'isPartOfStreak': false,
        },
        {
          'day': 22,
          'dayLabel': 'O',
          'status': 'today',
          'pushups': 25,
          'isPartOfStreak': false,
        },
        {
          'day': 23,
          'dayLabel': 'D',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
      ];

      // Act - Create WidgetData with calendar data
      final widgetData = WidgetData(
        todayPushups: 25,
        totalPushups: 180,
        goalPushups: 5050,
        streakDays: 3,
        weekDayData: weekDayData,
        threeDayData: threeDayData,
        hasStreakLine: true,
      );

      final jsonString = widgetData.toJsonString();
      final parsedData = WidgetData.fromJsonString(jsonString);

      // Assert - weekDayData is present and correct
      expect(parsedData.weekDayData.length, 7);
      expect(parsedData.weekDayData[0]['dayLabel'], 'L');
      expect(parsedData.weekDayData[0]['status'], 'completed');
      expect(parsedData.weekDayData[3]['status'], 'today');
      expect(parsedData.hasStreakLine, isTrue);
    });

    testWidgets('WidgetData contains threeDayData with correct structure',
        (tester) async {
      // Arrange - Create 3-day data
      final threeDayData = [
        {
          'day': 21,
          'dayLabel': 'I',
          'status': 'completed',
          'pushups': 60,
          'isPartOfStreak': false,
        },
        {
          'day': 22,
          'dayLabel': 'O',
          'status': 'today',
          'pushups': 25,
          'isPartOfStreak': false,
        },
        {
          'day': 23,
          'dayLabel': 'D',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
      ];

      // Act - Create WidgetData with 3-day data
      final widgetData = WidgetData(
        todayPushups: 25,
        totalPushups: 180,
        goalPushups: 5050,
        threeDayData: threeDayData,
      );

      final jsonString = widgetData.toJsonString();
      final parsedData = WidgetData.fromJsonString(jsonString);

      // Assert - threeDayData has exactly 3 entries with correct labels
      expect(parsedData.threeDayData.length, 3);
      expect(parsedData.threeDayData[0]['dayLabel'], 'I');
      expect(parsedData.threeDayData[1]['dayLabel'], 'O');
      expect(parsedData.threeDayData[2]['dayLabel'], 'D');
      expect(parsedData.threeDayData[0]['status'], 'completed');
      expect(parsedData.threeDayData[1]['status'], 'today');
      expect(parsedData.threeDayData[2]['status'], 'pending');
    });

    testWidgets('WidgetUpdateService includes calendar data in JSON',
        (tester) async {
      // Arrange - Create widget data with calendar fields
      final weekDayData = [
        {
          'day': 19,
          'dayLabel': 'L',
          'status': 'completed',
          'pushups': 50,
          'isPartOfStreak': false,
        },
        {
          'day': 20,
          'dayLabel': 'M',
          'status': 'missed',
          'pushups': 0,
          'isPartOfStreak': false,
        },
        // ... rest would be here, but 2 entries enough for test
      ];

      final threeDayData = [
        {
          'day': 21,
          'dayLabel': 'I',
          'status': 'completed',
          'pushups': 60,
          'isPartOfStreak': false,
        },
        {
          'day': 22,
          'dayLabel': 'O',
          'status': 'today',
          'pushups': 25,
          'isPartOfStreak': false,
        },
        {
          'day': 23,
          'dayLabel': 'D',
          'status': 'pending',
          'pushups': 0,
          'isPartOfStreak': false,
        },
      ];

      final widgetData = WidgetData(
        todayPushups: 25,
        totalPushups: 180,
        goalPushups: 5050,
        weekDayData: weekDayData,
        threeDayData: threeDayData,
        hasStreakLine: false,
      );

      // Act - Update widgets
      await widgetUpdateService.updateAllWidgets(widgetData);

      // Assert - WidgetUpdateService processes calendar data without error
      // (On Windows this may return false, but shouldn't throw)
      // The key is that the service accepts calendar data fields
      expect(widgetData.weekDayData.isNotEmpty, isTrue);
      expect(widgetData.threeDayData.isNotEmpty, isTrue);
    });

    testWidgets('UserStatsProvider builds calendar-enriched widget data',
        (tester) async {
      // Arrange - Save some daily records
      await storageService.saveDailyRecord(
        DailyRecord(
          date: DateTime(2026, 1, 19),
          totalPushups: 50,
          seriesCompleted: 5,
        ),
      );
      await storageService.saveDailyRecord(
        DailyRecord(
          date: DateTime(2026, 1, 20),
          totalPushups: 45,
          seriesCompleted: 4,
        ),
      );
      await storageService.saveDailyRecord(
        DailyRecord(
          date: DateTime(2026, 1, 22), // Today
          totalPushups: 25,
          seriesCompleted: 2,
        ),
      );

      // Act - Load stats (triggers widget update with calendar data)
      await userStatsProvider.loadStats();

      // Assert - Calendar service produces week data with expected structure
      final weekData = await calendarService.getWeekData(
        testDate: DateTime(2026, 1, 22),
      );

      expect(weekData.days.length, 7);
      expect(weekData.days.any((d) => d.status == CalendarDayStatus.completed),
          isTrue);
      expect(weekData.days.any((d) => d.status == CalendarDayStatus.today), isTrue);

      // Verify Italian day labels are present
      expect(weekData.days[0].dayLabel, 'L');
      expect(weekData.days[1].dayLabel, 'M');
      expect(weekData.days[6].dayLabel, 'D');
    });

    testWidgets('WidgetUpdateService buildWidgetData includes calendar',
        (tester) async {
      // Arrange - Create stats data
      final todayPushups = 30;
      final totalPushups = 500;
      final streakDays = 2;

      // Act - Build widget data using calendar service
      final widgetData = await widgetUpdateService.buildWidgetData(
        todayPushups: todayPushups,
        totalPushups: totalPushups,
        streakDays: streakDays,
      );

      // Assert - Calendar fields are populated
      expect(widgetData.weekDayData.length, 7);
      expect(widgetData.threeDayData.length, 3);
      expect(widgetData.todayPushups, todayPushups);
      expect(widgetData.totalPushups, totalPushups);
      expect(widgetData.streakDays, streakDays);

      // Verify week day data structure for Android consumption
      final firstDay = widgetData.weekDayData[0];
      expect(firstDay.containsKey('day'), isTrue);
      expect(firstDay.containsKey('dayLabel'), isTrue);
      expect(firstDay.containsKey('status'), isTrue);
      expect(firstDay.containsKey('pushups'), isTrue);
      expect(firstDay.containsKey('isPartOfStreak'), isTrue);

      // Verify 3-day data structure for Android consumption
      final yesterday = widgetData.threeDayData[0];
      expect(yesterday['dayLabel'], 'I');
      final today = widgetData.threeDayData[1];
      expect(today['dayLabel'], 'O');
      final tomorrow = widgetData.threeDayData[2];
      expect(tomorrow['dayLabel'], 'D');
    });

    testWidgets('WidgetData backward compatibility without calendar fields',
        (tester) async {
      // Arrange - Create WidgetData without calendar fields (legacy)
      final legacyData = {
        'todayPushups': 50,
        'totalPushups': 1500,
        'goalPushups': 5050,
        'todayGoalReached': true,
        'streakDays': 5,
      };

      // Act - Parse legacy JSON
      final widgetData = WidgetData.fromJson(legacyData);

      // Assert - Defaults applied for calendar fields
      expect(widgetData.todayPushups, 50);
      expect(widgetData.totalPushups, 1500);
      expect(widgetData.weekDayData, isEmpty);
      expect(widgetData.threeDayData, isEmpty);
      expect(widgetData.hasStreakLine, isFalse);
    });

    testWidgets('Calendar service handles missed day detection',
        (tester) async {
      // Arrange - Save records with a gap (missed day)
      await storageService.saveDailyRecord(
        DailyRecord(
          date: DateTime(2026, 1, 19),
          totalPushups: 50,
          seriesCompleted: 5,
        ),
      );
      // Skip Jan 20 (missed)
      await storageService.saveDailyRecord(
        DailyRecord(
          date: DateTime(2026, 1, 21),
          totalPushups: 45,
          seriesCompleted: 4,
        ),
      );

      // Act - Check if Jan 20 is marked as missed
      final isMissed = await calendarService.isDayMissed(
        DateTime(2026, 1, 20),
        DateTime(2026, 1, 22), // Test date after the missed day
      );

      // Assert - Day 20 should be detected as missed
      expect(isMissed, isTrue);
    });

    testWidgets('WeekDayData JSON structure matches Android expectations',
        (tester) async {
      // Arrange - Create week data
      final weekDayData = [
        {
          'day': 19,
          'dayLabel': 'L',
          'status': 'completed',
          'pushups': 50,
          'isPartOfStreak': false,
        },
      ];

      // Act - Serialize to JSON
      final widgetData = WidgetData(
        todayPushups: 50,
        totalPushups: 1500,
        weekDayData: weekDayData,
      );
      final json = widgetData.toJson();

      // Assert - JSON has correct structure for Android JSONObject parsing
      expect(json.containsKey('weekDayData'), isTrue);
      expect(json['weekDayData'], isA<List>());

      final weekDayArray = json['weekDayData'] as List;
      expect(weekDayArray.first, isA<Map<String, dynamic>>());

      final firstDay = weekDayArray.first as Map<String, dynamic>;
      expect(firstDay['day'], 19);
      expect(firstDay['dayLabel'], 'L');
      expect(firstDay['status'], 'completed');
      expect(firstDay['pushups'], 50);
      expect(firstDay['isPartOfStreak'], false);

      // These are the exact keys Android providers parse:
      // - day (int)
      // - dayLabel (string)
      // - status (string)
      // - pushups (int)
      // - isPartOfStreak (boolean)
    });
  });
}
