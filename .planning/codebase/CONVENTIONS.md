# Coding Conventions

**Analysis Date:** 2024-11-20

## Naming Patterns

**Files:**
- **PascalCase** for files representing widgets/screens: `CountdownCircle.dart`, `HomeScreen.dart`
- **snake_case** for utility files: `calculator.dart`, `app_colors.dart`
- **PascalCase** for model files: `WorkoutSession.dart`, `DailyRecord.dart`
- **snake_case** for test files: `calculator_test.dart`, `home_screen_golden_test.dart`

**Functions:**
- **PascalCase** for public methods and class constructors
- **snake_case** for private methods: `_handleTap()`, `_scaleController`
- **get prefix** for getters: `get totalKcal`, `getDayStreakMultiplier()`

**Variables:**
- **camelCase** for local variables: `currentSeries`, `totalReps`
- **PascalCase** for constants: `primaryOrange`, `appName`
- **snake_case** for private class variables: `_hasFirstTap`, `_workoutPreferences`

**Types:**
- **PascalCase** for all classes: `WorkoutSession`, `Calculator`, `AppColors`
- **PascalCase** for enums: `HapticIntensity`, `GoldenTestScenario`

## Code Style

**Formatting:**
- **Tool**: Flutter's default formatting with dart format
- **Key settings**:
  - 2-space indentation
  - Semicolons required
  - Trailing commas in function parameters
  - Curly braces on new lines

**Linting:**
- **Tool**: flutter_lints with custom rules in analysis_options.yaml
- **Key rules enforced**:
  - avoid_print: false (print statements allowed for debugging)
  - prefer_single_quotes: false (double quotes used throughout)
  - always_use_package_imports: true
  - sort_unnamed_constructors_first: true

## Import Organization

**Order:**
1. Package imports (3rd party)
2. Local relative imports
3. Absolute imports (when needed)

**Pattern:**
```dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/constants/app_colors.dart';
import 'core/utils/calculator.dart';
import 'models/workout_session.dart';
```

**Path Aliases:**
- No path aliases configured - using relative imports throughout

## Error Handling

**Patterns:**
- **null safety**: Strict null safety with required and nullable parameters
- **try-catch**: Around async operations and external service calls
- **async/await**: For all async operations instead of .then()
- **Result pattern**: No custom result types, using exceptions for errors

**Error Messages:**
- Centralized in AppStrings for user-facing messages
- Italian language with English fallbacks where needed

## Logging

**Framework:** Flutter's print() statements
- Debug messages in development
- No logging framework in production
- Avoid performance-critical paths

**Patterns:**
```dart
print('Debug: $message');
print('Error: Failed to load session');
```

## Comments

**When to Comment:**
- Complex business logic (formulas in Calculator)
- Edge cases and special conditions
- Deprecated features with migration notes
- TODO items in comments

**JSDoc/TSDoc:**
- Used consistently for all public classes and methods
- Format:
```dart
/// Workout session model
/// Tracks progressive push-up series with state management
class WorkoutSession {
  /// Series number to start workout from (1-99)
  final int startingSeries;

  /// Create a new workout session
  WorkoutSession({
    required this.startingSeries,
    required this.restTime,
    // ...
  });
}
```

## Function Design

**Size:**
- Keep functions under 30 lines
- Extract complex logic to separate methods
- Single responsibility per function

**Parameters:**
- Use named parameters for 3+ parameters
- Group related parameters into objects when needed
- Use required for mandatory parameters

**Return Values:**
- Single return type per function
- Use null for missing data rather than special values
- Throw exceptions for invalid states

## Module Design

**Exports:**
- No barrel files - direct imports throughout
- Classes are public, no private restrictions

**Organization:**
- Feature-based directory structure
- Clear separation between presentation, logic, and data
- Provider-based state management

---

*Convention analysis: 2024-11-20*
```