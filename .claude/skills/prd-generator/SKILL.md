---
name: prd-generator
description: >
  Generate complete Product Requirements Documents (PRD) and Project Implementation
  Plans (PIP) for Flutter apps and games. Use interactive brainstorming to
  discover forgotten features, clarify requirements, and identify edge cases.
  Generates two separate documents: PRD (what to build) and PIP (how to build
  with test-driven development). Includes automated testing strategy with
  golden tests for visual verification. Use when starting new Flutter projects,
  planning app/game features, or creating implementation roadmaps with testing.
triggers:
  - create a prd
  - write prd
  - product requirements
  - project plan
  - implementation plan
  - plan my app
  - design my game
  - app specification
  - game design document
---

# PRD Generator

Generate complete Product Requirements Documents and Project Implementation Plans for Flutter apps and games—designed for non-programmers who want AI to transform ideas into detailed, actionable specifications.

## Philosophy: Great Products Start with Clear Requirements

Vague ideas lead to misunderstood requirements, which leads to wasted time, wrong features, and frustrating rework. **Clear specifications are the foundation of successful products**.

**Core principle: Discover Before Declare**

| Rush to Code | Discover First |
|--------------|----------------|
| Start coding immediately | Ask questions first |
| Make assumptions | Clarify ambiguities |
| Forget edge cases | Identify what-ifs |
| Test at the end | Test during development |
| Fix bugs later | Prevent bugs upfront |

### Before Generating PRD, Ask

- **What problem does this solve?** Who has the problem?
- **What's the core value proposition?** Why would someone use this?
- **What's the minimum viable version?** Smallest feature set that's useful
- **What are edge cases?** What happens when X, Y, or Z goes wrong?
- **What's OUT of scope?** What are we NOT building (prevents scope creep)

### Core Principles

1. **Interrogate, Don't Assume**: Ask until requirements are crystal clear
2. **Test-Driven Planning**: Plan tests for each feature before implementation
3. **Visual Verification**: Use golden tests to prevent visual regressions
4. **Iterative Discovery**: Brainstorming reveals forgotten requirements
5. **Two Separate Documents**: PRD (what) + PIP (how with testing)

### Mental Model: The Specification Funnel

```
         Idea
           ↓
    [Brainstorming]  ← Ask questions, discover features
           ↓
    [Requirements]   ← PRD: What to build
           ↓
    [Implementation] ← PIP: How to build + test
           ↓
         Product
```

Don't skip steps—each stage prevents costly mistakes later.

---

## Quick Start: The Three-Phase Process

### Phase 1: Interactive Brainstorming

Ask progressive questions to discover complete requirements:

**For Games**:
- Game mechanics and rules
- Win/lose conditions
- Scoring system
- Progression (levels, difficulty)
- Content (questions, cards, puzzles)
- States (start, playing, paused, game over)

**For Apps**:
- Core user flows
- Data storage (what, where, how)
- User inputs and validation
- State management needs
- Offline behavior
- Multi-platform considerations

**For Both**:
- Design preferences (colors, style, inspiration)
- Platforms (Windows dev → Android/iOS production)
- Offline/online requirements
- Multi-language needs
- Edge cases and what-if scenarios

**Critical question**: "What happens when [unexpected situation]?"

Examples:
- "What if user closes app mid-game?"
- "What if network fails during save?"
- "What if user enters invalid data?"
- "What if device runs out of storage?"

### Phase 2: Generate PRD (Product Requirements Document)

Create PRD.md with:
- Overview (name, description, target)
- Platforms & technical requirements
- Core features with priorities
- Complete user journey
- Screens and UI specifications
- Game mechanics or app logic
- Edge cases and error handling
- Out of scope (what NOT to build)

### Phase 3: Generate PIP (Project Implementation Plan)

Create PIP.md with:
- Development phases
- Feature breakdown with TDD workflow
- Test strategy (unit, widget, integration, golden)
- Automated fixing instructions
- Success criteria

---

## PRD Template Structure

### 1. Overview

