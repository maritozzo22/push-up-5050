---
name: flutter-testing
description: >
  Complete Flutter testing guide covering unit tests, widget tests, integration
  tests, and golden tests. Learn to write tests that prevent bugs, catch
  regressions, and serve as living documentation. Use test-driven debugging to
  reproduce issues, verify fixes, and ensure code quality. Covers mocking,
  test organization, coverage reports, and testing best practices for
  non-programmers using AI. Use when testing Flutter apps, debugging with
  tests, or verifying code changes work correctly.
triggers:
  - flutter test
  - testing flutter
  - write a test
  - create test
  - debug with tests
  - test coverage
  - widget test
  - unit test
  - integration test flutter
---

# Flutter Testing

Write effective tests that prevent bugs, catch regressions, and make debugging faster—designed for non-programmers who want AI to handle testing.

## Philosophy: Tests as Safety Nets and Living Documentation

Tests aren't just checkboxes—they're **safety nets that catch mistakes** and **living documentation that shows how code works**.

**Core principle: Test Behavior, Not Implementation**

| Testing as Implementation Check | Testing as Behavior Verification |
|---------------------------------|-----------------------------------|
| Tests check private methods | Tests check user-facing behavior |
| Tests know too much about internals | Tests know only inputs and outputs |
| Tests break when code refactors | Tests survive refactoring if behavior same |
| Fragile, high maintenance | Robust, low maintenance |

### Before Testing, Ask

- **What behavior am I testing?** Not "how", but "what"
- **What should happen when I do X?** User perspective
- **Is this test reproducible?** Same input → same output always
- **Is this test independent?** Doesn't depend on other tests
- **Does this test add value?** Catches real bugs, not just increases coverage

### Core Principles

1. **Test Behavior, Not Implementation**: Test what code DOES, not how it does it
2. **Tests Should Be Fast**: Unit/widget tests run in milliseconds, integration tests slower
3. **One Test, One Assertion**: Keep tests focused and easy to understand
4. **Test Isolation**: Each test should be independent—no shared state
5. **Descriptive Test Names**: Test names should read like requirements

### Mental Model: The Testing Pyramid

```
        /\
       /  \     Integration Tests (few, key flows)
      /____\
     /      \   Widget Tests (many, UI behavior)
    /        \
   /          \ Unit Tests (most, pure functions)
  /____________\
```

**Rule of thumb**: 70% unit, 20% widget, 10% integration

---

## Quick Start: Test File Location

Always organize tests to mirror source structure:

```
lib/
├── models/
│   └── user.dart
├── widgets/
│   └── login_button.dart
└── screens/
    └── home_screen.dart

test/
├── models/
│   └── user_test.dart           # Unit tests
├── widgets/
│   └── login_button_test.dart   # Widget tests
├── screens/
│   └── home_screen_test.dart    # Widget tests for screens
└── integration_test/
    └── app_test.dart            # Integration tests
```

**Golden files** (screenshots):
```
test/
└── goldens/
    └── login_button.png
```

---

## Unit Tests

Unit tests test **individual functions and classes** in isolation. No UI, no dependencies—just pure logic.

### When to Write Unit Tests

✅ **Good for**:
- Business logic (calculations, validations)
- Pure functions (same input → same output)
- Data models and transformations
- Utility functions
- State management logic (BLoC events, providers)

❌ **Not for**:
- UI rendering (use widget tests)
- Widget interactions (use widget tests)
- Full app flows (use integration tests)

### Writing Unit Tests

**File being tested** (`lib/models/quiz.dart`):
```dart
class Quiz {
  final String question;
  final String correctAnswer;

  Quiz({required this.question, required this.correctAnswer});

  bool checkAnswer(String userAnswer) {
    return userAnswer.toLowerCase() == correctAnswer.toLowerCase();
  }
}
```

**Test file** (`test/models/quiz_test.dart`):
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/models/quiz.dart';

