import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/providers/active_workout_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Fake StorageService for testing ActiveWorkoutProvider.
class FakeStorageServiceForWorkout implements StorageService {
  WorkoutSession? _activeSession;
  int _clearSessionCount = 0;
  int _saveSessionCount = 0;
  Map<String, dynamic>? _workoutPreferences;
  DailyRecord? _savedDailyRecord;
  DailyRecord? _existingDailyRecord; // Record to return from getDailyRecord
  final List<DailyRecord> _savedDailyRecords = [];

  void setActiveSession(WorkoutSession? session) {
    _activeSession = session;
  }

  void setExistingDailyRecord(DailyRecord? record) {
    _existingDailyRecord = record;
  }

  WorkoutSession? getActiveSessionSaved() => _activeSession;
  int get clearSessionCount => _clearSessionCount;
  int get saveSessionCount => _saveSessionCount;
  DailyRecord? get savedDailyRecord => _savedDailyRecord;
  List<DailyRecord> get savedDailyRecords => List.unmodifiable(_savedDailyRecords);
  void resetCounters() {
    _clearSessionCount = 0;
    _saveSessionCount = 0;
    _savedDailyRecords.clear();
  }

  @override
  Future<int> calculateCurrentStreak() async => 0;

  @override
  Future<void> clearActiveSession() async {
    _activeSession = null;
    _clearSessionCount++;
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
  Future<void> saveAchievement(Achievement achievement) async {}

  @override
  Future<void> saveActiveSession(WorkoutSession session) async {
    _activeSession = session;
    _saveSessionCount++;
  }

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    _savedDailyRecord = record;
    _savedDailyRecords.add(record);
  }

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
    _activeSession = null;
    _workoutPreferences = null;
    _programStartDate = null;
  }
}