```markdown
# PRD: [App Name]

## One-Liner
[Single sentence description]

## Description
[2-3 paragraphs explaining what the app/game is and does]

## Type
- [ ] Game
- [ ] Productivity App
- [ ] Utility App
- [ ] Other: [specify]

## Target Audience
[Who is this for? What problem does it solve?]
```

### 2. Platforms & Technical Requirements

```markdown
## Development Platform
- Primary: Windows (development/testing)

## Production Platforms
- [ ] Android
- [ ] iOS
- [ ] Web

## Technical Stack
- Framework: Flutter
- Language: Dart

## Requirements
- [ ] Offline support
- [ ] Multi-language
- [ ] Persistent storage
- [ ] Network connectivity
- [ ] Device features (camera, GPS, etc.)
```

### 3. Core Features

```markdown
## Features (Must-Have)

### Feature 1: [Name]
**Description**: [Detailed description]
**Priority**: Must-Have
**User Value**: [Why users need this]

### Feature 2: [Name]
**Description**: [Detailed description]
**Priority**: Must-Have

## Features (Nice-to-Have)

### Feature 3: [Name]
**Description**: [Detailed description]
**Priority**: Nice-to-Have (Future v2.0)
```

### 4. User Journey (Complete Flow)

```markdown
## User Journey

**Flow: App Open → [Action] → [Result]**

1. **App Launch**
   - User opens app
   - Sees: [Screen name]
   - Can: [actions available]

2. **[Next Step]**
   - User taps [button/element]
   - Navigates to: [Screen name]
   - Sees: [content]

3. **[Continue for entire flow]**

4. **[End State]**
   - User reaches: [Screen/Result]
   - Can: [next actions]
```

### 5. Screens & UI

```markdown
## Screens

### Screen 1: [Name] (e.g., HomeScreen)
**Purpose**: [What user does here]
**Elements**:
- [ ] [UI Element 1]: [Description]
- [ ] [UI Element 2]: [Description]
**Navigation**:
- From: [Where user comes from]
- To: [Where user goes next]
**Responsive**:
- Windows: [Layout description]
- Mobile: [Layout description]

### Screen 2: [Name]
[Continue for all screens...]

## Design & Styling

**Color Scheme**:
- Primary: [Hex color or description]
- Secondary: [Hex color or description]
- Background: [Hex color or description]
- Accent: [Hex color or description]

**Typography**:
- Font style: [Modern, playful, professional, etc.]
- Inspiration: [Reference apps if any]

**Visual Style**:
- [ ] Minimal
- [ ] Playful
- [ ] Professional
- [ ] Dark mode
- [ ] Other: [describe]
```

### 6. Game Mechanics (for Games) or App Logic (for Apps)

**For Games**:
```markdown
## Game Mechanics

### Core Rules
1. [Rule 1]
2. [Rule 2]
3. [Rule 3]

### Scoring System
- Correct action: [+X points]
- Incorrect action: [-Y points or 0]
- Bonus: [conditions]
- Win condition: [score/threshold]
- Lose condition: [conditions]

### Progression
- Levels: [number or infinite]
- Difficulty increase: [how]
- Content variety: [how generated/selected]

### Game States
- **Start Screen**: [description]
- **Playing**: [description]
- **Paused**: [description]
- **Game Over**: [description]
- **Victory**: [description]
```

**For Apps**:
```markdown
## App Logic

### Data Flow
1. User [action]
2. App [processes]
3. Data [stored/displayed]

### State Management
- What state needs to persist: [list]
- Where stored: [local storage, database, etc.]
- When saved: [immediate, on exit, manually]

### Business Rules
- [Rule 1]: [description]
- [Rule 2]: [description]
```

### 7. Edge Cases & Error Handling

```markdown
## Edge Cases

### What-If Scenarios

**Q: What if user closes app mid-[action]?**
A: [What happens - state saved? lost? resumes?]

**Q: What if [error condition]?**
A: [How app handles it]

**Q: What if user enters invalid data?**
A: [Validation + error message]

**Q: What if [unexpected scenario]?**
A: [Handling approach]

### Error Handling
- Network errors: [message + retry option]
- Invalid input: [validation + inline error]
- Storage full: [message + resolution]
- Crashes: [auto-save? recovery?]
```

