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
  static const String _keyOnboardingCompleted = 'onboarding_completed';

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
}
