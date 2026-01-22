# Flutter Creator Skill

**Version**: 1.0.0
**Quality Score**: 92/100 ✅
**Target Users**: Non-programmers who want to create Flutter apps and simple games

---

## 🎯 What This Skill Does

`flutter-creator` helps you create production-ready Flutter apps and simple games from scratch—**even if you don't know how to program**.

It covers:
- ✅ Complete app development (UI, widgets, layouts)
- ✅ Simple games (quiz, puzzle, card games)
- ✅ Responsive design (Windows desktop + Android/iOS mobile)
- ✅ Simple state management (no complex patterns needed)
- ✅ Animations and gestures
- ✅ Debugging common issues
- ✅ Code organization (modular, reusable, clean)

---

## 🚀 How to Use

### Option 1: Automatic Activation

Just mention Flutter in your conversation:

```
"Create a Flutter quiz app with 10 questions"
"Build a card game memory match in Flutter"
"Fix this Flutter layout overflow error"
"Add a login screen to my Flutter app"
```

Claude Code will automatically load this skill when you mention:
- flutter
- flutter app
- flutter game
- dart mobile app
- create flutter
- build flutter
- fix flutter bug

### Option 2: Explicit Invocation

```
"Use the flutter-creator skill to build a calculator app"
```

---

## 📋 What Makes This Skill Different

### 1. Designed for Non-Programmers
- No prior programming knowledge needed
- AI handles 100% of code writing
- Clear explanations of what code does

### 2. Modular & Organized
- All files under 200 lines
- Reusable components (DRY principle)
- Consistent folder structure
- No code duplication

### 3. Follows Your Specifications
- **Never** adds features you didn't request
- Sticks to your PRD (Product Requirements Document)
- Asks when unclear, never assumes

### 4. Responsive by Default
- Works on Windows desktop
- Works on Android/iOS mobile
- Adaptive layouts

### 5. Simple State Management
- Uses built-in `setState`
- No complex packages to learn
- Perfect for simple apps and games

---

## 🎨 What This Skill Prevents

Based on real pain points from Flutter development:

| Pain Point | How This Skill Prevents It |
|------------|---------------------------|
| **Gigantic files** (500+ lines) | Rule: Max 200 lines per file |
| **Copy-pasted code** | Extract reusable widgets automatically |
| **Hardcoded colors/sizes** | Uses `AppColors`, `AppSizes`, `AppStrings` |
| **Layout overflow errors** | Teaches proper `Flexible`/`Expanded` usage |
| **AI adds unwanted features** | Strict rule: Follow specs only |
| **Not responsive** | Uses `LayoutBuilder` for adaptive layouts |
| **Memory leaks** | Always disposes controllers/timers |
| **Impossible to read** | Modular structure, clear naming |

---

## 📁 Standard Project Structure

When you ask to create an app, this skill generates:

```
lib/
├── main.dart                 # App entry point
├── core/                     # App-wide constants & utilities
│   ├── constants.dart        # Colors, sizes, strings
│   ├── theme.dart            # App theme
│   └── utils.dart            # Helper functions
├── models/                   # Data models
├── widgets/                  # Reusable UI components
│   └── common/               # Generic widgets
├── screens/                  # Full-screen widgets
├── services/                 # External services
└── features/                 # Feature modules (optional)
```

**Benefits**:
- Easy to navigate
- Clear separation of concerns
- Reusable components
- Testable code

---

## 💬 Example Conversations

### Creating a New App

**You**:
```
Create a Flutter quiz app about capitals.
Show 10 random questions, keep score, show results at the end.
```

**Claude (with this skill)**:
1. Creates proper folder structure
2. Builds `QuizScreen` with question display
3. Adds `ScoreWidget` for tracking points
4. Implements `ResultScreen` for final score
5. Uses `setState` for score management
6. Makes it responsive for Windows + mobile
7. No file exceeds 200 lines
8. All colors/sizes in `AppConstants`

### Fixing a Bug

**You**:
```
Fix this layout overflow error in my Flutter app
```

**Claude (with this skill)**:
1. Identifies the overflow cause
2. Wraps overflowed widget in `Expanded` or `Flexible`
3. Explains why the fix works
4. Tests responsive behavior