### 8. Out of Scope

```markdown
## Out of Scope (Explicitly NOT in v1.0)

The following features are intentionally excluded from this version:
- [Feature not included]: [Reason why deferred]
- [Feature not included]: [Reason why deferred]

**Rationale**: Focus on core value first, add complexity later.
```

---

## PIP Template Structure

### Project Implementation Plan

```markdown
# PIP: [App Name] - Implementation Plan

## Development Strategy

**Approach**: Test-Driven Development (TDD)
- Write tests BEFORE code
- Implement feature
- Verify tests pass
- Only then move to next feature

**Why TDD?**
- Catch issues immediately
- Prevent accumulation of bugs
- Tests serve as documentation
- Faster overall development

## Phases Overview

- **Phase 1**: Setup & Foundation
- **Phase 2**: Core Features (Must-Haves)
- **Phase 3**: Secondary Features
- **Phase 4**: Polish & Optimization
- **Phase 5**: Testing & Deployment

---

## Phase 1: Setup & Foundation

### 1.1 Project Setup
**Implementation**:
- [ ] Create Flutter project: `flutter create app_name`
- [ ] Setup folder structure (lib/core, lib/widgets, lib/screens, etc.)
- [ ] Configure app theme (colors, fonts in theme.dart)
- [ ] Setup constants (AppColors, AppSizes, AppStrings)

**Tests**:
- [ ] Integration test: App launches without crash
- [ ] Golden test: Home screen initial state

**Command**:
```bash
flutter test integration_test/app_launch_test.dart
```

**Verify**: Run app → `flutter run -d windows`
**Expected**: App opens, shows home screen ✅

---

### 1.2 Navigation Structure
**Implementation**:
- [ ] Define routes
- [ ] Create base screen shells
- [ ] Implement navigation between main screens

**Tests**:
- [ ] Widget test: Navigation buttons trigger correct routes
- [ ] Integration test: Complete navigation flow

**Command**:
```bash
flutter test test/screens/navigation_test.dart
```

**Verify**: Tap through screens, verify navigation ✅

---

## Phase 2: Core Features

For EACH feature, follow this pattern:

### Feature X: [Feature Name]

#### Step 1: Write Tests FIRST

**Unit Tests** (if applicable):
- [ ] Test [specific logic/behavior]
- [ ] Test [edge case]
- [ ] Test [error condition]

**Widget Tests**:
- [ ] Test [widget renders correctly]
- [ ] Test [interaction works]
- [ ] Test [state updates properly]

**Integration Test**:
- [ ] Test [complete user flow]

**Golden Test** (Visual verification):
- [ ] Test [screenshot matches design]

**File**: `test/[path]/[feature]_test.dart`

**Command**: `flutter test test/[path]/[feature]_test.dart`

---

#### Step 2: Implement Feature

**Implementation Checklist**:
- [ ] Create model/class (if needed)
- [ ] Create widget
- [ ] Implement logic
- [ ] Connect to state management
- [ ] Add styling

**Files**:
- `lib/models/[feature].dart` (if needed)
- `lib/widgets/[feature].dart`
- `lib/screens/[feature].dart` (if screen)

---

#### Step 3: Verify Tests Pass

**Run Tests**:
```bash
flutter test test/[path]/[feature]_test.dart
```

**Expected**: All tests pass ✅

---

#### Step 4: Automated Fixing (If Tests Fail)

**IMPORTANT**: Never ask user "should I fix it?"

**Workflow**:
1. Test fails → Read error message
2. Identify root cause
3. Fix the code
4. Explain: "Fixed [specific issue]. Please re-run: [command]"
5. User re-runs → Test should pass ✅

**If still failing**:
- Re-analyze error
- Try different fix
- Re-test
- Repeat until passes

---

#### Step 5: Manual Verification (Optional)

**Run on Windows**:
```bash
flutter run -d windows
```

**Check**:
- [ ] Visual appearance matches design
- [ ] Interaction feels right
- [ ] Performance acceptable

**Take Screenshot** (for golden reference):
- If looks correct, approve golden file
- If not, update golden and fix

---

#### Step 6: Feature Complete ✅

Move to next feature only when:
- [ ] All tests pass
- [ ] Manual verification (if done) successful
- [ ] No obvious bugs or issues

---

## Test Strategy

### Unit Tests
**Purpose**: Test business logic, calculations, data transformations
**Run**: `flutter test`
**Speed**: Very fast (milliseconds)
**Coverage**: All pure functions, models, business logic

### Widget Tests
**Purpose**: Test UI components and interactions
**Run**: `flutter test`
**Speed**: Fast
**Coverage**: All widgets, user interactions, state changes

### Integration Tests
**Purpose**: Test complete flows across multiple screens
**Run**: `flutter test integration_test/`
**Speed**: Slower (runs on device/emulator)
**Coverage**: Critical user flows (login, gameplay, etc.)

### Golden Tests
**Purpose**: Visual regression testing
**Run**: `flutter test`
**Speed**: Fast
**Usage**: Every screen, every significant widget
**Update**: `flutter test --update-goldens`

---

## Automated Testing Workflow

### When Implementing Each Feature:

```bash
# 1. Write test (fails initially)
flutter test test/widgets/my_widget_test.dart

