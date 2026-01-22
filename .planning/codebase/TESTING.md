# Testing Patterns

**Analysis Date:** 2024-11-20

## Test Framework

**Runner:**
- Flutter test with flutter_test SDK
- Config: Default configuration in pubspec.yaml
- No custom test configuration file

**Assertion Library:**
- Built-in expect() from flutter_test.dart
- Custom test helpers in test_helpers.dart

**Run Commands:**
```bash
flutter test                    # Run all tests
flutter test test/widgets/      # Run widget tests
flutter test test/core/        # Run core utility tests
flutter test test/golden_tests/  # Run golden tests
flutter test --coverage        # Check test coverage
flutter test --update-goldens  # Update golden files
```

## Test File Organization

**Location:**
- Parallel to lib directory structure
- test/ mirrors lib/ folder organization
- Test files co-located with implementation files

**Naming:**
- `*_test.dart` for unit and widget tests
- `*_golden_test.dart` for visual regression tests
- `integration_test.dart` for end-to-end tests

**Structure:**
```
test/
├── core/                # Utility and model tests
│   ├── constants/
│   ├── utils/
│   └── router_test.dart
├── models/              # Data model tests
├── widgets/             # Widget component tests
├── screens/             # Screen-level tests
├── providers/           # State provider tests
├── services/            # Service layer tests
├── golden_tests/        # Visual regression tests
└── integration/         # End-to-end tests
```

## Test Structure

**Suite Organization:**
```dart
void main() {
  group('Calculator', () {
    test('should calculate kcal correctly', () {
      expect(Calculator.calculateKcal(10), 4.5);
    });

    test('should calculate points correctly', () {
      // Multiple edge cases
    });

    group('Additive Multiplier Formula', () {
      // Subgroups for related tests
    });
  });
}
```

**Patterns:**
- **group()** for logical test grouping
- **test()** for individual test cases
- **testWidgets()** for widget testing
- **testGoldens()** for visual regression
- Test descriptions describe expected behavior

## Mocking

**Framework:** Mockito for unit tests
- Fake implementations for dependencies
- MockSharedPreferences for storage

**Patterns:**
```dart
class FakeStorageService implements StorageService {
  Map<String, dynamic> _data = {};

  @override
  Future<void> saveDailyRecord(DailyRecord record) async {
    _data['today'] = record;
  }
}
```

**What to Mock:**
- External services (StorageService, SharedPreferences)
- Platform-specific services (ProximitySensor, Audio)
- Complex state providers
- File systems and device sensors

**What NOT to Mock:**
- Pure calculations (Calculator methods)
- Simple data models (DailyRecord, Achievement)
- Basic widget logic
- Final classes

## Fixtures and Factories

**Test Data:**
```dart
// In test_helpers.dart
class FakeStorageService implements StorageService {
  // Test configuration methods
  void setTodayRecord(DailyRecord? record) {
    _todayRecord = record;
  }

  void setDailyRecords(Map<String, dynamic> records) {
    _dailyRecords = records;
  }
}
```

**Location:**
- Centralized in test/test_helpers.dart
- FakeStorageService for all provider tests
- Helper functions in test_helpers.dart

## Coverage

**Requirements:** 70%+ overall coverage (as per CLAUDE.md)

**View Coverage:**
```bash
flutter test --coverage
open coverage/index.html
```

## Test Types

**Unit Tests:**
- **Scope**: Business logic, calculations, models
- **Files**: `test/core/utils/calculator_test.dart`, `test/models/workout_session_test.dart`
- **Approach**: Direct function calls with isolated inputs/outputs
- **Mocking**: Heavy use of fakes for dependencies

**Widget Tests:**
- **Scope**: UI components, interactions, state changes
- **Files**: `test/widgets/common/statistics_badge_test.dart`, `test/widgets/workout/countdown_circle_test.dart`
- **Approach**: pumpWidget() with MaterialApp wrapper
- **Testing**: User interactions, visual properties, state updates

**Integration Tests:**
- **Scope**: Complete user flows
- **Files**: `test/integration/goal_integration_test.dart`
- **Approach**: End-to-end simulation with real widgets
- **Mocking**: Minimal mocking, real app structure

**Golden Tests:**
- **Scope**: Visual regression (EVERY screen)
- **Files**: `test/golden_tests/home_screen_golden_test.dart`
- **Approach**: matchesGoldenFile() comparison
- **Devices**: Multiple device sizes defined in GoldenDeviceSizes

## Common Patterns

**Async Testing:**
```dart
testWidgets('should display loading state', (tester) async {
  await tester.pumpWidget(createTestApp(child: LoadingWidget()));
  await tester.pumpAndSettle();
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

**Error Testing:**
```dart
test('should throw error for invalid series', () {
  expect(() => WorkoutSession(startingSeries: -1), throwsArgumentError);
});
```

**Widget Testing Setup:**
```dart
testWidgets('displays label and value correctly', (tester) async {
  await tester.pumpWidget(
    const MaterialApp(
      home: Scaffold(
        body: StatisticsBadge(
          label: 'Push-up Oggi',
          value: '15 / 50',
        ),
      ),
    ),
  );
  expect(find.text('Push-up Oggi: 15 / 50'), findsOneWidget);
});
```

**Golden Test Helper Usage:**
```dart
await tester.pumpWidget(
  createGoldenTestApp(
    child: const MainNavigationWrapper(),
  ),
);
await expectLater(
  find.byType(MainNavigationWrapper),
  matchesGoldenFile('goldens/home_screen.png'),
);
```

---

*Testing analysis: 2024-11-20*
```