void main() {
  group('ActiveWorkoutProvider', () {
    late FakeStorageServiceForWorkout fakeStorage;
    late ActiveWorkoutProvider provider;

    setUp(() {
      fakeStorage = FakeStorageServiceForWorkout();
      provider = ActiveWorkoutProvider(storage: fakeStorage);
    });

    test('initially has no active session', () {
      expect(provider.session, isNull);
      expect(provider.isRecovery, isFalse);
      expect(provider.recoverySecondsRemaining, 0);
    });

    test('starts new workout with correct parameters', () async {
      await provider.startWorkout(startingSeries: 5, restTime: 15);

      expect(provider.session, isNotNull);
      expect(provider.session?.startingSeries, 5);
      expect(provider.session?.restTime, 15);
      expect(provider.session?.currentSeries, 5);
      expect(provider.session?.repsInCurrentSeries, 0);
      expect(provider.session?.totalReps, 0);
      expect(provider.session?.isActive, isTrue);
      expect(fakeStorage.saveSessionCount, 1);
    });

    test('loads existing session from storage', () async {
      final existingSession = WorkoutSession(
        startingSeries: 2,
        restTime: 10,
        currentSeries: 4,
        repsInCurrentSeries: 3,
        totalReps: 9,
      );
      fakeStorage.setActiveSession(existingSession);

      await provider.loadExistingSession();

      expect(provider.session, isNotNull);
      expect(provider.session?.currentSeries, 4);
      expect(provider.session?.totalReps, 9);
      expect(provider.session?.isActive, isTrue);
    });

    test('countRep increments reps when not paused', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);
      fakeStorage.resetCounters();

      provider.countRep();

      expect(provider.session?.repsInCurrentSeries, 1);
      expect(provider.session?.totalReps, 1);
      expect(fakeStorage.saveSessionCount, 1); // Auto-save after count
    });

    test('startRecovery sets recovery state and timer', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);
      fakeStorage.resetCounters();

      provider.startRecovery();

      expect(provider.isRecovery, isTrue);
      expect(provider.recoverySecondsRemaining, 10);
      expect(fakeStorage.saveSessionCount, 1); // Save on state change
    });

    test('endWorkout clears session and saves to storage', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);
      fakeStorage.resetCounters();

      await provider.endWorkout();

      expect(provider.session, isNull); // Session completely cleared
      expect(fakeStorage.clearSessionCount, 1);
    });

    test('advanceToNextSeries moves to next series when current is complete', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);
      fakeStorage.resetCounters();

      // Complete first series
      for (int i = 0; i < 1; i++) {
        provider.countRep();
      }

      provider.advanceToNextSeries();

      expect(provider.session?.currentSeries, 2);
      expect(provider.session?.repsInCurrentSeries, 0);
      expect(fakeStorage.saveSessionCount, greaterThanOrEqualTo(1));
    });

    test('does not advance if current series is not complete', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);
      fakeStorage.resetCounters();

      provider.advanceToNextSeries();

      expect(provider.session?.currentSeries, 1); // Still on series 1
    });

    test('notifies listeners on state changes', () async {
      await provider.startWorkout(startingSeries: 1, restTime: 10);

      bool notified = false;
      provider.addListener(() {
        notified = true;
      });

      fakeStorage.resetCounters();
      provider.countRep();

      expect(notified, isTrue);
    });

    group('endWorkout - DailyRecord creation', () {
      test('creates and saves DailyRecord when ending workout', () async {
        await provider.startWorkout(startingSeries: 1, restTime: 10);

        // Complete 3 series: 1 + 2 + 3 = 6 push-ups
        provider.countRep();
        provider.advanceToNextSeries();
        provider.countRep();
        provider.countRep();
        provider.advanceToNextSeries();
        provider.countRep();
        provider.countRep();
        provider.countRep();

        expect(provider.session?.totalReps, 6);
        expect(provider.session?.currentSeries, 3); // Still on series 3, haven't advanced yet

        await provider.endWorkout();

        // Verify DailyRecord was created and saved
        expect(fakeStorage.savedDailyRecord, isNotNull);
        expect(fakeStorage.savedDailyRecord!.totalPushups, 6);
        expect(fakeStorage.savedDailyRecord!.seriesCompleted, 3);
      });

      test('creates new DailyRecord when none exists for today', () async {
        await provider.startWorkout(startingSeries: 5, restTime: 15);

        // Complete series 5: 5 push-ups
        for (int i = 0; i < 5; i++) {
          provider.countRep();
        }

        await provider.endWorkout();

        expect(fakeStorage.savedDailyRecord, isNotNull);
        expect(fakeStorage.savedDailyRecord!.totalPushups, 5);
        expect(fakeStorage.savedDailyRecord!.seriesCompleted, 1);
      });

      test('merges with existing DailyRecord for today', () async {
        // Set existing record: already did 20 push-ups in 2 series
        final existingRecord = DailyRecord(
          date: DateTime.now(),
          totalPushups: 20,
          seriesCompleted: 2,
        );
        fakeStorage.setExistingDailyRecord(existingRecord);

        await provider.startWorkout(startingSeries: 1, restTime: 10);

        // Do 3 more push-ups (completes series 1 and series 2: 1 + 2 = 3)
        provider.countRep();
        provider.countRep();
        provider.countRep();

        await provider.endWorkout();

        // Verify merged record
        expect(fakeStorage.savedDailyRecord, isNotNull);
        expect(fakeStorage.savedDailyRecord!.totalPushups, 23); // 20 + 3
        expect(fakeStorage.savedDailyRecord!.seriesCompleted, 4); // 2 + 2 (both series 1 and 2 complete)
      });

      test('correctly calculates seriesCompleted from startingSeries', () async {
        await provider.startWorkout(startingSeries: 2, restTime: 10);

        // Complete series 2 and 3: 2 + 3 = 5 push-ups
        for (int i = 0; i < 2; i++) provider.countRep();
        provider.advanceToNextSeries();
        for (int i = 0; i < 3; i++) provider.countRep();

        expect(provider.session?.currentSeries, 3); // Still on series 3, haven't advanced yet

        await provider.endWorkout();

        // 5 reps starting from series 2 = series 2 + 3 = 2 series completed
        expect(fakeStorage.savedDailyRecord!.seriesCompleted, 2);
      });
    });
  });
}
