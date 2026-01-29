import 'package:flutter/foundation.dart';
import 'package:push_up_5050/models/achievement.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/models/workout_session.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/core/utils/calculator.dart';
import 'package:push_up_5050/services/widget_update_service.dart';

/// Provider for active workout session.
///
/// Manages the current workout session state including:
/// - Active workout session data
/// - Recovery timer state
///
/// Automatically saves session to storage on every state change.
/// Updates Android home screen widgets when workout completes.
class ActiveWorkoutProvider extends ChangeNotifier {
  final StorageService _storage;
  final WidgetUpdateService _widgetUpdateService;

  WorkoutSession? _session;
  bool _isRecovery = false;
  int _recoverySecondsRemaining = 0;

  // Achievement tracking nella sessione corrente
  final List<Achievement> _sessionAchievements = [];

  // Points tracking nella sessione corrente (real-time)
  int _sessionPoints = 0;

  /// Create a new ActiveWorkoutProvider.
  ///
  /// Requires a [StorageService] instance for data persistence
  /// and [WidgetUpdateService] for updating home screen widgets.
  ActiveWorkoutProvider({
    required StorageService storage,
    required WidgetUpdateService widgetUpdateService,
  })  : _storage = storage,
        _widgetUpdateService = widgetUpdateService;

  /// The current active workout session.
  ///
  /// Null if no session is active.
  WorkoutSession? get session => _session;

  /// Whether the workout is currently in recovery mode.
  ///
  /// During recovery, user cannot count push-ups.
  bool get isRecovery => _isRecovery;

  /// Remaining seconds in recovery period.
  ///
  /// Only meaningful when [isRecovery] is true.
  int get recoverySecondsRemaining => _recoverySecondsRemaining;

  // ==================== Session Achievement Tracking ====================

  /// Achievement sbloccati durante la sessione corrente.
  List<Achievement> get sessionAchievements => List.unmodifiable(_sessionAchievements);

  /// Numero di achievement sbloccati nella sessione corrente.
  int get sessionAchievementCount => _sessionAchievements.length;

  /// Moltiplicatore achievement della sessione corrente.
  /// 0 achievement: 1.0x, 1 achievement: 1.5x, 2: 2.0x...
  double get sessionAchievementMultiplier =>
      Calculator.getAchievementMultiplier(_sessionAchievements.length);

  /// Punti guadagnati nella sessione corrente (real-time).
  /// Si aggiorna ogni volta che viene completata una serie.
  int get sessionPoints => _sessionPoints;

  /// Check if today's daily goal has already been completed.
  ///
  /// Returns true if today's existing record totalPushups >= daily goal.
  /// Used by HomeScreen to disable start button when goal complete.
  Future<bool> isDailyGoalComplete() async {
    final today = DateTime.now();
    final existingRecord = await _storage.getDailyRecord(today);
    final todayReps = existingRecord?.totalPushups ?? 0;
    final goal = _storage.getDailyGoal();
    return todayReps >= goal;
  }

  // ==================== Workout Preferences ====================

  int? _savedStartingSeries;
  int? _savedRestTime;

  /// The last saved starting series preference.
  ///
  /// Null if no preference has been saved yet.
  int? get savedStartingSeries => _savedStartingSeries;

  /// The last saved rest time preference (in seconds).
  ///
  /// Null if no preference has been saved yet.
  int? get savedRestTime => _savedRestTime;

  /// Start a new workout session.
  ///
  /// Creates a new [WorkoutSession] with the given parameters.
  /// Saves to storage automatically.
  /// Resets session achievement and points tracking.
  Future<void> startWorkout({
    required int startingSeries,
    required int restTime,
    int? goalPushups,
  }) async {
    _session = WorkoutSession(
      startingSeries: startingSeries,
      restTime: restTime,
      goalPushups: goalPushups,
    );
    _isRecovery = false;
    _recoverySecondsRemaining = 0;
    _sessionAchievements.clear(); // Reset tracking achievement sessione
    _sessionPoints = 0; // Reset tracking punti sessione

    await _saveSession();
    notifyListeners();
  }

