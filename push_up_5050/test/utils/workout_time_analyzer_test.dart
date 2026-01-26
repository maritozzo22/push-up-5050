import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/notification_time_slot.dart';
import 'package:push_up_5050/utils/workout_time_analyzer.dart';

void main() {
  group('WorkoutTimeAnalyzer', () {
    group('hasSufficientData', () {
      test('returns false when fewer than 7 workout times', () {
        final times = [
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 20, 8, 0)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 21, 9, 0)),
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 22, 10, 0)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 23, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 30, timestamp: DateTime(2025, 1, 24, 9, 30)),
          NotificationTimeSlot(hour: 8, minute: 15, timestamp: DateTime(2025, 1, 25, 8, 15)),
        ];

        expect(WorkoutTimeAnalyzer.hasSufficientData(times), false);
      });

      test('returns true when exactly 7 workout times', () {
        final times = [
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 19, 8, 0)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 20, 9, 0)),
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 21, 10, 0)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 22, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 30, timestamp: DateTime(2025, 1, 23, 9, 30)),
          NotificationTimeSlot(hour: 8, minute: 15, timestamp: DateTime(2025, 1, 24, 8, 15)),
          NotificationTimeSlot(hour: 9, minute: 15, timestamp: DateTime(2025, 1, 25, 9, 15)),
        ];

        expect(WorkoutTimeAnalyzer.hasSufficientData(times), true);
      });

      test('returns true when more than 7 workout times', () {
        final times = List.generate(
          10,
          (i) => NotificationTimeSlot(
            hour: 8 + (i % 3),
            minute: 0,
            timestamp: DateTime(2025, 1, 20 + i, 8, 0),
          ),
        );

        expect(WorkoutTimeAnalyzer.hasSufficientData(times), true);
      });

      test('returns false for empty list', () {
        expect(WorkoutTimeAnalyzer.hasSufficientData([]), false);
      });
    });

    group('calculatePersonalizedTime', () {
      test('returns null when fewer than 7 data points', () {
        final times = [
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 20, 8, 0)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 21, 9, 0)),
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 22, 10, 0)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNull);
      });

      test('returns hour bin with maximum workout count', () {
        final times = [
          // 6 workouts in 8-9 bin (hours 8-9)
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 19, 8, 0)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 20, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 21, 9, 0)),
          NotificationTimeSlot(hour: 8, minute: 15, timestamp: DateTime(2025, 1, 22, 8, 15)),
          NotificationTimeSlot(hour: 9, minute: 30, timestamp: DateTime(2025, 1, 23, 9, 30)),
          NotificationTimeSlot(hour: 8, minute: 45, timestamp: DateTime(2025, 1, 24, 8, 45)),
          // 1 workout in 10-11 bin
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 25, 10, 0)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNotNull);
        expect(result!.$1, 8); // 8-9 bin has max count
        expect(result.$2, 0); // Minutes always 0
      });

      test('returns 10 when most workouts in 10-11 bin', () {
        final times = [
          // 4 workouts in 8-9 bin
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 19, 8, 0)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 20, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 21, 9, 0)),
          NotificationTimeSlot(hour: 8, minute: 15, timestamp: DateTime(2025, 1, 22, 8, 15)),
          // 5 workouts in 10-11 bin
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 23, 10, 0)),
          NotificationTimeSlot(hour: 10, minute: 30, timestamp: DateTime(2025, 1, 24, 10, 30)),
          NotificationTimeSlot(hour: 11, minute: 0, timestamp: DateTime(2025, 1, 25, 11, 0)),
          NotificationTimeSlot(hour: 10, minute: 15, timestamp: DateTime(2025, 1, 26, 10, 15)),
          NotificationTimeSlot(hour: 11, minute: 30, timestamp: DateTime(2025, 1, 27, 11, 30)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNotNull);
        expect(result!.$1, 10); // 10-11 bin has max count
        expect(result.$2, 0);
      });

      test('returns earliest bin when there is a tie', () {
        final times = [
          // 4 workouts in 8-9 bin
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 19, 8, 0)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 20, 9, 0)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 21, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 30, timestamp: DateTime(2025, 1, 22, 9, 30)),
          // 4 workouts in 14-15 bin (tie)
          NotificationTimeSlot(hour: 14, minute: 0, timestamp: DateTime(2025, 1, 23, 14, 0)),
          NotificationTimeSlot(hour: 15, minute: 0, timestamp: DateTime(2025, 1, 24, 15, 0)),
          NotificationTimeSlot(hour: 14, minute: 30, timestamp: DateTime(2025, 1, 25, 14, 30)),
          NotificationTimeSlot(hour: 15, minute: 30, timestamp: DateTime(2025, 1, 26, 15, 30)),
          // 1 workout in another bin to reach 7 total
          NotificationTimeSlot(hour: 10, minute: 0, timestamp: DateTime(2025, 1, 27, 10, 0)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNotNull);
        // Should return earliest bin (8) in case of tie
        expect(result!.$1, 8);
        expect(result.$2, 0);
      });

      test('always returns 0 for minutes', () {
        final times = [
          NotificationTimeSlot(hour: 8, minute: 45, timestamp: DateTime(2025, 1, 19, 8, 45)),
          NotificationTimeSlot(hour: 9, minute: 15, timestamp: DateTime(2025, 1, 20, 9, 15)),
          NotificationTimeSlot(hour: 8, minute: 30, timestamp: DateTime(2025, 1, 21, 8, 30)),
          NotificationTimeSlot(hour: 9, minute: 45, timestamp: DateTime(2025, 1, 22, 9, 45)),
          NotificationTimeSlot(hour: 8, minute: 15, timestamp: DateTime(2025, 1, 23, 8, 15)),
          NotificationTimeSlot(hour: 9, minute: 30, timestamp: DateTime(2025, 1, 24, 9, 30)),
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 25, 8, 0)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNotNull);
        expect(result!.$2, 0); // Minutes always 0 for consistency
      });

      test('handles workouts spread across multiple bins', () {
        final times = [
          // 1 workout in 6-7 bin
          NotificationTimeSlot(hour: 6, minute: 0, timestamp: DateTime(2025, 1, 19, 6, 0)),
          // 2 workouts in 8-9 bin
          NotificationTimeSlot(hour: 8, minute: 0, timestamp: DateTime(2025, 1, 20, 8, 0)),
          NotificationTimeSlot(hour: 9, minute: 0, timestamp: DateTime(2025, 1, 21, 9, 0)),
          // 3 workouts in 14-15 bin (max)
          NotificationTimeSlot(hour: 14, minute: 0, timestamp: DateTime(2025, 1, 22, 14, 0)),
          NotificationTimeSlot(hour: 15, minute: 0, timestamp: DateTime(2025, 1, 23, 15, 0)),
          NotificationTimeSlot(hour: 14, minute: 30, timestamp: DateTime(2025, 1, 24, 14, 30)),
          // 1 workout in 18-19 bin
          NotificationTimeSlot(hour: 18, minute: 0, timestamp: DateTime(2025, 1, 25, 18, 0)),
        ];

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(times);

        expect(result, isNotNull);
        expect(result!.$1, 14); // 14-15 bin has max count
        expect(result.$2, 0);
      });

      test('returns null for empty list', () {
        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime([]);

        expect(result, isNull);
      });

      test('returns default hour/minute for all same time', () {
        final allSameTime = List.generate(
          10,
          (i) => NotificationTimeSlot(
            hour: 9,
            minute: 0,
            timestamp: DateTime(2025, 1, 20 + i, 9, 0),
          ),
        );

        final result = WorkoutTimeAnalyzer.calculatePersonalizedTime(allSameTime);

        expect(result, isNotNull);
        expect(result!.$1, 8); // 9 falls into 8-9 bin
        expect(result.$2, 0);
      });
    });

    group('Constants', () {
      test('minDataPointsForPersonalization is 7', () {
        expect(WorkoutTimeAnalyzer.minDataPointsForPersonalization, 7);
      });

      test('defaultHour is 9', () {
        expect(WorkoutTimeAnalyzer.defaultHour, 9);
      });

      test('defaultMinute is 0', () {
        expect(WorkoutTimeAnalyzer.defaultMinute, 0);
      });
    });
  });
}
