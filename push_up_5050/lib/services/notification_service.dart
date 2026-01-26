import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

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
///
/// Gracefully degrades on platforms without notification support.
class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  bool _initialized = false;

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
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _initialized = result ?? false;
    return _initialized;
  }

  /// Request notification permissions.
  ///
  /// Returns true if permissions granted.
  Future<bool> requestPermissions() async {
    if (!kIsWeb && Platform.isAndroid) {
      final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      if (androidPlugin == null) return false;

      final result = await androidPlugin.requestNotificationsPermission();
      return result ?? false;
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
      return result ?? false;
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
        0, // Notification ID
        'Non perdere la tua serie!',
        'Completa i tuoi push-up oggi per mantenere il moltiplicatore.',
        scheduledTime,
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
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

  /// Cancel daily reminder notification.
  Future<void> cancelDailyReminder() async {
    try {
      await _plugin.cancel(0);
    } catch (e) {
      // Ignore cancel errors
    }
  }

  /// Test immediato notifica (per debug).
  ///
  /// Mostra una notifica di test immediata per verificare che le notifiche funzionino.
  /// Ritorna true se la notifica è stata mostrata con successo.
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

    const platformDetails = NotificationDetails(
      android: androidDetails,
    );

    try {
      await _plugin.show(
        999, // ID univoco per test
        'Test Notifica',
        'Se vedi questo, le notifiche funzionano!',
        platformDetails,
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
        998, // ID univoco per test scheduled
        'Test Notifica Programmata',
        'Notifica inviata dopo $seconds secondi',
        tz.TZDateTime.from(scheduledTime, tz.local),
        platformDetails,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
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
    // Handle navigation to workout screen
    // This will be connected to the app's navigation
    debugPrint('Notification tapped: ${response.payload}');
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