  /// Registra un achievement sbloccato durante la sessione.
  ///
  /// Aggiunge l'achievement alla lista sessione e notifica i listener.
  void registerSessionAchievement(Achievement achievement) {
    if (!_sessionAchievements.any((a) => a.id == achievement.id)) {
      _sessionAchievements.add(achievement);
      notifyListeners();
    }
  }

  /// Registra più achievement sbloccati durante la sessione.
  ///
  /// Aggiunge tutti gli achievement alla lista sessione e notifica i listener.
  void registerSessionAchievements(List<Achievement> achievements) {
    for (final achievement in achievements) {
      if (!_sessionAchievements.any((a) => a.id == achievement.id)) {
        _sessionAchievements.add(achievement);
      }
    }
    if (achievements.isNotEmpty) {
      notifyListeners();
    }
  }

  /// Resetta il tracking achievement della sessione.
  ///
  /// Chiamato automaticamente all'inizio di una nuova sessione.
  void clearSessionAchievements() {
    _sessionAchievements.clear();
    notifyListeners();
  }

  /// Load existing session from storage.
  ///
  /// Use this on app startup to resume an interrupted workout.
  Future<void> loadExistingSession() async {
    _session = await _storage.loadActiveSession();
    notifyListeners();
  }

  /// Count one push-up rep.
  ///
  /// Increments the rep count if:
  /// - Session is active
  /// - Not in recovery mode
  ///
  /// Automatically saves to storage.
  /// Also calculates and adds points for this rep (real-time).
  /// Checks for goal completion after each rep.
  void countRep() async {
    if (_session == null) return;
    if (_isRecovery) return;

    _session!.countRep();

    // Calculate points for this rep immediately (real-time feedback)
    await _calculateRepPoints();

    // Check for goal completion after counting rep
    await _checkGoalCompletion();

    _saveSession();
    notifyListeners();
  }

  /// Start recovery period.
  ///
  /// Sets recovery state and initializes timer.
  /// User cannot count reps during recovery.
  /// Note: Points are now calculated per rep, not per series.
  void startRecovery() async {
    if (_session == null) return;

    _isRecovery = true;
    _recoverySecondsRemaining = _session!.restTime;

    // Points are now calculated per rep in countRep()
    // No additional calculation needed here

    _saveSession();
    notifyListeners();
  }

  /// Calculate points for a single rep and add to session total.
  ///
  /// Uses a per-rep formula derived from the aggressive series formula.
  /// Formula: (RepMult per rep + SeriesMult portion) × StreakMult
  /// Where RepMult per rep = 0.3, SeriesMult portion = (seriesNumber × 0.8) / seriesNumber
  /// This gives real-time feedback as each rep is completed.
  Future<void> _calculateRepPoints() async {
    if (_session == null) return;

    final streak = await _storage.calculateCurrentStreak();

    // Current series info
    final currentSeriesNumber = _session!.currentSeries;
    final repsInCurrentSeries = _session!.repsInCurrentSeries;

    if (currentSeriesNumber < _session!.startingSeries) return;

    // Calculate points for this single rep using Calculator method
    final repPoints = Calculator.calculateRepPoints(
      seriesNumber: currentSeriesNumber,
      repNumber: repsInCurrentSeries,
      consecutiveDays: streak,
    );

    _sessionPoints += repPoints;
  }

  /// Check if daily goal has been reached during active workout.
  ///
  /// Accounts for cumulative progress across all sessions today, not just
  /// the current session. Fetches existing daily record, adds current session
  /// reps, and compares to daily goal. Sets session.goalReached when threshold met.
  ///
  /// This should be called after each rep to enable real-time goal detection.
  Future<void> _checkGoalCompletion() async {
    if (_session == null) return;

    // Get the daily goal (default 50 if not set)
    final dailyGoal = _storage.getDailyGoal();

    // No goal configured - skip check
    if (_session!.goalPushups == null && dailyGoal == 50) {
      // Use default goal
    }

    final goal = _session!.goalPushups ?? dailyGoal;

    // Get today's existing record to account for cumulative progress
    final today = DateTime.now();
    final existingRecord = await _storage.getDailyRecord(today);
    final todayReps = existingRecord?.totalPushups ?? 0;

    // Calculate cumulative total: existing today reps + current session reps
    final cumulativeTotal = todayReps + _session!.totalReps;

    // Set goal reached flag when cumulative total meets or exceeds goal
    if (cumulativeTotal >= goal && !_session!.goalReached) {
      _session!.goalReached = true;
    }
  }

