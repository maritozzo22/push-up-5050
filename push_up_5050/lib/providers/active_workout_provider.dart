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
  /// Resets session achievement tracking.
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
  void countRep() {
    if (_session == null) return;
    if (_isRecovery) return;

    _session!.countRep();
    _saveSession();
    notifyListeners();
  }

  /// Start recovery period.
  ///
  /// Sets recovery state and initializes timer.
  /// User cannot count reps during recovery.
  void startRecovery() {
    if (_session == null) return;

    _isRecovery = true;
    _recoverySecondsRemaining = _session!.restTime;

    _saveSession();
    notifyListeners();
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

    // Calculate series completed from totalReps and startingSeries
    // Progressive series: startingSeries, startingSeries+1, startingSeries+2, ...
    // Example: startingSeries=5 means series 5, 6, 7, ... (not 1, 2, 3, ...)
    // A series is only counted as complete if totalReps covers it fully
    int seriesCompleted = 0;
    int repsCount = 0;
    int seriesNum = startingSeries;

    while (repsCount + seriesNum <= totalReps) {
      repsCount += seriesNum;
      seriesCompleted++;
      seriesNum++;
    }

    // Create and save daily record for today
    final today = DateTime.now();
    final existingRecord = await _storage.getDailyRecord(today);

    final record = DailyRecord.fromSession(
      today,
      totalReps,
      seriesCompleted,
    );

    if (existingRecord != null) {
      // Merge: somma ai dati esistenti per oggi
      final mergedRecord = DailyRecord(
        date: today,
        totalPushups: existingRecord.totalPushups + record.totalPushups,
        seriesCompleted: existingRecord.seriesCompleted + record.seriesCompleted,
      );
      await _storage.saveDailyRecord(mergedRecord);
    } else {
      // Nuovo record per oggi
      await _storage.saveDailyRecord(record);
    }

    // Update widgets with new workout data
    await _updateWidgetsAfterWorkout();

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
