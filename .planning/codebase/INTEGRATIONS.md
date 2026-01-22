# External Integrations

**Analysis Date:** 2026-01-20

## Overview

**Type:** Local-first mobile app with device integrations
**Backend:** None (all data stored locally)
**Authentication:** None (local-only app)

## External APIs & Services

**None** - This is a fully local application with no external API calls or cloud services.

## Local Device Integrations

### Proximity Sensor
**Package:** `proximity_sensor` ^1.3.8
**Location:** `lib/services/proximity_sensor_service.dart`
**Purpose:** Detect when user's chest is near device for automatic push-up counting
**Platform Support:** Android only (graceful degradation on other platforms)
**Permissions:** None required (hardware sensor)
**Fallback:** Manual tap button when sensor unavailable

### Vibration/Haptic Feedback
**Package:** `vibration` ^3.1.0
**Location:** `lib/services/haptic_feedback_service.dart`
**Purpose:** Provide tactile feedback on each rep counting
**Platform Support:** Android, iOS
**Permissions:** VIBRATE permission on Android
**Configuration:** User-adjustable intensity (Light, Medium, Heavy)

### Audio Playback
**Package:** `audioplayers` ^6.5.1
**Location:** `lib/services/audio_service.dart`
**Purpose:** Play beep sounds at recovery timer completion
**Assets:** `assets/sounds/beep.mp3` (or similar)
**Permissions:** None required
**Features:** Volume control, master mute switch

### Local Notifications
**Package:** `flutter_local_notifications` ^17.2.3
**Location:** `lib/services/notification_service.dart`
**Purpose:** Daily workout reminders at user-specified time
**Platform Support:** Android (POST_NOTIFICATIONS), iOS
**Permissions:**
- Android: POST_NOTIFICATIONS, SCHEDULE_EXACT_ALARM (Android 12+)
- iOS: Standard notification permissions
**Channels:**
- `daily_reminder_channel` - Daily workout reminders
- `test_channel` - Debug notifications

### Timezone Database
**Package:** `timezone` ^0.9.4
**Purpose:** Accurate scheduling for local notifications
**Usage:** Converting local time to proper timezone for alarm scheduling
**Data:** IANA timezone database bundled with package

## Data Persistence

### Local Storage
**Package:** `shared_preferences` ^2.2.2
**Location:** `lib/repositories/storage_service.dart`
**Purpose:** Persist all user data locally
**Data Stored:**
- Active workout sessions
- Daily workout records (full history)
- Achievement unlock status
- User preferences (settings)
- Workout preferences (starting series, rest time)
- Program start date

**Format:** JSON serialization
**Size:** Limited only by device storage (typically MB-scale)
**Encryption:** None (local-only, no sensitive data)

## File System Access

### Path Provider
**Package:** `path_provider` ^2.1.1
**Purpose:** Get application document directory paths
**Usage:** Minimal - most data uses SharedPreferences
**Platforms Supported:** Android, iOS, Windows, macOS, Linux

## Font Integration

### Google Fonts
**Package:** `google_fonts` ^6.1.0
**Font:** Montserrat
**Purpose:** App typography
**Delivery:** HTTP fetch on first launch, cached locally
**Fallback:** System sans-serif font if unavailable

## Platform-Specific Code

### Android
**Location:** `android/app/src/main/`
**Language:** Kotlin
**Purpose:** Proximity sensor platform channel (via plugin)
**Configuration:**
- `minSdkVersion`: 21
- `targetSdkVersion`: Latest (via Flutter)
- Permissions in `AndroidManifest.xml`:
  - VIBRATE (haptic feedback)
  - POST_NOTIFICATIONS (notifications)
  - SCHEDULE_EXACT_ALARM (Android 12+ alarms)
  - ACCESS_NEARBY_DEVICES (for proximity - Android 12+)

### iOS
**Location:** `ios/Runner/`
**Status:** Configured but not built (ios: false in launcher config)
**Required Entitlements:** None currently configured

## Third-Party Services (Unused)

The following are NOT integrated:
- **Firebase** - No analytics, auth, or remote config
- **AdMob** - No advertising
- **In-App Purchases** - No monetization
- **Analytics** - No user tracking or crash reporting
- **Cloud Sync** - No data synchronization

## Update Mechanism

**App Updates:** Handled by app stores (Google Play, direct APK)
**Data Migration:** Manual schema versioning in SharedPreferences would be needed

## Network Requirements

**Offline-First:** App fully functional without internet
**Optional Network:** Google Fonts fetch on first launch (falls back if unavailable)

---

*Integrations analysis: 2026-01-20*