void main() {
  group('Quiz', () {
    test('checkAnswer returns true for correct answer', () {
      // Arrange
      final quiz = Quiz(
        question: 'What is 2+2?',
        correctAnswer: '4',
      );

      // Act
      final result = quiz.checkAnswer('4');

      // Assert
      expect(result, true);
    });

    test('checkAnswer is case-insensitive', () {
      final quiz = Quiz(
        question: 'Capital of Italy?',
        correctAnswer: 'Rome',
      );

      expect(quiz.checkAnswer('rome'), true);
      expect(quiz.checkAnswer('ROME'), true);
      expect(quiz.checkAnswer('RoMe'), true);
    });

    test('checkAnswer returns false for wrong answer', () {
      final quiz = Quiz(
        question: 'Capital of France?',
        correctAnswer: 'Paris',
      );

      expect(quiz.checkAnswer('London'), false);
    });
  });
}
```

### Running Unit Tests

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/models/quiz_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
# Generate HTML report (requires genhtml)
lcov --summary coverage/lcov.info
```

---

## Widget Tests

Widget tests test **UI components and their interactions**. They're fast and run without a physical device.

### When to Write Widget Tests

✅ **Good for**:
- Individual widget behavior
- User interactions (taps, scrolls, input)
- State changes in UI
- Layout and rendering
- Widget composition

❌ **Not for**:
- Pure business logic (use unit tests)
- Full app flows across multiple screens (use integration tests)

### Widget Test Basics

**File being tested** (`lib/widgets/score_display.dart`):
```dart
class ScoreDisplay extends StatelessWidget {
  final int score;

  const ScoreDisplay({required this.score, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Text(
        'Score: $score',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}
```

