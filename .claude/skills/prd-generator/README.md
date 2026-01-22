# PRD Generator Skill

**Version**: 1.0.0
**Quality Score**: 97/100 ✅
**Target Users**: Non-programmers who want to transform app/game ideas into complete specifications

---

## 🎯 What This Skill Does

`prd-generator` helps you create **complete Product Requirements Documents (PRD)** and **Project Implementation Plans (PIP)** for Flutter apps and games—even if you have no technical background.

It does:
- ✅ **Interactive brainstorming** to discover forgotten features
- ✅ **Complete PRD generation** (WHAT to build)
- ✅ **Implementation plan with TDD** (HOW to build with testing)
- ✅ **Automated testing strategy** (test during development, not at end)
- ✅ **Golden tests** for visual verification
- ✅ **Two separate documents** (PRD.md + PIP.md)

---

## 🚀 How to Use

### Automatic Activation

Mention PRD, planning, or app design:

```
"Create a PRD for my quiz game"
"Write a product requirements document for a todo app"
"Plan my Flutter app implementation"
"Design a card game with testing"
```

Claude Code will automatically load this skill when you mention:
- create a prd
- write prd
- product requirements
- project plan
- implementation plan
- plan my app
- design my game
- app specification
- game design document

### Explicit Invocation

```
"Use the prd-generator skill to plan my memory card game"
```

---

## 🔄 The Three-Phase Process

### Phase 1: Interactive Brainstorming

Claude asks you targeted questions to discover:

**For Games:**
- Game mechanics and rules
- Scoring system
- Win/lose conditions
- Content (questions, cards)
- Progression (levels, difficulty)

**For Apps:**
- Core user flows
- Data storage needs
- User inputs
- Offline behavior

**For Both:**
- Design preferences
- Platforms (Windows → Android/iOS)
- Edge cases ("What if X?")
- What NOT to build (out of scope)

**Example:**
```
CLAUDE: "I understand you want a quiz app. Let me ask some questions:

1. What's the quiz topic?
2. How many questions total? Shown per game?
3. Multiple choice? Timer? Change answers?
4. How is scoring calculated?
5. What happens if user closes mid-game?
6. Offline or online?
7. Color/style preferences?

[You answer - even briefly]

CLAUDE: Great! One more thing - what if there are no
questions available?
```

---

### Phase 2: Generate PRD (What to Build)

Claude generates **PRD.md** with:

- **Overview**: Name, description, target audience
- **Platforms**: Windows (dev) → Android/iOS (production)
- **Features**: Complete list with priorities
- **User Journey**: Step-by-step flow
- **Screens**: Every screen with elements
- **Design**: Colors, style, responsive behavior
- **Game Mechanics** (games) or **App Logic** (apps)
- **Edge Cases**: What-if scenarios
- **Out of Scope**: What NOT to build now

**Result**: Crystal clear specification of WHAT to build.

---

### Phase 3: Generate PIP (How to Build + Test)

Claude generates **PIP.md** with:

- **Development Phases**: Setup → Core → Polish
- **TDD Workflow** for each feature:
  1. Write tests FIRST
  2. Implement feature
  3. Verify tests pass
  4. Fix automatically if fails
- **Test Strategy**: Unit, Widget, Integration, Golden
- **Commands**: Exact commands to run
- **Automated Fixing**: Claude fixes failed tests without asking
- **Success Criteria**: When is app "done"?

**Result**: Step-by-step plan with testing for EVERY feature.

---

## 📋 Example: Creating a Quiz Game

### You Say:
```
Create a PRD for a quiz game about European capitals
```

### Phase 1: Brainstorming

**Claude** asks:
```
Great! Let me understand your vision:

1. How many total questions in the database?
2. How many shown per game? Random or fixed order?
3. Multiple choice (A, B, C, D)?
4. Timer per question or unlimited time?
5. Can user change answer before submitting?
6. Scoring: How many points per correct answer?
7. Penalty for wrong answers?
8. What score needed to "win"?
9. What happens at the end? Show score? Ranking?
10. Can user replay? Same questions or new ones?
11. What if user closes app mid-game?
12. Offline playable?
13. Color preferences? Style reference?
14. Any special features I should know about?
```

