# Codebase Structure

**Analysis Date:** 2026-01-20

## Directory Layout

```
push_up_5050/
├── lib/                        # Main application source code
│   ├── core/                   # Foundation layer
│   │   ├── constants/          # AppColors, AppStrings, AppSizes
│   │   ├── theme/              # AppTheme configuration
│   │   ├── utils/              # Calculator (formulas)
│   │   └── router.dart         # Navigation route constants
│   ├── l10n/                   # Generated localization files
│   ├── models/                 # Data models
│   ├── providers/             # State management
│   ├── repositories/           # Data persistence
│   ├── screens/                # UI screens
│   │   ├── home/               # Home screen
│   │   ├── series_selection/   # Workout setup
│   │   ├── workout_execution/  # Active workout
│   │   ├── workout_summary/    # Post-workout summary
│   │   ├── statistics/        # Progress tracking
│   │   ├── achievements/       # Achievements display
│   │   ├── profile/            # User profile
│   │   └── settings/          # App settings
│   ├── services/               # Device services
│   └── widgets/               # Reusable widgets
│       ├── common/            # Shared components
│       ├── design_system/    # Core design elements
│       ├── workout/           # Workout-specific
│       ├── statistics/        # Data visualization
│       ├── goals/             # Goal tracking
│       └── profile/          # Profile components
├── test/                      # Unit and widget tests
│   ├── core/                  # Core layer tests
│   ├── models/                # Model tests
│   ├── providers/             # Provider tests
│   ├── repositories/          # Repository tests
│   ├── screens/               # Screen tests
│   ├── services/              # Service tests
│   └── widgets/               # Widget tests
├── integration_test/          # End-to-end tests
├── assets/                    # Static assets
│   ├── sounds/               # Audio files
│   ├── images/               # Images and icons
│   └── launcher/             # App launcher icons
├── android/                   # Android-specific code
├── ios/                      # iOS-specific code
├── windows/                   # Windows-specific code
├── web/                      # Web-specific code
└── pubspec.yaml             # Dependencies and app config
```

## Directory Purposes

### `lib/core/`
**Purpose:** Foundation layer with shared app configuration
**Contains:** Constants, theme configuration, utilities, routing
**Key files:**
- `constants/app_colors.dart` - All color values
- `constants/app_strings.dart` - All text strings
- `constants/app_sizes.dart` - Size constants
- `theme/app_theme.dart` - Dark theme configuration
- `utils/calculator.dart` - Formulas for kcal, points, levels

### `lib/models/`
**Purpose:** Data models and business objects
**Contains:** Immutable domain models with JSON serialization
**Key files:**
- `workout_session.dart` - Core workout state
- `daily_record.dart` - Daily workout summary
- `achievement.dart` - Achievement definitions
- `goal.dart` - Goal tracking model
- `haptic_intensity.dart` - Vibration settings

### `lib/repositories/`
**Purpose:** Data persistence abstraction
**Contains:** Storage service with error handling
**Key files:**
- `storage_service.dart` - SharedPreferences wrapper

### `lib/providers/`
**Purpose:** State management with ChangeNotifier
**Contains:** Business logic and state coordination
**Key files:**
- `user_stats_provider.dart` - Aggregate statistics
- `active_workout_provider.dart` - Current workout state
- `achievements_provider.dart` - Achievement tracking
- `goals_provider.dart` - Goal management

### `lib/screens/`
**Purpose:** Top-level UI pages with routing
**Contains:** StatefulWidget implementations
**Key files:**
- `home/home_screen.dart` - Main entry point
- `series_selection/series_selection_screen.dart` - Workout setup
- `workout_execution/workout_execution_screen.dart` - Active workout
- `statistics/statistics_screen.dart` - Progress tracking

### `lib/widgets/`
**Purpose:** Reusable UI components
**Contains:** StatelessWidget implementations organized by feature
**Key subdirectories:**
- `common/` - Shared components (bottom nav, badges)
- `design_system/` - Core design elements (buttons, cards)
- `workout/` - Workout-specific components
- `statistics/` - Data visualization components
- `goals/` - Goal tracking components

### `lib/services/`
**Purpose:** Device integrations and platform features
**Contains:** Service wrappers with graceful degradation
**Key files:**
- `proximity_sensor_service.dart` - Sensor detection
- `audio_service.dart` - Sound playback
- `haptic_feedback_service.dart` - Vibration
- `notification_service.dart` - Local notifications
- `app_settings_service.dart` - User preferences

### `test/`
**Purpose:** Unit and widget tests
**Contains:** Test files mirroring lib structure
**Key directories:**
- `models/` - Model tests
- `providers/` - Provider tests with mocks
- `screens/` - Screen widget tests
- `widgets/` - Component tests
- `golden_tests/` - Visual regression tests

## Key File Locations

**Entry Points:**
- `lib/main.dart` - App initialization
- `lib/main_navigation_wrapper.dart` - Navigation state
- `lib/core/router.dart` - Route constants

**Configuration:**
- `pubspec.yaml` - Dependencies and app config
- `assets/` - Static files (sounds, images)

**Core Logic:**
- `lib/models/workout_session.dart` - Workout domain model
- `lib/repositories/storage_service.dart` - Data persistence
- `lib/core/utils/calculator.dart` - Formulas

**Testing:**
- `test/` - Unit and widget tests
- `integration_test/` - End-to-end tests

## Naming Conventions

**Files:**
- Snake_case for files (e.g., `workout_session.dart`)
- PascalCase for classes and widgets

**Functions:**
- camelCase for methods
- get prefixes for computed properties
- Verb-first for actions (e.g., `startWorkout`, `countRep`)

**Variables:**
- camelCase with descriptive names
- Leading underscore for private fields
- _prefix for internal state

**Constants:**
- UPPER_SNAKE_CASE
- Grouped by category (e.g., `APP_COLOR_PRIMARY`)

**Directories:**
- lowercase_with_underscores
- Plural for collections (e.g., `screens/`, `widgets/`)

## Where to Add New Code

**New Feature:**
- **Screen**: Add to `lib/screens/[feature_name]/`
- **State**: Add to `lib/providers/[feature]_provider.dart`
- **Data**: Add to `lib/models/[feature]_model.dart`
- **UI Components**: Add to `lib/widgets/[category]/[feature]_[widget].dart`

**New Device Integration:**
- Add service in `lib/services/[feature]_service.dart`
- Handle platform-specific code with try/catch for graceful degradation

**New Calculation Logic:**
- Add to `lib/core/utils/calculator.dart`

**New UI Element:**
- **Design System**: Add to `lib/widgets/design_system/`
- **Feature-specific**: Add to appropriate widget category
- **Reusable**: Add to `lib/widgets/common/`

**New Test:**
- **Unit Test**: Add to `test/[category]/[feature]_test.dart`
- **Widget Test**: Add to `test/widgets/[category]/[widget]_test.dart`
- **Integration Test**: Add to `integration_test/`

## Special Directories

**`assets/`**:
- Purpose: Static application assets
- Generated: No (manual management)
- Committed: Yes

**`test/golden_tests/`**:
- Purpose: Visual regression test assets
- Generated: Yes (via `flutter test --update-goldens`)
- Committed: Yes (for baseline)

**`lib/l10n/`**:
- Purpose: Generated localization files
- Generated: Yes (Flutter's built-in system)
- Committed: Yes

---

*Structure analysis: 2026-01-20*