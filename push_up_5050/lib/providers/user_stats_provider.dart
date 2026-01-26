import 'package:flutter/foundation.dart';
import 'package:push_up_5050/models/daily_record.dart';
import 'package:push_up_5050/models/widget_data.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/services/widget_update_service.dart';

/// Provider for user statistics.
///
/// Manages aggregate statistics across all workout sessions:
/// - Today's push-ups
/// - Current streak
/// - Total push-ups all time
/// - Days completed (goal reached)
/// - Program start date and program day records
///
/// Loads data from StorageService and notifies listeners when data changes.
/// Updates Android home screen widgets when stats are refreshed.
class UserStatsProvider extends ChangeNotifier {
  final StorageService _storage;
  final WidgetUpdateService _widgetUpdateService;

  bool _isLoading = true;
  int _todayPushups = 0;
  int _currentStreak = 0;
  int _totalPushupsAllTime = 0;
  int _daysCompleted = 0;
  DateTime? _programStartDate;
  List<DailyRecord?> _programDayRecords = [];
  int _consecutiveMissedDays = 0;
  int _totalPoints = 0;
  int _weeklyStreak = 0;
  bool _streakFreezeActive = false;
  int _remainingStreakFreezes = 1;

  /// Create a new UserStatsProvider.
  ///
  /// Requires a [StorageService] instance for data persistence
  /// and [WidgetUpdateService] for updating home screen widgets.
  UserStatsProvider({
    required StorageService storage,
    required WidgetUpdateService widgetUpdateService,
  })  : _storage = storage,
        _widgetUpdateService = widgetUpdateService;

  /// Whether stats are currently being loaded.
  bool get isLoading => _isLoading;

  /// Number of push-ups completed today.
  int get todayPushups => _todayPushups;

  /// Current streak of consecutive days with ≥50 push-ups.
  int get currentStreak => _currentStreak;

  /// Total push-ups completed all time.
  int get totalPushupsAllTime => _totalPushupsAllTime;

  /// Number of days where 50+ push-up goal was reached.
  int get daysCompleted => _daysCompleted;

  /// Program start date (first workout date).
  DateTime? get programStartDate => _programStartDate;

  /// Program day records for the 30-day program.
  ///
  /// List of 30 elements where each element is:
  /// - `DailyRecord` if a record exists for that program day
  /// - `null` if no record exists (missed day)
  ///
  /// Ordered from day 1 (first workout) to day 30.
  List<DailyRecord?> get programDayRecords => _programDayRecords;

  /// Number of consecutive days missed (streak at risk warning).
  int get consecutiveMissedDays => _consecutiveMissedDays;

  /// Total points earned across all workout sessions.
  int get totalPoints => _totalPoints;

  /// Weekly streak of consecutive weeks with any push-ups (> 0).
  int get weeklyStreak => _weeklyStreak;

  /// Whether streak freeze is currently active for this week.
  bool get streakFreezeActive => _streakFreezeActive;

  /// Remaining streak freezes for the current month (0 or 1).
  int get remainingStreakFreezes => _remainingStreakFreezes;

  /// Total push-ups for the current week.
  ///
  /// Calculates from Monday to today using last30DaysRecords.
  int get weekTotal => _computeWeekTotal();

  /// Week progress as a fraction (0.0 to 1.0).
  ///
  /// Based on weekTotal vs weekly goal (250 = 50/day × 5 workout days).
  double get weekProgress => _computeWeekProgress();

  /// Weekly series data for the chart (7 days, Mon-Sun).
  ///
  /// Returns normalized values (0.0-1.0) for each day.
  /// Days in the future return 0.0.
  List<double> get weekSeries => _computeWeekSeries();

  /// Weekly goal in pushups (50 per day × 5 workout days).
  static const int weeklyGoal = 250;

  /// Daily goal in pushups.
  static const int dailyGoal = 50;

  /// Daily records for the last 30 days.
  ///
  /// List of 30 elements where each element is:
  /// - `DailyRecord` if a record exists for that day
  /// - `null` if no record exists (missed day)
  ///
  /// Ordered from oldest (index 0) to today (index 29).
  List<DailyRecord?> _last30DaysRecords = [];

  /// All daily records from storage for monthly calendar.
  ///
  /// Map of date strings (YYYY-MM-DD) to record data.
  Map<String, dynamic> _allDailyRecords = {};

  /// Get daily records for the last 30 days.
  ///
  /// Returns a list of 30 elements ordered from oldest to today.
  /// `null` indicates a missed day (no record in storage).
  List<DailyRecord?> get last30DaysRecords => _last30DaysRecords;

  /// Get completed days for the current month (1-31).
  ///
  /// Returns a set of day numbers that have ≥50 pushups in the current month.
  Set<int> get monthlyCompletedDays => _computeMonthlyCompletedDays();

