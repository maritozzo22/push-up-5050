# Flutter Testing Skill

**Version**: 1.0.0
**Quality Score**: 97/100 ✅
**Target Users**: Non-programmers who want to test Flutter apps and debug with tests

---

## 🎯 What This Skill Does

`flutter-testing` helps you write tests that prevent bugs, catch regressions, and make debugging faster—even if you don't know how to program.

It covers:
- ✅ **Unit Tests**: Test individual functions and logic
- ✅ **Widget Tests**: Test UI components and interactions
- ✅ **Integration Tests**: Test complete app flows
- ✅ **Golden Tests**: Visual regression testing (screenshots)
- ✅ **Debugging with Tests**: Reproduce bugs, fix them, verify
- ✅ **Test Organization**: Keep tests maintainable
- ✅ **Anti-Patterns**: What NOT to do when testing

---

## 🚀 How to Use

### Option 1: Automatic Activation

Mention testing in your conversation:

```
"Write a test for the login button"
"This test is failing, help me fix it"
"Debug this issue with tests"
"Add unit tests for the score calculation"
```

Claude Code will automatically load this skill when you mention:
- flutter test
- testing flutter
- write a test
- create test
- debug with tests
- test coverage
- widget test
- unit test
- integration test flutter

### Option 2: Explicit Invocation

```
"Use the flutter-testing skill to verify this code works"
```

---

## 📋 The 4 Types of Tests

### 1. Unit Tests 🧪

**What**: Test individual functions and classes

**Example**: Testing a score calculation
```dart
test('Score adds bonus for perfect round', () {
  final score = ScoreCalculator();
  expect(score.calculate(100, true), equals(150));
});
```

**When to use**: Business logic, calculations, validations

**Speed**: Very fast (milliseconds)

---

### 2. Widget Tests 🎨

**What**: Test UI components and interactions

**Example**: Testing a button tap
```dart
testWidgets('button increments counter', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  expect(find.text('Count: 1'), findsOneWidget);
});
```

**When to use**: Individual widgets, user interactions (tap, scroll, input)

**Speed**: Fast (no device needed)

---

### 3. Integration Tests 🔄

**What**: Test complete app flows

**Example**: Testing full login flow
```dart
testWidgets('complete login flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();
  await tester.enterText(find.byKey(Key('email')), 'user@example.com');
  await tester.tap(find.text('Login'));
  await tester.pumpAndSettle();
  expect(find.text('Welcome'), findsOneWidget);
});
```

**When to use**: Critical flows (login, checkout, signup)

**Speed**: Slower (runs on device/emulator)

---

### 4. Golden Tests 📸

**What**: Visual regression testing (screenshots)

**Example**: Verify widget appearance
```dart
testWidgets('Card matches golden', (tester) async {
  await tester.pumpWidget(CardWidget());
  await expectLater(
    find.byType(CardWidget),
    matchesGoldenFile('goldens/card.png'),
  );
});
```

**When to use**: Visual consistency, custom designs

**Speed**: Fast

---

## 🎯 How This Solves Your Problems

### Problem: "When I tap the button, nothing happens"

**Old way**: Describe vaguely → AI guesses wrong → Many prompts