**You** answer (briefly is fine!):
```
1. 50 total
2. 10 per game, random
3. Yes multiple choice
4. No timer
5. Can change answer
6. 10 points each
7. 0 for wrong
8. 70 points to win
9. Show score + win/lose message
10. Can replay with new random 10
11. Resume where left off
12. Yes offline
13. Colorful, playful
14. No other features
```

---

### Phase 2: PRD.md Generated

**Claude** creates complete PRD:

```markdown
# PRD: EuroQuiz - European Capitals Quiz

## Overview
...
[Complete specification with:
- Game rules
- Scoring system
- All 10 questions flow
- Screen breakdowns
- Edge cases (what if closes mid-game?)
- Out of scope (no multiplayer, no timers, etc.)
]
```

---

### Phase 3: PIP.md Generated

**Claude** creates implementation plan:

```markdown
# PIP: EuroQuiz - Implementation Plan

## Phase 1: Setup

### 1.1 Project Setup
- [ ] Create Flutter project
- [ ] Setup folder structure
- [ ] Configure theme (colorful, playful)
Tests:
- [ ] Integration test: App launches
Command: flutter test integration_test/app_test.dart

## Phase 2: Core Features

### Feature: Question Display

**Step 1: Write Tests FIRST**
- [ ] Unit test: Question model creation
- [ ] Widget test: QuestionCard displays
- [ ] Golden test: Screenshot matches design
Command: flutter test test/features/question_test.dart

**Step 2: Implement**
- [ ] Create Question model
- [ ] Create QuestionCard widget

**Step 3: Verify Tests Pass**
Command: flutter test test/features/question_test.dart

**If fails**: Claude fixes automatically ✅

[Continue for all features...]
```

---

## 🎯 How This Solves Your Problems

### Problem: "I Forget Important Things"

**Old way**: Describe app → Forget edge cases → Problems later

**New way with this skill**:
- Claude asks targeted questions
- Discovers forgotten requirements
- Identifies edge cases upfront
- Nothing forgotten

### Problem: "Claude Adds Things I Didn't Ask For"

**Old way**: Vague description → Claude guesses → Extra features

**New way**:
- PRD has "Out of Scope" section
- Explicitly lists what NOT to build
- Claude sticks to PRD exactly

### Problem: "I Don't Know What to Include"

**Old way**: Where to start? What's important?

**New way**:
- Skill asks you the right questions
- Generates complete template
- You just answer questions

### Problem: "Apps Have Bugs After"

**Old way**: Build everything → Test at end → 100 bugs

**New way**:
- TDD: Test BEFORE each feature
- Fix issues immediately
- Claude fixes failed tests automatically
- Bugs prevented, not discovered later

### Problem: "Can't Explain Well"

**Old way**: Long vague description → Misunderstandings

**New way**:
- Claude asks specific questions
- You answer briefly
- Claude fills in details
- Clear, structured specification

---

## 🔧 Automated Testing & Fixing

### How It Works:

#### 1. Test During Development (Not After)

For EACH feature:
```
1. Write test → Fails (no code yet)
2. Write code
3. Run test → Passes ✅
4. Move to next feature
```

**Benefit**: Catch bugs immediately, not later.

---

#### 2. Automatic Fixing

```
YOU: [Run test]
flutter test test/widgets/score_test.dart

OUTPUT: Test fails ❌

CLAUDE: "I see the issue - score isn't updating when
answer is correct. Fixing now..."

[Generates fixed code]

CLAUUDE: "Please re-run: flutter test test/widgets/score_test.dart"

YOU: [Re-run]

OUTPUT: Test passes ✅

CLAUDE: "Perfect! Moving to next feature."
```

**No "Should I fix it?"** → Claude just fixes it.

---

#### 3. Golden Tests (Screenshots)

