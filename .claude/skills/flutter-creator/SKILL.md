---
name: flutter-creator
description: >
  Complete Flutter app and game development from scratch for non-programmers.
  Covers UI widgets, layouts, animations, gestures, simple state management,
  responsive design for Windows desktop + Android/iOS mobile. Emphasizes
  modular, reusable code with DRY principles, organized structure under 200
  lines per file, no superfluous code. Use when creating Flutter apps, simple
  games (quiz, puzzle, card), features, or fixing bugs in existing Flutter
  projects. Always follows PRD/specifications without adding features.
triggers:
  - flutter
  - flutter app
  - flutter game
  - dart mobile app
  - create flutter
  - build flutter
  - fix flutter bug
---

# Flutter Creator

Create production-ready Flutter apps and simple games from scratch with modular, reusable, and organized code—designed for non-programmers who want AI to handle 100% of development.

## Philosophy: Modular Building Blocks

Flutter apps are not monoliths—they're collections of small, focused, reusable components. Think of it as LEGO: each piece is independent, serves one purpose, and combines to create complex structures.

**Core principle: Small Pieces, Loosely Joined**

| Monolithic Approach | Modular Approach |
|---------------------|------------------|
| God widgets (500+ lines) | Focused widgets (<200 lines) |
| Copy-pasted code | Reusable components |
| Tightly coupled logic | Independent, testable pieces |
| Hard to modify | Easy to change/replace |
| Impossible to reuse | Mix-and-match building blocks |

### Before Building, Ask

- **What's the minimum viable structure?** Can this be broken into smaller pieces?
- **Is this reusable?** Will I need this elsewhere? If yes, make it a component.
- **Is this file too large?** Over 200 lines? Split it.
- **Am I following specifications?** Is this in the PRD/user requirements? If no, don't add it.
- **Is this responsive?** Will this work on Windows desktop AND mobile?

### Core Principles