  /// Get missed days for the current month (1-31).
  ///
  /// Returns a set of day numbers in the current month that have no record.
  Set<int> get monthlyMissedDays => _computeMonthlyMissedDays();

  /// Get blocked days for the current month (1-31).
  ///
  /// Returns a set of day numbers BEFORE the first workout in the current month.
  /// These days should be displayed as locked/gray (not missed, just blocked).
  Set<int> get monthlyBlockedDays => _computeMonthlyBlockedDays();

  /// Load stats from storage.
  ///
  /// Fetches today's record, all records, and calculates aggregate stats.
  /// Notifies listeners when complete.
  Future<void> loadStats() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get today's record
      final todayRecord = await _storage.getDailyRecord(DateTime.now());
      _todayPushups = todayRecord?.totalPushups ?? 0;

      // Get all records and calculate totals
      final allRecords = await _storage.loadDailyRecords();
      _allDailyRecords = allRecords; // Store for monthly calendar
      _totalPushupsAllTime = 0;
      _daysCompleted = 0;
      _totalPoints = 0;

      for (final entry in allRecords.entries) {
        final recordData = entry.value as Map<String, dynamic>;
        final record = DailyRecord.fromJson(recordData);

        _totalPushupsAllTime += record.totalPushups;
        _totalPoints += record.pointsEarned;
        if (record.goalReached) {
          _daysCompleted++;
        }
      }

      // Get streak from storage
      _currentStreak = await _storage.calculateCurrentStreak();
      _weeklyStreak = await _storage.calculateWeeklyStreak();

      // Load streak freeze state
      _streakFreezeActive = await _storage.isStreakFreezeActive();
      _remainingStreakFreezes = await _storage.getStreakFreezeAllowance();

      // Load program start date
      _programStartDate = await _storage.getProgramStartDate();

      // If no program start date but we have records, set it to the first record date
      if (_programStartDate == null && allRecords.isNotEmpty) {
        // Find the oldest record date
        DateTime? oldestDate;
        for (final entry in allRecords.entries) {
          final dateString = entry.key as String;
          final parts = dateString.split('-');
          final date = DateTime(
            int.parse(parts[0]),
            int.parse(parts[1]),
            int.parse(parts[2]),
          );
          if (oldestDate == null || date.isBefore(oldestDate)) {
            oldestDate = date;
          }
        }
        if (oldestDate != null) {
          _programStartDate = oldestDate;
          await _storage.saveProgramStartDate(oldestDate);
        }
      }

      // Load last 30 days records for calendar (legacy)
      _last30DaysRecords = _computeLast30DaysRecords(allRecords);

      // Load program day records for new calendar
      _programDayRecords = _computeProgramDayRecords(allRecords);
      _consecutiveMissedDays = _computeConsecutiveMissedDays(allRecords);

      _isLoading = false;
      notifyListeners();

