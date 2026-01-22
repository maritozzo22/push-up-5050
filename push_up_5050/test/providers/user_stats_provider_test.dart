import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/user_stats_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';

/// Fake StorageService for testing.
class FakeStorageService implements StorageService {
  Map<String, dynamic> _dailyRecords = {};
  DailyRecord? _todayRecord;
  int _streak = 0;

  void setTodayRecord(DailyRecord? record) {
    _todayRecord = record;
  }

  void setDailyRecords(Map<String, dynamic> records) {
    _dailyRecords = records;
  }

  void setStreak(int streak) {
    _streak = streak;
  }

  @override
  Future<void> clearActiveSession() async {
    // Not implemented for fake
  }

  @override
  Future<void> clearAllData() async {
    _dailyRecords.clear();
    _todayRecord = null;
    _streak = 0;
  }

  @override
  Future<void> clearWorkoutPreferences() async {
    // Not implemented for fake
  }

  @override
  Future<int> calculateCurrentStreak() async {
    return _streak;
  }

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async {
    return _todayRecord;
  }

  @override
  Future<Map<String, dynamic>> getUserStats() async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> loadAchievements() async {
    return {};
  }

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async {
    return _dailyRecords;
  }

  @override
  Future<WorkoutSession?> loadActiveSession() async {
    return null;
  }

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async {
    return null;
  }

  @override
  Future<void> saveAchievement(Achievement achievement) async {
    // Not implemented for fake
  }

  @override
  Future<void> saveActiveSession(WorkoutSession session) async {
    // Not implemented for fake
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    // Not implemented for fake
  }

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {
    // Not implemented for fake
  }

  DateTime? _programStartDate;

  @override
  Future<DateTime?> getProgramStartDate() async => _programStartDate;

  @override
  Future<void> saveProgramStartDate(DateTime date) async {
    _programStartDate = date;
  }

  @override
  Future<void> clearProgramStartDate() async {
    _programStartDate = null;
  }

  @override
  Future<void> resetAllUserData() async {
    _dailyRecords.clear();
    _todayRecord = null;
    _streak = 0;
    _programStartDate = null;
  }
}

void main() {
  group('UserStatsProvider', () {
    late FakeStorageService fakeStorage;
    late UserStatsProvider provider;
    late WidgetUpdateService widgetUpdateService;

    setUp(() {
      fakeStorage = FakeStorageService();
      widgetUpdateService = WidgetUpdateService();
      provider = UserStatsProvider(
        storage: fakeStorage,
        widgetUpdateService: widgetUpdateService,
      );
    });

    test('initially has loading state true', () {
      expect(provider.isLoading, isTrue);
    });

    test('initially has zero values', () {
      expect(provider.todayPushups, 0);
      expect(provider.currentStreak, 0);
      expect(provider.totalPushupsAllTime, 0);
      expect(provider.daysCompleted, 0);
    });

    test('loads stats from storage successfully', () async {
      // Setup fake data
      final today = DateTime.now();
      final yesterday = today.subtract(const Duration(days: 1));
      final recordToday = DailyRecord(
        date: today,
        totalPushups: 25,
        seriesCompleted: 3,
      );
      final recordYesterday = DailyRecord(
        date: yesterday,
        totalPushups: 55,
        seriesCompleted: 5,
      );

      fakeStorage.setTodayRecord(recordToday);
      fakeStorage.setDailyRecords({
        '2025-01-13': recordYesterday.toJson(),
        '2025-01-14': recordToday.toJson(),
      });
      fakeStorage.setStreak(5);

      // Load stats
      await provider.loadStats();

      // Verify
      expect(provider.isLoading, isFalse);
      expect(provider.todayPushups, 25);
      expect(provider.totalPushupsAllTime, 80); // 25 + 55
      expect(provider.currentStreak, 5);
    });

    test('handles empty storage (first launch)', () async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      await provider.loadStats();

      expect(provider.isLoading, isFalse);
      expect(provider.todayPushups, 0);
      expect(provider.currentStreak, 0);
      expect(provider.totalPushupsAllTime, 0);
      expect(provider.daysCompleted, 0);
    });

    test('notifies listeners when data changes', () async {
      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords({});
      fakeStorage.setStreak(0);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.loadStats();

      expect(notified, isTrue);
    });

    test('refreshStats reloads data from storage', () async {
      final today = DateTime.now();
      final record = DailyRecord(
        date: today,
        totalPushups: 30,
        seriesCompleted: 4,
      );

      fakeStorage.setTodayRecord(record);
      fakeStorage.setDailyRecords({'2025-01-14': record.toJson()});
      fakeStorage.setStreak(3);

      await provider.loadStats();
      expect(provider.todayPushups, 30);

      // Update fake data for refresh
      final updatedRecord = DailyRecord(
        date: today,
        totalPushups: 50,
        seriesCompleted: 6,
      );
      fakeStorage.setTodayRecord(updatedRecord);
      fakeStorage.setDailyRecords({'2025-01-14': updatedRecord.toJson()});

      await provider.refreshStats();

      expect(provider.todayPushups, 50);
      expect(provider.currentStreak, 3);
    });

    test('calculates total pushups from all records', () async {
      final records = <String, dynamic>{};
      for (int i = 1; i <= 10; i++) {
        final date = DateTime(2025, 1, i);
        final record = DailyRecord(
          date: date,
          totalPushups: 50,
          seriesCompleted: 5,
        );
        records['2025-01-${i.toString().padLeft(2, '0')}'] = record.toJson();
      }

      fakeStorage.setTodayRecord(null);
      fakeStorage.setDailyRecords(records);
      fakeStorage.setStreak(10);

      await provider.loadStats();

      expect(provider.totalPushupsAllTime, 500); // 10 days * 50 pushups
      expect(provider.daysCompleted, 10);
    });

    test('counts only completed days for daysCompleted', () async {
      final today = DateTime.now();
      final completedRecord = DailyRecord(
        date: today,
        totalPushups: 50,
        seriesCompleted: 5,
      );
      final incompleteRecord = DailyRecord(
        date: today.subtract(const Duration(days: 1)),
        totalPushups: 30,
        seriesCompleted: 3,
      );

      fakeStorage.setTodayRecord(completedRecord);
      fakeStorage.setDailyRecords({
        '2025-01-14': completedRecord.toJson(),
        '2025-01-13': incompleteRecord.toJson(),
      });
      fakeStorage.setStreak(1);

      await provider.loadStats();

      expect(provider.daysCompleted, 1); // Only completedRecord has goalReached
    });
  });
}
