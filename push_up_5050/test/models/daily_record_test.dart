import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/models/daily_record.dart';

void main() {
  group('DailyRecord', () {
    test('should create record with auto-calculated values', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 100,
        seriesCompleted: 10,
      );

      expect(record.date, date);
      expect(record.totalPushups, 100);
      expect(record.seriesCompleted, 10);
      expect(record.totalKcal, 45.0); // 100 * 0.45
      expect(record.goalReached, true); // >= 50
    });

    test('should calculate goalReached correctly', () {
      final date = DateTime(2025, 1, 14);

      final underGoal = DailyRecord(
        date: date,
        totalPushups: 49,
        seriesCompleted: 5,
      );
      expect(underGoal.goalReached, false);

      final atGoal = DailyRecord(
        date: date,
        totalPushups: 50,
        seriesCompleted: 5,
      );
      expect(atGoal.goalReached, true);

      final overGoal = DailyRecord(
        date: date,
        totalPushups: 100,
        seriesCompleted: 10,
      );
      expect(overGoal.goalReached, true);
    });

    test('should create record from session data', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord.fromSession(
        date,
        100, // pushups
        10, // series
      );

      expect(record.date, date);
      expect(record.totalPushups, 100);
      expect(record.seriesCompleted, 10);
      expect(record.totalKcal, 45.0); // 100 * 0.45
      expect(record.goalReached, true);
    });

    test('should accept custom totalKcal', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 100,
        seriesCompleted: 10,
        totalKcal: 50.0, // Custom value
      );

      expect(record.totalKcal, 50.0);
    });

    test('should serialize to JSON with YYYY-MM-DD date format', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 100,
        seriesCompleted: 10,
      );

      final json = record.toJson();

      expect(json['date'], '2025-01-14');
      expect(json['totalPushups'], 100);
      expect(json['seriesCompleted'], 10);
      expect(json['totalKcal'], 45.0);
      expect(json['goalReached'], true);
    });

    test('should deserialize from JSON with YYYY-MM-DD date format', () {
      final json = {
        'date': '2025-01-14',
        'totalPushups': 100,
        'seriesCompleted': 10,
        'totalKcal': 45.0,
        'goalReached': true,
      };

      final record = DailyRecord.fromJson(json);

      expect(record.date, DateTime(2025, 1, 14));
      expect(record.totalPushups, 100);
      expect(record.seriesCompleted, 10);
      expect(record.totalKcal, 45.0);
      expect(record.goalReached, true);
    });

    test('should create copy with updated values', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 50,
        seriesCompleted: 5,
      );

      final updated = record.copyWith(
        totalPushups: 100,
        seriesCompleted: 10,
      );

      expect(updated.date, date);
      expect(updated.totalPushups, 100);
      expect(updated.seriesCompleted, 10);
      expect(updated.totalKcal, 45.0); // Recalculated
      expect(updated.goalReached, true);
    });

    test('should handle zero pushups', () {
      final date = DateTime(2025, 1, 14);
      final record = DailyRecord(
        date: date,
        totalPushups: 0,
        seriesCompleted: 0,
      );

      expect(record.totalKcal, 0.0);
      expect(record.goalReached, false);
    });

    test('should handle boundary at 50 pushups', () {
      final date = DateTime(2025, 1, 14);

      // Just under goal
      final under = DailyRecord(
        date: date,
        totalPushups: 49,
        seriesCompleted: 7,
      );
      expect(under.goalReached, false);
      expect(under.totalKcal, 22.05); // 49 * 0.45

      // Exactly at goal
      final at = DailyRecord(
        date: date,
        totalPushups: 50,
        seriesCompleted: 8,
      );
      expect(at.goalReached, true);
      expect(at.totalKcal, 22.5); // 50 * 0.45

      // Just over goal
      final over = DailyRecord(
        date: date,
        totalPushups: 51,
        seriesCompleted: 8,
      );
      expect(over.goalReached, true);
      expect(over.totalKcal, 22.95); // 51 * 0.45
    });

    test('should preserve date through serialization roundtrip', () {
      final originalDate = DateTime(2025, 1, 14, 15, 30); // With time
      final record = DailyRecord(
        date: originalDate,
        totalPushups: 75,
        seriesCompleted: 12,
      );

      final json = record.toJson();
      final restored = DailyRecord.fromJson(json);

      // Time is lost in YYYY-MM-DD format, only date is preserved
      expect(restored.date, DateTime(2025, 1, 14));
      expect(restored.totalPushups, 75);
    });

    group('Points Tracking - Phase 03.2', () {
      test('creates record with default points (0) and multiplier (1.0)', () {
        final record = DailyRecord(date: DateTime(2025, 1, 15));
        expect(record.pointsEarned, 0);
        expect(record.multiplier, 1.0);
      });

      test('creates record with specified points and multiplier', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 50,
          pointsEarned: 100,
          multiplier: 1.5,
        );
        expect(record.pointsEarned, 100);
        expect(record.multiplier, 1.5);
      });

      test('serializes pointsEarned and multiplier to JSON', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 50,
          pointsEarned: 100,
          multiplier: 1.5,
        );
        final json = record.toJson();
        expect(json['pointsEarned'], 100);
        expect(json['multiplier'], 1.5);
      });

      test('deserializes pointsEarned and multiplier from JSON', () {
        final json = {
          'date': '2025-01-15',
          'totalPushups': 50,
          'seriesCompleted': 5,
          'totalKcal': 22.5,
          'goalReached': true,
          'pointsEarned': 150,
          'multiplier': 1.2,
        };
        final record = DailyRecord.fromJson(json);
        expect(record.pointsEarned, 150);
        expect(record.multiplier, 1.2);
      });

      test('handles missing pointsEarned and multiplier for backward compatibility', () {
        final oldJson = {
          'date': '2025-01-15',
          'totalPushups': 50,
          'seriesCompleted': 5,
          'totalKcal': 22.5,
          'goalReached': true,
          // No pointsEarned or multiplier
        };
        final record = DailyRecord.fromJson(oldJson);
        expect(record.pointsEarned, 0); // Default
        expect(record.multiplier, 1.0); // Default
      });

      test('copyWith updates pointsEarned and multiplier', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          pointsEarned: 100,
          multiplier: 1.5,
        );
        final updated = record.copyWith(
          pointsEarned: 200,
          multiplier: 2.0,
        );
        expect(updated.pointsEarned, 200);
        expect(updated.multiplier, 2.0);
        expect(record.pointsEarned, 100); // Original unchanged
        expect(record.multiplier, 1.5); // Original unchanged
      });

      test('copyWith with null values preserves original', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 50,
          pointsEarned: 100,
          multiplier: 1.5,
        );
        final updated = record.copyWith();
        expect(updated.pointsEarned, 100);
        expect(updated.multiplier, 1.5);
      });

      test('creates record with default excessPushups (0)', () {
        final record = DailyRecord(date: DateTime(2025, 1, 15));
        expect(record.excessPushups, 0);
      });

      test('creates record with specified excessPushups', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 100,
          excessPushups: 25, // 25 pushups beyond cap
        );
        expect(record.excessPushups, 25);
      });

      test('serializes excessPushups to JSON', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 100,
          pointsEarned: 100,
          multiplier: 1.5,
          excessPushups: 25,
        );
        final json = record.toJson();
        expect(json['excessPushups'], 25);
      });

      test('deserializes excessPushups from JSON', () {
        final json = {
          'date': '2025-01-15',
          'totalPushups': 100,
          'seriesCompleted': 10,
          'totalKcal': 45.0,
          'goalReached': true,
          'pointsEarned': 200,
          'multiplier': 1.2,
          'excessPushups': 25,
        };
        final record = DailyRecord.fromJson(json);
        expect(record.excessPushups, 25);
      });

      test('handles missing excessPushups for backward compatibility', () {
        final oldJson = {
          'date': '2025-01-15',
          'totalPushups': 100,
          'seriesCompleted': 10,
          'totalKcal': 45.0,
          'goalReached': true,
          'pointsEarned': 200,
          'multiplier': 1.2,
          // No excessPushups
        };
        final record = DailyRecord.fromJson(oldJson);
        expect(record.excessPushups, 0); // Default
      });

      test('copyWith updates excessPushups', () {
        final record = DailyRecord(
          date: DateTime(2025, 1, 15),
          totalPushups: 100,
          excessPushups: 10,
        );
        final updated = record.copyWith(excessPushups: 30);
        expect(updated.excessPushups, 30);
        expect(record.excessPushups, 10); // Original unchanged
      });
    });
  });
}
