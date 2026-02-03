# Phase 11: Android Notifications Fix - Context

## User Report

**Issue**: Android notifications are not working reliably. When pressing the test notification button in Settings, the notification appears correctly. However, scheduled notifications (daily reminder, streak at risk, progress encouragement, weekly challenge) do not appear on Android, despite notification permissions being granted.

## Current Implementation Analysis

### Files Involved

1. **lib/services/notification_service.dart**
   - Uses `flutter_local_notifications` plugin
   - Implements `scheduleDailyReminder()`, `scheduleStreakAtRiskNotification()`, `scheduleProgressNotification()`, `scheduleWeeklyChallengeNotification()`
   - Test notification (`showTestNotification()`) works correctly
   - Already requests `SCHEDULE_EXACT_ALARM` permission on Android 12+
   - Uses `AndroidScheduleMode.exactAllowWhileIdle` for smart notifications

2. **lib/services/notification_scheduler.dart**
   - Calls NotificationService methods based on user conditions
   - Schedules notifications at personalized times

3. **android/app/src/main/AndroidManifest.xml**
   - Has `POST_NOTIFICATIONS` permission (Android 13+)
   - Has `SCHEDULE_EXACT_ALARM` permission (Android 12+)
   - Has `USE_EXACT_ALARM` permission
   - Has `RECEIVE_BOOT_COMPLETED` permission (but BootReceiver not implemented)

### Root Cause Hypothesis

The most likely cause is that **SCHEDULE_EXACT_ALARM permission is not being granted by the user**:

1. On Android 12+, `requestExactAlarmsPermission()` from `flutter_local_notifications` opens system settings
2. User must manually toggle the permission ON
3. If user cancels or doesn't toggle, scheduled notifications silently fail
4. The current code doesn't verify if permission was actually granted after the settings open

Additionally:
- **No BootReceiver**: Scheduled notifications are lost after device reboot
- **No retry logic**: If permission is denied, notifications are never rescheduled
- **No UI feedback**: User doesn't know if scheduling succeeded or failed

## Notification Types

| Type | ID | Use Case | Schedule |
|------|----|----------|----------|
| Daily Reminder | 0 | Daily workout reminder | User-set time, repeats daily |
| Streak at Risk | 1 | Warning after 2+ missed days | Personalized time, repeats daily |
| Progress Encouragement | 2 | Within 5 of goal, 50%+ done | Personalized time, once per day |
| Weekly Challenge | 3 | Sunday challenge announcement | Sunday 8:00 AM, weekly |

## Testing Limitations

**Important**: Android notifications cannot be reliably tested on:
- **Emulator**: May have different behavior than physical devices
- **Web**: Notifications use different API (web notifications)
- **Windows**: No native notification scheduling

**Testing requires**:
- Physical Android device
- Android 12+ (API 31+) for SCHEDULE_EXACT_ALARM testing
- Android 13+ (API 33+) for POST_NOTIFICATIONS testing

## Success Metrics

After this phase, all notifications should:
1. **Schedule successfully** on Android 12+ with proper permission handling
2. **Persist** after device reboot (BootReceiver)
3. **Show user-friendly errors** when permissions are missing
4. **Work across Android versions** (Android 6-13+)
