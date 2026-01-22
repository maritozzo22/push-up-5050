# Push-Up 5050 - Developer Guide

> Progressive push-up training app with gamification. Flutter 3.x+, Provider state management, local-only storage.

## Quick Start

```bash
cd push_up_5050
flutter pub get
flutter run -d windows        # Development
flutter run -d android        # Testing
flutter test                  # Run ALL tests
flutter test --coverage       # With coverage report
```

**Essential Commands**:
| Command | Purpose |
|---------|---------|
| `flutter pub get` | Install dependencies |
| `flutter run -d windows` | Run on Windows (dev) |
| `flutter run -d android` | Run on Android (test) |
| `flutter test` | Run all tests |
| `flutter test --update-goldens` | Update golden files |
| `flutter clean` | Clean build artifacts |
| `flutter analyze` | Analyze code for issues |
| `dart format .` | Format code |

---

## Project Structure

```
lib/
├── core/
│   ├── constants/      # AppColors, AppSizes, AppStrings
│   ├── theme/          # AppTheme (dark theme, Montserrat)
│   ├── l10n/           # i18n (IT/EN, 77 keys)
│   └── utils/          # Calculator (kcal, points, levels)
├── models/             # WorkoutSession, DailyRecord, Achievement
├── providers/          # State management (Provider)
├── repositories/       # StorageService (shared_preferences wrapper)
├── screens/            # UI screens (9 screens implemented)
├── widgets/            # Reusable widgets
└── services/           # Proximity sensor, notifications, audio
```

**State Management**: Provider
- `UserStatsProvider`: Total push-ups, streak, level, points
- `DailyRecordsProvider`: Map<DateTime, DailyRecord>
- `AchievementsProvider`: List<Achievement> with unlock status
- `ActiveWorkoutSessionProvider`: WorkoutSession? (null if no active session)

---

## TDD Workflow (NON-NEGOTIABLE)

**Rule**: TEST FIRST → Implement → Verify

```bash
# 1. Write test (FAILS - RED)
flutter test test/path/to/test.dart

# 2. Write code to make test pass (GREEN)

# 3. Refactor if needed

# 4. Run ALL tests before proceeding
flutter test
```

**Test Types**:
| Type | Purpose | Command |
|------|---------|---------|
| Unit | Business logic, calculations | `flutter test` |
| Widget | UI components, interactions | `flutter test` |
| Integration | Complete user flows | `flutter test integration_test/` |
| Golden | Visual regression | `flutter test` (update: `--update-goldens`) |

**Coverage Target**: 70%+

---

## Design System

### Colors

| Name | HEX | Usage |
|------|-----|-------|
| Primary Orange | `#FF6B00` | Buttons, active states |
| Secondary Orange | `#FF8C00` | Gradients, highlights |
| Deep Orange-Red | `#FF4500` | Critical actions (TERMINA) |
| Background | `#1A1A1A` | Main background |
| Card Background | `#2A2A2A` | Cards, elevated surfaces |
| Recovery Full | `#4CAF50` | 100-66% remaining |
| Recovery Warning | `#FF9800` | 66-33% remaining |
| Recovery Critical | `#F44336` | 33-0% remaining |
| Text Primary | `#FFFFFF` | Main text |
| Text Secondary | `#B3FFFFFF` | 70% opacity white |

**Use**: `AppColors.primaryOrange`, `AppColors.background`, etc.

### Typography

| Style | Size | Weight | Usage |
|-------|------|--------|-------|
| Logo Title | 32px | Bold | Screen titles |
| Countdown Number | 120px | Bold | Workout circle |
| Headline Large | 40px | Bold | Workout screen title |
| Body Large | 18px | Regular | Stats badges |
| Body Medium | 16px | Regular | Body text |
| Body Small | 14px | Regular | Subtitles |
| Caption | 12px | Regular | Helper text |

**Font**: Montserrat (Google Fonts)

### Sizes

| Type | Value |
|------|-------|
| Spacing (S/M/L/XL) | 8/12/16/20 |
| Border Radius (Small/Medium/Large) | 6/12/20 |
| Button Height | 56px |
| Bottom Nav Height | 56px |
| Countdown Circle (Mobile/Desktop) | 280/320px |
| Progress Circle | 180px |

**Use**: `AppSizes.s`, `AppSizes.radiusMedium`, etc.

---

## Key Features

### Progressive Workout System

- **Series N = N push-ups** (Series 3 = 3 push-ups)
- **Starting options**: 1, 2, 5, or 10
- **Recovery timer**: 5-60 seconds (default 10s)
- **Countdown**: Decrements from target → 0
- **No skip button**: Must wait full recovery

### Dual Counting

