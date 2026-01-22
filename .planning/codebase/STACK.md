# Technology Stack

**Analysis Date:** 2026-01-20

## Languages & Runtime

**Primary Language:** Dart
- **Version:** `>=3.0.0 <4.0.0` (as per pubspec.yaml)
- **Type System:** Strong static typing with null safety
- **Runtime:** Flutter Dart VM (JIT for development, AOT for production)

**Secondary Languages:**
- **Kotlin:** Android platform code (minimal)
- **Swift:** iOS platform code (minimal, via Flutter plugins)
- **Objective-C:** iOS platform legacy code (via plugins)

## Framework

**Flutter SDK** (Core application framework)
- **Purpose:** Cross-platform mobile/desktop app development
- **Key Features:** Widget-based UI, hot reload, platform channels
- **Version Management:** SDK version controlled by Flutter installation

## Platform Targets

**Primary:**
- **Android:** minSdk 21 (Android 5.0 Lollipop)
- **iOS:** Not currently supported (ios: false in launcher config)

**Secondary (Development):**
- **Windows:** Development and testing platform
- **Web:** Not supported
- **macOS:** Configured but not a target
- **Linux:** Configured but not a target

## Dependencies

### State Management
- **provider:** ^6.1.1 - State management with ChangeNotifier pattern

### Storage & Data
- **shared_preferences:** ^2.2.2 - Key-value local persistence
- **path_provider:** ^2.1.1 - File system paths (not heavily used)

### Device Features
- **proximity_sensor:** ^1.3.8 - Hardware proximity detection for push-up counting
- **vibration:** ^3.1.0 - Haptic feedback
- **audioplayers:** ^6.5.1 - Sound playback
- **flutter_local_notifications:** ^17.2.3 - Local notification scheduling
- **timezone:** ^0.9.4 - Timezone handling for notifications

### UI Components
- **table_calendar:** ^3.0.9 - Calendar widget for statistics view
- **fl_chart:** ^0.65.0 - Chart library for weekly progress visualization
- **google_fonts:** ^6.1.0 - Typography (Montserrat font)

### Utilities
- **intl:** ^0.20.2 - Internationalization and formatting

### Flutter SDK
- **flutter_localizations:** Built-in localization support
- **cupertino_icons:** ^1.0.8 - iOS-style icons

## Development Dependencies

### Testing
- **flutter_test:** SDK - Unit and widget testing
- **integration_test:** SDK - End-to-end testing
- **golden_toolkit:** ^0.15.0 - Visual regression testing
- **mockito:** ^5.4.4 - Mocking framework for unit tests

### Code Quality
- **flutter_lints:** ^3.0.1 - Dart linter rules

### Build Tools
- **build_runner:** ^2.4.6 - Code generation (not actively used)
- **flutter_launcher_icons:** ^0.13.1 - App icon generation

## Configuration Files

**pubspec.yaml** - Dependencies and project metadata
**analysis_options.yaml** - Linting configuration
**.flutter-plugins** - Plugin tracking (generated)
**.flutter-plugins-dependencies** - Plugin dependency resolution

## Asset Structure

**Locations:**
- `assets/sounds/` - Audio feedback files
- `assets/images/` - Image assets
- `assets/launcher/` - App launcher icons

**Font:**
- Montserrat (via google_fonts package, no local font files needed)

## Build Configuration

**Android:**
- Gradle-based build
- Kotlin for platform code
- Adaptive icons with foreground/background

**iOS:**
- Not currently configured for production builds

**Windows:**
- MSVC-based build (via Flutter Windows desktop support)

---

*Stack analysis: 2026-01-20*