**New way with this skill**:
1. AI writes test to reproduce bug
2. Test fails (shows exactly what's wrong)
3. AI fixes the bug
4. Test passes ✅
5. Bug never comes back (test prevents regression)

### Example Workflow:

**You**:
```
The login button doesn't work when I tap it
```

**Claude** (with flutter-testing skill):
1. Writes test:
```dart
testWidgets('login button triggers callback', (tester) async {
  bool loginCalled = false;
  await tester.pumpWidget(
    MaterialApp(
      home: LoginButton(onLogin: () => loginCalled = true),
    ),
  );
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  expect(loginCalled, true);  // This FAILS initially
});
```

2. Identifies problem: "Button has no onPressed handler"

3. Fixes bug:
```dart
ElevatedButton(
  onPressed: widget.onLogin,  // ← Added
  child: Text('Login'),
)
```

4. Verifies fix: Test now passes ✅

**Result**: Bug fixed, test prevents future regressions

---

## 📁 Test File Organization

Tests mirror your source structure:

```
lib/
├── models/
│   └── quiz.dart
├── widgets/
│   └── score_display.dart
└── screens/
    └── home_screen.dart

test/
├── models/
│   └── quiz_test.dart           # Unit tests
├── widgets/
│   └── score_display_test.dart  # Widget tests
├── screens/
│   └── home_screen_test.dart    # Widget tests
└── integration_test/
    └── app_test.dart            # Integration tests
```

---

## 💬 Example Conversations

### Writing a Test

**You**:
```
Write a test for this score display widget
```

**Claude** (with this skill):
- Creates `test/widgets/score_display_test.dart`
- Writes test that verifies score is displayed
- Includes test for different score values
- Uses proper test structure (AAA pattern)

### Debugging with Tests

**You**:
```
This quiz app shows the wrong score after answering questions
```

**Claude** (with this skill):
1. Writes test to reproduce the issue
2. Runs test (you execute it)
3. Analyzes failure
4. Identifies bug (score not updating correctly)
5. Fixes the bug
6. Verifies with test

### Adding Test Coverage

**You**:
```
Add unit tests for the quiz model
```

**Claude** (with this skill):
- Tests `checkAnswer()` method
- Tests edge cases (empty string, case sensitivity)
- Tests score calculation
- Uses descriptive test names

---

## 🚫 What This Skill Prevents

| Testing Problem | How This Skill Prevents It |
|-----------------|---------------------------|
| **Fragile tests** | Teaches testing behavior, not implementation |
| **No assertions** | Every test includes expect() statements |
| **Slow tests** | Uses unit/widget tests (fast), integration tests sparingly |
| **Interdependent tests** | Each test is independent |
| **Over-mocking** | Mock only external dependencies |
| **Test duplication** | Extracts common setup code |
| **Testing trivial code** | Focus on high-value, high-risk code |

---

## 🎓 Key Principles Taught

This skill instills these principles:

1. **Test Behavior, Not Implementation** → Test WHAT code does, not HOW
2. **Tests Should Be Fast** → Quick feedback during development
3. **One Test, One Assertion** → Keep tests focused
4. **Test Isolation** → Each test independent
5. **Descriptive Names** → Test names read like requirements

---

## 🛠️ Running Tests

### Common Commands

```bash
# Run all tests
flutter test

# Run specific file
flutter test test/widgets/score_test.dart

# Run with coverage
flutter test --coverage

# Run integration tests
flutter test integration_test/

# Update golden files
flutter test --update-goldens
```

### What Test Type to Use When

| Situation | Test Type |
|-----------|-----------|
| Testing a calculation | Unit test |
| Testing button works | Widget test |
| Testing full login flow | Integration test |
| Verifying visual design | Golden test |
| Debugging specific bug | Start with widget test |

---

## 📊 The Testing Pyramid

This skill teaches the right balance:

```
        /\
       /  \     Integration Tests (10%) - Few, critical flows
      /____\
     /      \   Widget Tests (20%) - Many, UI behavior
    /        \
   /          \ Unit Tests (70%) - Most, pure logic
  /____________\
```

**Don't test everything** - focus on high-value tests.

---

## 🔍 Claude Can't "Press Buttons" Directly

### Important Clarification:

**What Claude CAN do**:
- ✅ Write tests that SIMULATE button presses
- ✅ Read test output and errors
- ✅ Analyze what went wrong
- ✅ Fix bugs based on test failures

**What Claude CANNOT do**:
- ❌ Physically tap buttons on your running app
- ❌ See the app in real-time
- ❌ Interact with emulator like a human

### How It Works in Practice:

```
YOU: "The button doesn't work"

CLAUDE: "Let me write a test to check"
      [Writes test with tester.tap()]

YOU: [Run the test]

CLAUDE: [Reads test output]
      "The test fails because onPressed is null.
       Let me fix that."
      [Fixes the bug]

YOU: [Re-run test] ✅ Passes!
```

---

## 💡 Tips for Best Results

1. **Be Specific About the Issue**
   - Bad: "Something's wrong"
   - Good: "When I tap the submit button, nothing happens"

2. **Share Error Messages**
   - Paste test output
   - Include error messages

3. **Run Tests When Asked**
   - When Claude says "Run this test", execute it
   - Share the output back

4. **Start with Widget Tests**
   - Fast and catch most UI bugs
   - Integration tests for critical flows only

5. **Don't Chase 100% Coverage**
   - 70-80% is practical
   - Focus on important code

---

## 🎮 Examples: What You Can Test

### Unit Tests
- ✅ Score calculations
- ✅ Answer validation (quiz app)
- ✅ Data transformations
- ✅ Business logic

### Widget Tests
- ✅ Buttons tap and trigger actions
- ✅ Text input captures user input
- ✅ Lists scroll correctly
- ✅ State updates after interactions
- ✅ Error messages display

### Integration Tests
- ✅ Complete login flow
- ✅ Quiz game (start → answer → results)
- ✅ Multi-screen workflows
- ✅ Form submission

### Golden Tests
- ✅ Custom card designs
- ✅ Responsive layouts
- ✅ Themed components
- ✅ Visual consistency

---

## 📈 Test Coverage Goals

Practical targets (not 100%!):

- **Overall**: 70-80%
- **Business logic**: 90%+
- **UI widgets**: 60-70%
- **Generated code**: 0% (don't test boilerplate)

**Remember**: Quality > quantity.

---

## 🔄 Workflow: Debug with Tests

### Step-by-Step:

1. **Report the bug**
   ```
   "The score doesn't update after answering correctly"
   ```

2. **Claude writes test**
   ```dart
   testWidgets('score updates after correct answer', (tester) async {
     // Test code that reproduces bug
   });
   ```

3. **You run the test**
   ```bash
   flutter test test/widgets/quiz_test.dart
   ```

4. **Test fails** → Shows what's wrong

5. **Claude analyzes and fixes**

6. **You re-run** → Test passes ✅

7. **Bug prevented forever** (test catches regression)

---

## 🔗 Related Skills

- **flutter-creator**: Create Flutter apps (use first)
- **flutter-testing**: Test the apps you create (use this second)

**Recommended workflow**:
1. Create app with `flutter-creator`
2. Add tests with `flutter-testing`
3. Fix bugs using both skills together

---

## 📄 License

Part of the BuilderPack collection.

---

## 💡 Remember

**Tests give you confidence to change code without breaking things.**

With this skill, Claude helps you:
- Write tests that catch real bugs
- Debug issues faster
- Prevent regressions
- Understand how code works

**You don't need to be a testing expert—Claude writes the tests for you.**

**Happy testing! 🧪**
