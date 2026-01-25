import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/core/utils/calculator.dart';

void main() {
  group('Calculator', () {
    test('should calculate kcal correctly (0.45 per push-up)', () {
      expect(Calculator.calculateKcal(0), 0.0);
      expect(Calculator.calculateKcal(1), 0.45);
      expect(Calculator.calculateKcal(10), 4.5);
      expect(Calculator.calculateKcal(100), 45.0);
      expect(Calculator.calculateKcal(1000), 450.0);
    });

    test('should calculate points correctly', () {
      // Base: (10 * 10) + 100 = 200 (consecutiveDays removed from base)
      // Series multiplier: 10 series → 2.0x
      // Streak multiplier: 3 days → 1.0x (not included in sum)
      // Total: 200 * 2.0 = 400
      final points = Calculator.calculatePoints(
        seriesCompleted: 10,
        totalPushups: 100,
        consecutiveDays: 3,
      );

      expect(points, 400); // 200 * 2.0 (series multiplier only)
    });

    test('should apply multiplier correctly based on streak', () {
      // 1-3 day streak: ×1.0
      expect(Calculator.getMultiplier(0), 1.0);
      expect(Calculator.getMultiplier(3), 1.0);

      // 4-7 day streak: ×1.2
      expect(Calculator.getMultiplier(4), 1.2);
      expect(Calculator.getMultiplier(7), 1.2);

      // 8-14 day streak: ×1.5
      expect(Calculator.getMultiplier(8), 1.5);
      expect(Calculator.getMultiplier(14), 1.5);

      // 15-30 day streak: ×2.0
      expect(Calculator.getMultiplier(15), 2.0);
      expect(Calculator.getMultiplier(30), 2.0);
    });

    test('should calculate level correctly based on points', () {
      expect(Calculator.calculateLevel(0), 1); // Beginner
      expect(Calculator.calculateLevel(999), 1); // Beginner
      expect(Calculator.calculateLevel(1000), 2); // Intermediate
      expect(Calculator.calculateLevel(4999), 2); // Intermediate
      expect(Calculator.calculateLevel(5000), 3); // Advanced
      expect(Calculator.calculateLevel(9999), 3); // Advanced
      expect(Calculator.calculateLevel(10000), 4); // Expert
      expect(Calculator.calculateLevel(24999), 4); // Expert
      expect(Calculator.calculateLevel(25000), 5); // Master
    });

    test('should get level name correctly', () {
      expect(Calculator.getLevelName(1), 'Beginner');
      expect(Calculator.getLevelName(2), 'Intermediate');
      expect(Calculator.getLevelName(3), 'Advanced');
      expect(Calculator.getLevelName(4), 'Expert');
      expect(Calculator.getLevelName(5), 'Master');
    });

    test('should calculate base points with achievement points', () {
      // Formula: (seriesCompleted × 10) + (totalPushups × 1) + achievementPoints
      // Example: 5 series + 20 pushups + 50 achievement points
      // = (5 × 10) + (20 × 1) + 50 = 50 + 20 + 50 = 120
      final points = Calculator.calculateBasePoints(
        seriesCompleted: 5,
        totalPushups: 20,
        consecutiveDays: 3,
        achievementPoints: 50,
      );

      expect(points, 120);
    });

    test('should calculate base points without achievement points', () {
      // Formula: (seriesCompleted × 10) + (totalPushups × 1) + achievementPoints
      // Example: 5 series + 20 pushups + 0 achievement points
      // = (5 × 10) + (20 × 1) + 0 = 50 + 20 = 70
      final points = Calculator.calculateBasePoints(
        seriesCompleted: 5,
        totalPushups: 20,
        consecutiveDays: 3,
        achievementPoints: 0,
      );

      expect(points, 70);
    });

    test('should calculate base points with only achievement points', () {
      // Formula: (seriesCompleted × 10) + (totalPushups × 1) + achievementPoints
      // Example: 0 series + 0 pushups + 100 achievement points
      // = (0 × 10) + (0 × 1) + 100 = 100
      final points = Calculator.calculateBasePoints(
        seriesCompleted: 0,
        totalPushups: 0,
        consecutiveDays: 0,
        achievementPoints: 100,
      );

      expect(points, 100);
    });

    test('should calculate final points with achievement points in base', () {
      // Base: (5 × 10) + 20 + 50 (achievement) = 120
      // Streak: 5 days → 1.2x
      // Series: 5 series → 1.5x
      // Sum: 1.2 + 1.5 = 2.7
      // Total: 120 * 2.7 = 324
      final points = Calculator.calculatePoints(
        seriesCompleted: 5,
        totalPushups: 20,
        consecutiveDays: 5,
        achievementPoints: 50,
      );

      expect(points, 324);
    });

    test('should calculate final points with multiplier', () {
      // Base: (10 * 10) + 100 = 200 (consecutiveDays removed from base)
      // Streak: 5 days → 1.2x
      // Series: 10 series → 2.0x
      // Sum of multipliers > 1.0: 1.2 + 2.0 = 3.2
      // Final: 200 * 3.2 = 640
      final points = Calculator.calculatePoints(
        seriesCompleted: 10,
        totalPushups: 100,
        consecutiveDays: 5,
      );

      expect(points, 640); // 200 * (1.2 + 2.0)
    });

    group('Goal Multiplier - Deprecated (No longer used in new formula)', () {
      test('goalReached parameter is ignored in new formula', () {
        // Base: (10 * 10) + 55 = 155 (consecutiveDays removed from base)
        // Streak: 3 days → 1.0x (not included)
        // Series: 10 series → 2.0x
        // Total: 155 * 2.0 = 310 (goalReached is now ignored)
        final points = Calculator.calculatePoints(
          seriesCompleted: 10,
          totalPushups: 55,
          consecutiveDays: 3,
          goalReached: true,
        );

        expect(points, 310); // goalReached no longer affects calculation
      });

      test('calculation without goalReached', () {
        // Base: (5 * 10) + 20 = 70
        // Streak: 3 days → 1.0x (not included)
        // Series: 5 series → 1.5x
        // Total: 70 * 1.5 = 105
        final points = Calculator.calculatePoints(
          seriesCompleted: 5,
          totalPushups: 20,
          consecutiveDays: 3,
          goalReached: false,
        );

        expect(points, 105);
      });

      test('calculation with high streak (no goal multiplier)', () {
        // Base: (10 * 10) + 55 = 155
        // Streak: 10 days → 1.5x
        // Series: 10 series → 2.0x
        // Sum: 1.5 + 2.0 = 3.5
        // Total: 155 * 3.5 = 542 (goalReached no longer used)
        final points = Calculator.calculatePoints(
          seriesCompleted: 10,
          totalPushups: 55,
          consecutiveDays: 10,
          goalReached: true,
        );

        expect(points, 542);
      });

      test('default goalReached behavior unchanged', () {
        final points = Calculator.calculatePoints(
          seriesCompleted: 10,
          totalPushups: 55,
          consecutiveDays: 3,
        );

        // Base: 155, Series: 2.0x, Streak: 1.0x (not included)
        // Total: 155 * 2.0 = 310
        expect(points, 310);
      });
    });
  });

  group('Additive Multiplier Formula - New Implementation', () {
    test('sums multipliers greater than 1.0', () {
      // Base: (5 * 10) + 10 = 60 (consecutiveDays not included)
      // Streak: 5 days → 1.2x
      // Series: 5 series → 1.5x
      // Sum of multipliers > 1.0: 1.2 + 1.5 = 2.7
      // Total: 60 * 2.7 = 162
      final points = Calculator.calculatePoints(
        seriesCompleted: 5,
        totalPushups: 10,
        consecutiveDays: 5,
        achievementCount: 0,
      );
      expect(points, 162);
    });

    test('uses base points only when all multipliers are 1.0', () {
      // Base: (0 * 10) + 10 = 10
      // All multipliers are 1.0, so no sum applied
      // Total: 10 * 1.0 = 10
      final points = Calculator.calculatePoints(
        seriesCompleted: 0,
        totalPushups: 10,
        consecutiveDays: 0,
        achievementCount: 0,
      );
      expect(points, 10);
    });

    test('achievement multipliers no longer used - points added to base instead', () {
      // Base: (10 * 10) + 10 + 50 (achievement points) = 160
      // Streak: 15 days → 2.0x
      // Series: 10 series → 2.0x
      // Achievement multiplier is NO LONGER used
      // Sum: 2.0 + 2.0 = 4.0
      // Total: 160 * 4.0 = 640
      final points = Calculator.calculatePoints(
        seriesCompleted: 10,
        totalPushups: 10,
        consecutiveDays: 15,
        achievementCount: 1,
        achievementPoints: 50,
      );
      expect(points, 640);
    });

    test('includes only streak multiplier when others are 1.0', () {
      // Base: (0 * 10) + 10 = 10
      // Streak: 5 days → 1.2x
      // Series: 0 series → 1.0x (not included)
      // Achievement: 0 achievements → 1.0x (not included)
      // Sum: 1.2
      // Total: 10 * 1.2 = 12
      final points = Calculator.calculatePoints(
        seriesCompleted: 0,
        totalPushups: 10,
        consecutiveDays: 5,
        achievementCount: 0,
      );
      expect(points, 12);
    });

    test('includes only series multiplier when others are 1.0', () {
      // Base: (5 * 10) + 10 = 60
      // Streak: 0 days → 1.0x (not included)
      // Series: 5 series → 1.5x
      // Achievement: 0 achievements → 1.0x (not included)
      // Sum: 1.5
      // Total: 60 * 1.5 = 90
      final points = Calculator.calculatePoints(
        seriesCompleted: 5,
        totalPushups: 10,
        consecutiveDays: 0,
        achievementCount: 0,
      );
      expect(points, 90);
    });

    test('achievement points added to base - no multiplier', () {
      // Base: (0 * 10) + 10 + 50 (achievement points) = 60
      // Streak: 0 days → 1.0x (not included)
      // Series: 0 series → 1.0x (not included)
      // Achievement multiplier NO LONGER used, points added to base
      // Total: 60 * 1.0 = 60
      final points = Calculator.calculatePoints(
        seriesCompleted: 0,
        totalPushups: 10,
        consecutiveDays: 0,
        achievementCount: 1,
        achievementPoints: 50,
      );
      expect(points, 60);
    });

    test('handles large streak and series multipliers', () {
      // Base: (20 * 10) + 100 = 300
      // Streak: 20 days → 2.0x
      // Series: 20 series → 3.0x
      // Achievement: 0 achievements → 1.0x (not included)
      // Sum: 2.0 + 3.0 = 5.0
      // Total: 300 * 5.0 = 1500
      final points = Calculator.calculatePoints(
        seriesCompleted: 20,
        totalPushups: 100,
        consecutiveDays: 20,
        achievementCount: 0,
      );
      expect(points, 1500);
    });

    test('multiple achievement points added to base', () {
      // Base: (0 * 10) + 10 + 150 (3 achievements × 50 points) = 160
      // Streak: 0 days → 1.0x (not included)
      // Series: 0 series → 1.0x (not included)
      // Achievement multiplier NO LONGER used, points added to base
      // Total: 160 * 1.0 = 160
      final points = Calculator.calculatePoints(
        seriesCompleted: 0,
        totalPushups: 10,
        consecutiveDays: 0,
        achievementCount: 3,
        achievementPoints: 150,
      );
      expect(points, 160);
    });
  });

  group('Exponential Session Multiplier - New Formula', () {
    test('returns 1.0 for zero pushups and zero series', () {
      // N=0, S=0: baseMultiplier * (1.004)^0 * (1.03)^(-1) = 1.0 * 1 * 1 = 1.0
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 0,
        seriesCompleted: 0,
      );
      expect(multiplier, closeTo(1.0, 0.01));
    });

    test('returns 1.0 for first pushup', () {
      // N=1, S=0: baseMultiplier * (1.004)^1 * (1.03)^(-1) = 1.0 * 1.004 * 1 = 1.004
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 1,
        seriesCompleted: 0,
      );
      expect(multiplier, greaterThan(1.0));
      expect(multiplier, lessThan(1.01));
    });

    test('calculates correctly for 15 pushups (threshold)', () {
      // N=15, S=0: all in first rate
      // pushFactor = (1.004)^15 ≈ 1.06
      // seriesFactor = 1 (no series completed beyond first)
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 15,
        seriesCompleted: 0,
      );
      expect(multiplier, greaterThan(1.05));
      expect(multiplier, lessThan(1.1));
    });

    test('applies higher rate after 15 pushups', () {
      // N=20 (15 at r1=0.004, 5 at r2=0.02)
      // pushFactor = (1.004)^15 * (1.02)^5 ≈ 1.06 * 1.10 ≈ 1.17
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 20,
        seriesCompleted: 0,
      );
      expect(multiplier, greaterThan(1.15));
    });

    test('includes series factor for completed series', () {
      // N=10, S=2:
      // pushFactor = (1.004)^10 ≈ 1.04
      // seriesFactor = (1.03)^1 ≈ 1.03 (max(S-1, 0) = max(2-1, 0) = 1)
      // total ≈ 1.04 * 1.03 ≈ 1.07
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 10,
        seriesCompleted: 2,
      );
      expect(multiplier, greaterThan(1.05));
      expect(multiplier, lessThan(1.1));
    });

    test('grows significantly with high pushup count', () {
      // N=50, S=5:
      // pushFactor = (1.004)^15 * (1.02)^35 ≈ 1.06 * 2.0 ≈ 2.12
      // seriesFactor = (1.03)^4 ≈ 1.13
      // total ≈ 2.12 * 1.13 ≈ 2.4
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 50,
        seriesCompleted: 5,
      );
      expect(multiplier, greaterThan(2.0));
    });

    test('combines pushup and series factors correctly', () {
      // Test with moderate values
      final multiplier = Calculator.calculateSessionMultiplier(
        totalPushups: 30,
        seriesCompleted: 3,
      );
      // Should be > 1.3 due to combined factors
      expect(multiplier, greaterThan(1.3));
    });
  });

  group('Aggressive Points Formula - Phase 03.2', () {
    group('getRepMultiplier', () {
      test('returns 0.0 for 0 pushups', () {
        expect(Calculator.getRepMultiplier(0), 0.0);
      });

      test('returns 1.5 for 5 pushups (5 x 0.3)', () {
        expect(Calculator.getRepMultiplier(5), 1.5);
      });

      test('returns 3.0 for 10 pushups (10 x 0.3)', () {
        expect(Calculator.getRepMultiplier(10), 3.0);
      });

      test('calculates correctly for any value', () {
        expect(Calculator.getRepMultiplier(1), 0.3);
        expect(Calculator.getRepMultiplier(15), 4.5);
        expect(Calculator.getRepMultiplier(20), 6.0);
      });
    });

    group('getSeriesMultiplier', () {
      test('returns 0.8 for series 1 (1 x 0.8)', () {
        expect(Calculator.getSeriesMultiplier(1), 0.8);
      });

      test('returns 4.0 for series 5 (5 x 0.8)', () {
        expect(Calculator.getSeriesMultiplier(5), 4.0);
      });

      test('returns 8.0 for series 10 (10 x 0.8)', () {
        expect(Calculator.getSeriesMultiplier(10), 8.0);
      });

      test('calculates correctly for any series', () {
        expect(Calculator.getSeriesMultiplier(2), 1.6);
        expect(Calculator.getSeriesMultiplier(15), 12.0);
        expect(Calculator.getSeriesMultiplier(20), 16.0);
      });
    });

    group('calculateSeriesPoints', () {
      test('calculates Series 1, 1 pushup, 0-day streak = 11 points', () {
        // Base: 10
        // RepMult: 1 x 0.3 = 0.3
        // SeriesMult: 1 x 0.8 = 0.8
        // StreakMult: 1.0 (0 days)
        // Result: 10 x (0.3 + 0.8) x 1.0 = 11
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 1,
          pushupsInSeries: 1,
          consecutiveDays: 0,
        );
        expect(points, 11);
      });

      test('calculates Series 5, 5 pushups, 3-day streak = 55 points', () {
        // Base: 10
        // RepMult: 5 x 0.3 = 1.5
        // SeriesMult: 5 x 0.8 = 4.0
        // StreakMult: 1.0 (3 days)
        // Result: 10 x (1.5 + 4.0) x 1.0 = 55
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 5,
          pushupsInSeries: 5,
          consecutiveDays: 3,
        );
        expect(points, 55);
      });

      test('calculates Series 10, 10 pushups, 20-day streak (2.0x) = 220 points', () {
        // Base: 10
        // RepMult: 10 x 0.3 = 3.0
        // SeriesMult: 10 x 0.8 = 8.0
        // StreakMult: 2.0 (20 days)
        // Result: 10 x (3.0 + 8.0) x 2.0 = 220
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 10,
          pushupsInSeries: 10,
          consecutiveDays: 20,
        );
        expect(points, 220);
      });

      test('applies 1.2x multiplier for 5-day streak', () {
        // Base: 10
        // RepMult: 5 x 0.3 = 1.5
        // SeriesMult: 5 x 0.8 = 4.0
        // StreakMult: 1.2 (5 days)
        // Result: 10 x (1.5 + 4.0) x 1.2 = 66
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 5,
          pushupsInSeries: 5,
          consecutiveDays: 5,
        );
        expect(points, 66);
      });

      test('applies 1.5x multiplier for 10-day streak', () {
        // Base: 10
        // RepMult: 10 x 0.3 = 3.0
        // SeriesMult: 10 x 0.8 = 8.0
        // StreakMult: 1.5 (10 days)
        // Result: 10 x (3.0 + 8.0) x 1.5 = 165
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 10,
          pushupsInSeries: 10,
          consecutiveDays: 10,
        );
        expect(points, 165);
      });

      test('handles 0 pushups in series', () {
        // Base: 10
        // RepMult: 0 x 0.3 = 0.0
        // SeriesMult: 5 x 0.8 = 4.0
        // StreakMult: 1.0
        // Result: 10 x (0.0 + 4.0) x 1.0 = 40
        final points = Calculator.calculateSeriesPoints(
          seriesNumber: 5,
          pushupsInSeries: 0,
          consecutiveDays: 0,
        );
        expect(points, 40);
      });

      test('rewards longer series significantly more', () {
        // Series 1, 1 pushup, 0 streak: 10 x (0.3 + 0.8) x 1.0 = 11
        final points1 = Calculator.calculateSeriesPoints(
          seriesNumber: 1,
          pushupsInSeries: 1,
          consecutiveDays: 0,
        );

        // Series 20, 20 pushups, 0 streak: 10 x (6.0 + 16.0) x 1.0 = 220
        final points20 = Calculator.calculateSeriesPoints(
          seriesNumber: 20,
          pushupsInSeries: 20,
          consecutiveDays: 0,
        );

        expect(points1, 11);
        expect(points20, 220);
        expect(points20 / points1, greaterThan(19)); // 20x progression
      });
    });
  });

  group('Daily Cap Calculation - Phase 03.2', () {
    test('calculates cap for level 1-3 (1.5x daily goal)', () {
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 0), 75); // Level 1
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 500), 75); // Level 1
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 999), 75); // Level 1
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 1000), 75); // Level 2
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 5000), 75); // Level 3
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 9999), 75); // Level 3
    });

    test('calculates cap for level 4 (2.0x daily goal)', () {
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 10000), 100); // Level 4
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 24999), 100); // Level 4
    });

    test('calculates cap for level 5 (2.5x daily goal)', () {
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 25000), 125); // Level 5
      expect(Calculator.calculateDailyCap(dailyGoal: 50, totalPoints: 100000), 125); // Level 5
    });

    test('handles different daily goals', () {
      expect(Calculator.calculateDailyCap(dailyGoal: 20, totalPoints: 0), 30); // 20 x 1.5
      expect(Calculator.calculateDailyCap(dailyGoal: 30, totalPoints: 0), 45); // 30 x 1.5
      expect(Calculator.calculateDailyCap(dailyGoal: 75, totalPoints: 0), 112); // 75 x 1.5
      expect(Calculator.calculateDailyCap(dailyGoal: 100, totalPoints: 0), 150); // 100 x 1.5
    });
  });
}