  /// Advance to next series.
  ///
  /// Only works if current series is complete.
  /// Resets rep count for new series.
  void advanceToNextSeries() {
    if (_session == null) return;
    if (!_session!.isSeriesComplete()) return;

    _session!.advanceToNextSeries();
    _isRecovery = false;
    _recoverySecondsRemaining = 0;

    _saveSession();
    notifyListeners();
  }

  /// End the workout session.
  ///
  /// Marks session as inactive and clears from storage.
  /// Also creates a DailyRecord for today with the workout data.
  Future<void> endWorkout() async {
    if (_session == null) return;

    _session!.endSession();

    // Save the ended session state, then clear from storage
    await _storage.saveActiveSession(_session!);
    await _storage.clearActiveSession();

    // Capture session data before clearing the session
    final totalReps = _session!.totalReps;
    final startingSeries = _session!.startingSeries;

    _session = null;
    _isRecovery = false;
    _recoverySecondsRemaining = 0;

    // Calculate points for this workout using aggressive formula
    // Load streak for multiplier
    final streak = await _storage.calculateCurrentStreak();

    // Get today's existing record to check cap
    final today = DateTime.now();
    final existingRecord = await _storage.getDailyRecord(today);
    final dailyGoal = _storage.getDailyGoal();

    // Calculate daily cap based on total points
    // Note: TotalPoints from all records (before this workout)
    final allRecords = await _storage.loadDailyRecords();
    int totalPointsBefore = 0;
    for (final entry in allRecords.entries) {
      final recordData = entry.value as Map<String, dynamic>;
      final record = DailyRecord.fromJson(recordData);
      totalPointsBefore += record.pointsEarned;
    }

    final dailyCap = Calculator.calculateDailyCap(
      dailyGoal: dailyGoal,
      totalPoints: totalPointsBefore,
    );

    // Calculate pushups already done today
    final pushupsAlreadyDone = existingRecord?.totalPushups ?? 0;

    // Calculate series completed and points with cap enforcement in one loop
    int seriesCompleted = 0;
    int earnedPoints = 0;
    double lastMultiplier = 1.0;
    int seriesIndex = 0;
    int repsCount = 0;
    int seriesNum = startingSeries;
    int rewardedPushups = 0;
    int excessPushups = 0;

    while (repsCount + seriesNum <= totalReps) {
      final pushupsInSeries = seriesNum;
      final pushupsAfterThis = pushupsAlreadyDone + repsCount + pushupsInSeries;

      // Check if this series would exceed cap
      if (pushupsAfterThis <= dailyCap) {
        // Within cap - calculate full points
        final seriesPoints = Calculator.calculateSeriesPoints(
          seriesNumber: seriesNum,
          pushupsInSeries: pushupsInSeries,
          consecutiveDays: streak,
        );
        earnedPoints += seriesPoints;
        rewardedPushups += pushupsInSeries;
      } else if (pushupsAlreadyDone + repsCount < dailyCap) {
        // Partial series - calculate points only up to cap
        final remainingToCap = dailyCap - (pushupsAlreadyDone + repsCount);
        final partialPoints = Calculator.calculateSeriesPoints(
          seriesNumber: seriesNum,
          pushupsInSeries: remainingToCap,
          consecutiveDays: streak,
        );
        earnedPoints += ((partialPoints / pushupsInSeries) * remainingToCap).floor();
        rewardedPushups += remainingToCap;
        excessPushups += (pushupsInSeries - remainingToCap);
      } else {
        // Beyond cap - no points
        excessPushups += pushupsInSeries;
      }

      repsCount += seriesNum;
      seriesIndex++;
      seriesNum++;
    }

    // Update streak multiplier for display
    lastMultiplier = Calculator.getDayStreakMultiplier(streak);

    // Create and save daily record for today
    final record = DailyRecord(
      date: today,
      totalPushups: totalReps,
      seriesCompleted: seriesCompleted,
      pointsEarned: earnedPoints,
      multiplier: lastMultiplier,
      excessPushups: (existingRecord?.excessPushups ?? 0) + excessPushups,
    );

    if (existingRecord != null) {
      // Merge: somma ai dati esistenti per oggi
      final mergedRecord = DailyRecord(
        date: today,
        totalPushups: existingRecord.totalPushups + record.totalPushups,
        seriesCompleted: existingRecord.seriesCompleted + record.seriesCompleted,
        pointsEarned: existingRecord.pointsEarned + record.pointsEarned,
        multiplier: record.multiplier,
        excessPushups: existingRecord.excessPushups + record.excessPushups,
      );
      await _storage.saveDailyRecord(mergedRecord);
    } else {
      // Nuovo record per oggi
      await _storage.saveDailyRecord(record);
    }

    // Update widgets with new workout data
    await _updateWidgetsAfterWorkout();

    // Save workout completion time for personalized notification calculation
    await _storage.saveWorkoutCompletionTime(today);

    notifyListeners();
  }

