# Phase 11: Android Notifications Fix - Research

**Researched:** 2025-02-03
**Domain:** Flutter local notifications, Android 13+ permissions, notification channels
**Confidence:** HIGH

## Summary

This phase focuses on fixing Android notification functionality for Android 13+ (API 33+) and Android 14+ (API 34+). The app uses `flutter_local_notifications` v17.2.3, but the package has been significantly updated (current version is 20.0.0) with important changes for Android 13+ and Android 14+ compatibility.

**Key issues identified:**
1. **Android 13+ (API 33)**: Requires runtime `POST_NOTIFICATIONS` permission - users must explicitly grant it
2. **Android 14+ (API 34)**: `SCHEDULE_EXACT_ALARM` permission is no longer pre-granted - must be requested via system settings
3. **Missing broadcast receivers**: The AndroidManifest.xml lacks the `ScheduledNotificationBootReceiver` for scheduled notifications to persist after reboot
4. **Package version outdated**: Using v17.2.3 but v20.0.0 has better Android 14+ support and requires `compileSdk 35`

**Primary recommendation:** Update to `flutter_local_notifications` 20.0.0, add missing broadcast receivers to AndroidManifest.xml, implement proper permission request flow for Android 13+, and handle the SCHEDULE_EXACT_ALARM permission redirect for Android 14+.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| flutter_local_notifications | 20.0.0 | Cross-platform local notifications | Official package, actively maintained, latest has Android 14+ fixes |
| timezone | ^0.9.4 | Timezone support for scheduled notifications | Already in use, required for zonedSchedule |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| permission_handler | ^11.0.0 | Optional: more granular permission handling | If needing more control over permission requests |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| flutter_local_notifications | awesome_notifications | More features but heavier, more complex API |
| flutter_local_notifications | local_notifier | Desktop-focused, limited mobile support |

**Installation:**
```bash
# Update to latest version
flutter pub upgrade flutter_local_notifications

# Or specify version in pubspec.yaml
flutter_local_notifications: ^20.0.0
```

## Architecture Patterns

### Android Manifest Setup (CRITICAL for Android 13+)

**Current State Analysis:**
The AndroidManifest.xml has `POST_NOTIFICATIONS`, `SCHEDULE_EXACT_ALARM`, `USE_EXACT_ALARM`, and `RECEIVE_BOOT_COMPLETED` declared, but is **missing the broadcast receivers** required for scheduled notifications to work after device reboot.

**Required additions:**
```xml
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationReceiver" />
<receiver android:exported="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
        <action android:name="android.intent.action.QUICKBOOT_POWERON" />
        <action android:name="com.htc.intent.action.QUICKBOOT_POWERON"/>
    </intent-filter>
</receiver>
```

### Permission Request Pattern for Android 13+

**What:** Request POST_NOTIFICATIONS permission at runtime before showing/scheduling notifications
**When to use:** On app startup OR when user first enables notifications feature
**Example:**
```dart
// Source: https://pub.dev/packages/flutter_local_notifications
// Request permission on Android 13+
final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();

if (androidPlugin != null) {
  final result = await androidPlugin.requestNotificationsPermission();
  if (result ?? false) {
    // Permission granted, can show notifications
  } else {
    // Permission denied, show explanation or disable feature
  }
}
```

### SCHEDULE_EXACT_ALARM Pattern for Android 14+

**What:** Android 14+ requires users to manually grant SCHEDULE_EXACT_ALARM via system settings
**When to use:** When scheduling exact-time notifications (daily reminders, etc.)
**Example:**
```dart
// Source: https://pub.dev/packages/flutter_local_notifications
final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
    AndroidFlutterLocalNotificationsPlugin>();

if (androidPlugin != null) {
  final result = await androidPlugin.requestExactAlarmsPermission();
  // This opens system settings - user must manually grant
  // Check if granted with areNotificationsEnabled() or similar
}
```

### Notification Channel Initialization Pattern

**What:** Channels are created when first notification is shown; cannot be modified after creation
**When to use:** App startup OR before first notification
**Example:**
```dart
// Source: Android documentation
// Once created, channel importance/vibration CANNOT be changed
// Only name and description can be updated
const androidDetails = AndroidNotificationDetails(
  'daily_reminder_channel',  // Channel ID - must be unique
  'Promemoria Giornaliero',   // Channel name (user-visible)
  channelDescription: 'Promemoria per completare i push-up giornalieri',
  importance: Importance.high,
  priority: Priority.high,
);
```

### Anti-Patterns to Avoid
- **Requesting permissions on every notification launch:** Request once at startup or feature enable, cache result
- **Silently failing when permissions denied:** Always show user-facing explanation when permission is denied
- **Not handling Android 14's SCHEDULE_EXACT_ALARM redirect:** The permission opens system settings - user must manually enable
- **Ignoring the "deleted channel" issue:** Once a channel is created, it cannot be truly deleted - only hidden. Recreating with same ID won't update settings

## Don't Hand-Roll