      // Update widgets with fresh data
      await _updateWidgets();
    } catch (e) {
      // On error, set loading to false but keep values at 0
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update all home screen widgets with current stats data.
  ///
  /// Uses WidgetUpdateService.buildWidgetData() to create widget data
  /// enriched with calendar information (when calendar service is available).
  /// Triggers widget updates via updateAllWidgets().
  Future<void> _updateWidgets() async {
    try {
      // Build widget data using WidgetUpdateService.buildWidgetData()
      // This will include calendar data if calendar service is available
      final widgetData = await _widgetUpdateService.buildWidgetData(
        todayPushups: _todayPushups,
        totalPushups: _totalPushupsAllTime,
        goalPushups: 5050,
        streakDays: _currentStreak,
        totalPoints: _totalPoints,
        lastWorkoutDate: _allDailyRecords.isNotEmpty
            ? _getLastWorkoutDate()
            : null,
        allDailyRecords: _allDailyRecords,
      );

      await _widgetUpdateService.updateAllWidgets(widgetData);
    } catch (e) {
      // Silently fail - widgets are optional
    }
  }

  /// Get the date of the most recent workout from all daily records.
  DateTime? _getLastWorkoutDate() {
    if (_allDailyRecords.isEmpty) return null;
    DateTime? latestDate;
    for (final entry in _allDailyRecords.entries) {
      final dateString = entry.key as String;
      final parts = dateString.split('-');
      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
      if (latestDate == null || date.isAfter(latestDate)) {
        latestDate = date;
      }
    }
    return latestDate;
  }

  /// Compute the last 30 days records from all records map.
  ///
  /// Returns a list of 30 elements ordered from oldest to today.
  /// `null` indicates a missed day (no record in storage).
  List<DailyRecord?> _computeLast30DaysRecords(
      Map<String, dynamic> allRecords) {
    final List<DailyRecord?> result = [];
    final now = DateTime.now();

    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (allRecords.containsKey(dateKey)) {
        final recordData = allRecords[dateKey] as Map<String, dynamic>;
        result.add(DailyRecord.fromJson(recordData));
      } else {
        result.add(null); // Missed day
      }
    }

    return result;
  }

  /// Compute the program day records from all records map.
  ///
  /// Returns a list of 30 elements ordered from program start date.
  /// Each element represents one day in the 30-day program.
  /// `null` indicates a missed day (no record in storage).
  List<DailyRecord?> _computeProgramDayRecords(
      Map<String, dynamic> allRecords) {
    final List<DailyRecord?> result = [];

    if (_programStartDate == null) {
      // No program start date, return empty list
      return List.generate(30, (_) => null);
    }

    final startDate = _programStartDate!;
    final now = DateTime.now();

    // Generate 30 program days starting from program start date
    for (int i = 0; i < 30; i++) {
      final date = startDate.add(Duration(days: i));

      // Only add records for dates that are not in the future
      if (date.isAfter(DateTime(now.year, now.month, now.day))) {
        result.add(null); // Future day
      } else {
        final dateKey =
            '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

        if (allRecords.containsKey(dateKey)) {
          final recordData = allRecords[dateKey] as Map<String, dynamic>;
          result.add(DailyRecord.fromJson(recordData));
        } else {
          result.add(null); // Missed day
        }
      }
    }

    return result;
  }

  /// Compute consecutive missed days from today going backwards.
  ///
  /// Counts how many days in a row the user has missed (no record).
  /// Returns 0 if today has a record or no records exist.
  int _computeConsecutiveMissedDays(Map<String, dynamic> allRecords) {
    int missedCount = 0;
    final now = DateTime.now();

    for (int i = 0; i < 30; i++) {
      final date = now.subtract(Duration(days: i));
      final dateKey =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      if (allRecords.containsKey(dateKey)) {
        // Found a record, stop counting
        break;
      } else {
        // No record for this day
        // Skip today if it's not over yet (user might still work out)
        if (i == 0) {
          // Check if there are any records at all
          if (allRecords.isEmpty) {
            return 0;
          }
          continue;
        }
        missedCount++;
      }
    }

    return missedCount;
  }

  /// Compute total pushups for the current week (Monday to today).
  int _computeWeekTotal() {
    if (_last30DaysRecords.isEmpty) return 0;

    final now = DateTime.now();
    // Monday = 1, Sunday = 7 in DateTime.weekday
    final todayOfWeek = now.weekday;

    // Calculate days from Monday to today
    // _last30DaysRecords is ordered from oldest (index 0) to today (index 29)
    // So today is at index 29, yesterday at 28, etc.
    int total = 0;
    for (int dayOffset = 0; dayOffset < todayOfWeek; dayOffset++) {
      final index = 29 - dayOffset;
      if (index >= 0 && index < _last30DaysRecords.length) {
        total += _last30DaysRecords[index]?.totalPushups ?? 0;
      }
    }
    return total;
  }

  /// Compute week progress as fraction (0.0 to 1.0).
  double _computeWeekProgress() {
    final total = _computeWeekTotal();
    if (weeklyGoal == 0) return 0.0;
    return (total / weeklyGoal).clamp(0.0, 1.0);
  }

  /// Compute weekly series data for chart (7 days, Mon-Sun).
  ///
  /// Returns normalized values where 1.0 = daily goal (50 pushups).
  /// Future days (after today) return 0.0.
  List<double> _computeWeekSeries() {
    final now = DateTime.now();
    final todayOfWeek = now.weekday; // 1=Mon, 7=Sun
    final series = <double>[];

    // _last30DaysRecords: index 29 = today, 28 = yesterday, etc.
    for (int dayOfWeek = 1; dayOfWeek <= 7; dayOfWeek++) {
      if (dayOfWeek > todayOfWeek) {
        // Future day
        series.add(0.0);
      } else {
        final dayOffset = todayOfWeek - dayOfWeek;
        final index = 29 - dayOffset;
        if (index >= 0 && index < _last30DaysRecords.length) {
          final pushups = _last30DaysRecords[index]?.totalPushups ?? 0;
          // Normalize: 1.0 = dailyGoal (50), max 1.5 for exceptional days
          final normalized = (pushups / dailyGoal).clamp(0.0, 1.5);
          series.add(normalized);
        } else {
          series.add(0.0);
        }
      }
    }
    return series;
  }

  /// Refresh stats from storage.
  ///
  /// Same as [loadStats] but can be called after initial load.
  Future<void> refreshStats() async {
    await loadStats();
  }

  /// Manually activate streak freeze for the current week.
  ///
  /// Checks if user has remaining freezes (> 0).
  /// If successful, updates state and notifies listeners.
  /// Returns true if activation succeeded, false if no freezes available.
  Future<bool> activateStreakFreeze() async {
    if (_remainingStreakFreezes <= 0) return false;

    final activated = await _storage.useStreakFreeze();
    if (activated) {
      _streakFreezeActive = true;
      _remainingStreakFreezes = await _storage.getStreakFreezeAllowance();
      notifyListeners();
    }
    return activated;
  }

  /// Compute completed days for the current month.
  ///
  /// Returns a set of day numbers (1-31) that have any pushups (> 0).
  Set<int> _computeMonthlyCompletedDays() {
    final completed = <int>{};
    final now = DateTime.now();

    for (final entry in _allDailyRecords.entries) {
      final dateString = entry.key as String; // "2025-01-16"
      final parts = dateString.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Only include days from current month
      if (year == now.year && month == now.month) {
        final recordData = entry.value as Map<String, dynamic>;
        final record = DailyRecord.fromJson(recordData);
        if (record.totalPushups > 0) {
          completed.add(day);
        }
      }
    }
    return completed;
  }

  /// Compute missed days for the current month.
  ///
  /// Returns a set of day numbers (1-31) in the current month
  /// that have no record and are in the past (not today or future).
  /// Days BEFORE the first workout are NOT marked as missed (they're blocked).
  /// Only days AFTER the last consecutive workout are marked as missed.
  Set<int> _computeMonthlyMissedDays() {
    final missed = <int>{};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Find first workout in current month
    final firstWorkout = _getFirstWorkoutDateInCurrentMonth();
    if (firstWorkout == null) return missed; // No workouts this month

    // Find last consecutive workout (going backwards from today)
    final lastConsecutive = _getLastConsecutiveWorkoutDate();

    for (int day = 1; day <= 31; day++) {
      // Check if this day exists in current month
      try {
        final date = DateTime(now.year, now.month, day);
        // Skip if date is in the future or today
        if (date.isAfter(today) || date.isAtSameMomentAs(today)) {
          continue;
        }
      } catch (_) {
        // Invalid day for this month (e.g., Feb 30)
        continue;
      }

      // Skip days before first workout (these are blocked, not missed)
      if (day < firstWorkout.day) {
        continue;
      }

      // Determine reference date (last consecutive or first workout)
      final referenceDate = lastConsecutive ?? firstWorkout;

      // Skip days on or before reference (these days are "ok")
      if (day <= referenceDate.day) {
        continue;
      }

      // Format date key
      final dateKey = '${now.year}-${now.month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}';

      // If no record exists for this day AND it's after the reference, it's missed
      if (!_allDailyRecords.containsKey(dateKey)) {
        missed.add(day);
      }
    }
    return missed;
  }

  /// Compute blocked days for the current month.
  ///
  /// Returns a set of day numbers (1-31) BEFORE the first workout in current month.
  /// Days before the first workout should be shown as locked/gray, not missed.
  Set<int> _computeMonthlyBlockedDays() {
    final blocked = <int>{};
    final now = DateTime.now();

    // Find first workout date in current month
    DateTime? firstWorkoutInMonth = _getFirstWorkoutDateInCurrentMonth();

    if (firstWorkoutInMonth != null) {
      // Block all days before the first workout
      for (int day = 1; day < firstWorkoutInMonth.day; day++) {
        blocked.add(day);
      }
    }

    return blocked;
  }

  /// Get the first workout date in the current month.
  ///
  /// Returns null if no workout exists in current month.
  DateTime? _getFirstWorkoutDateInCurrentMonth() {
    final now = DateTime.now();
    DateTime? firstDate;

    for (final entry in _allDailyRecords.entries) {
      final dateString = entry.key as String;
      final parts = dateString.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final day = int.parse(parts[2]);

      // Only consider records from current month
      if (year == now.year && month == now.month) {
        final date = DateTime(year, month, day);
        if (firstDate == null || date.isBefore(firstDate)) {
          firstDate = date;
        }
      }
    }

    return firstDate;
  }

  /// Get the last consecutive workout date going backwards from today.
  /// Returns the date of the most recent day with a workout record,
  /// searching backwards from today. This is used to determine
  /// which days should be marked as "missed" vs "blocked".
  DateTime? _getLastConsecutiveWorkoutDate() {
    if (_allDailyRecords.isEmpty) return null;

    final now = DateTime.now();
    DateTime checkDate = now;

    // Go back day by day until we find a record
    for (int i = 0; i < 365; i++) {
      final dateKey = '${checkDate.year}-'
          '${checkDate.month.toString().padLeft(2, '0')}-'
          '${checkDate.day.toString().padLeft(2, '0')}';

      if (_allDailyRecords.containsKey(dateKey)) {
        return checkDate; // Found last consecutive workout date
      }

      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    return null;
  }
}
