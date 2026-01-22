import 'dart:math' as math;

/// Calculator utility for all game formulas
/// Centralized to ensure consistency across the app
class Calculator {
  // ============ MULTIPLIERS ============

  /// Moltiplicatore giorni consecutivi (resetta se salta un giorno)
  /// 0-3 giorni: 1.0x
  /// 4-7 giorni: 1.2x
  /// 8-14 giorni: 1.5x
  /// 15-30 giorni: 2.0x
  static double getDayStreakMultiplier(int consecutiveDays) {
    if (consecutiveDays >= 15) return 2.0;
    if (consecutiveDays >= 8) return 1.5;
    if (consecutiveDays >= 4) return 1.2;
    return 1.0;
  }

  /// Moltiplicatore serie nella sessione (esponenziale per serie)
  /// Ogni serie completata aggiunge 0.1x al moltiplicatore
  /// 0 serie: 1.0x, 1 serie: 1.1x, 2 serie: 1.2x...
  ///
  /// NOTA: Questo metodo usa la formula vecchia. Per la nuova formula
  /// esponenziale basata su push-up totali e serie, usa calculateSessionMultiplier().
  static double getSessionSeriesMultiplier(int completedSeries) {
    return 1.0 + (completedSeries * 0.1);
  }

  /// Moltiplicatore sessione con formula esponenziale
  /// Basato su push-up totali (N) e serie completate (S)
  ///
  /// Formula:
  /// - r1 = 0.004 (crescita per push-up da 1 a 15)
  /// - r2 = 0.02 (crescita per push-up dopo 15)
  /// - s = 0.03 (crescita per ogni serie)
  ///
  /// pushFactor = (1 + r1)^n1 * (1 + r2)^n2
  /// seriesFactor = (1 + s)^S
  /// multiplier = baseMultiplier * pushFactor * seriesFactor
  ///
  /// Esempi:
  /// - N=0, S=0: 1.0x
  /// - N=1, S=1: ~1.03x (1 push-up, 1 serie completata)
  /// - N=15, S=1: ~1.09x
  /// - N=30, S=3: ~1.65x
  /// - N=50, S=5: ~2.7x
  static double calculateSessionMultiplier({
    required int totalPushups,
    required int seriesCompleted,
  }) {
    const baseMultiplier = 1.0;
    const r1 = 0.004; // crescita per push-up da 1 a 15
    const r2 = 0.02; // crescita per push-up dopo 15
    const s = 0.03; // crescita per ogni serie completata

    final n1 = math.min(totalPushups, 15);
    final n2 = math.max(totalPushups - 15, 0);

    final pushFactor = math.pow(1 + r1, n1) * math.pow(1 + r2, n2);
    final seriesFactor = math.pow(1 + s, seriesCompleted);

    return baseMultiplier * pushFactor * seriesFactor;
  }

  /// Moltiplicatore achievement nella sessione
  /// Ogni achievement sbloccato aggiunge 0.5x al moltiplicatore
  /// 0 achievement: 1.0x, 1 achievement: 1.5x, 2: 2.0x...
  static double getAchievementMultiplier(int achievementCount) {
    return 1.0 + (achievementCount * 0.5);
  }
  /// Calculate kcal burned
  /// Formula: pushups × 0.45
  static double calculateKcal(int pushups) {
    return pushups * 0.45;
  }

  /// Get streak multiplier based on consecutive days
  /// 0-3 days: ×1.0
  /// 4-7 days: ×1.2
  /// 8-14 days: ×1.5
  /// 15-30 days: ×2.0
  static double getMultiplier(int consecutiveDays) {
    if (consecutiveDays >= 15) return 2.0;
    if (consecutiveDays >= 8) return 1.5;
    if (consecutiveDays >= 4) return 1.2;
    return 1.0;
  }

  /// Calculate base points WITHOUT multipliers
  /// Returns the raw points before any multiplier is applied
  /// Formula: (seriesCompleted × 10) + (totalPushups × 1) + (achievementPoints)
  /// Note: consecutiveDays is no longer included in base points (kept for backward compatibility)
  static int calculateBasePoints({
    required int seriesCompleted,
    required int totalPushups,
    required int consecutiveDays,
    int achievementPoints = 0,
  }) {
    return (seriesCompleted * 10) + (totalPushups * 1) + achievementPoints;
  }

  /// Calculate final points with additive multipliers
  /// Formula: basePoints × sum(multipliers > 1.0)
  /// Base points: (seriesCompleted × 10) + (totalPushups × 1) + achievementPoints
  /// Multipliers: streak, series (only those > 1.0 are summed)
  /// If no multipliers > 1.0, returns basePoints only
  static int calculatePoints({
    required int seriesCompleted,
    required int totalPushups,
    required int consecutiveDays,
    bool goalReached = false,
    int achievementCount = 0,
    int achievementPoints = 0,
  }) {
    // Base points: series × 10 + pushups × 1 + achievementPoints
    final basePoints = (seriesCompleted * 10) + totalPushups + achievementPoints;

    // Collect all multipliers > 1.0
    final multipliers = <double>[];

    // Streak multiplier
    final streakMult = getDayStreakMultiplier(consecutiveDays);
    if (streakMult > 1.0) multipliers.add(streakMult);

    // Series multiplier
    final seriesMult = getSessionSeriesMultiplier(seriesCompleted);
    if (seriesMult > 1.0) multipliers.add(seriesMult);

    // Achievement points are now included in basePoints, not as a multiplier
    // The getAchievementMultiplier method is kept for backward compatibility but not used

    // Sum multipliers or use 1.0 if none
    final multiplierSum = multipliers.isEmpty ? 1.0 : multipliers.reduce((a, b) => a + b);

    return (basePoints * multiplierSum).floor();
  }

  /// Calculate level based on total points
  /// 0-999: Level 1 (Beginner)
  /// 1000-4999: Level 2 (Intermediate)
  /// 5000-9999: Level 3 (Advanced)
  /// 10000-24999: Level 4 (Expert)
  /// 25000+: Level 5 (Master)
  static int calculateLevel(int points) {
    if (points >= 25000) return 5;
    if (points >= 10000) return 4;
    if (points >= 5000) return 3;
    if (points >= 1000) return 2;
    return 1;
  }

  /// Get level name
  static String getLevelName(int level) {
    switch (level) {
      case 1:
        return 'Beginner';
      case 2:
        return 'Intermediate';
      case 3:
        return 'Advanced';
      case 4:
        return 'Expert';
      case 5:
        return 'Master';
      default:
        return 'Beginner';
    }
  }

  /// Calculate daily goal progress (0.0 to 1.0)
  static double calculateDailyProgress(int todayPushups, int goal) {
    if (goal == 0) return 1.0;
    return (todayPushups / goal).clamp(0.0, 1.0);
  }

  /// Calculate overall 30-day progress
  static double calculateOverallProgress(int totalPushups, int goal) {
    if (goal == 0) return 1.0;
    return (totalPushups / goal).clamp(0.0, 1.0);
  }
}
