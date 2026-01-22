# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**Push-Up 5050** is a progressive push-up training Flutter app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a goal of 50 push-ups/day within 30 consecutive days.

**Key Features**:
- Progressive series counting (manual tap OR proximity sensor)
- Real-time stats (reps, kcal: 0.45 per push-up)
- Recovery timer with color transitions (green → orange → red → flashing)
- 30-day calendar tracking
- Achievement system with points/levels
- Streak multipliers (1.0x → 2.0x based on consecutive days)

**Target Platforms**: Windows (development), Android/iOS (production)

## Development Approach

This project uses **Test-Driven Development (TDD)**. ALL code must follow the Red-Green-Refactor cycle:
1. **Write test FIRST** (test will fail - RED)
2. **Implement code** to make test pass (GREEN)
3. **Refactor** if needed (REFACTOR)
4. **Move to next feature** only when tests pass

**Never skip tests. Never write code before tests.** This is non-negotiable.

## Critical Commands

### Testing
```bash
# Run ALL tests
flutter test

# Run specific test file
flutter test test/core/constants/app_colors_test.dart

# Run integration tests
flutter test integration_test/

# Run golden tests (visual regression)
flutter test

# Update golden files (when design changes intentionally)
flutter test --update-goldens

# Check test coverage
flutter test --coverage
```

### Development
```bash
# Install dependencies
flutter pub get

# Run on Windows (development)
cd push_up_5050
flutter run -d windows

# Run on Android (testing)
flutter run -d android

# Build Android APK
flutter build apk --release

# Build iOS (via Xcode)
flutter build ios --release
```

### Build & Clean
```bash
# Clean build artifacts
flutter clean

# Analyze code for issues
flutter analyze

# Fix code formatting
dart format .
```

## Architecture & Code Organization

### Design Philosophy
The app is structured around **progressive workout sessions** with real-time state management and local persistence.

**Core Flow**:
1. User configures workout (starting series: 1/2/5/10, recovery time: 5-60s)
2. Workout begins: Series 1 = 1 push-up, Series 2 = 2 push-ups, etc.
3. Count via manual tap OR proximity sensor
4. Recovery timer between series (color-coded: green → orange → red)
5. Session persists even if app closes
6. Statistics saved to daily record (50 push-ups/day goal)

### Project Structure
```
lib/
├── core/               # Foundation layer (constants, theme, utils)
│   ├── constants/       # AppColors, AppStrings, AppSizes (centralized values)
│   ├── theme/          # AppTheme with dark theme, Montserrat font
│   └── utils/          # Calculator (kcal, points, level formulas)
├── models/             # Data models (WorkoutSession, DailyRecord, Achievement)
├── repositories/       # Storage service (shared_preferences wrapper)
├── screens/            # UI screens (home, series_selection, workout_execution, statistics)
├── widgets/            # Reusable widgets (common, workout, achievements)
└── services/           # Device services (proximity sensor, notifications, audio)
```

### State Management
- **Provider** for global state (UserStats, DailyRecords, Achievements, ActiveWorkoutSession)
- **StatefulWidget** for local state (WorkoutScreen countdown, timers)
- **Persistence** via shared_preferences (sessions, stats, achievements)

### Key Design Patterns

**WorkoutSession Model**:
- Progressive series: Series N always requires N push-ups
- Session persists across app restarts (saved immediately on each update)
- kcal = totalReps × 0.45 (constant, no weight config)
- Series complete when `repsInCurrentSeries >= currentSeries`

**Recovery Timer**:
- Color states based on remaining time: Green (100-66%) → Orange (66-33%) → Red (33-5%) → Flashing (5-0%)
- No skip button - user MUST wait full recovery
- Beep sound at 0s before next series begins

**Achievement System**:
- Pre-defined achievements (11 total) with unlock conditions
- Non-intrusive popup: slide-in from top, auto-dismiss after 3-4s
- Points formula: `(series × 10) + (push-ups × 1) + (consecutive days × 50) × multiplier`
- Multiplier: 1.0x (0-3 days) → 1.2x (4-7) → 1.5x (8-14) → 2.0x (15-30)

**Calendar & Streak**:
- Streak = consecutive days with ≥50 push-ups
- Calendar grid: 5 columns × 6 rows (30 days)
- Completed = orange with checkmark, Today = orange border, Future = gray, Missed = X

### Visual Design System