### Adding a Feature

**You**:
```
Add swipe gestures to the card game
```

**Claude (with this skill)**:
1. Adds `GestureDetector` to cards
2. Implements `onSwipeLeft`/`onSwipeRight`
3. Updates state appropriately
4. Doesn't add unrelated features
5. Reuses existing card widget

---

## 🎓 Key Principles Taught

This skill instills these principles in Claude:

1. **Modularity First** → Every widget has ONE job
2. **DRY (Don't Repeat Yourself)** → Reuse, don't copy-paste
3. **Responsive by Default** → Design for multiple screen sizes
4. **Explicit Over Implicit** → Follow your specs exactly
5. **Organized Structure** → Consistent folder organization

---

## 🚫 What This Skill WON'T Do

- ❌ Add features you didn't request
- ❌ Create files over 200 lines
- ❌ Duplicate code
- ❌ Hardcode values (colors, sizes, strings)
- ❌ Ignore your specifications
- ❌ Create non-responsive layouts
- ❌ Over-engineer simple problems

---

## 🔄 Workflow Recommendations

### For New Apps

1. **Write a PRD** (Product Requirements Document)
   - What the app does
   - Key features
   - Target platforms (Windows, Android, iOS)

2. **Tell Claude about Flutter**
   - Mention "Use Flutter" at the start
   - Share your PRD
   - The skill will activate automatically

3. **Iterate on features**
   - Add features one at a time
   - Test on both desktop and mobile
   - Ask for changes when needed

### For Debugging

1. **Describe the problem**
   - Include error messages
   - Explain expected vs actual behavior

2. **Share relevant code**
   - The problematic widget/file
   - Error output

3. **Let Claude fix it**
   - This skill knows common issues
   - Will explain the fix
   - Won't add unnecessary changes

---

## 📊 Skill Quality Metrics

This skill scored **92/100** on the skill quality analysis:

- **Philosophy Foundation**: 35/40 (87%)
- **Anti-Pattern Prevention**: 25/25 (100%)
- **Variation Encouragement**: 18/20 (90%)
- **Organization**: 9/10 (90%)
- **Empowerment vs Constraint**: 5/5 (100%)

**Target**: 70+/100 for effective skills ✅

---

## 🛠️ Technical Details

- **Name**: `flutter-creator`
- **Type**: Development skill
- **Framework**: Flutter (Dart)
- **State Management**: Built-in `setState`
- **Platforms**: Windows, Android, iOS
- **Game Complexity**: Simple games only (no physics, no multiplayer)

---

## 📝 Tips for Best Results

1. **Be Specific in Your Requirements**
   - Bad: "Create an app"
   - Good: "Create a quiz app with 10 questions about capitals"

2. **Mention Flutter Early**
   - Say "using Flutter" in your first message
   - This ensures the skill activates

3. **Test on Multiple Platforms**
   - Windows desktop during development
   - Android/iOS before release

4. **Ask for Explanations**
   - "Why did you structure it this way?"
   - "What does this widget do?"

5. **Iterate Gradually**
   - Start with core features
   - Add advanced features later

---

## 🎮 Examples of Apps You Can Create

### Productivity Apps
- Todo list
- Note taking app
- Habit tracker
- Calendar app

### Simple Games
- Quiz game
- Memory card matching
- Tic-tac-toe
- Flashcard app
- Simple puzzle games

### Utility Apps
- Calculator
- Converter app
- Timer/stopwatch
- Weather app (with API)

### Social/Lifestyle
- Journal app
- Recipe collection
- Workout tracker
- Budget manager

---

## 🔗 Related Skills

After mastering app creation, you might want:

- **flutter-testing** (coming soon): Learn to test your Flutter apps
- **flutter-architecture** (if needed): Advanced patterns for complex apps

---

## 📄 License

Part of the BuilderPack collection.

---

## 💡 Remember

**You don't need to know programming to create Flutter apps with this skill.**

Just describe what you want clearly, and Claude (using this skill) will:
1. Create organized, modular code
2. Follow your specifications exactly
3. Make it responsive for Windows + mobile
4. Keep everything clean and reusable
5. Explain what the code does

**Happy app building!** 🚀
