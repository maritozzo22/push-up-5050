import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/core/utils/calculator.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Fake StorageService for testing goal functionality.
class FakeStorageServiceForGoal implements StorageService {
  WorkoutSession? _activeSession;
  Map<String, dynamic>? _workoutPreferences;
  DailyRecord? _existingDailyRecord;

  void setActiveSession(WorkoutSession? session) {
    _activeSession = session;
  }

  void setExistingDailyRecord(DailyRecord? record) {
    _existingDailyRecord = record;
  }

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<void> clearActiveSession() async {
    _activeSession = null;
  }

  @override
  Future<void> clearAllData() async {}

  @override
  Future<void> clearWorkoutPreferences() async {
    _workoutPreferences = null;
  }

  @override
  Future<DailyRecord?> getDailyRecord(DateTime date) async => _existingDailyRecord;

  @override
  Future<Map<String, dynamic>> getUserStats() async => {};

  @override
  Future<Map<String, dynamic>> loadAchievements() async => {};

  @override
  Future<Map<String, dynamic>> loadDailyRecords() async => {};

  @override
  Future<WorkoutSession?> loadActiveSession() async => _activeSession;

  @override
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async =>
      _workoutPreferences;

  @override
  Future<void> saveAchievement(dynamic achievement) async {}

  @override
  Future<void> saveActiveSession(WorkoutSession session) async {
    _activeSession = session;
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {}

  @override
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {
    _workoutPreferences = {
      'startingSeries': startingSeries,
      'restTime': restTime,
    };
  }

  @override
  Future<DateTime?> getProgramStartDate() async => null;

  @override
  Future<void> saveProgramStartDate(DateTime date) async {}

  @override
  Future<void> clearProgramStartDate() async {}

  @override
  Future<void> resetAllUserData() async {
    _activeSession = null;
    _workoutPreferences = null;
  }
}

void main() {
  group('Workout with Goal Integration', () {
    late FakeStorageServiceForGoal fakeStorage;
    late ActiveWorkoutProvider provider;

    setUp(() {
      fakeStorage = FakeStorageServiceForGoal();
      provider = ActiveWorkoutProvider(storage: fakeStorage);
    });

    test('complete workout flow with goal reached', () async {
      // 1. Start workout with goal = 10 push-ups
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 10,
      );

      final session = provider.session;
      expect(session, isNotNull);
      expect(session!.goalPushups, 10);
      expect(session.goalReached, false);

      // 2. Complete series 1 (1 rep)
      provider.countRep();
      expect(session.currentSeries, 1);
      expect(session.totalReps, 1);
      expect(session.goalReached, false);

      // Advance to series 2
      session.advanceToNextSeries();
      expect(session.currentSeries, 2);
      expect(session.goalReached, false);

      // 3. Complete series 2 (2 reps) → total 3
      provider.countRep();
      provider.countRep();
      expect(session.totalReps, 3);
      session.advanceToNextSeries();
      expect(session.currentSeries, 3);
      expect(session.goalReached, false);

      // 4. Complete series 3 (3 reps) → total 6
      provider.countRep();
      provider.countRep();
      provider.countRep();
      expect(session.totalReps, 6);
      session.advanceToNextSeries();
      expect(session.currentSeries, 4);
      expect(session.goalReached, false);

      // 5. Complete series 4 (4 reps) → total 10 = GOAL REACHED!
      provider.countRep();
      provider.countRep();
      provider.countRep();
      provider.countRep();
      expect(session.totalReps, 10);
      session.advanceToNextSeries();
      expect(session.currentSeries, 5);

      // GOAL RAGGIUNTO!
      expect(session.goalReached, true);

      // 6. Verify points calculation with goal multiplier
      final points = Calculator.calculatePoints(
        seriesCompleted: 4,
        totalPushups: 10,
        consecutiveDays: 0,
        goalReached: true,
      );
      // Base: (4*10) + (10*1) + (0*50) = 40 + 10 + 0 = 50
      // Con 2x goal multiplier: 50 * 2 = 100
      expect(points, 100);

      // 7. Without goal, points would be half
      final pointsWithoutGoal = Calculator.calculatePoints(
        seriesCompleted: 4,
        totalPushups: 10,
        consecutiveDays: 0,
        goalReached: false,
      );
      expect(pointsWithoutGoal, 50);
    });

    test('goal persists across app restart', () async {
      // 1. Start workout with goal
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 5,
      );

      // Complete first series
      provider.countRep();
      provider.advanceToNextSeries();

      expect(provider.session!.goalPushups, 5);
      expect(provider.session!.currentSeries, 2);

      // 2. Save to storage
      await fakeStorage.saveActiveSession(provider.session!);

      // 3. Simula riavvio app - create new provider
      final newProvider = ActiveWorkoutProvider(storage: fakeStorage);
      await newProvider.loadExistingSession();

      // 4. Verify goal is restored
      expect(newProvider.session?.goalPushups, 5);
      expect(newProvider.session?.goalReached, false);
      expect(newProvider.session?.currentSeries, 2);
    });

    test('can continue workout after reaching goal', () async {
      // 1. Start workout with goal = 3 push-ups
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 3,
      );

      // 2. Complete series 1 (1 rep)
      provider.countRep();
      provider.advanceToNextSeries();

      // 3. Complete series 2 (2 reps → total 3, goal reached!)
      provider.countRep();
      provider.countRep();
      provider.advanceToNextSeries();

      expect(provider.session!.goalReached, true);

      // 4. Can continue to series 3
      provider.countRep();
      provider.countRep();
      provider.countRep();
      expect(provider.session!.totalReps, 6);

      // 5. Can still count reps after goal
      provider.countRep();
      expect(provider.session!.totalReps, 7);
    });

    test('goal status updates correctly during workout', () async {
      // Goal: 15 push-ups total
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 15,
      );

      final session = provider.session!;

      // Initially not reached
      expect(session.goalReached, false);

      // After series 1: 1 rep → total 1
      session.countRep();
      session.advanceToNextSeries();
      expect(session.goalReached, false);

      // After series 2: +2 reps → total 3
      for (int i = 0; i < 2; i++) session.countRep();
      session.advanceToNextSeries();
      expect(session.goalReached, false);

      // After series 3: +3 reps → total 6
      for (int i = 0; i < 3; i++) session.countRep();
      session.advanceToNextSeries();
      expect(session.goalReached, false);

      // After series 4: +4 reps → total 10
      for (int i = 0; i < 4; i++) session.countRep();
      session.advanceToNextSeries();
      expect(session.goalReached, false);

      // After series 5: +5 reps → total 15 = GOAL REACHED!
      for (int i = 0; i < 5; i++) session.countRep();
      session.advanceToNextSeries();
      expect(session.goalReached, true);
    });

    test('no goal means no goal tracking', () async {
      // Start workout WITHOUT goal
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: null,
      );

      final session = provider.session!;

      expect(session.goalPushups, null);
      expect(session.goalReached, false);

      // Complete multiple series
      for (int s = 1; s <= 10; s++) {
        for (int r = 0; r < s; r++) {
          provider.countRep();
        }
        session.advanceToNextSeries();
      }

      // Goal status should still be false (no goal set)
      expect(session.goalReached, false);
    });

    test('goal of 1 works correctly', () async {
      await provider.startWorkout(
        startingSeries: 1,
        restTime: 10,
        goalPushups: 1,
      );

      final session = provider.session!;

      // Complete first series
      provider.countRep();
      session.advanceToNextSeries();

      // Goal should be reached after just 1 series
      expect(session.goalReached, true);
      expect(session.currentSeries, 2);
    });
  });
}