# 2. Implement widget

# 3. Re-run test
flutter test test/widgets/my_widget_test.dart

# 4. If fails → AI fixes automatically → re-run
# Repeat until passes ✅

# 5. Create golden test
flutter test test/widgets/my_widget_golden_test.dart

# 6. Verify golden screenshot
# If correct → approve
# If wrong → fix and re-run

# 7. Move to next feature
```

### Golden Test Workflow:

```bash
# First time: Creates golden file
flutter test test/screens/home_screen_test.dart
# → Creates: goldens/home_screen.png

# Verify: Open screenshot, check if correct
# If correct → Great! Test will prevent regressions.

# After code changes:
flutter test test/screens/home_screen_test.dart
# → If visual changed: Test FAILS with diff

# AI: Sees failure → Fixes layout → Updates golden
# Re-run → Passes ✅
```

---

## Success Criteria

Project is complete when:

- [ ] All PRD features implemented
- [ ] All unit tests pass (target: 70%+ coverage)
- [ ] All widget tests pass
- [ ] All integration tests pass
- [ ] All golden tests pass
- [ ] Tested on Windows (development)
- [ ] Tested on Android (production)
- [ ] Tested on iOS (production)
- [ ] Zero critical bugs
- [ ] Performance acceptable
- [ ] No visual regressions

---

## Deployment Checklist

### Pre-Deployment
- [ ] All tests pass
- [ ] Code reviewed (or self-reviewed against PRD)
- [ ] Golden tests verified
- [ ] Performance tested
- [ ] Error handling tested

### Windows Deployment
- [ ] Build: `flutter build windows`
- [ ] Test on clean Windows machine
- [ ] Verify all features work

### Android Deployment
- [ ] Build: `flutter build apk`
- [ ] Test on Android device
- [ ] Verify responsive design
- [ ] Test on different screen sizes

### iOS Deployment
- [ ] Build: `flutter build ios`
- [ ] Test on iOS device
- [ ] Verify permissions
- [ ] Test on different iPhone/iPad sizes

---

## Anti-Patterns to Avoid

❌ **Writing PRD After Starting Development**
Why wrong: Leads to missing features, wrong assumptions, rework
Better: Complete PRD first, then PIP, then development

❌ **Vague One-Line Requirements**
Why wrong: "Add login" is too vague—what kind? Email? Social? OAuth?
Better: "Add email/password login with validation and error messages"

❌ **Forgetting Edge Cases**
Why wrong: Users WILL encounter edge cases, app will break
Better: Ask "what if X?" for every feature

❌ **Testing at the End**
Why wrong: Accumulation of bugs, hard to fix, no safety net
Better: TDD—test BEFORE each feature

❌ **Asking "Should I Fix?" When Test Fails**
Why wrong: Wastes time, user already wants it fixed
Better: Fix immediately, then ask to re-run test

❌ **Skipping Golden Tests**
Why wrong: Visual regressions slip through, manual verification slow
Better: Golden test for every screen and significant widget

❌ **No Out of Scope Section**
Why wrong: Scope creep, project never finishes
Better: Explicitly list what NOT to build now

❌ **Assuming Instead of Asking**
Why wrong: You'll guess wrong, build wrong thing
Better: Ask questions until requirements are crystal clear

❌ **Single Monolithic Document**
Why wrong: Confuses what (PRD) with how (PIP)
Better: Two separate documents: PRD.md + PIP.md

❌ **Forgetting User Journey**
Why wrong: Screens built in isolation don't flow well
Better: Map complete user journey first, then build screens

❌ **Ignoring Technical Constraints**
Why wrong: Design impossible to implement, performance issues
Better: Consider platform limitations early

---

## Variation Guidance

**IMPORTANT**: PRDs and PIPs should adapt to project type.

**For GAMES**:
- Emphasize: Game mechanics, scoring, progression, content
- User journey: Start → Play → Win/Lose → Restart
- Testing: Focus on game logic, state changes, scoring accuracy
- Screens: Game screens often have unique layouts

**For PRODUCTIVITY APPS**:
- Emphasize: User flows, data management, efficiency
- User journey: Task → Action → Complete → Next task
- Testing: Focus on data integrity, validation, state persistence
- Screens: Often use standard patterns (lists, forms, cards)

**For UTILITY APPS**:
- Emphasize: Speed, simplicity, single-purpose focus
- User journey: Open → Use → Close
- Testing: Focus on core functionality accuracy
- Screens: Minimal, often single-screen

**Context should drive detail level**:
- **Simple app** → Shorter PRD, fewer features
- **Complex app** → Detailed PRD, more edge cases
- **First version** → MVP features only
- **Mature product** → More comprehensive features

**Vary brainstorming questions**:
- Games → Rules, scoring, content
- Apps → User flows, data, workflows
- Utilities → Core function, speed, simplicity

**Avoid one-size-fits-all**:
- ❌ Same template for everything
- ❌ Same questions regardless of context
- ❌ Same testing approach for all projects

---

## Brainstorming Questions by Category

### For Any Project:
- What problem does this solve?
- Who is the target user?
- What's the core value?
- What platforms?
- Offline or online?
- Multi-language?

### For Games:
- What are the rules?
- How do you win/lose?
- How is scoring calculated?
- What's the progression?
- What content (questions, cards, etc.)?
- What states exist (start, play, pause, game over)?
- What happens if player quits mid-game?
- Is there a time limit?
- Are there levels or infinite play?

### For Apps:
- What's the primary user flow?
- What data needs to be stored?
- What inputs does user provide?
- How is data validated?
- Can user work offline?
- What happens if sync fails?
- What's the retention strategy (why come back)?

### Edge Cases (Always Ask):
- What if user closes app mid-action?
- What if network fails?
- What if storage is full?
- What if user enters invalid data?
- What if device has poor performance?
- What if user denies permissions?

### Design:
- Color preferences?
- Style inspiration (other apps)?
- Playful or professional?
- Dark mode?
- Custom illustrations or standard icons?

---

## Remember

**Clear specifications prevent wasted development time.**

The best PRDs and PIPs:
- Start with questions, not assumptions
- Separate WHAT (PRD) from HOW (PIP)
- Include edge cases and error handling
- Plan tests before implementation
- Use golden tests for visual verification
- Fix failed tests automatically, don't ask permission
- Adapt to project type (game vs app vs utility)

**A day spent planning saves a week of rework.**

**Great products aren't coded—they're designed first, then built.**
