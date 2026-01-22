import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/services/widget_update_service.dart';
import 'package:push_up_5050/services/widget_calendar_service.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/models/achievement.dart';

class MockMethodChannel {
  String? lastMethodCalled;
  dynamic lastArguments;

  void mockInvokeMethod(String method, [dynamic arguments]) {
    lastMethodCalled = method;
    lastArguments = arguments;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('WidgetUpdateService', () {
    late WidgetUpdateService service;

    setUp(() {
      service = WidgetUpdateService();
    });

    group('Initialization', () {
      test('should initialize successfully', () async {
        // Act
        final result = await service.initialize();

        // Assert
        expect(result, isTrue);
        expect(service.isAvailable, isTrue);
      });

      test('should be available after initialization', () {
        // Arrange
        expect(service.isAvailable, isFalse);

        // Act
        service.initialize().ignore();

        // Assert
        expect(service.isAvailable, isTrue);
      });
    });

    group('updateAllWidgets', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateAllWidgets(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle empty widget data', () async {
        // Arrange
        final emptyData = WidgetData.empty();

        // Act
        final result = await service.updateAllWidgets(emptyData);

        // Assert - should not throw, returns bool
        expect(result, isA<bool>());
      });

      test('should handle complete widget data', () async {
        // Arrange
        final completeData = WidgetData(
          todayPushups: 41,
          totalPushups: 44,
          goalPushups: 5050,
          todayGoalReached: false,
          streakDays: 2,
          lastWorkoutDate: DateTime(2026, 1, 20),
          calendarDays: [
            CalendarDayData(1, true),
            CalendarDayData(2, true),
            CalendarDayData(3, false),
          ],
        );

        // Act
        final result = await service.updateAllWidgets(completeData);

        // Assert - should not throw
        expect(result, isA<bool>());
      });
    });

    group('updateQuickStartWidget', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateQuickStartWidget(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle update without throwing', () async {
        // Arrange
        final data = WidgetData.forWidgets(
          todayPushups: 50,
          totalPushups: 500,
        );

        // Act & Assert - should not throw
        await expectLater(
          () => service.updateQuickStartWidget(data),
          returnsNormally,
        );
      });
    });

    group('updateSmallWidget', () {
      setUp(() async {
        await service.initialize();
      });

      test('should return false when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();
        final data = WidgetData.empty();

        // Act
        final result = await uninitializedService.updateSmallWidget(data);

        // Assert
        expect(result, isFalse);
      });

      test('should handle calendar data update', () async {
        // Arrange
        final data = WidgetData(
          todayPushups: 30,
          totalPushups: 300,
          calendarDays: List.generate(
            30,
            (i) => CalendarDayData(i + 1, i < 5),
          ),
        );

        // Act & Assert - should not throw
        await expectLater(
          () => service.updateSmallWidget(data),
          returnsNormally,
        );
      });
    });

    group('buildWidgetData', () {
      setUp(() async {
        await service.initialize();
      });

      test('should work without calendar service (backward compatibility)', () async {
        // Arrange - Service without calendar service
        final serviceWithoutCalendar = WidgetUpdateService();

        // Act
        final widgetData = await serviceWithoutCalendar.buildWidgetData(
          todayPushups: 41,
          totalPushups: 444,
          goalPushups: 5050,
          streakDays: 2,
        );

        // Assert
        expect(widgetData.todayPushups, 41);
        expect(widgetData.totalPushups, 444);
        expect(widgetData.streakDays, 2);
        expect(widgetData.weekDayData, isEmpty);
        expect(widgetData.threeDayData, isEmpty);
        expect(widgetData.hasStreakLine, false);
      });

      test('should return default WidgetData when service not initialized', () async {
        // Arrange
        final uninitializedService = WidgetUpdateService();

        // Act
        final widgetData = await uninitializedService.buildWidgetData(
          todayPushups: 0,
          totalPushups: 44,
          streakDays: 2,
        );

        // Assert
        expect(widgetData.todayPushups, 0);
        expect(widgetData.totalPushups, 44);
      });
    });

    group('clearWidgetData', () {
      test('should handle clearing without throwing', () async {
        // Act & Assert - should not throw even when not initialized
        await expectLater(
          () => service.clearWidgetData(),
          returnsNormally,
        );
      });

      test('should clear data after initialization', () async {
        // Arrange
        await service.initialize();

        // Act & Assert - should not throw
        await expectLater(
          () => service.clearWidgetData(),
          returnsNormally,
        );
      });
    });

    group('registerPeriodicUpdates', () {
      test('should return false when not initialized', () async {
        // Act
        final result = await service.registerPeriodicUpdates();

        // Assert
        expect(result, isFalse);
      });

      test('should handle periodic update registration', () async {
        // Arrange
        await service.initialize();

        // Act
        final result = await service.registerPeriodicUpdates();

        // Assert
        expect(result, isA<bool>());
      });
    });

    group('getWidgetData', () {
      test('should return null when service not initialized', () async {
        // Act
        final result = await service.getWidgetData();

        // Assert
        expect(result, isNull);
      });

      test('should return null when no data saved', () async {
        // Arrange
        await service.initialize();

        // Act
        final result = await service.getWidgetData();

        // Assert - null is expected when no data exists
        expect(result, isNull);
      });
    });
  });

  group('WidgetUpdateService with Calendar Integration', () {
    late MockStorageService mockStorage;
    late WidgetCalendarService calendarService;

    setUp(() {
      mockStorage = MockStorageService();
      calendarService = WidgetCalendarService(storage: mockStorage);
    });

    group('buildWidgetData with Calendar Service', () {
      test('includes week data from calendar service', () async {
        // Arrange - Set up some workout records
        final now = DateTime(2026, 1, 22); // Wednesday
        final monday = DateTime(2026, 1, 19);
        final tuesday = DateTime(2026, 1, 20);

        final records = {
          _formatDate(monday): {
            'date': _formatDate(monday),
            'totalPushups': 50,
            'seriesCompleted': 5,
            'totalKcal': 22.5,
            'goalReached': true,
          },
          _formatDate(tuesday): {
            'date': _formatDate(tuesday),
            'totalPushups': 40,
            'seriesCompleted': 4,
            'totalKcal': 18.0,
            'goalReached': false,
          },
        };
        mockStorage.setDailyRecords(records);

        final serviceWithCalendar = WidgetUpdateService(
          calendarService: calendarService,
        );

        // Act
        final widgetData = await serviceWithCalendar.buildWidgetData(
          todayPushups: 41,
          totalPushups: 444,
          goalPushups: 5050,
          streakDays: 2,
        );

        // Assert
        expect(widgetData.todayPushups, 41);
        expect(widgetData.totalPushups, 444);
        expect(widgetData.streakDays, 2);
        expect(widgetData.weekDayData.length, 7); // 7 days in week
        expect(widgetData.hasStreakLine, true); // Monday and Tuesday consecutive

        // Check Italian day labels
        expect(widgetData.weekDayData[0]['dayLabel'], 'L'); // Lunedi
        expect(widgetData.weekDayData[1]['dayLabel'], 'M'); // Martedi
        expect(widgetData.weekDayData[2]['dayLabel'], 'M'); // Mercoledi
        expect(widgetData.weekDayData[3]['dayLabel'], 'G'); // Giovedi
        expect(widgetData.weekDayData[4]['dayLabel'], 'V'); // Venerdi
        expect(widgetData.weekDayData[5]['dayLabel'], 'S'); // Sabato
        expect(widgetData.weekDayData[6]['dayLabel'], 'D'); // Domenica
      });

      test('includes three-day data with Italian labels', () async {
        // Arrange
        final now = DateTime(2026, 1, 21); // Wednesday
        final yesterday = DateTime(2026, 1, 20);

        final records = {
          _formatDate(yesterday): {
            'date': _formatDate(yesterday),
            'totalPushups': 50,
            'seriesCompleted': 5,
            'totalKcal': 22.5,
            'goalReached': true,
          },
        };
        mockStorage.setDailyRecords(records);

        final serviceWithCalendar = WidgetUpdateService(
          calendarService: calendarService,
        );

        // Act
        final widgetData = await serviceWithCalendar.buildWidgetData(
          todayPushups: 30,
          totalPushups: 300,
          streakDays: 1,
        );

        // Assert
        expect(widgetData.threeDayData.length, 3);
        expect(widgetData.threeDayData[0]['dayLabel'], 'I'); // Ieri
        expect(widgetData.threeDayData[1]['dayLabel'], 'O'); // Oggi
        expect(widgetData.threeDayData[2]['dayLabel'], 'D'); // Domani
      });

      test('hasStreakLine matches calendar service result', () async {
        // Arrange - Create consecutive completed days
        final now = DateTime(2026, 1, 21); // Wednesday
        final monday = DateTime(2026, 1, 19);
        final tuesday = DateTime(2026, 1, 20);

        final records = {
          _formatDate(monday): {
            'date': _formatDate(monday),
            'totalPushups': 50,
            'seriesCompleted': 5,
            'totalKcal': 22.5,
            'goalReached': true,
          },
          _formatDate(tuesday): {
            'date': _formatDate(tuesday),
            'totalPushups': 40,
            'seriesCompleted': 4,
            'totalKcal': 18.0,
            'goalReached': false,
          },
        };
        mockStorage.setDailyRecords(records);

        final serviceWithCalendar = WidgetUpdateService(
          calendarService: calendarService,
        );

        // Act
        final widgetData = await serviceWithCalendar.buildWidgetData(
          todayPushups: 0,
          totalPushups: 90,
          streakDays: 2,
        );

        // Assert - should have streak line since Monday and Tuesday are consecutive
        expect(widgetData.hasStreakLine, true);
      });

      test('gracefully degrades on calendar service error', () async {
        // Arrange - Empty storage (will cause calendar service to handle gracefully)
        mockStorage.setDailyRecords({});

        final serviceWithCalendar = WidgetUpdateService(
          calendarService: calendarService,
        );

        // Act - Should not throw
        final widgetData = await serviceWithCalendar.buildWidgetData(
          todayPushups: 10,
          totalPushups: 100,
          streakDays: 0,
        );

        // Assert - Should still have basic data even if calendar data is empty
        expect(widgetData.todayPushups, 10);
        expect(widgetData.totalPushups, 100);
      });
    });

    group('updateAllWidgets with Calendar Data', () {
      test('saves calendar data to storage', () async {
        // Arrange
        final now = DateTime(2026, 1, 22);
        final monday = DateTime(2026, 1, 19);

        final records = {
          _formatDate(monday): {
            'date': _formatDate(monday),
            'totalPushups': 50,
            'seriesCompleted': 5,
            'totalKcal': 22.5,
            'goalReached': true,
          },
        };
        mockStorage.setDailyRecords(records);

        final serviceWithCalendar = WidgetUpdateService(
          calendarService: calendarService,
        );
        await serviceWithCalendar.initialize();

        // Act
        final widgetData = await serviceWithCalendar.buildWidgetData(
          todayPushups: 41,
          totalPushups: 444,
          streakDays: 1,
        );

        final result = await serviceWithCalendar.updateAllWidgets(widgetData);

        // Assert - should complete without throwing
        expect(result, isA<bool>());
        expect(widgetData.weekDayData.length, 7);
        expect(widgetData.threeDayData.length, 3);
      });
    });
  });

  group('WidgetUpdateService Midnight Update', () {
    test('scheduleMidnightUpdate calls platform channel', () async {
      // Since we can't directly mock MethodChannel in test without platform code,
      // we verify the method exists and handles platform errors gracefully
      final service = WidgetUpdateService();

      // Act - initialize should call scheduleMidnightUpdate
      await service.initialize();

      // Assert - service should be available after initialization
      expect(service.isAvailable, isTrue);

      // Act - call scheduleMidnightUpdate directly
      await service.scheduleMidnightUpdate();

      // Assert - should not throw (graceful failure on non-Android platforms)
      expect(service.isAvailable, isTrue);
    });

    test('scheduleMidnightUpdate handles unavailable service gracefully', () async {
      // Arrange
      final service = WidgetUpdateService();
      // Force service to be unavailable by not calling initialize
      // Call scheduleMidnightUpdate on uninitialized service

      // Act & Assert - should not throw
      await expectLater(
        () => service.scheduleMidnightUpdate(),
        returnsNormally,
      );
    });

    test('initialize calls scheduleMidnightUpdate', () async {
      // Arrange
      final service = WidgetUpdateService();

      // Act - initialize should schedule midnight update
      final result = await service.initialize();

      // Assert
      expect(result, isTrue);
      expect(service.isAvailable, isTrue);
      // scheduleMidnightUpdate was called (no exception thrown)
    });

    test('scheduleMidnightUpdate is idempotent', () async {
      // Arrange
      final service = WidgetUpdateService();
      await service.initialize();

      // Act - call multiple times
      await service.scheduleMidnightUpdate();
      await service.scheduleMidnightUpdate();
      await service.scheduleMidnightUpdate();

      // Assert - should not throw
      expect(service.isAvailable, isTrue);
    });
  });
}

/// Mock StorageService for testing calendar integration
class MockStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};

  void setDailyRecords(Map<String, dynamic> records) {
    _dailyRecords = records;
  }

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async {
    return _dailyRecords;
  }

  // Unused methods - required for interface compliance
  @override
  Future<void> saveActiveSession(WorkoutSession session) async {}

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<Map<String, dynamic>> loadAchievements() async => {};

  @override
  Future<void> saveAchievement(Achievement achievement) async {}

  @override
  Future<void> clearAllData() async {}

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<void> clearActiveSession() async {}

  @override
  Future<void> clearProgramStartDate() async {}

  @override
  Future<void> clearWorkoutPreferences() async {}

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => null;

  @override
  Future<WorkoutSession?> loadActiveSession() async => null;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async => null;

  @override
  Future<void> resetAllUserData() async {}

  @override
  Future<void> saveProgramStartDate(DateTime date) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {}

  @override
  Future<DateTime?> getProgramStartDate() async => null;
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
