import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/goal.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/goals_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Fake StorageService for testing GoalsProvider.
class FakeStorageServiceForGoals implements StorageService {
  int _dailyGoal = 50; // default
  int _monthlyGoal = 1500; // default

  /// Set custom goals for testing
  void setDailyGoalForTest(int goal) {
    _dailyGoal = goal;
  }

  void setMonthlyGoalForTest(int goal) {
    _monthlyGoal = goal;
  }

  @override
  int getDailyGoal() => _dailyGoal;

  @override
  int getMonthlyGoal() => _monthlyGoal;

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<void> clearActiveSession() async {}

  @override
  Future<void> clearAllData() async {}

  @override
  Future<void> clearWorkoutPreferences() async {}

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => null;

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<Map<String, dynamic>> loadAchievements() async => {};

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => {};

  @override
  Future<WorkoutSession?> loadActiveSession() async => null;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async => null;

  @override
  Future<void> saveAchievement(Achievement achievement) async {}

  @override
  Future<void> saveActiveSession(WorkoutSession session) async {}

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {}

  @override
  Future<void> setDailyGoal(int goal) async {
    _dailyGoal = goal;
  }

  @override
  Future<void> setMonthlyGoal(int goal) async {
    _monthlyGoal = goal;
  }

  @override
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
  Future<void> resetAllUserData() async {}

  @override
  bool isOnboardingCompleted() => false;

  @override
  Future<void> setOnboardingCompleted(bool completed) async {}

  @override
  Future<void> resetOnboarding() async {}
}

void main() {
  group('GoalsProvider loadGoals', () {
    late FakeStorageServiceForGoals fakeStorage;
    late GoalsProvider provider;

    setUp(() {
      fakeStorage = FakeStorageServiceForGoals();
      provider = GoalsProvider(storage: fakeStorage);
    });

    test('loadGoals_withDefaults uses default values when first launched', () async {
      // FakeStorageService defaults to daily=50, monthly=1500
      await provider.loadGoals();

      // Should have 6 goals: weekly, monthly, total, and 3 challenges
      expect(provider.goals.length, 6);

      // Weekly should be calculated as 50 * 7 = 350
      final weekly = provider.weeklyGoals.first;
      expect(weekly.target, 350);

      // Monthly should be 1500
      final monthly = provider.monthlyGoals.first;
      expect(monthly.target, 1500);
    });

    test('loadGoals_withCustomValues loads user-configured goals', () async {
      // Set custom goals in fake storage
      fakeStorage.setDailyGoalForTest(100);
      fakeStorage.setMonthlyGoalForTest(3000);

      await provider.loadGoals();

      // Weekly should be calculated as 100 * 7 = 700
      final weekly = provider.weeklyGoals.first;
      expect(weekly.target, 700);

      // Monthly should be 3000
      final monthly = provider.monthlyGoals.first;
      expect(monthly.target, 3000);
    });

    test('weeklyGoal_autoCalculates as daily * 7', () async {
      // Set daily goal to 75
      fakeStorage.setDailyGoalForTest(75);

      await provider.loadGoals();

      // Weekly should be 75 * 7 = 525
      final weekly = provider.weeklyGoal;
      expect(weekly.target, 525);
    });

    test('dailyGoal calculates correctly from weekly goal', () async {
      // Set daily goal to 100
      fakeStorage.setDailyGoalForTest(100);

      await provider.loadGoals();

      // dailyGoal should have target of 100
      final daily = provider.dailyGoal;
      expect(daily.target, 100);
      expect(daily.title, 'GIORNALIERA');
      expect(daily.description, contains('100'));
    });

    test('challengeGoals_unchanged from predefined values', () async {
      // Set custom goals
      fakeStorage.setDailyGoalForTest(75);
      fakeStorage.setMonthlyGoalForTest(2250);

      await provider.loadGoals();

      final challenges = provider.challengeGoals;

      // Centurion: 100 pushups in one session
      final centurion = challenges.firstWhere((g) => g.id == 'challenge_100');
      expect(centurion.target, 100);

      // Perfect Week: 7 consecutive days
      final perfectWeek = challenges.firstWhere((g) => g.id == 'challenge_7days');
      expect(perfectWeek.target, 7);

      // Program Complete: 30 days
      final programComplete =
          challenges.firstWhere((g) => g.id == 'challenge_30days');
      expect(programComplete.target, 30);
    });

    test('totalGoal_unchanged at 5050', () async {
      // Set custom goals
      fakeStorage.setDailyGoalForTest(100);
      fakeStorage.setMonthlyGoalForTest(3000);

      await provider.loadGoals();

      final total = provider.totalGoals.first;
      expect(total.target, 5050);
      expect(total.id, 'total_5050');
    });

    test('loadGoals sets isLoading to false after loading', () async {
      expect(provider.isLoading, false); // Initially false

      await provider.loadGoals();

      expect(provider.isLoading, false);
    });

    test('weeklyGoal getter returns first weekly goal with progress', () async {
      fakeStorage.setDailyGoalForTest(60);

      await provider.loadGoals();

      // Add some progress
      await provider.updateProgress(
        weeklyPushups: 180,
        monthlyPushups: 600,
        totalPushups: 1000,
        maxSessionReps: 50,
        consecutiveDays: 3,
        completedDays: 3,
      );

      final weekly = provider.weeklyGoal;
      expect(weekly.target, 420); // 60 * 7
      expect(weekly.current, 180);
      expect(weekly.id, 'weekly_custom');
    });

    test('monthlyGoal getter returns first monthly goal with progress', () async {
      fakeStorage.setMonthlyGoalForTest(2000);

      await provider.loadGoals();

      // Add some progress
      await provider.updateProgress(
        weeklyPushups: 300,
        monthlyPushups: 800,
        totalPushups: 2000,
        maxSessionReps: 50,
        consecutiveDays: 5,
        completedDays: 5,
      );

      final monthly = provider.monthlyGoal;
      expect(monthly.target, 2000);
      expect(monthly.current, 800);
      expect(monthly.id, 'monthly_custom');
    });

    test('all goal types are present after loading', () async {
      await provider.loadGoals();

      // Should have exactly 6 goals
      expect(provider.goals.length, 6);

      // Check for each type
      expect(provider.weeklyGoals.length, 1);
      expect(provider.monthlyGoals.length, 1);
      expect(provider.challengeGoals.length, 3);
      expect(provider.totalGoals.length, 1);
    });
  });
}
