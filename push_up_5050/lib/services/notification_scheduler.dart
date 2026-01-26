import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';
import 'package:push_up_5050/services/notification_service.dart';
import 'package:push_up_5050/providers/notification_preferences_provider.dart';
import 'package:push_up_5050/repositories/storage_service.dart';

/// Scheduler for smart notifications based on user behavior.
///
/// Checks conditions and schedules:
/// - Streak at risk (2+ consecutive missed days)
/// - Progress encouragement (within 5 of goal, 50%+ complete)
/// - Weekly challenge (Sunday 8:00 AM, always scheduled)
class NotificationScheduler {
  final NotificationService _notificationService;
  final NotificationPreferencesProvider _preferencesProvider;
  final StorageService _storage;

  NotificationScheduler({
    required NotificationService notificationService,
    required NotificationPreferencesProvider preferencesProvider,
    required StorageService storage,
  })  : _notificationService = notificationService,
        _preferencesProvider = preferencesProvider,
        _storage = storage;

  /// Schedule all smart notifications based on current state.
  ///
  /// Should be called:
  /// - On app startup (from main.dart)
  /// - After workout completion
  /// - When stats refresh (streak may change)
  Future<void> scheduleAllSmartNotifications(BuildContext context) async {
    await checkAndScheduleStreakAtRisk(context);
    await checkAndScheduleProgress(context);
    await scheduleWeeklyChallenge(context);
  }

  /// Check streak condition and schedule streak at risk notification.
  ///
  /// Conditions:
  /// - consecutiveMissedDays >= 2
  /// - User has NOT worked out today (todayPushups == 0)
  ///
  /// If conditions met, schedule at personalized time.
  /// If conditions not met, cancel existing streak notification.
  Future<void> checkAndScheduleStreakAtRisk(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    final records = await _storage.loadDailyRecords();
    final today = DateTime.now();
    final todayKey = _formatDate(today);

    // Check if user worked out today
    final todayRecord = records[todayKey];
    final workedOutToday = todayRecord != null &&
        (todayRecord as Map<String, dynamic>)['totalPushups'] as int > 0;

    if (workedOutToday) {
      // User active today, cancel streak warning
      await _notificationService.cancel(NotificationIds.streakAtRisk);
      debugPrint('NotificationScheduler: User worked out today, streak warning canceled');
      return;
    }

    // Calculate consecutive missed days
    int missedDays = 0;
    DateTime checkDate = today.subtract(const Duration(days: 1));

    for (int i = 0; i < 30; i++) {
      final key = _formatDate(checkDate);
      if (records.containsKey(key)) {
        final recordData = records[key] as Map<String, dynamic>;
        final pushups = recordData['totalPushups'] as int;
        if (pushups > 0) break; // Found activity, stop counting
        missedDays++;
      } else if (i > 0) {
        // No record for past day = missed
        missedDays++;
      }
      checkDate = checkDate.subtract(const Duration(days: 1));
    }

    if (missedDays >= 2) {
      // Schedule streak at risk notification
      final hour = _preferencesProvider.personalizedHour;
      final minute = _preferencesProvider.personalizedMinute;

      // Choose message based on days missed
      final body = missedDays == 3
          ? loc.notificationStreakAtRiskBodyDay3
          : loc.notificationStreakAtRiskBodyDay4(missedDays);

      await _notificationService.scheduleStreakAtRiskNotification(
        title: loc.notificationStreakAtRiskTitle,
        body: body,
        channelName: loc.notificationStreakChannel,
        channelDescription: loc.notificationStreakChannelDesc,
        hour: hour,
        minute: minute,
      );
      debugPrint('NotificationScheduler: Streak at risk scheduled (missed $missedDays days)');
    } else {
      // Not at risk, cancel if exists
      await _notificationService.cancel(NotificationIds.streakAtRisk);
    }
  }

  /// Check progress condition and schedule progress notification.
  ///
  /// Conditions (NOTIF-02 requirement):
  /// - todayPushups >= dailyGoal * 0.5 (50% complete)
  /// - todayPushups <= dailyGoal - 5 (within 5 of goal)
  /// - NOT already at goal
  ///
  /// If conditions met, schedule at personalized time.
  /// Note: Actual condition check happens at scheduled time.
  Future<void> checkAndScheduleProgress(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    final dailyGoal = _storage.getDailyGoal();
    final todayRecord = await _storage.getDailyRecord(DateTime.now());
    final todayPushups = todayRecord?.totalPushups ?? 0;

    // Calculate thresholds per NOTIF-02:
    // - 50% threshold: dailyGoal * 0.5
    // - Near goal threshold: dailyGoal - 5
    final halfGoal = (dailyGoal * 0.5).floor();
    final nearGoal = dailyGoal - 5;

    // Only schedule if in the "progress zone" (both conditions must be true)
    if (todayPushups >= halfGoal && todayPushups <= nearGoal) {
      final hour = _preferencesProvider.personalizedHour;
      final minute = _preferencesProvider.personalizedMinute;

      await _notificationService.scheduleProgressNotification(
        title: loc.notificationProgressTitle,
        body: loc.notificationProgressBody,
        channelName: loc.notificationProgressChannel,
        channelDescription: loc.notificationProgressChannelDesc,
        hour: hour,
        minute: minute,
      );
      debugPrint('NotificationScheduler: Progress notification scheduled ($todayPushups pushups, goal: $dailyGoal)');
    } else {
      // Outside progress zone, cancel if exists
      await _notificationService.cancel(NotificationIds.progressEncouragement);
    }
  }

  /// Schedule weekly challenge notification (Sunday 8:00 AM).
  ///
  /// This notification is NOT personalized - always fires Sunday at 8:00 AM.
  /// Should be scheduled once and repeats weekly.
  Future<void> scheduleWeeklyChallenge(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;

    await _notificationService.scheduleWeeklyChallengeNotification(
      title: loc.notificationChallengeTitle,
      body: loc.notificationChallengeBody,
      channelName: loc.notificationChallengeChannel,
      channelDescription: loc.notificationChallengeChannelDesc,
    );
    debugPrint('NotificationScheduler: Weekly challenge notification scheduled');
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
