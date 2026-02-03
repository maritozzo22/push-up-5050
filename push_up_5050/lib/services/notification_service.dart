import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'package:android_intent_plus/android_intent.dart';
import 'package:push_up_5050/l10n/app_localizations.dart';

/// Callback type for notification tap events.
///
/// Called when user taps a notification. Payload contains notification type.
typedef NotificationTapCallback = void Function(String? payload);

/// Unique notification IDs to prevent overwriting.
class NotificationIds {
  static const int dailyReminder = 0;        // Existing - Daily workout reminder
  static const int streakAtRisk = 1;         // NEW - Streak at risk warning
  static const int progressEncouragement = 2; // NEW - Progress encouragement
  static const int weeklyChallenge = 3;      // NEW - Sunday challenge announcement
}

/// Notification channel IDs for Android system settings.
class NotificationChannels {
  static const String streak = 'streak_channel';
  static const String progress = 'progress_channel';
  static const String challenge = 'challenge_channel';
}

/// Service for managing local notifications.
///
/// Handles:
/// - Daily reminder scheduling
/// - Permission requests
/// - Notification initialization
/// - Smart notifications (streak at risk, progress, weekly challenge)
/// - Notification tap handling with deep link support
///
/// Gracefully degrades on platforms without notification support.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;
  NotificationTapCallback? _onNotificationTapCallback;
  bool? _cachedPermissionStatus;

  NotificationService() : _plugin = FlutterLocalNotificationsPlugin();

  /// Whether the service has been initialized.
  bool get isInitialized => _initialized;

  /// Initialize the notification service.
  ///
  /// Returns true if initialization successful.
  Future<bool> initialize() async {
    if (_initialized) return true;

    // Initialize timezone database
    tz_data.initializeTimeZones();

    // Android initialization settings
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization settings
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    final result = await _plugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = result ?? false;
    return _initialized;
  }

  /// Request notification permissions.
  ///
  /// Returns true if permissions granted.
  /// Caches the permission status to avoid repeated prompts.
  Future<bool> requestPermissions() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin == null) return false;

      final result = await androidPlugin.requestNotificationsPermission();
      _cachedPermissionStatus = result ?? false;
      return _cachedPermissionStatus!;
    }

    if (!kIsWeb && Platform.isIOS) {
      final iosPlugin = _plugin.resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>();

      if (iosPlugin == null) return false;

      final result = await iosPlugin.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
      _cachedPermissionStatus = result ?? false;
      return _cachedPermissionStatus!;
    }

    return true; // Default for platforms that don't need explicit permission
  }

  /// Request SCHEDULE_EXACT_ALARM permission for Android 12+.
  ///
  /// Returns true if permission granted, false otherwise.
  /// On Android < 12 or other platforms, returns true (not needed).
  Future<bool> requestExactAlarmPermission() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin == null) return false;

      // Android 12+ (API 31+) requires SCHEDULE_EXACT_ALARM permission
      final result = await androidPlugin.requestExactAlarmsPermission();
      return result ?? false;
    }

    return true; // Not needed on other platforms
  }

  /// Check if notifications are enabled without requesting permission.
  ///
  /// Returns cached status from previous permission request,
  /// or checks system settings if not cached.
  /// This is useful for UI to show notification status without prompting the user.
  Future<bool> areNotificationsEnabled() async {
    // Return cached status if available
    if (_cachedPermissionStatus != null) return _cachedPermissionStatus!;

    // Check system status if not cached
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return false;
      final enabled = await androidPlugin.areNotificationsEnabled();
      _cachedPermissionStatus = enabled ?? false;
      return _cachedPermissionStatus!;
    }

    if (!kIsWeb && Platform.isIOS) {
      // iOS doesn't have a direct check, assume true if initialized
      return _initialized;
    }

    return true; // Default for other platforms
  }

  /// Check if SCHEDULE_EXACT_ALARM permission is granted (Android 12+).
  ///
  /// Returns true if permission granted or not needed (Android < 12, other platforms).
  /// Note: flutter_local_notifications doesn't have a direct check method.
  /// This returns optimistic true - actual permission is verified when scheduling.
  Future<bool> checkExactAlarmPermission() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin == null) return false;

      // Android 12+ (API 31+) requires SCHEDULE_EXACT_ALARM permission
      // User must manually grant via system settings
      // We return true optimistically - the actual check happens on scheduling
      return true;
    }
    return true; // Not needed on other platforms
  }

  /// Open the app's notification settings in system settings.
  ///
  /// This opens the Android app settings page where users can grant
  /// POST_NOTIFICATIONS and SCHEDULE_EXACT_ALARM permissions.
  Future<void> openNotificationSettings() async {
    if (!kIsWeb && Platform.isAndroid) {
      final intent = AndroidIntent(
        action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
        data: 'package:com.pushup5050.push_up_5050',
      );
      await intent.launch();
    }
  }

  /// Get pending notifications for debugging.
  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    try {
      final pending = await _plugin.pendingNotificationRequests();
      debugPrint('NotificationService: Pending notifications count: ${pending.length}');
      for (final notification in pending) {
        debugPrint('  - ID: ${notification.id}, Title: ${notification.title}');
      }
      return pending;
    } catch (e) {
      debugPrint('NotificationService: Error getting pending notifications: $e');
      return [];
    }
  }

  /// Schedule daily reminder notification.
  ///
  /// [hour] is in 24-hour format (0-23).
  /// [minute] is 0-59.
  /// Returns true if scheduled successfully.
  Future<bool> scheduleDailyReminder({
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    // Check POST_NOTIFICATIONS permission
    final hasNotificationPermission = await requestPermissions();
    if (!hasNotificationPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted, cannot schedule reminder');
      return false;
    }

    // Try to request SCHEDULE_EXACT_ALARM permission (Android 12+)
    // Note: This opens system settings on Android 12+
    // User must manually grant the permission for scheduled notifications to work
    if (!kIsWeb && Platform.isAndroid) {
      debugPrint('NotificationService: Requesting SCHEDULE_EXACT_ALARM permission...');
      await requestExactAlarmPermission();
      debugPrint('NotificationService: Please verify permission is granted in system settings');
    }

    // Cancel any existing daily reminder
    await cancelDailyReminder();

    final scheduledTime = _nextInstanceOfTime(hour, minute);
    final now = tz.TZDateTime.now(tz.local);

    // FIX #2: Add detailed logging for debugging
    debugPrint('NotificationService: Scheduling daily reminder at $hour:$minute');
    debugPrint('NotificationService: Current time: ${now.toLocal()}');
    debugPrint('NotificationService: Scheduled time: ${scheduledTime.toLocal()}');
    debugPrint('NotificationService: Timezone: ${tz.local.name}');

    const androidDetails = AndroidNotificationDetails(
      'daily_reminder_channel',
      'Promemoria Giornaliero',
      channelDescription: 'Promemoria per completare i push-up giornalieri',
      importance: Importance.high,
      priority: Priority.high,
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _plugin.zonedSchedule(
        scheduledDate: scheduledTime,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id: 0, // Notification ID
        title: 'Non perdere la tua serie!',
        body: 'Completa i tuoi push-up oggi per mantenere il moltiplicatore.',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: Reminder scheduled successfully');
      // Verify by checking pending notifications
      await getPendingNotifications();
      return true;
    } catch (e) {
      // FIX #2: Enhanced error logging
      debugPrint('NotificationService: Failed to schedule notification: $e');
      debugPrint('NotificationService: Error type: ${e.runtimeType}');
      return false;
    }
  }

  /// Schedule daily reminder with permission guidance.
  ///
  /// Shows dialog if SCHEDULE_EXACT_ALARM permission is needed.
  /// [context] is required for showing permission dialogs.
  /// [hour] is in 24-hour format (0-23).
  /// [minute] is 0-59.
  /// Returns true if scheduled successfully.
  Future<bool> scheduleDailyReminderWithDialog({
    required BuildContext context,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final hasNotificationPermission = await requestPermissions();
    if (!hasNotificationPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted');
      if (context.mounted) {
        _showPermissionDeniedDialog(context);
      }
      return false;
    }

    // Try to schedule
    final scheduled = await scheduleDailyReminder(hour: hour, minute: minute);

    // If scheduling failed, show exact alarm permission dialog
    if (!scheduled && context.mounted) {
      await _showExactAlarmDialog(context);
    }

    return scheduled;
  }

  /// Show permission denied dialog with option to open settings.
  Future<void> _showPermissionDeniedDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          loc.notificationPermissionRequired,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Text(
          loc.notificationPermissionExplanation,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.notificationCancel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openNotificationSettings();
            },
            child: Text(
              loc.notificationOpenSettings,
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show exact alarm permission dialog with option to open settings.
  Future<void> _showExactAlarmDialog(BuildContext context) async {
    final loc = AppLocalizations.of(context)!;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1F28),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          loc.notificationExactAlarmTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Colors.white,
          ),
        ),
        content: Text(
          loc.notificationExactAlarmExplanation,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.white.withOpacity(0.80),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              loc.notificationCancel,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openNotificationSettings();
            },
            child: Text(
              loc.notificationOpenSettings,
              style: const TextStyle(
                color: Color(0xFFFFB347),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Cancel daily reminder notification.
  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(id: NotificationIds.dailyReminder);
    } catch (e) {
      // Ignore cancel errors
    }
  }

  /// Cancel a specific notification by ID.
  Future<void> cancel(int id) async {
    try {
      await _plugin.cancel(id: id);
    } catch (e) {
      // Ignore cancel errors
    }
  }

  /// Register callback for notification tap events.
  ///
  /// Called when user taps a notification. Payload contains notification type.
  void setOnNotificationTapCallback(NotificationTapCallback callback) {
    _onNotificationTapCallback = callback;
  }

  /// Schedule streak at risk notification.
  ///
  /// Sends daily reminder if user hasn't worked out in 2+ days.
  /// Uses [hour] and [minute] for personalized scheduling time.
  /// Message varies by day count (motivational on day 3, urgent on day 4+).
  /// All strings are localized by caller via AppLocalizations.
  ///
  /// Returns true if scheduled successfully.
  Future<bool> scheduleStreakAtRiskNotification({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted');
      return false;
    }

    // Cancel existing streak notification
    await cancel(NotificationIds.streakAtRisk);

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.streak,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _plugin.zonedSchedule(
        scheduledDate: scheduledTime,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id: NotificationIds.streakAtRisk,
        title: title,
        body: body,
        payload: 'streak_at_risk',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: Streak at risk notification scheduled for $hour:$minute');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Failed to schedule streak at risk: $e');
      return false;
    }
  }

  /// Schedule progress encouragement notification.
  ///
  /// Sends notification when user is within 5 push-ups of daily goal
  /// AND has completed at least 50% of goal.
  /// Only fires once per day at the scheduled time.
  /// All strings are localized by caller via AppLocalizations.
  ///
  /// Returns true if scheduled successfully.
  Future<bool> scheduleProgressNotification({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted');
      return false;
    }

    // Cancel existing progress notification
    await cancel(NotificationIds.progressEncouragement);

    final scheduledTime = _nextInstanceOfTime(hour, minute);

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.progress,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.defaultImportance,
      priority: Priority.defaultPriority,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _plugin.zonedSchedule(
        scheduledDate: scheduledTime,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id: NotificationIds.progressEncouragement,
        title: title,
        body: body,
        payload: 'progress',
        matchDateTimeComponents: DateTimeComponents.time,
      );
      debugPrint('NotificationService: Progress notification scheduled for $hour:$minute');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Failed to schedule progress: $e');
      return false;
    }
  }

  /// Schedule weekly challenge announcement notification.
  ///
  /// Sends notification on Sunday at 8:00 AM announcing new weekly challenge.
  /// Not personalized - always fires at 8:00 AM Sunday.
  /// All strings are localized by caller via AppLocalizations.
  ///
  /// Returns true if scheduled successfully.
  Future<bool> scheduleWeeklyChallengeNotification({
    required String title,
    required String body,
    required String channelName,
    required String channelDescription,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    final hasPermission = await requestPermissions();
    if (!hasPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted');
      return false;
    }

    // Cancel existing challenge notification
    await cancel(NotificationIds.weeklyChallenge);

    // Calculate next Sunday 8:00 AM
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, 8, 0);

    // Find next Sunday (weekday 7)
    while (scheduled.weekday != 7) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    // If Sunday 8AM has passed today, schedule for next Sunday
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 7));
    }

    final androidDetails = AndroidNotificationDetails(
      NotificationChannels.challenge,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _plugin.zonedSchedule(
        scheduledDate: scheduled,
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id: NotificationIds.weeklyChallenge,
        title: title,
        body: body,
        payload: 'weekly_challenge',
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
      debugPrint('NotificationService: Weekly challenge notification scheduled for Sunday 8:00 AM');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Failed to schedule weekly challenge: $e');
      return false;
    }
  }

  /// Test immediato notifica (per debug).
  ///
  /// Mostra una notifica di test immediata per verificare che le notifiche funzionino.
  /// Ritorna true se la notifica e stata mostrata con successo.
  Future<bool> showTestNotification() async {
    if (!_initialized) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('NotificationService: Failed to initialize for test notification');
        return false;
      }
    }

    // Ensure permissions are granted before showing test notification
    final hasPermissions = await requestPermissions();
    if (!hasPermissions) {
      debugPrint('NotificationService: Permissions not granted for test notification');
      return false;
    }

    const androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifiche',
      channelDescription: 'Canale per test notifiche',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _plugin.show(
        id: 999, // ID univoco per test
        title: 'Test Notifica',
        body: 'Se vedi questo, le notifiche funzionano!',
        notificationDetails: platformDetails,
      );
      debugPrint('NotificationService: Test notification sent successfully');
      return true;
    } catch (e) {
      debugPrint('NotificationService: Test notification failed: $e');
      debugPrint('NotificationService: Error type: ${e.runtimeType}');
      return false;
    }
  }

  /// Test notifica programmata (per debug).
  ///
  /// Mostra una notifica dopo il numero di secondi specificato.
  Future<bool> showScheduledTestNotification({int seconds = 5}) async {
    if (!_initialized) {
      final initialized = await initialize();
      if (!initialized) {
        debugPrint('NotificationService: Failed to initialize for scheduled test notification');
        return false;
      }
    }

    // Check POST_NOTIFICATIONS permission
    final hasNotificationPermission = await requestPermissions();
    if (!hasNotificationPermission) {
      debugPrint('NotificationService: POST_NOTIFICATIONS permission not granted');
      return false;
    }

    // Try to request SCHEDULE_EXACT_ALARM permission (Android 12+)
    // Note: This opens system settings on Android 12+
    // User must manually grant the permission for scheduled notifications to work
    if (!kIsWeb && Platform.isAndroid) {
      debugPrint('NotificationService: Requesting SCHEDULE_EXACT_ALARM permission...');
      await requestExactAlarmPermission();
      debugPrint('NotificationService: Please verify permission is granted in system settings');
    }

    final androidDetails = AndroidNotificationDetails(
      'test_channel',
      'Test Notifiche',
      channelDescription: 'Canale per test notifiche',
      importance: Importance.max,
      priority: Priority.high,
    );

    final platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      // Schedule notification for future time
      final scheduledTime = DateTime.now().add(Duration(seconds: seconds));
      await _plugin.zonedSchedule(
        scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        notificationDetails: platformDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        id: 998, // ID univoco per test scheduled
        title: 'Test Notifica Programmata',
        body: 'Notifica inviata dopo $seconds secondi',
      );
      debugPrint('NotificationService: Scheduled test notification in $seconds seconds');
      // Verify by checking pending notifications
      await getPendingNotifications();
      return true;
    } catch (e) {
      debugPrint('NotificationService: Scheduled test notification failed: $e');
      debugPrint('NotificationService: Error type: ${e.runtimeType}');
      return false;
    }
  }

  /// Handle notification tap.
  void _onNotificationTap(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');

    // Notify registered callback for deep link navigation
    _onNotificationTapCallback?.call(response.payload);
  }

  /// Calculate next occurrence of given time.
  tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// Dispose resources.
  void dispose() {
    // Nothing to dispose for notifications
  }

  /// Debug: Print all permission and notification status.
  /// Call this from settings to see the current state.
  Future<void> debugPrintStatus() async {
    debugPrint('========== NOTIFICATION SERVICE STATUS ==========');
    debugPrint('Initialized: $_initialized');

    if (!kIsWeb && Platform.isAndroid) {
      debugPrint('Platform: Android');
      debugPrint('Note: Check SCHEDULE_EXACT_ALARM in system settings');
    }

    final pending = await getPendingNotifications();
    debugPrint('Pending notifications count: ${pending.length}');
    debugPrint('==================================================');
  }
}
