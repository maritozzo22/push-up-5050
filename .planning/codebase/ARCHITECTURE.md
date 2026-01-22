# Architecture

**Analysis Date:** 2026-01-20

## Pattern Overview

**Overall:** Feature-based Flutter with Provider state management and clean separation of concerns

**Key Characteristics:**
- Layered architecture with clear separation between UI, business logic, and data
- Provider pattern for state management with ChangeNotifier
- Repository pattern for data persistence
- Service layer for device integrations
- Progressive workout session as core domain model

## Layers

### Presentation Layer (Screens & Widgets)
**Location:** `push_up_5050/lib/screens/`, `push_up_5050/lib/widgets/`

**Purpose:** Handle UI rendering and user interactions
**Contains:** StatelessWidget and StatefulWidget implementations
**Depends on:** Providers, Services, Models, Core utilities
**Used by:** MaterialApp navigation

**Key Components:**
- **Screens**: Top-level pages (Home, Statistics, Profile, Settings, etc.)
- **Widgets**: Reusable UI components organized by feature:
  - `widgets/common/`: Shared components (bottom nav, badges)
  - `widgets/design_system/`: Core design elements (buttons, cards, gradients)
  - `widgets/workout/`: Workout-specific components
  - `widgets/statistics/`: Data visualization components
  - `widgets/goals/`: Goal tracking components

### Business Logic Layer (Providers & Services)
**Location:** `push_up_5050/lib/providers/`, `push_up_5050/lib/services/`

**Purpose:** Manage application state and business rules
**Contains:** ChangeNotifier implementations and device service wrappers
**Depends on:** Models, Repositories, Core utilities
**Used by:** Presentation layer

**Providers:**
- `UserStatsProvider`: Aggregate statistics, streaks, calendar data
- `ActiveWorkoutProvider`: Current workout session state, recovery timer
- `AchievementsProvider`: Achievement unlock tracking
- `GoalsProvider`: Goal management and tracking

**Services:**
- `ProximitySensorService`: Device proximity detection with graceful degradation
- `AudioService`: Sound playback for feedback
- `HapticFeedbackService`: Vibration feedback
- `NotificationService`: Local notifications
- `AppSettingsService`: User preferences management

### Data Layer (Models & Repositories)
**Location:** `push_up_5050/lib/models/`, `push_up_5050/lib/repositories/`

**Purpose:** Data models and persistence abstraction
**Contains:** Domain models and data access implementations
**Depends on:** Core utilities
**Used by:** Business logic layer

**Models:**
- `WorkoutSession`: Progressive workout state and series logic
- `DailyRecord`: Daily workout summary and goal tracking
- `Achievement`: Achievement definitions and unlock conditions
- `Goal`: Individual goal tracking
- `HapticIntensity`: Vibration settings

**Repositories:**
- `StorageService`: SharedPreferences wrapper with JSON serialization

### Core Foundation Layer
**Location:** `push_up_5050/lib/core/`

**Purpose:** Shared utilities, constants, and app configuration
**Contains:** Theme, constants, utilities, routing
**Depends on:** Flutter framework
**Used by:** All layers

**Components:**
- `constants/`: AppColors, AppStrings, AppSizes (centralized values)
- `theme/`: AppTheme with dark theme configuration
- `utils/`: Calculator (kcal, points, level formulas)
- `router.dart`: Navigation route constants
- `l10n/`: Internationalization support

## Data Flow

### Workout Session Flow

1. **User initiates workout** from Home screen
2. **SeriesSelectionScreen** captures preferences (starting series, rest time)
3. **ActiveWorkoutProvider** creates new WorkoutSession and saves to storage
4. **WorkoutExecutionScreen** displays current series and rep counter
5. **ProximitySensorService** or manual button triggers rep counting
6. **ActiveWorkoutProvider** updates session state and persists changes
7. **Recovery timer** activates between series with color transitions
8. **Achievement unlock** triggers popup notification
9. **Session completes** and saves to DailyRecord via StorageService

### Statistics Flow

1. **UserStatsProvider** loads daily records from StorageService
2. **Calculates aggregate stats** (total pushups, streak, weekly progress)
3. **Provides computed data** to StatisticsScreen
4. **Calendar widgets** display program progress and missed days
5. **Weekly charts** normalize data for visualization

### State Management Flow

```
UI Screens → Providers (ChangeNotifier) → StorageService → SharedPreferences
     ↓              ↓                       ↓
Widgets ← Consumer/ConsumerWidget ← JSON serialization
```

## Key Abstractions

### WorkoutSession Model
- **Purpose**: Core domain object representing progressive workout state
- **Location**: `push_up_5050/lib/models/workout_session.dart`
- **Pattern**: Immutable with copyWith for state updates
- **Key Logic**: Series progression (Series N requires N push-ups)

### StorageService
- **Purpose**: Abstract persistence layer with error handling
- **Location**: `push_up_5050/lib/repositories/storage_service.dart`
- **Pattern**: Repository with dependency injection
- **Features**: JSON serialization, data corruption recovery

### Provider Hierarchy
- **Purpose**: Layered state management with clear responsibilities
- **Pattern**: Multiple ChangeNotifiers with specific domains
- **Features**: Automatic persistence, computed properties, loading states

### ProximitySensorService
- **Purpose**: Device abstraction with graceful degradation
- **Location**: `push_up_5050/lib/services/proximity_sensor_service.dart`
- **Pattern**: Stream-based with callback interface
- **Features**: Debouncing, fallback to manual input

## Entry Points

### Main Application
- **Location**: `push_up_5050/lib/main.dart`
- **Triggers**: App initialization, provider setup, theme application
- **Responsibilities**: Service initialization, dependency injection

### Navigation Wrapper
- **Location**: `push_up_5050/lib/main_navigation_wrapper.dart`
- **Triggers**: Bottom navigation tab changes
- **Responsibilities**: Screen switching, navigation state management

### Route Constants
- **Location**: `push_up_5050/lib/core/router.dart`
- **Triggers**: Navigation.push() calls
- **Responsibilities**: Centralized route definitions

## Error Handling

**Strategy:** Defensive programming with graceful degradation

**Patterns:**
- Storage corruption handling with automatic cleanup
- Sensor availability checks with fallback UI
- Async error boundaries in providers
- Loading states for data fetching

## Cross-Cutting Concerns

**Logging:** Console logging for debugging, structured logging for analytics
**Validation:** Model-level validation for business rules
**Authentication:** Not applicable (local-only app)
**Internationalization:** Built-in Flutter localization with custom delegates

---

*Architecture analysis: 2026-01-20*