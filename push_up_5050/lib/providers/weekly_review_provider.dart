import 'package:flutter/foundation.dart';
import 'package:push_up_5050/repositories/storage_service.dart';
import 'package:push_up_5050/models/daily_record.dart';

enum GoalAdjustment {
  maintain,
  increase10,
  increase20,
  decrease10,
  decrease20,
  decrease30,
}

class WeeklyReviewProvider extends ChangeNotifier {
  final StorageService _storage;

  int _weeklyTotal = 0;
  int _weeklyTarget = 0;
  int _weeklyBonus = 0;
  bool _targetReached = false;

  WeeklyReviewProvider({required StorageService storage})
      : _storage = storage;

  // Getters
  int get weeklyTotal => _weeklyTotal;
  int get weeklyTarget => _weeklyTarget;
  int get weeklyBonus => _weeklyBonus;
  bool get targetReached => _targetReached;

  // Current progress percentage (0.0 to 1.0)
  double get progressPercent {
    if (_weeklyTarget == 0) return 0.0;
    return (_weeklyTotal / _weeklyTarget).clamp(0.0, 1.0);
  }

  /// Load weekly data and calculate bonus
  Future<void> loadWeeklyData(int weeklyTotal, int weeklyTarget) async {
    _weeklyTotal = weeklyTotal;
    _weeklyTarget = weeklyTarget;
    _targetReached = weeklyTotal >= weeklyTarget;

    if (_targetReached) {
      _weeklyBonus = calculateWeeklyBonus(weeklyTotal, weeklyTarget);
    }

    notifyListeners();
  }

  /// Calculate weekly bonus points
  /// Base: 500 points for reaching target
  /// Overachievement: 0.5 points per excess pushup
  /// Cap: 250 bonus points for excess (max 750 total)
  int calculateWeeklyBonus(int total, int target) {
    const baseBonus = 500;
    const excessRate = 0.5;
    const maxExcessBonus = 250;

    if (total < target) return 0;

    final excess = total - target;
    final excessBonus = (excess * excessRate).floor().clamp(0, maxExcessBonus);

    return baseBonus + excessBonus;
  }

  /// Calculate new goal based on adjustment selection
  /// Enforces bounds: min 30, max 100
  int calculateAdjustedGoal(int currentGoal, GoalAdjustment adjustment) {
    const minGoal = 30;
    const maxGoal = 100;

    int newGoal;
    switch (adjustment) {
      case GoalAdjustment.maintain:
        newGoal = currentGoal;
        break;
      case GoalAdjustment.increase10:
        newGoal = (currentGoal * 1.1).floor();
        break;
      case GoalAdjustment.increase20:
        newGoal = (currentGoal * 1.2).floor();
        break;
      case GoalAdjustment.decrease10:
        newGoal = (currentGoal * 0.9).floor();
        break;
      case GoalAdjustment.decrease20:
        newGoal = (currentGoal * 0.8).floor();
        break;
      case GoalAdjustment.decrease30:
        newGoal = (currentGoal * 0.7).floor();
        break;
    }

    return newGoal.clamp(minGoal, maxGoal);
  }

  /// Calculate months to reach 50 push-ups at new daily goal
  int calculateMonthsToGoal(int newDailyGoal) {
    const targetPushups = 50;
    const currentPushups = 0; // Simplified - in reality would track progress
    final remaining = targetPushups - currentPushups;
    final daysNeeded = (remaining / newDailyGoal).ceil();
    return (daysNeeded / 30).ceil().clamp(1, 12);
  }

  /// Apply goal adjustment and save to storage
  Future<void> applyGoalAdjustment(GoalAdjustment adjustment) async {
    final currentDailyGoal = _storage.getDailyGoal();
    final newDailyGoal = calculateAdjustedGoal(currentDailyGoal, adjustment);

    await _storage.setDailyGoal(newDailyGoal);
    await _storage.setWeeklyGoal(newDailyGoal * 5);

    notifyListeners();
  }

  /// Award weekly bonus points to today's record
  Future<void> awardWeeklyBonus(String weekNumber) async {
    if (_weeklyBonus == 0) return;

    final today = DateTime.now();
    final existingRecord = await _storage.getDailyRecord(today);

    final updatedRecord = DailyRecord(
      date: today,
      totalPushups: existingRecord?.totalPushups ?? 0,
      seriesCompleted: existingRecord?.seriesCompleted ?? 0,
      pointsEarned: (existingRecord?.pointsEarned ?? 0) + _weeklyBonus,
      multiplier: existingRecord?.multiplier ?? 1.0,
      excessPushups: existingRecord?.excessPushups ?? 0,
    );

    await _storage.saveDailyRecord(updatedRecord);
    await _storage.markWeeklyBonusAwarded(weekNumber);
  }
}