1. **Modularity First**: Every widget/file has ONE clear responsibility
2. **DRY (Don't Repeat Yourself)**: Similar code appears 2+ times? Extract it
3. **Responsive by Default**: Design for Windows desktop + mobile from day one
4. **Explicit Over Implicit**: Follow specifications exactly—don't add "nice-to-have" features
5. **Organized Structure**: Consistent folder organization, clear naming

### Mental Model: The Component Tree

```
App (Root)
├── MaterialApp (Theme, Routes)
│   ├── Screen (Full page)
│   │   ├── Scaffold (App bar, body)
│   │   │   ├── Widget (Reusable component)
│   │   │   │   ├── Leaf Widget (Button, Text, etc.)
```

Every level is a separate, focused component. No level does everything.

---

## Quick Start: Project Structure

Always use this consistent structure:

```
lib/
├── main.dart                 # App entry point
├── core/                     # App-wide constants & utilities
│   ├── constants.dart        # App constants (colors, sizes)
│   ├── theme.dart            # App theme configuration
│   └── utils.dart            # Helper functions
├── models/                   # Data models
│   └── [model_name].dart
├── widgets/                  # Reusable UI components
│   ├── common/               # Generic widgets (buttons, cards)
│   └── [specific_widgets].dart
├── screens/                  # Full-screen widgets
│   ├── home_screen.dart
│   └── [other_screens].dart
├── services/                 # External services (storage, API)
│   └── [service_name].dart
└── features/                 # Feature-based modules (optional)
    └── [feature_name]/
        ├── [feature]_screen.dart
        ├── [feature]_model.dart
        └── [feature]_widget.dart
```

**Rule**: If a file exceeds 200 lines, split it into smaller files.

---

## UI Development Guidelines

### Widget Composition

**Build widgets hierarchically, not monolithically**:

```dart
// ❌ BAD: Monolithic widget (300+ lines)
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // 100 lines of header
          // 100 lines of form
          // 100 lines of footer
        ],
      ),
    );
  }
}

// ✅ GOOD: Composed of smaller widgets
class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          LoginHeader(),           // Extracted (50 lines)
          LoginForm(),             // Extracted (60 lines)
          LoginFooter(),           // Extracted (30 lines)
        ],
      ),
    );
  }
}
```

### Layout Fundamentals

**Understand the box model**: Every widget has constraints from its parent.

**Key widgets for responsive layouts**:
- `LayoutBuilder`: Build different layouts based on available space
- `Flexible` / `Expanded`: Share remaining space
- `Wrap`: Flow children in multiple lines
- `MediaQuery`: Get screen size (use sparingly)

**Responsive pattern**:

```dart
Widget build(BuildContext context) {
  return LayoutBuilder(
    builder: (context, constraints) {
      // Desktop (Windows)
      if (constraints.maxWidth > 600) {
        return DesktopLayout();
      }
      // Mobile (Android/iOS)
      else {
        return MobileLayout();
      }
    },
  );
}
```

**Anti-pattern**: Hardcoding sizes. **Better**: Use `FractionallySizedBox` or percentages.

### Common UI Patterns

**Center content**:
```dart
Center(child: MyWidget())
```

**Row with spacing**:
```dart
Row(
  children: [
    Expanded(child: LeftWidget()),
    SizedBox(width: 16),  // Spacing
    Expanded(child: RightWidget()),
  ],
)
```

**Scrollable list**:
```dart
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) {
    return ListTile(title: Text(items[index]));
  },
)
```

**Stacked widgets (overlay)**:
```dart
Stack(
  children: [
    BackgroundImage(),
    Positioned(
      top: 20,
      left: 20,
      child: OverlayWidget(),
    ),
  ],
)
```

### Custom Widgets: When to Extract

**Extract a widget when**:
- It appears 2+ times (even with slight variations)
- It has complex logic (>30 lines)
- It can be tested independently
- The parent widget is too long (>200 lines)

**Widget naming**: Be descriptive. `UserAvatarCard` not `Widget1` or `CustomWidget`.

---

## Simple State Management

For non-programmers and simple apps/games, use **setState**—it's built-in, requires no packages, and is easy to understand.

### When to Use setState

✅ **Good for**:
- Simple UI state (loading, selected tab, form input)
- Local component state (button pressed, checkbox checked)
- Small apps without complex data flow
- Games with simple state (score, current level)

❌ **Not for**:
- Complex state sharing across many screens
- Large-scale apps with heavy business logic
- State that needs persistence (use services + storage)

### setState Pattern

```dart
class ScoreWidget extends StatefulWidget {
  @override
  State<ScoreWidget> createState() => _ScoreWidgetState();
}

class _ScoreWidgetState extends State<ScoreWidget> {
  int _score = 0;  // State variable

  void _incrementScore() {
    setState(() {
      _score++;  // Update state → UI rebuilds
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Score: $_score'),
        ElevatedButton(
          onPressed: _incrementScore,
          child: Text('Add Point'),
        ),
      ],
    );
  }
}
```

**Rules**:
- State variables are private (start with `_`)
- Only call `setState` to update state
- Don't call `setState` in `build()` method

### Passing Data Between Widgets

**Parent to Child**: Use constructor parameters
```dart
ChildWidget(score: _score)  // Pass data
```

**Child to Parent**: Use callback functions
```dart
// Parent
ChildWidget(onScoreChanged: (newScore) {
  setState(() {
    _score = newScore;
  });
})

// Child
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () => widget.onScoreChanged(100),
  );
}
```

---

## Theming and Styling

### Centralized Theming

**Always use `Theme.of(context)`** instead of hardcoding colors/styles.

**In `lib/core/theme.dart`**:
```dart
final appTheme = ThemeData(
  primaryColor: AppColors.primary,
  scaffoldBackgroundColor: AppColors.background,
  textTheme: TextTheme(
    headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    bodyMedium: TextStyle(fontSize: 16),
  ),
);
```

**In widgets**:
```dart
Text(
  'Hello',
  style: Theme.of(context).textTheme.headlineLarge,
)
```

### Define App Constants

**In `lib/core/constants.dart`**:
```dart
class AppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color background = Color(0xFFFFFFFF);
  static const Color error = Color(0xFFE53935);
}

class AppSizes {
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double borderRadius = 12.0;
}

class AppStrings {
  static const String appName = 'My App';
  static const String submitButton = 'Submit';
}
```

**Use constants everywhere**:
```dart
Container(
  padding: EdgeInsets.all(AppSizes.paddingMedium),
  decoration: BoxDecoration(
    color: AppColors.primary,
    borderRadius: BorderRadius.circular(AppSizes.borderRadius),
  ),
)
```

---

## Animations (Simple)

For simple games and apps, use Flutter's built-in animations.

### Implicit Animations (Easiest)

Widgets that animate automatically when values change:

```dart
// Fade in/out
AnimatedOpacity(
  opacity: _isVisible ? 1.0 : 0.0,
  duration: Duration(milliseconds: 300),
  child: MyWidget(),
)

// Animate container properties
AnimatedContainer(
  duration: Duration(milliseconds: 300),
  width: _isExpanded ? 200 : 100,
  height: _isExpanded ? 200 : 100,
  color: _isSelected ? Colors.blue : Colors.red,
  child: MyWidget(),
)
```

### Explicit Animations (More Control)

```dart
class FadeInWidget extends StatefulWidget {
  @override
  State<FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();  // Start animation
  }

  @override
  void dispose() {
    _controller.dispose();  // Always dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: MyWidget(),
    );
  }
}
```

**Rule**: Always dispose AnimationController to prevent memory leaks.

---

## Gestures and Interactions

### Common Gestures

**Tap/Press**:
```dart
GestureDetector(
  onTap: () => print('Tapped'),
  child: Container(
    width: 100,
    height: 100,
    color: Colors.blue,
    child: Text('Tap me'),
  ),
)

// Or use buttons
ElevatedButton(
  onPressed: () => print('Pressed'),
  child: Text('Click'),
)
```

**Swipe**:
```dart
GestureDetector(
  onSwipeLeft: () => print('Swiped left'),
  onSwipeRight: () => print('Swiped right'),
  child: CardWidget(),
)
```

**Long press**:
```dart
GestureDetector(
  onLongPress: () => print('Long pressed'),
  child: Icon(Icons.delete),
)
```

**Drag**:
```dart
GestureDetector(
  onPanUpdate: (details) {
    setState(() {
      _position += details.delta;
    });
  },
  child: Positioned(
    left: _position.dx,
    top: _position.dy,
    child: DraggableWidget(),
  ),
)
```

### Interactive Buttons

Use appropriate button widgets:
- `ElevatedButton`: Primary action (most prominent)
- `TextButton`: Secondary action (less prominent)
- `OutlinedButton`: Tertiary action (outlined border)
- `IconButton`: Icon-only button
- `FloatingActionButton`: Floating action button (FAB)

---

## Game Development (Simple Games)

For simple games (quiz, puzzle, card games):

### Game State Pattern

```dart
class GameState {
  final int score;
  final int level;
  final bool isGameOver;

  GameState({
    required this.score,
    required this.level,
    required this.isGameOver,
  });

  GameState copyWith({
    int? score,
    int? level,
    bool? isGameOver,
  }) {
    return GameState(
      score: score ?? this.score,
      level: level ?? this.level,
      isGameOver: isGameOver ?? this.isGameOver,
    );
  }
}
```

### Game Loop (Simple)

```dart
Timer.periodic(Duration(seconds: 1), (timer) {
  if (!gameState.isGameOver) {
    setState(() {
      // Update game state every second
    });
  } else {
    timer.cancel();
  }
});
```

### Score Tracking

```dart
class ScoreTracker {
  int _currentScore = 0;

  void addPoints(int points) {
    _currentScore += points;
  }

  void reset() {
    _currentScore = 0;
  }

  int get score => _currentScore;
}
```

---

## Debugging Common Issues

### LayoutOverflow Errors

**Problem**: "A RenderFlex overflowed by X pixels"

**Causes**:
- Child widget too big for parent
- Not using `Expanded` or `Flexible`
- Hardcoded sizes that don't fit

**Solutions**:
1. Wrap overflowing child in `Expanded` or `Flexible`
2. Use `ListView` instead of `Column` for scrollable content
3. Reduce font sizes or padding

```dart
// ❌ BAD: Overflows
Row(
  children: [
    Container(width: 400),  // Too wide!
    Container(width: 400),  // Too wide!
  ],
)

// ✅ GOOD: Flexible
Row(
  children: [
    Expanded(child: Container()),  // Takes available space
    Expanded(child: Container()),
  ],
)
```

### setState Called Improperly

**Problem**: "setState() called after dispose()"

**Cause**: Calling `setState` after widget is removed from tree

**Solution**: Check if widget is still mounted
```dart
if (mounted) {
  setState(() {
    // Update state
  });
}
```

### Widgets Not Rebuilding

**Problem**: State changes but UI doesn't update

**Cause**: Forgetting `setState`, using `const` widgets

**Solution**: Ensure state updates use `setState` and don't use `const` on widgets that should rebuild

---

## Code Organization Rules

### File Size Limits

- **Maximum 200 lines per file**
- If exceeding 200 lines, split into smaller files
- Exception: `main.dart` can be slightly larger

### Naming Conventions

- **Files**: `snake_case.dart` (e.g., `home_screen.dart`)
- **Classes**: `PascalCase` (e.g., `HomeScreen`, `UserProfile`)
- **Variables/Functions**: `camelCase` (e.g., `userName`, `fetchData()`)
- **Constants**: `lowerCamelCase` (e.g., `appPrimaryColor`) or use classes like `AppColors.primary`
- **Private members**: Prefix with `_` (e.g., `_score`,`_handleSubmit()`)

### Export Organization

When creating reusable widgets, export from barrel file:

```dart
// lib/widgets/common.dart
export 'button_widget.dart';
export 'card_widget.dart';
export 'input_widget.dart';
```

Then import once:
```dart
import 'package:my_app/widgets/common.dart';
```

---

## Anti-Patterns to Avoid

❌ **God Components**: Single widget files with 500+ lines
Why wrong: Impossible to read, test, modify, or reuse
Better: Split into focused widgets under 200 lines each

❌ **Copy-Paste Programming**: Duplicating similar code 2+ times
Why wrong: Maintenance nightmare, bugs in multiple places
Better: Extract reusable widget or function

❌ **Hardcoded Values**: Colors, sizes, strings scattered everywhere
Why wrong: Impossible to theme, inconsistent styling
Better: Use `AppColors`, `AppSizes`, `AppStrings` constants

❌ **Ignoring Specifications**: Adding features not in PRD/user requirements
Why wrong: Wastes time, creates unnecessary code, confuses users
Better: Follow specifications exactly. Ask if unclear, don't assume.

❌ **Non-Responsive Design**: Fixed layouts for one screen size only
Why wrong: Won't work on Windows desktop AND mobile
Better: Use `LayoutBuilder`, `Flexible`, responsive breakpoints

❌ ** setState in build() Method**: Calling setState inside build
Why wrong: Infinite loop, crashes app
Better: Call setState in response to user actions or callbacks

❌ **Forgetting to Dispose**: Not disposing AnimationController, Timer, etc.
Why wrong: Memory leaks, performance issues, crashes
Better: Always override `dispose()` and clean up resources

❌ **Tight Coupling**: Widgets that depend heavily on specific implementations
Why wrong: Can't test, reuse, or modify independently
Better: Pass data via parameters, use callbacks for communication

❌ **Ignoring Errors**: Using empty catch blocks or ignoring exceptions
Why wrong: Silent failures, impossible to debug
Better: Log errors, show user-friendly error messages

❌ **Premature Optimization**: Adding complexity "for performance" without measuring
Why wrong: Unnecessary complexity, harder to maintain
Better: Keep it simple. Optimize only if there's a proven problem.

---

## Variation Guidance

**IMPORTANT**: Every app should feel uniquely designed for its specific purpose.

**Vary across dimensions**:
- **Color schemes**: Warm vs cool, vibrant vs muted, custom branding
- **Layout patterns**: Single screen, tab navigation, drawer navigation, bottom nav
- **Widget styles**: Material vs Cupertino vs custom
- **Animation style**: Subtle vs playful, minimal vs rich
- **Typography**: Sans-serif vs serif, playful vs professional

**Context should drive design**:
- **Game** → Playful, colorful, animations, sound effects
- **Productivity app** → Clean, minimal, fast, keyboard shortcuts
- **Social app** → Modern, card-based, avatars, chat bubbles
- **Utility app** → Functional, clear, icon-driven, simple

**Avoid overused patterns**:
- ❌ Default Material blue theme everywhere
- ❌ Same app structure for every project
- ❌ Generic "my app" names and icons
- ❌ Identical button styles across different apps

**Responsive behavior should vary**:
- Desktop app → Multi-column, mouse-focused, keyboard shortcuts
- Mobile app → Single column, touch-focused, swipe gestures
- Tablet app → Hybrid approach

---

## Remember

**Flutter apps are built from small, focused, reusable pieces—not monolithic monsters.**

The best apps:
- Keep widgets under 200 lines
- Extract reusable components (DRY principle)
- Use centralized theming and constants
- Design responsive layouts for Windows + mobile
- Follow specifications exactly without adding extra features
- Use simple state management (setState) for simple needs
- Organize code in consistent folder structure
- Handle errors gracefully and provide feedback

You're building more than code—you're creating a user experience. Every widget should serve a clear purpose, every file should be readable, and every decision should make the app better for its users.

**Keep it small, keep it simple, keep it modular.**