```
CLAUDE: "Creating golden test for HomeScreen..."

YOU: [Run test]
flutter test test/screens/home_golden_test.dart

OUTPUT: Creates screenshot → goldens/home.png

CLAUDE: "Screenshot captured. Please verify it looks correct."

YOU: "Looks good!"

[LATER - After code changes]

YOU: flutter test test/screens/home_golden_test.dart

OUTPUT: Test fails - visual changed!

CLAUDE: "Golden test failed - layout is different.
Fixing now..."

[Fixes layout]

YOU: [Re-run] → Passes ✅
```

**Benefit**: Visual regressions caught automatically.

---

## 📁 Two Separate Documents

### Why Two Documents?

**PRD.md** = WHAT to build
- Features
- Design
- User journey
- Requirements

**PIP.md** = HOW to build (with testing)
- Implementation order
- Tests for each feature
- Commands to run
- Success criteria

**Separate because**:
- PRD can change without breaking PIP
- Easier to maintain
- Clearer separation of concerns

---

## 💡 Tips for Best Results

### 1. Answer Brainstorming Questions

Even brief answers help! Examples:
- "10 questions" vs "I don't know"
- "Colorful" vs "No preference"
- "Can replay" vs "Not sure"

### 2. Be Honest About "Don't Know"

If unsure, say "I don't know, you decide"
- Claude will make reasonable choice
- Or explain options and ask you to pick

### 3. Review PRD Before Development

When PRD is generated:
- Read it through
- Does it match your vision?
- Any changes needed?
- Better to fix PRD than code later!

### 4. Execute PIP Step-by-Step

For each feature:
1. Run the test command shown
2. Let Claude fix if it fails
3. Verify manually if you want
4. Only then move to next feature

### 5. Approve Golden Screenshots

When golden tests create screenshots:
- Open the image file
- Does it look right?
- If yes, great!
- If no, tell Claude what to fix

---

## 🎮 Examples: What You Can Plan

### Games
- ✅ Quiz games (any topic)
- ✅ Memory card matching
- ✅ Puzzle games
- ✅ Simple word games
- ✅ Flashcard apps

### Productivity Apps
- ✅ Todo lists
- ✅ Note taking
- ✅ Habit trackers
- ✅ Calendars
- ✅ Budget managers

### Utility Apps
- ✅ Calculators
- ✅ Converters
- ✅ Timers
- ✅ Counter apps

---

## 🔄 Complete Workflow Example

```
YOU: "Create a PRD for a memory card matching game"

PHASE 1: Brainstorming
CLAUDE: [Asks 15 questions about game]
YOU: [Answer briefly]

PHASE 2: PRD Generated
CLAUDE: [Creates PRD.md with complete spec]

PHASE 3: PIP Generated
CLAUDE: [Creates PIP.md with TDD steps]

DEVELOPMENT STARTS
↓

Feature 1: Card Model
CLAUDE: "Write test first..."
YOU: [flutter test]
OUTPUT: Fails
CLAUDE: [Fixes automatically]
YOU: [Re-run] → Passes ✅

Feature 2: Card Widget
CLAUDE: "Write test first..."
YOU: [flutter test]
OUTPUT: Passes ✅

Feature 3: Game Logic
[Continue for all features...]

FINAL APP: Fully tested, working! 🎉
```

---

## 🎓 Key Principles

This skill instills:

1. **Discover Before Declare** → Ask questions first
2. **Test-Driven Development** → Test before code
3. **Visual Verification** → Golden tests prevent regressions
4. **Automated Fixing** → Fix immediately, don't ask
5. **Separate Documents** → PRD (what) + PIP (how)

---

## 🔗 Related Skills

- **prd-generator**: Plan the app (use FIRST)
- **flutter-creator**: Build the app (use SECOND)
- **flutter-testing**: Test the app (integrated in PIP)

**Recommended workflow**:
1. Create PRD + PIP with `prd-generator`
2. Build following PIP with `flutter-creator`
3. Tests included in every step (TDD)

---

## 📄 License

Part of the BuilderPack collection.

---

## 💡 Remember

**A day spent planning saves a week of rework.**

With this skill, Claude helps you:
- Discover forgotten requirements
- Create clear specifications
- Plan implementation with testing
- Prevent bugs before they happen
- Fix issues automatically

**You don't need to be a technical writer—Claude creates complete PRD and PIP for you.**

**Happy planning! 📋**