Problems that look simple but have existing solutions:

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Notification scheduling from scratch | AlarmManager directly, WorkManager | flutter_local_notifications zonedSchedule | Handles timezone, daylight saving, reboot persistence |
| Permission request UI | Custom dialogs | flutter_local_notifications built-in request methods | Properly integrated with system permission dialogs |
| Channel management | Manual channel creation/deletion | flutter_local_notifications automatic channel creation | Channels are created automatically with first notification |

**Key insight:** Android notification system is complex with many edge cases (OEM battery optimizations, Do Not Disturb, channel immutability). The package handles these - custom solutions will fail on real devices.

## Common Pitfalls

### Pitfall 1: Permission Not Requested on Android 13+
**What goes wrong:** Notifications silently fail because POST_NOTIFICATIONS permission is denied by default on Android 13+
**Why it happens:** Android 13 introduced runtime notification permission - apps must explicitly request it
**How to avoid:** Always call `requestNotificationsPermission()` before scheduling/showing notifications on Android 13+
**Warning signs:** Notifications work on Android 12 but not on Android 13+ devices

### Pitfall 2: SCHEDULE_EXACT_ALARM Not Granted on Android 14+
**What goes wrong:** Scheduled notifications don't fire at exact time or at all
**Why it happens:** Android 14 no longer pre-grants SCHEDULE_EXACT_ALARM - users must manually enable in system settings
**How to avoid:** Call `requestExactAlarmsPermission()` which opens system settings, then show explanation to user
**Warning signs:** Scheduled notifications work immediately but fail after app restart or on subsequent schedules

### Pitfall 3: Missing Boot Receiver
**What goes wrong:** Scheduled notifications are lost after device reboot
**Why it happens:** Without `ScheduledNotificationBootReceiver`, the app doesn't know to reschedule after reboot
**How to avoid:** Add the broadcast receiver to AndroidManifest.xml (see Architecture Patterns above)
**Warning signs:** Notifications work until phone is restarted, then never appear again

### Pitfall 4: Channel Configuration Locked After First Use
**What goes wrong:** Cannot change notification importance, sound, or vibration after first notification
**Why it happens:** Android locks channel configuration after creation - it's user-controlled after that
**How to avoid:** Use a new channel ID if you need different settings, or guide user to system settings
**Warning signs:** Changing notification details has no effect on already-shown notifications

### Pitfall 5: Desugaring Not Configured
**What goes wrong:** Scheduled notifications crash on older Android versions
**Why it happens:** flutter_local_notifications v17+ requires desugaring for backward compatibility
**How to avoid:** Ensure `coreLibraryDesugaringEnabled = true` in build.gradle
**Warning signs:** Crash on Android 7-8 when scheduling notifications

### Pitfall 6: Using Outdated Package Version
**What goes wrong:** Missing Android 14 compatibility fixes and new APIs
**Why it happens:** Package at v17.2.3 but v20.0.0 has important updates
**How to avoid:** Update to latest version, check changelog for breaking changes
**Warning signs:** Permission methods don't work as documented, missing new APIs

## Code Examples

Verified patterns from official sources:

### Android 13+ Permission Request
```dart
// Source: https://pub.dev/packages/flutter_local_notifications
// Request POST_NOTIFICATIONS permission on Android 13+

Future<bool> requestNotificationPermission() async {
  if (!kIsWeb && Platform.isAndroid) {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    final result = await androidPlugin.requestNotificationsPermission();
    return result ?? false;
  }
  return true;
}

// Usage before showing notifications:
final hasPermission = await requestNotificationPermission();
if (!hasPermission) {
  // Show explanation to user
  return false;
}
```

### Android 14+ Exact Alarm Permission
```dart
// Source: https://pub.dev/packages/flutter_local_notifications
// Request SCHEDULE_EXACT_ALARM on Android 14+

Future<bool> requestExactAlarmPermission() async {
  if (!kIsWeb && Platform.isAndroid) {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (androidPlugin == null) return false;

    // This opens system settings - returns true if opening succeeded,
    // NOT if user granted permission
    final result = await androidPlugin.requestExactAlarmsPermission();
    return result ?? false;
  }
  return true;
}

// Usage:
await requestExactAlarmPermission();
// Note: User must manually grant in settings
// Consider showing guidance dialog
```

### Checking Permission Status
```dart
// Source: flutter_local_notifications plugin documentation
// Check if notifications are enabled

Future<bool> areNotificationsEnabled() async {
  final androidPlugin = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  if (androidPlugin == null) return false;

  return await androidPlugin.areNotificationsEnabled() ?? false;
}
```

### Opening System Notification Settings
```dart
// Source: https://github.com/MaikuB/flutter_local_notifications
// Guide user to app notification settings

Future<void> openNotificationSettings() async {
  // Using platform channel or url_launcher
  final intent = AndroidIntent(
    action: 'android.settings.APPLICATION_DETAILS_SETTINGS',
    data: 'package:com.pushup5050.push_up_5050',
  );
  await intent.launch();
}
```

