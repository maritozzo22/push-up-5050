import 'package:flutter/foundation.dart';
import 'package:push_up_5050/models/goal.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Provider for managing user goals and progress.
///
/// Tracks progress toward weekly, monthly, challenge, and total goals.
/// Updates progress based on user stats and workout sessions.
class GoalsProvider extends ChangeNotifier {
  final StorageService _storage;

  bool _isLoading = false;
  List<Goal> _goals = [];
  int _weeklyProgress = 0;
  int _monthlyProgress = 0;
  int _totalProgress = 0;
  int _maxSessionReps = 0;
  int _consecutiveDays = 0;
  int _completedDays = 0;

  GoalsProvider({required StorageService storage}) : _storage = storage;

  bool get isLoading => _isLoading;

  /// All active goals
  List<Goal> get goals => _goals;

  /// Weekly goals with updated progress
  List<Goal> get weeklyGoals => _goals
      .where((g) => g.type == GoalType.weekly)
      .map((g) => g.copyWith(current: _weeklyProgress))
      .toList();

  /// Monthly goals with updated progress
  List<Goal> get monthlyGoals => _goals
      .where((g) => g.type == GoalType.monthly)
      .map((g) => g.copyWith(current: _monthlyProgress))
      .toList();

  /// Challenge goals with updated progress
  List<Goal> get challengeGoals {
    final updated = <Goal>[];

    for (final goal in _goals.where((g) => g.type == GoalType.challenge)) {
      int current = 0;
      switch (goal.id) {
        case 'challenge_100':
          current = _maxSessionReps;
          break;
        case 'challenge_7days':
          current = _consecutiveDays;
          break;
        case 'challenge_30days':
          current = _completedDays;
          break;
      }
      updated.add(goal.copyWith(current: current));
    }
    return updated;
  }

  /// Total goals with updated progress
  List<Goal> get totalGoals => _goals
      .where((g) => g.type == GoalType.total)
      .map((g) => g.copyWith(current: _totalProgress))
      .toList();

  /// Get the primary daily goal (retrieved directly from storage)
  Goal get dailyGoal {
    // Get the daily target directly from storage, not calculated from weekly
    final dailyTarget = _storage.getDailyGoal();
    return Goal(
      id: 'daily_current',
      title: 'GIORNALIERA',
      description: '$dailyTarget Push-up al giorno',
      type: GoalType.weekly,
      target: dailyTarget,
      current: _weeklyProgress ~/ 7, // Approximate daily progress
      iconName: 'today',
    );
  }

  /// Get the weekly target (daily goal × 5 workout days).
  ///
  /// This represents the expected push-ups for 5 workout days per week,
  /// allowing 2 rest days while maintaining consistent progression.
  int get weeklyTarget => _storage.getWeeklyGoal();

  /// Get the primary weekly goal with current progress
  Goal get weeklyGoal {
    final weekly = weeklyGoals.isNotEmpty ? weeklyGoals.first : null;
    return weekly ?? PredefinedGoals.weekly.copyWith(current: _weeklyProgress);
  }

  /// Get the primary monthly goal with current progress
  Goal get monthlyGoal {
    final monthly = monthlyGoals.isNotEmpty ? monthlyGoals.first : null;
    return monthly ?? PredefinedGoals.monthly.copyWith(current: _monthlyProgress);
  }

  /// Load goals from storage and initialize with defaults
  Future<void> loadGoals() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load saved goals
      final saved = await _loadSavedGoals();
      _goals = saved;

      // Load stats for progress
      await _updateProgress();

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      // On error, initialize with predefined goals
      _goals = PredefinedGoals.all;
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load saved goals from storage
  Future<List<Goal>> _loadSavedGoals() async {
    // Load user's custom daily and monthly goals from storage
    // These are set during onboarding and persist across app restarts
    final dailyGoal = _storage.getDailyGoal(); // defaults to 50
    final monthlyGoal = _storage.getMonthlyGoal(); // defaults to 1500
    final weeklyGoal = _storage.getWeeklyGoal(); // auto-calculate as daily * 5

    return [
      // Weekly goal with custom target (calculated from daily)
      Goal(
        id: 'weekly_custom',
        title: PredefinedGoals.weekly.title,
        description: PredefinedGoals.weekly.description,
        type: GoalType.weekly,
        target: weeklyGoal,
        iconName: PredefinedGoals.weekly.iconName,
      ),
      // Monthly goal with custom target from storage
      Goal(
        id: 'monthly_custom',
        title: PredefinedGoals.monthly.title,
        description: PredefinedGoals.monthly.description,
        type: GoalType.monthly,
        target: monthlyGoal,
        iconName: PredefinedGoals.monthly.iconName,
      ),
      // Keep predefined challenge and total goals (unchanged)
      PredefinedGoals.total,
      PredefinedGoals.centurion,
      PredefinedGoals.perfectWeek,
      PredefinedGoals.programComplete,
    ];
  }

  /// Update progress from user stats
  Future<void> updateProgress({
    required int weeklyPushups,
    required int monthlyPushups,
    required int totalPushups,
    required int maxSessionReps,
    required int consecutiveDays,
    required int completedDays,
  }) async {
    _weeklyProgress = weeklyPushups;
    _monthlyProgress = monthlyPushups;
    _totalProgress = totalPushups;
    _maxSessionReps = maxSessionReps;
    _consecutiveDays = consecutiveDays;
    _completedDays = completedDays;

    notifyListeners();
  }

  /// Update progress from storage stats
  Future<void> _updateProgress() async {
    final allRecords = await _storage.loadDailyRecords();
    final now = DateTime.now();

    // Calculate totals
    int total = 0;
    int maxSession = 0;
    for (final entry in allRecords.entries) {
      final recordData = entry.value as Map<String, dynamic>;
      final reps = recordData['totalPushups'] as int? ?? 0;
      final sessionReps = recordData['maxSeries'] as int? ?? 0;
      total += reps;
      if (sessionReps > maxSession) maxSession = sessionReps;
    }

    // Calculate weekly (Monday to today)
    int weekly = 0;
    final todayOfWeek = now.weekday; // 1=Mon, 7=Sun
    for (int dayOffset = 0; dayOffset < todayOfWeek; dayOffset++) {
      final date = now.subtract(Duration(days: dayOffset));
      final key = _formatDate(date);
      if (allRecords.containsKey(key)) {
        final recordData = allRecords[key] as Map<String, dynamic>;
        weekly += recordData['totalPushups'] as int? ?? 0;
      }
    }

    // Calculate monthly
    int monthly = 0;
    for (final entry in allRecords.entries) {
      final dateString = entry.key as String;
      final parts = dateString.split('-');
      final year = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      if (year == now.year && month == now.month) {
        final recordData = entry.value as Map<String, dynamic>;
        monthly += recordData['totalPushups'] as int? ?? 0;
      }
    }

    // Get streak and completed days from provider's calculation
    final streak = await _storage.calculateCurrentStreak();
    int completed = 0;
    for (final entry in allRecords.entries) {
      final recordData = entry.value as Map<String, dynamic>;
      if (recordData['goalReached'] == true) {
        completed++;
      }
    }

    _weeklyProgress = weekly;
    _monthlyProgress = monthly;
    _totalProgress = total;
    _maxSessionReps = maxSession;
    _consecutiveDays = streak;
    _completedDays = completed;
  }

  /// Refresh goals progress
  Future<void> refreshGoals() async {
    await _updateProgress();
    notifyListeners();
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