**Colors** (from AppColors):
- Primary: `#FF6B00` (orange - actions, buttons)
- Background: `#1A1A1A` (dark charcoal)
- Recovery states: `#4CAF50` (green) → `#FF9800` (orange) → `#F44336` (red)
- Text: `#FFFFFF` (primary), `#B3FFFFFF` (70% opacity secondary)

**Typography**: Montserrat font (GoogleFonts)
- Logo: 32px Bold
- Countdown number: 120px Bold
- Body: 16px Regular
- Captions: 12px Regular

**Components** (see UI_MOCKUPS.md):
- CountdownCircle: 280px diameter, radial gradient, scale animation on tap
- RecoveryTimerBar: 12px height, 6px radius, color transitions
- StatisticsBadge: 20px radius, orange circle icon (12px)
- BottomNav: 56px height, orange when selected

## Testing Strategy

**Test Coverage Goal**: 70%+ overall

**Unit Tests**: Business logic, calculations, models
- Models: WorkoutSession, DailyRecord, Achievement
- Utils: Calculator (kcal, points, levels)
- Services: StorageService (mocked SharedPreferences)

**Widget Tests**: UI components, interactions, state changes
- All screens: Home, SeriesSelection, WorkoutExecution, Statistics
- Key widgets: CountdownCircle, RecoveryTimer, AchievementPopup

**Integration Tests**: Complete user flows
- Workout flow: Setup → Exercise → Save
- Persistence: Session saves/loads correctly
- Navigation: All routes work end-to-end

**Golden Tests**: Visual regression (EVERY screen)
- Run: `flutter test --update-goldens` (initial)
- Run: `flutter test` (check for regressions)
- Update golden files ONLY when design changes intentionally

## Important Implementation Notes

### When Adding Features
1. Read PRD.md for complete specification
2. Read UI_MOCKUPS.md for exact design specs (colors, sizes, spacing)
3. Read PIP.md Phase X for implementation steps
4. Write tests FIRST (unit → widget → integration)
5. Implement to make tests pass
6. Run ALL tests: `flutter test`
7. Fix failures immediately before continuing

### Modifying Core Logic
- **Calculator utility**: All formulas centralized here (kcal, points, levels)
- **StorageService**: Wrapper around shared_preferences, handles all persistence
- **WorkoutSession**: Core workout model, MUST maintain series progression logic

### Sensor Integration
- **Proximity sensor**: Falls back to manual button ALWAYS (graceful degradation)
- **Haptic feedback**: Light vibration on each push-up count (no sound)
- **Sounds**: Beep at recovery timer 0s, achievement unlock chime

### Edge Cases (Already Specified)
- App closes mid-workout → Session persists, resumes on reopen
- Sensor unavailable → Show toast, use manual button
- Zero push-ups completed → Day not counted in streak
- Missed day → Streak resets to 0
- Storage full → Show error, continue in-memory

## File References

**Essential Reading** (in this order):
1. **PRD.md** - Complete feature specifications, user flows, edge cases
2. **UI_MOCKUPS.md** - Visual specifications for every screen (ASCII art + CSS)
3. **PIP.md** - TDD implementation plan with 10 phases

**Key Implementation Files**:
- `lib/core/constants/app_colors.dart` - All color values (use these, never hardcode)
- `lib/core/constants/app_strings.dart` - All text strings (localization-ready)
- `lib/core/utils/calculator.dart` - All calculation formulas
- `lib/models/workout_session.dart` - Core workout model with series progression
- `lib/repositories/storage_service.dart` - Local persistence wrapper

## Debugging Tips

**Tests failing?**
1. Check for Color precision issues (use `.alpha` instead of `.opacity`)
2. Verify async operations use `await`/`async`
3. Check mock setup (mockito for SharedPreferences)
4. Run single test file: `flutter test test/path/to/test.dart`

**Build errors?**
1. Run `flutter clean` then `flutter pub get`
2. Check pubspec.yaml dependencies are compatible
3. Verify asset paths exist (create placeholder files if needed)

**Golden test failures?**
1. If intentional change: `flutter test --update-goldens`
2. If regression: Fix the code, not the golden file

## Platform-Specific Notes

**Windows (Development)**:
- Use for rapid testing with Android preview
- No proximity sensor (test with manual button only)
- Sound may not work (use physical device for audio testing)

**Android (Production)**:
- Requires proximity sensor permission
- Requires notification permission for daily reminders
- Test on physical device for sensor/audio

**iOS (Production)**:
- Configure proximity sensor in Info.plist
- Configure notifications in Info.plist
- Requires physical device for sensor testing
