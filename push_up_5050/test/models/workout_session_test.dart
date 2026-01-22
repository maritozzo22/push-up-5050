import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/workout_session.dart';

void main() {
  group('WorkoutSession', () {
    test('should create session with default values', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
      );

      expect(session.startingSeries, 1);
      expect(session.currentSeries, 1);
      expect(session.repsInCurrentSeries, 0);
      expect(session.totalReps, 0);
      expect(session.restTime, 30);
      expect(session.isActive, true);
      expect(session.startTime, isNotNull);
      expect(session.totalKcal, 0.0);
    });

    test('should create session with custom values', () {
      final startTime = DateTime(2025, 1, 14, 10, 0);
      final session = WorkoutSession(
        startingSeries: 5,
        restTime: 60,
        currentSeries: 7,
        repsInCurrentSeries: 3,
        totalReps: 25,
        startTime: startTime,
      );

      expect(session.startingSeries, 5);
      expect(session.currentSeries, 7);
      expect(session.repsInCurrentSeries, 3);
      expect(session.totalReps, 25);
      expect(session.restTime, 60);
      expect(session.totalKcal, 25 * 0.45);
      expect(session.startTime, startTime);
    });

    test('should calculate totalKcal correctly', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        totalReps: 100,
      );

      expect(session.totalKcal, 45.0); // 100 * 0.45
    });

    test('should detect when series is complete', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 5,
      );

      expect(session.isSeriesComplete(), true);
    });

    test('should detect when series is not complete', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 3,
      );

      expect(session.isSeriesComplete(), false);
    });

    test('should count rep', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 3,
        totalReps: 10,
      );

      session.countRep();

      expect(session.repsInCurrentSeries, 4);
      expect(session.totalReps, 11);
    });

    test('should calculate remaining reps correctly', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 3,
      );

      expect(session.remainingReps, 2);
    });

    test('should return 0 remaining reps when series complete', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 5,
      );

      expect(session.remainingReps, 0);
    });

    test('should advance to next series when current is complete', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 5,
      );

      session.advanceToNextSeries();

      expect(session.currentSeries, 6);
      expect(session.repsInCurrentSeries, 0);
    });

    test('should not advance when series is not complete', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 3,
      );

      session.advanceToNextSeries();

      expect(session.currentSeries, 5);
      expect(session.repsInCurrentSeries, 3);
    });

    test('should end session', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
      );

      expect(session.isActive, true);

      session.endSession();
      expect(session.isActive, false);
    });

    test('should serialize to JSON correctly', () {
      final startTime = DateTime(2025, 1, 14, 10, 0);
      final session = WorkoutSession(
        startingSeries: 5,
        restTime: 60,
        currentSeries: 7,
        repsInCurrentSeries: 3,
        totalReps: 25,
        isActive: true,
        startTime: startTime,
      );

      final json = session.toJson();

      expect(json['startingSeries'], 5);
      expect(json['restTime'], 60);
      expect(json['currentSeries'], 7);
      expect(json['repsInCurrentSeries'], 3);
      expect(json['totalReps'], 25);
      expect(json['isActive'], true);
      expect(json['startTime'], startTime.toIso8601String());
    });

    test('should deserialize from JSON correctly', () {
      final startTime = DateTime(2025, 1, 14, 10, 0);
      final json = {
        'startingSeries': 5,
        'restTime': 60,
        'currentSeries': 7,
        'repsInCurrentSeries': 3,
        'totalReps': 25,
        'isActive': true,
        'startTime': startTime.toIso8601String(),
      };

      final session = WorkoutSession.fromJson(json);

      expect(session.startingSeries, 5);
      expect(session.restTime, 60);
      expect(session.currentSeries, 7);
      expect(session.repsInCurrentSeries, 3);
      expect(session.totalReps, 25);
      expect(session.isActive, true);
      expect(session.startTime, startTime);
    });

    test('should create copy with updated values', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        currentSeries: 5,
        repsInCurrentSeries: 3,
      );

      final updated = session.copyWith(
        currentSeries: 6,
        repsInCurrentSeries: 0,
      );

      expect(updated.startingSeries, 1);
      expect(updated.currentSeries, 6);
      expect(updated.repsInCurrentSeries, 0);
      expect(updated.restTime, 30);
    });

    test('should handle series progression correctly', () {
      // Start from series 1
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
      );

      // Complete series 1
      for (int i = 0; i < 1; i++) {
        session.countRep();
      }
      expect(session.isSeriesComplete(), true);

      session.advanceToNextSeries();
      expect(session.currentSeries, 2);
      expect(session.repsInCurrentSeries, 0);

      // Complete series 2
      for (int i = 0; i < 2; i++) {
        session.countRep();
      }
      expect(session.isSeriesComplete(), true);
    });

    test('should start from different starting series', () {
      final session = WorkoutSession(
        startingSeries: 10,
        restTime: 30,
      );

      expect(session.currentSeries, 10);
      expect(session.repsInCurrentSeries, 0);
      expect(session.totalReps, 0);

      // Complete series 10
      for (int i = 0; i < 10; i++) {
        session.countRep();
      }
      expect(session.isSeriesComplete(), true);

      session.advanceToNextSeries();
      expect(session.currentSeries, 11);
    });
  });

  group('WorkoutSession - Goal Feature', () {
    test('should create with goal pushups', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 50,
      );

      expect(session.goalPushups, 50);
      expect(session.goalReached, false);
    });

    test('should have no goal by default', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
      );

      expect(session.goalPushups, null);
      expect(session.goalReached, false);
    });

    test('should detect when goal is reached by total reps', () {
      // Goal: 10 push-ups total
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 10,
      );

      expect(session.goalReached, false);

      // Complete series 1-4: 1+2+3+4 = 10 push-ups
      for (int s = 1; s <= 4; s++) {
        for (int r = 0; r < s; r++) {
          session.countRep();
        }
        session.advanceToNextSeries();
      }

      expect(session.totalReps, 10);
      expect(session.goalReached, true);
    });

    test('should not mark goal as reached before total reps target', () {
      // Goal: 20 push-ups total
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 20,
      );

      // Complete series 1-4: 1+2+3+4 = 10 push-ups (not enough)
      for (int s = 1; s <= 4; s++) {
        for (int r = 0; r < s; r++) {
          session.countRep();
        }
        session.advanceToNextSeries();
      }

      expect(session.totalReps, 10);
      expect(session.goalReached, false);
    });

    test('should mark goal as reached during any series when total reps hit',
        () {
      // Goal: 6 push-ups (will be reached during series 3)
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 6,
      );

      // Complete series 1: 1 push-up
      session.countRep();
      session.advanceToNextSeries();
      expect(session.totalReps, 1);
      expect(session.goalReached, false);

      // Complete series 2: 2 push-ups → total 3
      session.countRep();
      session.countRep();
      session.advanceToNextSeries();
      expect(session.totalReps, 3);
      expect(session.goalReached, false);

      // Complete series 3: 3 push-ups → total 6 (goal reached!)
      for (int i = 0; i < 3; i++) {
        session.countRep();
      }
      session.advanceToNextSeries();
      expect(session.totalReps, 6);
      expect(session.goalReached, true);
    });

    test('should serialize goal to JSON', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 10,
      );
      session.goalReached = true;

      final json = session.toJson();

      expect(json['goalPushups'], 10);
      expect(json['goalReached'], true);
    });

    test('should deserialize goal from JSON', () {
      final json = {
        'startingSeries': 1,
        'restTime': 30,
        'currentSeries': 5,
        'repsInCurrentSeries': 0,
        'totalReps': 15,
        'isActive': true,
        'startTime': DateTime(2025, 1, 14, 10, 0).toIso8601String(),
        'goalPushups': 10,
        'goalReached': true,
      };

      final session = WorkoutSession.fromJson(json);

      expect(session.goalPushups, 10);
      expect(session.goalReached, true);
    });

    test('should deserialize without goal when null', () {
      final json = {
        'startingSeries': 1,
        'restTime': 30,
        'currentSeries': 5,
        'repsInCurrentSeries': 0,
        'totalReps': 15,
        'isActive': true,
        'startTime': DateTime(2025, 1, 14, 10, 0).toIso8601String(),
        'goalPushups': null,
        'goalReached': false,
      };

      final session = WorkoutSession.fromJson(json);

      expect(session.goalPushups, null);
      expect(session.goalReached, false);
    });

    test('copyWith should preserve goal fields', () {
      final session = WorkoutSession(
        startingSeries: 1,
        restTime: 30,
        goalPushups: 10,
      );
      session.goalReached = true;

      final updated = session.copyWith(currentSeries: 6);

      expect(updated.goalPushups, 10);
      expect(updated.goalReached, true);
      expect(updated.currentSeries, 6);
    });
  });
}
