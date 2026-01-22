import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/services/widget_calendar_service.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Test double for StorageService
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
  Future<void> saveWorkoutPreferences({required int startingSeries, required int restTime}) async {}

  @override
  Future<DateTime?> getProgramStartDate() async => null;
}

void main() {
  late MockStorageService mockStorage;
  late WidgetCalendarService calendarService;

  setUp(() {
    mockStorage = MockStorageService();
    calendarService = WidgetCalendarService(storage: mockStorage);
  });

  group('WidgetCalendarService - WeekDayData Model', () {
    test('WeekDayData should have all required fields', () {
      // Arrange & Act
      final dayData = WeekDayData(
        day: 15,
        dayLabel: 'L',
        status: CalendarDayStatus.completed,
        pushups: 50,
        isPartOfStreak: true,
      );

      // Assert
      expect(dayData.day, 15);
      expect(dayData.dayLabel, 'L');
      expect(dayData.status, CalendarDayStatus.completed);
      expect(dayData.pushups, 50);
      expect(dayData.isPartOfStreak, true);
    });

    test('WeekDayData should serialize to JSON correctly', () {
      // Arrange
      final dayData = WeekDayData(
        day: 15,
        dayLabel: 'L',
        status: CalendarDayStatus.completed,
        pushups: 50,
        isPartOfStreak: true,
      );

      // Act
      final json = dayData.toJson();

      // Assert
      expect(json['day'], 15);
      expect(json['dayLabel'], 'L');
      expect(json['status'], 'completed');
      expect(json['pushups'], 50);
      expect(json['isPartOfStreak'], true);
    });

    test('WeekDayData should deserialize from JSON correctly', () {
      // Arrange
      final json = {
        'day': 20,
        'dayLabel': 'M',
        'status': 'missed',
        'pushups': 0,
        'isPartOfStreak': false,
      };

      // Act
      final dayData = WeekDayData.fromJson(json);

      // Assert
      expect(dayData.day, 20);
      expect(dayData.dayLabel, 'M');
      expect(dayData.status, CalendarDayStatus.missed);
      expect(dayData.pushups, 0);
      expect(dayData.isPartOfStreak, false);
    });

    test('WeekDayData copyWith should work correctly', () {
      // Arrange
      final original = WeekDayData(
        day: 15,
        dayLabel: 'L',
        status: CalendarDayStatus.completed,
        pushups: 50,
        isPartOfStreak: true,
      );

      // Act
      final copy = original.copyWith(status: CalendarDayStatus.missed);

      // Assert
      expect(copy.day, original.day);
      expect(copy.dayLabel, original.dayLabel);
      expect(copy.status, CalendarDayStatus.missed);
      expect(copy.pushups, original.pushups);
      expect(copy.isPartOfStreak, original.isPartOfStreak);
    });
  });

  group('WidgetCalendarService - WeekData Model', () {
    test('WeekData should contain 7 days', () {
      // Arrange & Act
      final weekData = WeekData(
        days: List.generate(
          7,
          (i) => WeekDayData(
            day: i + 1,
            dayLabel: 'L',
            status: CalendarDayStatus.pending,
            pushups: 0,
            isPartOfStreak: false,
          ),
        ),
        hasStreakLine: false,
      );

      // Assert
      expect(weekData.days.length, 7);
      expect(weekData.hasStreakLine, false);
    });

    test('WeekData should serialize to JSON correctly', () {
      // Arrange
      final weekData = WeekData(
        days: [
          WeekDayData(
            day: 15,
            dayLabel: 'L',
            status: CalendarDayStatus.completed,
            pushups: 50,
            isPartOfStreak: true,
          ),
        ],
        hasStreakLine: true,
      );

      // Act
      final json = weekData.toJson();

      // Assert
      expect(json['days'], isList);
      expect(json['days'].length, 1);
      expect(json['hasStreakLine'], true);
    });

    test('WeekData should deserialize from JSON correctly', () {
      // Arrange
      final json = {
        'days': [
          {
            'day': 15,
            'dayLabel': 'L',
            'status': 'completed',
            'pushups': 50,
            'isPartOfStreak': true,
          }
        ],
        'hasStreakLine': true,
      };

      // Act
      final weekData = WeekData.fromJson(json);

      // Assert
      expect(weekData.days.length, 1);
      expect(weekData.days[0].day, 15);
      expect(weekData.hasStreakLine, true);
    });
  });

  group('WidgetCalendarService - CalendarDayStatus Enum', () {
    test('CalendarDayStatus should have all required values', () {
      // Assert
      expect(CalendarDayStatus.values.length, 4);
      expect(CalendarDayStatus.values, contains(CalendarDayStatus.completed));
      expect(CalendarDayStatus.values, contains(CalendarDayStatus.missed));
      expect(CalendarDayStatus.values, contains(CalendarDayStatus.pending));
      expect(CalendarDayStatus.values, contains(CalendarDayStatus.today));
    });

    test('CalendarDayStatus should serialize to string correctly', () {
      // Arrange & Act
      expect(CalendarDayStatus.completed.name, 'completed');
      expect(CalendarDayStatus.missed.name, 'missed');
      expect(CalendarDayStatus.pending.name, 'pending');
      expect(CalendarDayStatus.today.name, 'today');
    });
  });

  group('WidgetCalendarService - getWeekData', () {
    test('getWeekData_returns7Days Monday through Sunday', () async {
      // Arrange
      mockStorage.setDailyRecords({});

      // Act
      final weekData = await calendarService.getWeekData();

      // Assert
      expect(weekData.days.length, 7);
    });

    test('getWeekData_completedDaysHaveOrangeStatus', () async {
      // Arrange - Create records for Monday and Tuesday
      final now = DateTime(2026, 1, 22); // Wednesday
      final monday = DateTime(2026, 1, 19);
      final tuesday = DateTime(2026, 1, 20);

      final records = {
        _formatDate(monday): {'date': _formatDate(monday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
        _formatDate(tuesday): {'date': _formatDate(tuesday), 'totalPushups': 30, 'seriesCompleted': 3, 'totalKcal': 13.5, 'goalReached': false},
      };

      mockStorage.setDailyRecords(records);

      // Act
      final weekData = await calendarService.getWeekData(testDate: now);

      // Assert
      final mondayData = weekData.days[0]; // Monday
      final tuesdayData = weekData.days[1]; // Tuesday
      expect(mondayData.status, CalendarDayStatus.completed);
      expect(tuesdayData.status, CalendarDayStatus.completed);
      expect(mondayData.pushups, 50);
      expect(tuesdayData.pushups, 30);
    });

    test('getWeekData_missedDaysHaveRedStatus', () async {
      // Arrange - Wednesday is current day, has no record but it's after Monday's workout
      final now = DateTime(2026, 1, 21); // Wednesday
      final monday = DateTime(2026, 1, 19);
      // No record for Tuesday

      final records = {
        _formatDate(monday): {'date': _formatDate(monday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
      };

      mockStorage.setDailyRecords(records);

      // Act
      final weekData = await calendarService.getWeekData(testDate: now);

      // Assert
      final tuesdayData = weekData.days[1]; // Tuesday - should be missed
      expect(tuesdayData.status, CalendarDayStatus.missed);
    });

    test('getWeekData_streakLineDetectedForConsecutiveDays', () async {
      // Arrange - Monday and Tuesday both completed
      final now = DateTime(2026, 1, 21); // Wednesday
      final monday = DateTime(2026, 1, 19);
      final tuesday = DateTime(2026, 1, 20);

      final records = {
        _formatDate(monday): {'date': _formatDate(monday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
        _formatDate(tuesday): {'date': _formatDate(tuesday), 'totalPushups': 40, 'seriesCompleted': 4, 'totalKcal': 18.0, 'goalReached': false},
      };

      mockStorage.setDailyRecords(records);

      // Act
      final weekData = await calendarService.getWeekData(testDate: now);

      // Assert
      expect(weekData.hasStreakLine, true);
      // Monday is start of streak, not part of streak line from previous
      expect(weekData.days[0].isPartOfStreak, false);
      // Tuesday is part of streak
      expect(weekData.days[1].isPartOfStreak, true);
    });
  });

  group('WidgetCalendarService - getThreeDayData', () {
    test('getThreeDayData_yesterdayTodayTomorrow', () async {
      // Arrange
      final now = DateTime(2026, 1, 21); // Wednesday
      final yesterday = DateTime(2026, 1, 20);
      final records = {
        _formatDate(yesterday): {'date': _formatDate(yesterday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
      };

      mockStorage.setDailyRecords(records);

      // Act
      final threeDayData = await calendarService.getThreeDayData(testDate: now);

      // Assert
      expect(threeDayData.length, 3);
      expect(threeDayData[0].day, 20); // Yesterday
      expect(threeDayData[1].day, 21); // Today
      expect(threeDayData[2].day, 22); // Tomorrow
    });

    test('getThreeDayData_dynamicLabelsForYesterdayTodayTomorrow', () async {
      // Arrange
      final now = DateTime(2026, 1, 21); // Wednesday
      final records = <String, dynamic>{};

      mockStorage.setDailyRecords(records);

      // Act
      final threeDayData = await calendarService.getThreeDayData(testDate: now);

      // Assert
      expect(threeDayData[0].dayLabel, 'I'); // Ieri
      expect(threeDayData[1].dayLabel, 'O'); // Oggi
      expect(threeDayData[2].dayLabel, 'D'); // Domani
    });
  });

  group('WidgetCalendarService - getCurrentWeekMonday', () {
    test('getCurrentWeekMonday_returnsCorrectMonday', () {
      // Arrange - Wednesday Jan 21, 2026
      final wednesday = DateTime(2026, 1, 21);

      // Act
      final monday = calendarService.getCurrentWeekMonday(wednesday);

      // Assert
      expect(monday.year, 2026);
      expect(monday.month, 1);
      expect(monday.day, 19); // Monday is Jan 19
    });

    test('getCurrentWeekMonday_handlesYearBoundary', () {
      // Arrange - Jan 1, 2026 is Thursday
      final newYear = DateTime(2026, 1, 1);

      // Act
      final monday = calendarService.getCurrentWeekMonday(newYear);

      // Assert
      expect(monday.year, 2025); // Week started in previous year
      expect(monday.month, 12);
      expect(monday.day, 29); // Monday Dec 29, 2025
    });
  });

  group('WidgetCalendarService - isDayMissed', () {
    test('isDayMissed_returnsTrueForPastDaysWithoutRecord', () async {
      // Arrange - Current day is Wednesday, first workout was Monday
      final now = DateTime(2026, 1, 21); // Wednesday
      final monday = DateTime(2026, 1, 19);
      final tuesday = DateTime(2026, 1, 20);

      final records = {
        _formatDate(monday): {'date': _formatDate(monday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
        // No record for Tuesday
      };

      mockStorage.setDailyRecords(records);

      // Act
      final isMissed = await calendarService.isDayMissed(tuesday, now);

      // Assert
      expect(isMissed, true);
    });

    test('isDayMissed_returnsFalseForDaysBeforeFirstWorkout', () async {
      // Arrange - Current day is Wednesday, first workout was Monday
      final now = DateTime(2026, 1, 21); // Wednesday
      final monday = DateTime(2026, 1, 19);
      final sunday = DateTime(2026, 1, 18); // Before first workout

      final records = {
        _formatDate(monday): {'date': _formatDate(monday), 'totalPushups': 50, 'seriesCompleted': 5, 'totalKcal': 22.5, 'goalReached': true},
      };

      mockStorage.setDailyRecords(records);

      // Act
      final isMissed = await calendarService.isDayMissed(sunday, now);

      // Assert
      expect(isMissed, false);
    });
  });

  group('WidgetCalendarService - Italian Day Labels', () {
    test('uses correct Italian day labels for week data', () async {
      // Arrange
      final now = DateTime(2026, 1, 22); // Thursday
      mockStorage.setDailyRecords({});

      // Act
      final weekData = await calendarService.getWeekData(testDate: now);

      // Assert - Italian labels: L, M, M, G, V, S, D
      expect(weekData.days[0].dayLabel, 'L'); // Lunedi
      expect(weekData.days[1].dayLabel, 'M'); // Martedi
      expect(weekData.days[2].dayLabel, 'M'); // Mercoledi
      expect(weekData.days[3].dayLabel, 'G'); // Giovedi
      expect(weekData.days[4].dayLabel, 'V'); // Venerdi
      expect(weekData.days[5].dayLabel, 'S'); // Sabato
      expect(weekData.days[6].dayLabel, 'D'); // Domenica
    });
  });
}

String _formatDate(DateTime date) {
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
