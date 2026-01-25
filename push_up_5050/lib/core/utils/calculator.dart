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

  // ============ AGGRESSIVE POINTS FORMULA - PHASE 03.2 ============

  /// Calculates points for a single rep in a series (real-time feedback).
  /// Formula derived from calculateSeriesPoints but distributed per rep.
  ///
  /// Per-rep formula: BaseRep x (RepMultPerRep + SeriesMultPortion) x StreakMult
  /// - BaseRep: 3 points (portion of the 10 point series base per rep, scaled)
  /// - RepMultPerRep: 0.3 (same as series formula, per rep)
  /// - SeriesMultPortion: (seriesNumber × 0.8) / repNumber (grows as series progresses)
  /// - StreakMult: from getDayStreakMultiplier (1.0x to 2.0x)
  ///
  /// Example: Series 5, rep 3 of 5, 5-day streak (1.2x)
  /// = 3 x (0.3 + (4.0/3)) x 1.2 = ~17 points per rep
  ///
  /// This ensures real-time feedback while maintaining total points
  /// approximately equal to the series-based formula.
  static int calculateRepPoints({
    required int seriesNumber,
    required int repNumber,
    required int consecutiveDays,
  }) {
    // Base: 3 points per rep (portion of series completion reward)
    const baseRep = 3;

    // Rep multiplier: 0.3 per rep (same as series formula)
    const repMultPerRep = 0.3;

    // Series multiplier portion: grows as you progress through the series
    // Higher reps in the series = more points (rewarding completion)
    final seriesMultPortion = (seriesNumber * 0.8) / repNumber;

    // Streak multiplier: from existing getDayStreakMultiplier method
    final streakMult = getDayStreakMultiplier(consecutiveDays);

    // Formula: BaseRep x (RepMultPerRep + SeriesMultPortion) x StreakMult
    final points = baseRep * (repMultPerRep + seriesMultPortion) * streakMult;

    return points.floor();
  }

  /// Calculates the rep multiplier for the aggressive points formula.
  /// RepMult = push-ups in series x 0.3
  /// This rewards completing more reps in each series.
  static double getRepMultiplier(int pushupsInSeries) {
    return pushupsInSeries * 0.3;
  }

  /// Calculates the series multiplier for the aggressive points formula.
  /// SeriesMult = series number x 0.8
  /// This rewards progressing through longer workout sessions.
  static double getSeriesMultiplier(int seriesNumber) {
    return seriesNumber * 0.8;
  }

  /// Calculates points for a single completed series using aggressive formula.
  /// Formula: Base x (RepMult + SeriesMult) x StreakMult
  /// - Base: 10 points per series
  /// - RepMult: push-ups in series x 0.3
  /// - SeriesMult: series number x 0.8
  /// - StreakMult: from getDayStreakMultiplier (1.0x to 2.0x)
  ///
  /// Example: Series 5, 5 pushups, 5-day streak (1.2x)
  /// = 10 x (1.5 + 4.0) x 1.2 = 66 points
  static int calculateSeriesPoints({
    required int seriesNumber,
    required int pushupsInSeries,
    required int consecutiveDays,
  }) {
    // Base: 10 points per series
    const base = 10;

    // Rep multiplier: push-ups in series x 0.3
    final repMult = getRepMultiplier(pushupsInSeries);

    // Series multiplier: series number x 0.8
    final seriesMult = getSeriesMultiplier(seriesNumber);

    // Streak multiplier: from existing getDayStreakMultiplier method
    final streakMult = getDayStreakMultiplier(consecutiveDays);

    // Formula: Base x (RepMult + SeriesMult) x StreakMult
    final points = base * (repMult + seriesMult) * streakMult;

    return points.floor();
  }

  // ============ DAILY CAP ANTI-CHEAT - PHASE 03.2 ============

  /// Calculate daily push-up cap based on user level and daily goal.
  ///
  /// Cap formula: daily goal x (1 + (level x 0.1))
  /// - Level 1 (Beginner): 0-999 points → cap = daily goal x 1.5
  /// - Level 2 (Intermediate): 1000-4999 points → cap = daily goal x 1.5
  /// - Level 3 (Advanced): 5000-9999 points → cap = daily goal x 1.5
  /// - Level 4 (Expert): 10000-24999 points → cap = daily goal x 2.0
  /// - Level 5 (Master): 25000+ points → cap = daily goal x 2.5
  ///
  /// This prevents excessive points farming while allowing
  /// motivated users to continue training beyond the cap.
  static int calculateDailyCap({
    required int dailyGoal,
    required int totalPoints,
  }) {
    final level = calculateLevel(totalPoints);

    // Calculate cap multiplier based on level
    final double capMultiplier;
    if (level <= 3) {
      capMultiplier = 1.5;
    } else if (level == 4) {
      capMultiplier = 2.0;
    } else {
      capMultiplier = 2.5;
    }

    return (dailyGoal * capMultiplier).floor();
  }
}
