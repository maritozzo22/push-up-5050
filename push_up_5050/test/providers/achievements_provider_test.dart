import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/achievements_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Fake StorageService for testing AchievementsProvider.
class FakeStorageServiceForAchievements implements StorageService {
  Map<String, dynamic> _achievements = {};
  int _saveCount = 0;

  void setAchievementData(Map<String, dynamic> data) {
    _achievements = data;
  }

  Map<String, dynamic> get savedAchievements => _achievements;
  int get saveCount => _saveCount;
  void resetCounters() {
    _saveCount = 0;
  }

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<void> clearActiveSession() async {}

  @override
  Future<void> clearAllData() async {
    _achievements.clear();
  }

  @override
  Future<void> clearWorkoutPreferences() async {}

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => null;

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<Map<String, dynamic>> loadAchievements() async => _achievements;

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => {};

  @override
  Future<WorkoutSession?> loadActiveSession() async => null;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async => null;

  @override
  Future<void> saveAchievement(Achievement achievement) async {
    _achievements[achievement.id] = achievement.toJson();
    _saveCount++;
  }

  @override
  Future<void> saveActiveSession(WorkoutSession session) async {}

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {}

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
    _achievements.clear();
  }
}

void main() {
  group('AchievementsProvider', () {
    late FakeStorageServiceForAchievements fakeStorage;
    late AchievementsProvider provider;

    setUp(() {
      fakeStorage = FakeStorageServiceForAchievements();
      provider = AchievementsProvider(storage: fakeStorage);
    });

    test('initially loads all predefined achievements', () {
      expect(provider.achievements.length, 6); // 6 predefined achievements
      expect(provider.unlockedAchievements.length, 0); // None unlocked initially
    });

    test('loads achievement unlock status from storage', () async {
      // Setup: unlock an achievement
      final unlockedAchievement = Achievement(
        id: 'first_pushup',
        name: 'Primo Passo',
        description: 'Completa il tuo primo push-up',
        points: 50,
        icon: '🎯',
      );
      unlockedAchievement.unlock();
      fakeStorage.setAchievementData({
        'first_pushup': unlockedAchievement.toJson(),
      });

      await provider.loadAchievements();

      expect(provider.unlockedAchievements.length, 1);
      expect(provider.unlockedAchievements.first.id, 'first_pushup');
    });

    test('checkUnlocks returns newly unlocked achievements', () async {
      // Stats that should unlock 'first_pushup' achievement
      final stats = {
        'totalPushups': 5,
        'maxRepsInOneSeries': 5,
        'totalPushupsAllTime': 5,
        'currentStreak': 1,
        'maxPushupsInOneDay': 5,
        'daysCompleted': 0,
      };

      final newlyUnlocked = provider.checkUnlocks(stats);

      expect(newlyUnlocked.length, 1);
      expect(newlyUnlocked.first.id, 'first_pushup');
    });

    test('checkUnlocks returns multiple achievements when conditions met', () async {
      // Stats that should unlock multiple achievements
      final stats = {
        'totalPushups': 150,
        'maxRepsInOneSeries': 15,
        'totalPushupsAllTime': 150,
        'currentStreak': 8,
        'maxPushupsInOneDay': 150,
        'daysCompleted': 3,
      };

      final newlyUnlocked = provider.checkUnlocks(stats);

      // Should unlock: first_pushup, ten_in_a_row, centenary, perfect_week
      expect(newlyUnlocked.length, greaterThanOrEqualTo(3));
    });

    test('does not unlock already unlocked achievements', () async {
      // Manually unlock an achievement
      final first = provider.achievements.firstWhere((a) => a.id == 'first_pushup');
      first.unlock();

      final stats = {
        'totalPushups': 10,
        'maxRepsInOneSeries': 10,
        'totalPushupsAllTime': 10,
        'currentStreak': 1,
        'maxPushupsInOneDay': 10,
        'daysCompleted': 0,
      };

      final newlyUnlocked = provider.checkUnlocks(stats);

      // first_pushup should not be in newly unlocked
      expect(newlyUnlocked.any((a) => a.id == 'first_pushup'), isFalse);
    });

    test('unlockAchievement saves to storage and notifies listeners', () async {
      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.unlockAchievement('first_pushup');

      expect(fakeStorage.saveCount, 1);
      expect(notified, isTrue);

      final achievement =
          provider.achievements.firstWhere((a) => a.id == 'first_pushup');
      expect(achievement.isUnlocked, isTrue);
    });

    test('notifies listeners when achievements are loaded', () async {
      fakeStorage.setAchievementData({});

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      await provider.loadAchievements();

      expect(notified, isTrue);
    });

    test('getAllAchievements returns correct predefined list', () {
      final all = AchievementsProvider.getAllAchievements();

      expect(all.length, 6);
      expect(all.any((a) => a.id == 'first_pushup'), isTrue);
      expect(all.any((a) => a.id == 'ten_in_a_row'), isTrue);
      expect(all.any((a) => a.id == 'centenary'), isTrue);
      expect(all.any((a) => a.id == 'perfect_week'), isTrue);
      expect(all.any((a) => a.id == 'marathon'), isTrue);
      expect(all.any((a) => a.id == 'lion_month'), isTrue);
    });
  });
}