  /// Update all home screen widgets after workout completion.
  ///
  /// Fetches the latest data from storage and builds WidgetData
  /// to reflect the completed workout stats.
  Future<void> _updateWidgetsAfterWorkout() async {
    try {
      // Get today's record for widget data
      final today = DateTime.now();
      final todayRecord = await _storage.getDailyRecord(today);

      // Get all records for calendar and streak
      final allRecords = await _storage.loadDailyRecords();
      int totalPushups = 0;
      for (final entry in allRecords.entries) {
        final recordData = entry.value as Map<String, dynamic>;
        final record = DailyRecord.fromJson(recordData);
        totalPushups += record.totalPushups;
      }

      final streak = await _storage.calculateCurrentStreak();

      // Build calendar days (last 30 days)
      final calendarDays = <CalendarDayData>[];
      final now = DateTime.now();
      for (int i = 29; i >= 0; i--) {
        final date = now.subtract(Duration(days: i));
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        final hasRecord = allRecords.containsKey(dateKey);
        calendarDays.add(CalendarDayData(
          date.day,
          hasRecord,
        ));
      }

      final widgetData = WidgetData(
        todayPushups: todayRecord?.totalPushups ?? 0,
        totalPushups: totalPushups,
        goalPushups: 5050,
        todayGoalReached: (todayRecord?.totalPushups ?? 0) >= 50,
        streakDays: streak,
        lastWorkoutDate: today,
        calendarDays: calendarDays,
      );

      await _widgetUpdateService.updateAllWidgets(widgetData);
    } catch (e) {
      // Silently fail - widgets are optional
    }
  }

  /// Tick the recovery timer.
  ///
  /// Call this every second during recovery.
  /// Returns true when recovery is complete.
  bool tickRecovery() {
    if (!_isRecovery) return false;

    _recoverySecondsRemaining--;

    if (_recoverySecondsRemaining <= 0) {
      _isRecovery = false;
      _recoverySecondsRemaining = 0;
      notifyListeners();
      return true; // Recovery complete
    }

    notifyListeners();
    return false;
  }

  /// Load workout preferences from storage.
  ///
  /// Use this to retrieve the user's last used starting series and rest time.
  Future<void> loadWorkoutPreferences() async {
    final prefs = await _storage.loadWorkoutPreferences();
    if (prefs != null) {
      _savedStartingSeries = prefs['startingSeries'] as int?;
      _savedRestTime = prefs['restTime'] as int?;
      notifyListeners();
    }
  }

  /// Save workout preferences to storage.
  ///
  /// Call this when the user changes their starting series or rest time preference.
  Future<void> saveWorkoutPreferences({
    required int startingSeries,
    required int restTime,
  }) async {
    _savedStartingSeries = startingSeries;
    _savedRestTime = restTime;
    await _storage.saveWorkoutPreferences(
      startingSeries: startingSeries,
      restTime: restTime,
    );
    notifyListeners();
  }

  /// Save session to storage.
  ///
  /// Private method called automatically on state changes.
  Future<void> _saveSession() async {
    if (_session != null) {
      await _storage.saveActiveSession(_session!);
    }
  }
}