**Test file** (`test/widgets/score_display_test.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/score_display.dart';

void main() {
  group('ScoreDisplay', () {
    testWidgets('displays score text', (tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: ScoreDisplay(score: 10),
        ),
      );

      // Verify text exists
      expect(find.text('Score: 10'), findsOneWidget);
    });

    testWidgets('uses correct text style', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: ScoreDisplay(score: 5),
        ),
      );

      final textWidget = tester.widget<Text>(find.text('Score: 5'));
      expect(textWidget.style?.fontSize, isNotNull);
    });
  });
}
```

### Testing User Interactions

**File being tested** (`lib/widgets/counter.dart`):
```dart
class CounterWidget extends StatefulWidget {
  @override
  State<CounterWidget> createState() => _CounterWidgetState();
}

class _CounterWidgetState extends State<CounterWidget> {
  int _count = 0;

  void _increment() {
    setState(() {
      _count++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Count: $_count'),
        ElevatedButton(
          onPressed: _increment,
          child: Text('Increment'),
        ),
      ],
    );
  }
}
```

**Test with interactions** (`test/widgets/counter_test.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/counter.dart';

void main() {
  group('CounterWidget', () {
    testWidgets('increments count when button tapped', (tester) async {
      // Build widget
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(),
        ),
      );

      // Verify initial state
      expect(find.text('Count: 0'), findsOneWidget);

      // Find and tap button
      final button = find.byType(ElevatedButton);
      await tester.tap(button);

      // Rebuild widget after state change
      await tester.pump();

      // Verify count changed
      expect(find.text('Count: 1'), findsOneWidget);
    });

    testWidgets('increments multiple times', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: CounterWidget(),
        ),
      );

      final button = find.byType(ElevatedButton);

      // Tap three times
      await tester.tap(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();
      await tester.tap(button);
      await tester.pump();

      expect(find.text('Count: 3'), findsOneWidget);
    });
  });
}
```

### Testing Text Input

```dart
testWidgets('text field captures input', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: TextField(
        key: Key('username'),
        decoration: InputDecoration(labelText: 'Username'),
      ),
    ),
  );

  // Enter text
  await tester.enterText(find.byKey(Key('username')), 'mario');

  // Verify text entered
  expect(find.text('mario'), findsOneWidget);
});
```

### Testing Scrollable Content

```dart
testWidgets('list scrolls to reveal items', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ListView.builder(
        itemCount: 100,
        itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
      ),
    ),
  );

  // Item 50 not visible initially
  expect(find.text('Item 50'), findsNothing);

  // Scroll until item 50 appears
  await tester.drag(find.byType(ListView), Offset(0, -1000));
  await tester.pump();

  // Now it's visible
  expect(find.text('Item 50'), findsOneWidget);
});
```

### Common Widget Test Matchers

```dart
// Find widgets
find.text('Hello')              // Find by text
find.byType(ElevatedButton)     // Find by type
find.byKey(Key('myKey'))        // Find by key
find.byIcon(Icons.add)          // Find by icon

// Assert number of widgets found
findsOneWidget                  // Exactly one
findsNothing                    // None
findsWidgets                    // One or more
findsNWidgets(3)                // Exactly three

// Expectations
expect(widget, findsOneWidget);
expect(text, 'Hello');
expect(value, isTrue);
expect(value, equals(42));
expect(value, isNotNull);
```

---

## Integration Tests

Integration tests test **complete app flows** from user's perspective. They run on real devices or emulators.

### When to Write Integration Tests

✅ **Good for**:
- Critical user flows (login, checkout, signup)
- Multiple screens working together
- Real device behavior (camera, GPS, sensors)
- End-to-end scenarios

❌ **Not for**:
- Isolated widget behavior (use widget tests)
- Fast feedback during development (too slow)

### Writing Integration Tests

**Test file** (`integration_test/app_test.dart`):
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('End-to-End App Flow', () {
    testWidgets('complete quiz flow', (tester) async {
      // Launch app
      app.main();
      await tester.pumpAndSettle();

      // Verify on home screen
      expect(find.text('Start Quiz'), findsOneWidget);

      // Tap start button
      await tester.tap(find.text('Start Quiz'));
      await tester.pumpAndSettle();

      // Answer question
      await tester.tap(find.text('Paris'));
      await tester.pumpAndSettle();

      // Verify on results screen
      expect(find.text('Your Score: 1'), findsOneWidget);
    });

    testWidgets('login flow with invalid credentials', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Navigate to login
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Enter credentials
      await tester.enterText(find.byKey(Key('email')), 'test@example.com');
      await tester.enterText(find.byKey(Key('password')), 'wrong');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle();

      // Verify error message
      expect(find.text('Invalid credentials'), findsOneWidget);
    });
  });
}
```

### Running Integration Tests

```bash
# On connected device/emulator
flutter test integration_test/app_test.dart

# On specific device
flutter test -d <device_id> integration_test/app_test.dart

# Run all integration tests
flutter test integration_test/
```

---

## Golden Tests (Visual Regression)

Golden tests capture widget screenshots and compare against reference images. Detect visual regressions.

### When to Use Golden Tests

✅ **Good for**:
- Visual consistency across changes
- Verifying responsive layouts
- Custom widget designs
- Theming and styling

❌ **Not for**:
- Behavior verification (use widget tests)
- Dynamic content (dates, random data)

### Writing Golden Tests

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/widgets/custom_card.dart';

void main() {
  testWidgets('CustomCard matches golden', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomCard(
            title: 'Test Card',
            subtitle: 'Test Subtitle',
          ),
        ),
      ),
    );

    // Compare with golden file
    await expectLater(
      find.byType(CustomCard),
      matchesGoldenFile('goldens/custom_card.png'),
    );
  });
}
```

### Updating Golden Files

```bash
# Update goldens (when design changes intentionally)
flutter test --update-goldens
```

### Running Golden Tests

```bash
# Requires pixel-perfect rendering
flutter test test/widgets/custom_card_test.dart
```

**Note**: Golden tests require consistent rendering (fonts, locale, etc.).

---

## Test Organization and Structure

### Test File Structure

```dart
void main() {
  // Top-level group for feature
  group('FeatureName', () {
    // Nested group for specific component
    group('ComponentName', () {
      testWidgets('does something specific', (tester) async {
        // Arrange, Act, Assert
      });

      testWidgets('handles edge case', (tester) async {
        // Test edge case
      });
    });
  });
}
```