- **Manual**: Tap large circle
- **Sensor**: Proximity sensor (≤5cm)
- **Fallback**: Manual always available
- **Feedback**: Scale animation + haptic + flash

### Statistics

- **Kcal formula**: `totalReps × 0.45`
- **Level thresholds**: <1000 (Beginner), <5000 (Intermediate), <10000 (Advanced), <25000 (Expert), 25000+ (Master)
- **Streak**: Consecutive days with ≥50 push-ups

### Points & Multipliers

```
Base Points = (Series × 10) + (Push-ups × 1) + (Consecutive Days × 50)
Multipliers: 1.0x (0-3 days), 1.2x (4-7), 1.5x (8-14), 2.0x (15-30)
Final Points = Base × Multiplier
```

### i18n

- **Languages**: IT (default), EN
- **Keys**: 77 total
- **Usage**: `AppLocalizations.of(context)!.homeTitle`
- **Bang operator**: Required (config guarantees locale exists)

---

## Code Style

### DO ✅

1. **Test First**: Always write test before implementation
2. **DRY**: Extract reusable code into widgets/utils
3. **File Size**: Keep files <200 lines when possible
4. **Constants**: Use AppColors, AppStrings, AppSizes
5. **Async/Await**: Use proper async handling

### DON'T ❌

1. **Hardcode**: Never hardcode colors/strings/sizes
2. **Skip Tests**: Never skip TDD workflow
3. **Over-engineer**: Keep solutions simple
4. **Premature Abstraction**: Don't abstract for hypothetical future use
5. **Add Features**: Stick to requirements, don't add "nice-to-haves"

### Example

```dart
// ❌ BAD
Container(color: Color(0xFFFF6B00), child: Text('Start'))

// ✅ GOOD
Container(color: AppColors.primaryOrange, child: Text(AppStrings.start))
```

---

## Platform-Specific

### Windows (Development)
- No proximity sensor → test with manual button only
- Use for rapid UI iteration
- Sound may not work → test on physical device

### Android (Production)
- **Permissions**: `proximity_sensor`, `notification`
- **Test**: Physical device required for sensor/audio
- **Build**: `flutter build apk --release`

### iOS (Production)
- **Info.plist**: Configure sensor/notification permissions
- **Test**: Physical device required
- **Build**: `flutter build ios --release` (via Xcode)

---

## Critical Files

| File | Purpose |
|------|---------|
| `lib/core/constants/app_colors.dart` | All color values |
| `lib/core/constants/app_strings.dart` | All text strings (replaced by i18n) |
| `lib/core/utils/calculator.dart` | All calculation formulas |
| `lib/models/workout_session.dart` | Core workout model |
| `lib/repositories/storage_service.dart` | Local persistence wrapper |
| `lib/l10n/app_*.arb` | Localization files (IT/EN) |

---

## Troubleshooting

### Test Failures

**Color precision issues**: Use `.alpha` instead of `.opacity`
```dart
// ❌ color.opacity
// ✅ color.alpha / 255
```

**Async operations**: Ensure all async calls use `await`
```dart
// ❌ storage.save(data);
// ✅ await storage.save(data);
```

**Golden tests**: Only update golden files if design change is intentional
```bash
# First time or intentional change:
flutter test --update-goldens

# Verify:
flutter test
```

### Build Errors

1. Run `flutter clean`
2. Run `flutter pub get`
3. Check pubspec.yaml dependencies
4. Verify asset paths exist

### Common Issues

| Issue | Solution |
|-------|----------|
| Sensor unavailable | Manual fallback always available |
| Storage full | Show error, continue in-memory |
| App closed mid-workout | Session persists, resumes on reopen |
| Zero push-ups | Day not counted in streak |

---

## Archived Documentation

Detailed specifications archived in `docs/archive/`:

| Document | Content |
|----------|---------|
| `PRD.md` | Complete feature specs, user flows, edge cases |
| `PIP.md` | TDD implementation plan, 10 phases, testing strategy |
| `UI_MOCKUPS.md` | Visual design specs, component library, screen mockups |

---

## Current Status

- **Tests**: 506/514 passing (98.4%)
- **i18n**: IT/EN complete (77 keys)
- **Screens**: 9 implemented
- **FASE 1-2**: Bottom nav, WorkoutSummaryScreen complete
- **FASE 3**: DEV.md creation (this file)

---

## Implementation Notes

### MainNavigationWrapper
- Centralized bottom navigation
- Home, Stats, Profile tabs
- Use `Navigator.pushReplacement` after workout ends

### WorkoutSummaryScreen
- Shows post-workout summary
- Series completed, total push-ups, kcal
- Called via `Navigator.pushReplacement` after `endWorkout()`

### Session Persistence
- Session saves immediately on each update
- Resumes if app closed mid-workout
- Only ends when user clicks "TERMINA"
