import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/achievement.dart';

/// Storage service for persisting app data using SharedPreferences.
///
/// Use [create] for production, or inject a mock [SharedPreferences] for testing.
class StorageService {
  final SharedPreferences _prefs;

  /// Private constructor - use [create] factory or [forTesting] for injection.
  StorageService._(this._prefs);

  /// Constructor for testing with dependency injection.
  factory StorageService.forTesting(SharedPreferences prefs) {
    return StorageService._(prefs);
  }

  /// Factory for production use - initializes SharedPreferences.
  static Future<StorageService> create() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService._(prefs);
  }

  // Storage keys
  static const String _keyActiveSession = 'active_session';
  static const String _keyDailyRecords = 'daily_records';
  static const String _keyAchievements = 'achievements';
  static const String _keyWorkoutPreferences = 'workout_preferences';
  static const String _keyProgramStartDate = 'program_start_date';
  static const String _keyDailyGoal = 'daily_goal';
  static const String _keyMonthlyGoal = 'monthly_goal';
  static const String _keyWeeklyGoal = 'weekly_goal';
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyWeeklyReviewShown = 'weekly_review_shown_';
  static const String _keyWeeklyBonusAwarded = 'weekly_bonus_awarded_';

  // ==================== Active Session ====================

  /// Save active workout session to storage.
  Future<void> saveActiveSession(WorkoutSession session) async {
    final json = jsonEncode(session.toJson());
    await _prefs.setString(_keyActiveSession, json);
  }

  /// Load active workout session from storage.
  /// Returns null if no session exists or data is corrupted.
  Future<WorkoutSession?> loadActiveSession() async {
    final json = _prefs.getString(_keyActiveSession);
    if (json == null) return null;

    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return WorkoutSession.fromJson(decoded);
    } catch (e) {
      // Corrupted data, clear it
      await clearActiveSession();
      return null;
    }
  }

  /// Remove active session from storage.
  Future<void> clearActiveSession() async {
    await _prefs.remove(_keyActiveSession);
  }

  // ==================== Daily Records ====================

  /// Save or merge a daily record to storage.
  Future<void> saveDailyRecord(DailyRecord record) async {
    final records = await loadDailyRecords();
    records[_formatDate(record.date)] = record.toJson();

    final json = jsonEncode(records);
    await _prefs.setString(_keyDailyRecords, json);
  }

  /// Load all daily records from storage.
  /// Returns empty map if no records exist or data is corrupted.
  Future<Map<String, dynamic>> loadDailyRecords() async {
    final json = _prefs.getString(_keyDailyRecords);
    if (json == null) return {};

    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded;
    } catch (e) {
      // Corrupted data, return empty
      return {};
    }
  }

  /// Get a specific daily record by date.
  /// Returns null if record doesn't exist.
  Future<DailyRecord?> getDailyRecord(DateTime date) async {
    final records = await loadDailyRecords();
    final key = _formatDate(date);
    final json = records[key];

    if (json == null) return null;

    return DailyRecord.fromJson(json as Map<String, dynamic>);
  }

  // ==================== Streak Calculation ====================

  /// Calculate current streak of consecutive days with any push-ups (> 0).
  /// Counts backwards from today, breaks on days with no push-ups (missed).
  /// Today is skipped if no record exists yet (workout not done).
  Future<int> calculateCurrentStreak() async {
    final records = await loadDailyRecords();
    int streak = 0;
    DateTime date = DateTime.now();

    // Check backwards from today
    for (int i = 0; i < 30; i++) {
      final key = _formatDate(date);
      final json = records[key];

      if (json == null) {
        // No record for this day
        // Check if it's today (we shouldn't break streak if today not done yet)
        if (i == 0) {
          date = date.subtract(const Duration(days: 1));
          continue;
        }
        break; // Missed day, streak broken
      }

      final recordData = json as Map<String, dynamic>;
      final totalPushups = recordData['totalPushups'] as int;

      if (totalPushups > 0) {
        // Any day with push-ups counts for the streak
        streak++;
        date = date.subtract(const Duration(days: 1));
      } else {
        // Day with 0 push-ups - break unless it's today
        if (i == 0) {
          date = date.subtract(const Duration(days: 1));
          continue;
        }
        break;
      }
    }

    return streak;
  }

  // ==================== Achievements ====================

  /// Save achievement unlock status to storage.
  Future<void> saveAchievement(Achievement achievement) async {
    final achievements = await loadAchievements();
    achievements[achievement.id] = achievement.toJson();

    final json = jsonEncode(achievements);
    await _prefs.setString(_keyAchievements, json);
  }

  /// Load all achievements from storage.
  /// Returns empty map if no achievements exist or data is corrupted.
  Future<Map<String, dynamic>> loadAchievements() async {
    final json = _prefs.getString(_keyAchievements);
    if (json == null) return {};

    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded;
    } catch (e) {
      // Corrupted data, return empty
      return {};
    }
  }

  // ==================== User Stats ====================

  /// Get aggregate user statistics from all daily records.
  Future<Map<String, dynamic>> getUserStats() async {
    final records = await loadDailyRecords();

    int totalPushupsAllTime = 0;
    int maxPushupsInOneDay = 0;
    int daysCompleted = 0;

    for (final entry in records.entries) {
      final recordData = entry.value as Map<String, dynamic>;
      final record = DailyRecord.fromJson(recordData);

      totalPushupsAllTime += record.totalPushups;
      if (record.totalPushups > maxPushupsInOneDay) {
        maxPushupsInOneDay = record.totalPushups;
      }
      if (record.goalReached) {
        daysCompleted++;
      }
    }

    return {
      'totalPushupsAllTime': totalPushupsAllTime,
      'maxPushupsInOneDay': maxPushupsInOneDay,
      'daysCompleted': daysCompleted,
      'currentStreak': await calculateCurrentStreak(),
      'maxRepsInOneSeries': 0, // TODO: Track this separately
    };
  }

  // ==================== Utilities ====================

  /// Format date as YYYY-MM-DD for storage keys.
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// Clear all data from storage (for testing or reset).
  Future<void> clearAllData() async {
    await _prefs.remove(_keyActiveSession);
    await _prefs.remove(_keyDailyRecords);
    await _prefs.remove(_keyAchievements);
  }

  /// Reset all user data from storage.
  ///
  /// Removes ALL user data including:
  /// - Active session
  /// - Daily records (all workout history)
  /// - Achievements (all unlock progress)
  /// - Workout preferences
  /// - Program start date
  ///
  /// Use with caution - this cannot be undone!
  Future<void> resetAllUserData() async {
    await _prefs.remove(_keyActiveSession);
    await _prefs.remove(_keyDailyRecords);
    await _prefs.remove(_keyAchievements);
    await _prefs.remove(_keyWorkoutPreferences);
    await _prefs.remove(_keyProgramStartDate);
  }

  // ==================== Workout Preferences ====================

  /// Save workout preferences (starting series and rest time) to storage.
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {
    final json = jsonEncode({
      'startingSeries': startingSeries,
      'restTime': restTime,
    });
    await _prefs.setString(_keyWorkoutPreferences, json);
  }

  /// Load workout preferences from storage.
  /// Returns null if no preferences exist or data is corrupted.
  Future<Map<String, dynamic>?> loadWorkoutPreferences() async {
    final json = _prefs.getString(_keyWorkoutPreferences);
    if (json == null) return null;

    try {
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return decoded;
    } catch (e) {
      // Corrupted data, clear it
      await clearWorkoutPreferences();
      return null;
    }
  }

  /// Remove workout preferences from storage.
  Future<void> clearWorkoutPreferences() async {
    await _prefs.remove(_keyWorkoutPreferences);
  }

  // ==================== Program Start Date ====================

  /// Get the program start date (first workout date).
  ///
  /// Returns null if the program hasn't started yet.
  Future<DateTime?> getProgramStartDate() async {
    final dateString = _prefs.getString(_keyProgramStartDate);
    if (dateString == null) return null;

    try {
      final parts = dateString.split('-');
      return DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    } catch (e) {
      return null;
    }
  }

  /// Save the program start date.
  ///
  /// This should be called when the user completes their first workout.
  Future<void> saveProgramStartDate(DateTime date) async {
    await _prefs.setString(_keyProgramStartDate, _formatDate(date));
  }

  /// Clear the program start date.
  Future<void> clearProgramStartDate() async {
    await _prefs.remove(_keyProgramStartDate);
  }

  // ==================== Goals & Onboarding ====================

  /// Save daily goal to storage.
  Future<void> setDailyGoal(int goal) async {
    await _prefs.setInt(_keyDailyGoal, goal);
  }

  /// Get daily goal from storage.
  /// Returns 50 as default if not set.
  int getDailyGoal() {
    return _prefs.getInt(_keyDailyGoal) ?? 50;
  }

  /// Save monthly goal to storage.
  Future<void> setMonthlyGoal(int goal) async {
    await _prefs.setInt(_keyMonthlyGoal, goal);
  }

  /// Get monthly goal from storage.
  /// Returns 1500 (50 * 30) as default if not set.
  int getMonthlyGoal() {
    return _prefs.getInt(_keyMonthlyGoal) ?? 1500;
  }

  /// Save weekly goal to storage.
  Future<void> setWeeklyGoal(int goal) async {
    await _prefs.setInt(_keyWeeklyGoal, goal);
  }

  /// Get weekly goal from storage.
  /// Returns daily goal × 5 as default if not set.
  /// This ensures weekly goal stays synced with daily goal changes.
  int getWeeklyGoal() {
    return _prefs.getInt(_keyWeeklyGoal) ?? getDailyGoal() * 5;
  }

  /// Save onboarding completion status.
  Future<void> setOnboardingCompleted(bool completed) async {
    await _prefs.setBool(_keyOnboardingCompleted, completed);
  }

  /// Check if onboarding is completed.
  /// Returns false by default (first-time users).
  bool isOnboardingCompleted() {
    return _prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  /// Reset onboarding status (for "Restart Tutorial" feature).
  Future<void> resetOnboarding() async {
    await _prefs.remove(_keyOnboardingCompleted);
  }

  // ==================== Weekly State ====================

  /// Calculate the Monday (start) of the week for any given date.
  ///
  /// Uses DateTime.weekday where 1=Monday, 7=Sunday.
  /// Returns Monday 00:00:00 of the week containing the input date.
  DateTime getWeekStart(DateTime date) {
    // weekday is 1=Monday, 7=Sunday
    // Subtract (weekday - 1) days to get to Monday
    final daysToSubtract = date.weekday - 1;
    return DateTime(date.year, date.month, date.day)
        .subtract(Duration(days: daysToSubtract));
  }

  /// Calculate the week number in "YYYY-WW" format.
  ///
  /// Returns the ISO week number within the year (1-53).
  /// Used as a key for weekly flag storage.
  String getWeekNumber(DateTime date) {
    // Calculate day of year (1-366) - counting days since Jan 1
    final janFirst = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(janFirst).inDays + 1;

    // Get weekday of Jan 1 (1=Mon, 7=Sun)
    final janFirstWeekday = janFirst.weekday;

    // Days to first Monday of the year
    // If Jan 1 is Mon (1), daysToFirstMonday = 0
    // If Jan 1 is Tue (2), daysToFirstMonday = 6 (previous Monday)
    // If Jan 1 is Wed (3), daysToFirstMonday = 5
    // If Jan 1 is Thu (4), daysToFirstMonday = 4
    // If Jan 1 is Fri (5), daysToFirstMonday = 3
    // If Jan 1 is Sat (6), daysToFirstMonday = 2
    // If Jan 1 is Sun (7), daysToFirstMonday = 1
    final daysToFirstMonday = janFirstWeekday == 1 ? 0 : 8 - janFirstWeekday;

    // Calculate week number
    // Add daysToFirstMonday to align with Monday start
    final adjustedDayOfYear = dayOfYear + daysToFirstMonday;
    final weekNumber = ((adjustedDayOfYear - 1) ~/ 7) + 1;

    // Handle edge case for late December days that belong to next year's week 1
    if (weekNumber > 52) {
      // Check if this should be week 1 of next year
      final lastDay = DateTime(date.year, 12, 31);
      final lastDayWeekday = lastDay.weekday;
      if (lastDayWeekday < 4) {
        // Last day is Mon-Wed, this is week 1 of next year
        return '${date.year + 1}-01';
      }
    }

    return '${date.year}-${weekNumber.toString().padLeft(2, '0')}';
  }

  /// Check if the weekly review popup has been shown for a given week.
  ///
  /// [weekNumber] should be in "YYYY-WW" format from [getWeekNumber].
  /// Returns false if not set (first time viewing the week).
  Future<bool> hasWeeklyReviewBeenShown(String weekNumber) async {
    return _prefs.getBool('$_keyWeeklyReviewShown$weekNumber') ?? false;
  }

  /// Mark the weekly review popup as shown for a given week.
  ///
  /// Prevents duplicate popup for the same week.
  Future<void> markWeeklyReviewShown(String weekNumber) async {
    await _prefs.setBool('$_keyWeeklyReviewShown$weekNumber', true);
  }

  /// Check if the weekly bonus has been awarded for a given week.
  ///
  /// [weekNumber] should be in "YYYY-WW" format from [getWeekNumber].
  /// Returns false if not awarded yet.
  /// Separate from review flag - bonus tracks award status independently.
  Future<bool> hasWeeklyBonusBeenAwarded(String weekNumber) async {
    return _prefs.getBool('$_keyWeeklyBonusAwarded$weekNumber') ?? false;
  }

  /// Mark the weekly bonus as awarded for a given week.
  ///
  /// Prevents duplicate bonus awards for the same week.
  Future<void> markWeeklyBonusAwarded(String weekNumber) async {
    await _prefs.setBool('$_keyWeeklyBonusAwarded$weekNumber', true);
  }

  /// Calculate consecutive weeks with any push-ups (> 0).
  ///
  /// Counts backwards from current week.
  /// Week boundary: Monday 00:00:00 to Sunday 23:59:59.
  /// Any push-ups (> 0) in the week preserves the streak.
  /// A full week with 0 push-ups breaks the streak.
  Future<int> calculateWeeklyStreak() async {
    final records = await loadDailyRecords();
    int streak = 0;

    // Start with current week
    DateTime weekStart = getWeekStart(DateTime.now());
    final today = DateTime.now();

    // Check up to 52 weeks back
    for (int i = 0; i < 52; i++) {
      bool weekHasActivity = false;
      bool weekHasAnyRecord = false;

      // Check all 7 days of the week (Mon-Sun)
      for (int dayOffset = 0; dayOffset < 7; dayOffset++) {
        final dayDate = weekStart.add(Duration(days: dayOffset));
        final dateKey = _formatDate(dayDate);

        // Skip checking future days in current week
        if (dayDate.isAfter(DateTime(today.year, today.month, today.day))) {
          continue;
        }

        if (records.containsKey(dateKey)) {
          weekHasAnyRecord = true;
          final recordData = records[dateKey] as Map<String, dynamic>;
          final totalPushups = recordData['totalPushups'] as int;
          if (totalPushups > 0) {
            weekHasActivity = true;
          }
        }
      }

      // If current week has no records yet, don't break streak (week not complete)
      if (i == 0 && !weekHasAnyRecord) {
        weekStart = weekStart.subtract(const Duration(days: 7));
        continue;
      }

      if (weekHasActivity) {
        streak++;
        weekStart = weekStart.subtract(const Duration(days: 7));
      } else {
        // Week with no activity breaks the streak
        break;
      }
    }

    return streak;
  }
}