### AAA Pattern (Arrange-Act-Assert)

```dart
testWidgets('button shows loading indicator', (tester) async {
  // ARRANGE: Set up test
  await tester.pumpWidget(MyApp());
  final button = find.byType(ElevatedButton);

  // ACT: Perform action
  await tester.tap(button);
  await tester.pump();

  // ASSERT: Verify result
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

### Test Naming

✅ **Good names**:
- `'increments count when button tapped'`
- `'returns false for invalid email'`
- `'shows error message when login fails'`

❌ **Bad names**:
- `'test button'` ← Too vague
- `'widget test'` ← Describes nothing
- `'test1'` ← Meaningless

---

## Debugging with Tests

### Workflow: Bug Report → Test → Fix → Verify

**You**: "When I tap the login button, nothing happens"

**Claude (with this skill)**:

1. **Write test to reproduce bug**:
```dart
testWidgets('login button calls onLogin when tapped', (tester) async {
  bool loginCalled = false;

  await tester.pumpWidget(
    MaterialApp(
      home: LoginButton(
        onLogin: () => loginCalled = true,
      ),
    ),
  );

  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();

  expect(loginCalled, true);  // This will FAIL initially
});
```

2. **Run test, see it fail**:
```
Expected: true
Actual: false
```

3. **Fix the bug**:
```dart
ElevatedButton(
  onPressed: widget.onLogin,  // ← Add this
  child: Text('Login'),
)
```

4. **Re-run test, verify it passes** ✅

### Finding Why Tests Fail

```bash
# Run with verbose output
flutter test --verbose

# Run specific test
flutter test --name "test name"

# Stop on first failure
flutter test --no-pub