### Handling Permission Denied Gracefully
```dart
// Source: Android best practices
// Show in-app dialog when permission is denied

Future<void> showPermissionDeniedDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(loc.notificationsRequired),
      content: Text(loc.notificationsDeniedExplanation),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(loc.cancel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            openNotificationSettings();
          },
          child: Text(loc.openSettings),
        ),
      ],
    ),
  );
}
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| Notifications work by default on Android | Android 13+ requires POST_NOTIFICATIONS runtime permission | Android 13 (API 33) released Aug 2022 | Apps must request permission before showing notifications |
| SCHEDULE_EXACT_ALARM pre-granted | Android 14+ no longer pre-grants exact alarm | Android 14 (API 34) released Oct 2023 | Scheduled alarms fail without user manual grant in settings |
| flutter_local_notifications v15.x | v20.0.0 with compileSdk 35 requirement | 2024-2025 updates | Better Android 14+ support, new APIs, desugaring required |

**Deprecated/outdated:**
- **Not requesting POST_NOTIFICATIONS on Android 13+:** Notifications will silently fail on Android 13+ devices
- **Assuming SCHEDULE_EXACT_ALARM is granted:** On Android 14+, users must manually enable in system settings
- **Old package versions (<17.0):** Missing Android 13+ support and other fixes

**Important:** The app currently uses `flutter_local_notifications: ^17.2.3`. The latest is 20.0.0 which requires `compileSdk 35`. The project's build.gradle uses `flutter.compileSdkVersion` which should be checked to ensure it's 35 or higher.

## Open Questions

1. **Current compileSdk and targetSdk values:** The build.gradle.kts uses `flutter.compileSdkVersion` and `flutter.targetSdkVersion` - need to verify these are 34+ (for Android 14) and 35+ (for latest plugin)

2. **Permission request UX:** Where should permission requests be made?
   - Option A: On app startup (might feel intrusive)
   - Option B: When user enables notifications in settings
   - Option C: First time scheduling a notification

3. **Notification channel migration:** If channels were created with old configuration, they persist even after app update. Should we:
   - Keep existing channel IDs (users' settings preserved)
   - Use new channel IDs (fresh configuration, but users lose custom settings)

4. **Exact alarm fallback:** If user denies SCHEDULE_EXACT_ALARM, should we:
   - Fall back to inexact scheduling (notifications may be delayed)
   - Show error and disable scheduling feature
   - Keep requesting until granted

## Current Implementation Analysis

### What's Already Working
- `NotificationService` class has `requestPermissions()` method for Android 13+
- `requestExactAlarmPermission()` method exists for Android 12+
- AndroidManifest.xml has required permissions declared
- Desugaring is enabled in build.gradle
- Package initialization happens in main.dart

### What Needs Fixing
1. **Missing broadcast receivers** in AndroidManifest.xml for scheduled notifications persistence
2. **No permission request on startup** - permissions only requested when scheduling, which is too late
3. **Package version outdated** - v17.2.3 should be updated to v20.0.0 for latest Android 14+ fixes
4. **No user-friendly error handling** when permissions are denied
5. **Exact alarm permission** opens system settings but no user guidance provided

### Recommended Fix Approach
1. Update `flutter_local_notifications` to 20.0.0
2. Add missing `<receiver>` entries to AndroidManifest.xml
3. Add permission check on first app launch or settings access
4. Implement user-friendly dialog when permission is denied
5. Add explanation when redirecting to system settings for exact alarm

## Sources

### Primary (HIGH confidence)
- [flutter_local_notifications package on pub.dev](https://pub.dev/packages/flutter_local_notifications) - Full documentation for v20.0.0
- [Android Developers - Create and manage notification channels](https://developer.android.com/develop/ui/views/notifications/channels) - Official Android notification channel documentation
- [Android Developers - Schedule exact alarms (Android 14)](https://developer.android.com/about/versions/14/changes/schedule-exact-alarms) - Android 14 exact alarm permission changes

### Secondary (MEDIUM confidence)
- [GitHub Issue - Support for Android 13 Tiramisu (API 33)](https://github.com/MaikuB/flutter_local_notifications/issues/1597) - Discussion on Android 13 POST_NOTIFICATIONS support
- [Android 14 Behavior Changes](https://developer.android.com/about/versions/14/behavior-changes-all) - Official Android 14 changes documentation

### Tertiary (LOW confidence)
- [Stack Overflow - POST_NOTIFICATIONS dialog not showing](https://stackoverflow.com/questions/75305401/android-13-post-notifications-request-permission-dialog-not-showing) - Community discussion on permission issues
- [GitHub Issue - Notifications getting deleted automatically](https://github.com/MaikuB/flutter_local_notifications/issues/2632) - Related to notification persistence issues

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Based on official pub.dev documentation
- Architecture: HIGH - Based on official Android Developers documentation
- Pitfalls: HIGH - Based on official Android documentation and verified GitHub issues

**Research date:** 2025-02-03
**Valid until:** 30 days (stable package ecosystem, but new Android versions may change requirements)

**Project-specific notes:**
- Current package: flutter_local_notifications ^17.2.3 (should update to ^20.0.0)
- Android target SDK: Uses `flutter.targetSdkVersion` (needs verification)
- Desugaring: Already enabled (good)
- Permissions declared: Yes, but missing broadcast receivers