# Print widget tree on failure
# Add this in test:
debugDumpApp();
```

---

## Mocking and Test Doubles

### When to Mock

✅ **Mock when**:
- Testing in isolation (no network, database)
- Simulating edge cases (errors, timeouts)
- Speed (avoid slow I/O)

❌ **Don't over-mock**:
- If real implementation is simple
- If mock becomes more complex than real code

### Simple Mocking with Function Variables

```dart
testWidgets('shows error when API fails', (tester) async {
  // Create mock function
  String mockError = 'Network error';

  await tester.pumpWidget(
    MaterialApp(
      home: DataWidget(
        fetchData: () async => throw Exception(mockError),
      ),
    ),
  );

  // Wait for async operation
  await tester.pumpAndSettle();

  // Verify error shown
  expect(find.text(mockError), findsOneWidget);
});
```

### Using Mock Libraries (Optional)

For advanced mocking, packages like `mocktail` can be used—though for simple apps, function variables are sufficient.

---

## Anti-Patterns to Avoid

❌ **Testing Implementation Instead of Behavior**
Why wrong: Breaks when refactoring, even if behavior unchanged
Example: Testing that a private method was called
Better: Test public API behavior (inputs → outputs)

❌ **Fragile Tests That Break Easily**
Why wrong: High maintenance, ignored by developers
Example: Testing exact text that changes often ("Welcome, User Name!")
Better: Test key elements, use partial matching or key identifiers

❌ **Tests with No Assertions**
Why wrong: Tests can pass even if code broken
Example:
```dart
testWidgets('test button', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(ElevatedButton));
  // No expect() - test always passes!
});
```
Better: Always include assertions
```dart
expect(find.text('Success'), findsOneWidget);
```

❌ **Interdependent Tests**
Why wrong: One test fails → others fail, hard to debug
Example: Test1 sets state, Test2 assumes Test1 ran
Better: Each test is independent and sets up its own state

❌ **Testing Everything and Nothing**
Why wrong: Low value, high maintenance
Example: Testing getters/setters, trivial code
Better: Focus on complex logic, edge cases, user-facing behavior

❌ **Slow Tests in Unit/Widget Suite**
Why wrong: Developers won't run them frequently
Example: Network calls, database operations in widget tests
Better: Mock slow dependencies, use integration tests for real I/O

❌ **Over-Mocking**
Why wrong: Tests pass but code doesn't work
Example: Mocking everything, tests don't verify real behavior
Better: Mock only external dependencies (API, database)

❌ **Test Code Duplication**
Why wrong: Changes require updating many tests
Example: Same setup code in 50 tests
Better: Extract setup into `setUp()` or helper functions

❌ **Ignoring Flaky Tests**
Why wrong: Unreliable tests, developers lose trust
Example: Test that sometimes passes, sometimes fails
Better: Fix race conditions, timing issues, or remove test

❌ **Testing Multiple Behaviors in One Test**
Why wrong: Hard to diagnose which part failed
Example:
```dart
testWidgets('everything', (tester) async {
  // Tests button, text, input, scroll all together
});
```
Better: One test per behavior
```dart
testWidgets('button works', ...);
testWidgets('input validation', ...);
testWidgets('scrolling behavior', ...);
```

❌ **Golden Tests with Dynamic Content**
Why wrong: Images never match
Example: Golden test with current timestamp
Better: Use fixed test data, or don't use golden tests

---

## Variation Guidance

**IMPORTANT**: Tests should vary based on what's being tested and testing goals.

**Vary across dimensions**:
- **Test complexity**: Unit tests (simple) vs integration (comprehensive)
- **Test style**: Arrange-Act-Assert vs Given-When-Then
- **Test organization**: Flat structure vs nested groups
- **Assertion style**: Explicit matchers vs custom matchers

**Context should drive testing approach**:
- **Business logic** → Many unit tests, edge cases
- **UI component** → Widget tests, interaction testing
- **Critical flow** → Integration tests, happy path + edge cases
- **Visual design** → Golden tests for consistency

**Avoid one-size-fits-all**:
- ❌ Every component needs 100% coverage (diminishing returns)
- ❌ Always test public AND private methods (test behavior, not implementation)
- ❌ Mock everything (only external dependencies)
- ❌ Golden tests for everything (use selectively)

**Test to reduce risk, not increase numbers**:
- High-risk code (payments, authentication) → More tests
- Low-risk code (simple UI) → Fewer tests
- Complex logic → Many unit tests
- Simple glue code → Fewer tests

---

## Test Coverage

### Viewing Coverage

```bash
# Generate coverage
flutter test --coverage

# View summary
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

### Coverage Goals (Practical)

- **Overall**: Aim for 70-80% (not 100%)
- **Business logic**: 90%+
- **UI widgets**: 60-70%
- **Generated code**: 0% (don't test boilerplate)

**Remember**: 100% coverage ≠ bug-free. Quality > quantity.

---

## Running Tests

### Common Commands

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/widgets/my_widget_test.dart

# Run with name filter
flutter test --name "button tap"

# Run tests matching pattern
flutter test --name-as-regexp="login.*"

# Update golden files
flutter test --update-goldens

# Run integration tests
flutter test integration_test/

# Run on specific device (integration)
flutter test -d <device_id> integration_test/
```

### Continuous Integration

Include tests in CI/CD:

```yaml
# .github/workflows/test.yml
name: Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter test integration_test/
```

---

## Best Practices Summary

### DO ✅

- Test behavior, not implementation
- Write descriptive test names
- Keep tests fast and independent
- Use AAA pattern (Arrange-Act-Assert)
- Focus on high-value, high-risk code
- Update tests when behavior changes
- Run tests frequently during development

### DON'T ❌

- Test private methods
- Write fragile tests that break easily
- Let tests depend on each other
- Over-mock external dependencies
- Ignore flaky tests
- Test generated code
- Chase 100% coverage at expense of quality

---

## Remember

**Tests are safety nets that give you confidence to change code.**

The best test suites:
- Focus on behavior users care about
- Run fast and provide quick feedback
- Are maintainable and don't break unnecessarily
- Catch real bugs, not just increase numbers
- Serve as living documentation of how code works

**Test to reduce fear of breaking things—not just to check a box.**
