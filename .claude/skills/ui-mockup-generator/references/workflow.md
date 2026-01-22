# Workflow: Integrating UI Mockup Generator with Other Skills

This guide explains how `ui-mockup-generator` fits into the complete Flutter development workflow with other BuilderPack skills.

## Complete Flutter Development Pipeline

```
┌─────────────────┐
│   User Idea     │
└────────┬────────┘
         │
         ▼
┌─────────────────────────────────┐
│  1. prd-generator               │
│  - Interactive brainstorming    │
│  - Generate PRD.md (what)       │
│  - Generate PIP.md (how + test) │
└────────┬────────────────────────┘
         │ PRD.md + PIP.md ready
         ▼
┌─────────────────────────────────┐
│  2. ui-mockup-generator         │
│  - Read PRD.md for context      │
│  - Ask design system questions  │
│  - Generate MOCKUP.md (visual)  │
└────────┬────────────────────────┘
         │ MOCKUP.md ready
         ▼
┌─────────────────────────────────┐
│  3. flutter-creator             │
│  - Read MOCKUP.md               │
│  - Read PIP.md (testing)        │
│  - Implement Flutter code       │
└────────┬────────────────────────┘
         │ Flutter code ready
         ▼
┌─────────────────────────────────┐
│  4. flutter-testing             │
│  - Read PIP.md                  │
│  - Generate tests               │
│  - Run tests + fix failures     │
└────────┬────────────────────────┘
         │
         ▼
┌─────────────────┐
│  Complete App   │
└─────────────────┘
```

## Step-by-Step Integration

### Step 1: Generate PRD (prd-generator)

**User says**:
```
"Create a PRD for my task manager app"
```

**What happens**:
1. `prd-generator` skill loads
2. Asks brainstorming questions (features, user flows, edge cases)
3. Generates `PRD.md` with:
   - Overview
   - Features (must-have, nice-to-have)
   - User journey
   - Screens list
   - App logic
   - Edge cases
4. Generates `PIP.md` with:
   - Development phases
   - Testing strategy
   - Success criteria

**Output files**:
- `PRD.md`
- `PIP.md`

**Time**: 15-30 minutes

---

### Step 2: Generate UI Mockups (ui-mockup-generator)

**User says**:
```
"Generate UI mockups for my task manager app"
```

**What happens**:
1. `ui-mockup-generator` skill loads
2. Reads `PRD.md` for context (screens, features, user journey)
3. Asks design system questions:
   - Color scheme (HEX codes)
   - Typography (font style, sizes)
   - Visual style (minimal, playful, professional)
   - Spacing system
4. For EACH screen in PRD:
   - Asks screen-specific questions
   - Generates ASCII layout (mobile)
   - Lists all elements with positions
   - Creates 5 state variations (normal, loading, error, empty, success)
   - Adds responsive rules (desktop/tablet)
5. Generates `MOCKUP.md` with:
   - Design system (colors, typography, spacing)
   - Component library (reusable widgets)
   - Navigation flow (user flows, route map, interaction types)
   - Screen mockups (ASCII + elements + states + responsive)

**Output files**:
- `MOCKUP.md`

**Time**: 20-40 minutes (depending on number of screens)

---

### Step 3: Implement Flutter Code (flutter-creator)

**User says**:
```
"Implement my task manager app using the mockups"
```

**What happens**:
1. `flutter-creator` skill loads
2. Reads `MOCKUP.md` for visual specifications
3. Reads `PIP.md` for testing requirements
4. Creates Flutter project structure:
   - `lib/core/theme.dart` (from design system colors)
   - `lib/core/constants.dart` (from spacing system)
   - `lib/widgets/common/` (from component library)
   - `lib/screens/` (from screen mockups)
5. For EACH screen in MOCKUP.md:
   - Implements layout following ASCII mockup
   - Implements all 5 states
   - Applies responsive rules
   - Uses components from library
6. Writes tests following PIP.md (TDD approach)

**Output files**:
- `lib/` (Flutter source code)
- `test/` (unit tests, widget tests)
- `integration_test/` (integration tests)

**Time**: 2-6 hours (depending on app complexity)

---

### Step 4: Generate and Run Tests (flutter-testing)

**User says**:
```
"Generate tests for my task manager app"
```

**What happens**:
1. `flutter-testing` skill loads
2. Reads `PIP.md` for testing strategy
3. Reads Flutter code to understand implementation
4. Generates tests:
   - Unit tests (business logic, models)
   - Widget tests (UI components, interactions)
   - Integration tests (complete user flows)
   - Golden tests (visual regression)
5. Runs tests and fixes failures automatically
6. Reports coverage

**Output files**:
- `test/` (enhanced test files)
- `test/goldens/` (golden test images)

**Time**: 1-2 hours

---

## File Dependencies

```
PRD.md
  ├─→ ui-mockup-generator (reads)
  │    └─→ MOCKUP.md
  │         └─→ flutter-creator (reads)
  │              └─→ Flutter code
  │
  └─→ PIP.md
       ├─→ flutter-creator (reads for testing)
       └─→ flutter-testing (reads for strategy)
            └─→ Tests
```

## Iterative Workflow

### Updating Mockups After Implementation

If you implement and realize changes needed:

**User says**:
```
"Update mockup for HomeScreen: add filter button to top bar"
```

**What happens**:
1. `ui-mockup-generator` loads existing `MOCKUP.md`
2. Updates HomeScreen section with new button
3. Regenerates state variations and responsive rules
4. Saves updated `MOCKUP.md`

**Then**:
```
"Update HomeScreen implementation to match new mockup"
```

5. `flutter-creator` reads updated `MOCKUP.md`
6. Updates `lib/screens/home_screen.dart`
7. Adds filter button following specifications

### Adding New Screens

**User says**:
```
"Add mockup for ProfileScreen to my task manager app"
```

**What happens**:
1. `ui-mockup-generator` loads `MOCKUP.md`
2. Asks screen-specific questions for ProfileScreen
3. Generates ASCII layout + elements + states + responsive rules
4. Updates navigation flow in `MOCKUP.md`
5. Appends ProfileScreen section

**Then**:
```
"Implement ProfileScreen"
```

6. `flutter-creator` reads updated `MOCKUP.md`
7. Implements `lib/screens/profile_screen.dart`

## Best Practices

### ✅ DO

- **Use skills in order**: PRD → Mockup → Code → Test
- **Read output files**: Review PRD.md, MOCKUP.md before proceeding
- **Provide feedback**: If mockup isn't right, ask for changes before implementation
- **Iterate**: Update mockups, then update code
- **Keep files synced**: When PRD changes, update mockups, then code

### ❌ DON'T

- **Skip PRD**: Don't generate mockups without PRD (misses requirements context)
- **Skip mockups**: Don't implement from PRD directly (leads to visual inconsistencies)
- **Implement first**: Don't write code before mockups (wastes time on rework)
- **Ignore mockup during implementation**: flutter-creator needs MOCKUP.md for exact specifications
- **Generate tests without code**: flutter-testing needs implementation to test

## Example Session

**User**: "Create a task manager app"

**Claude** (prd-generator):
```
Let me create a PRD for your task manager app.
[Asks brainstorming questions...]
✅ Generated PRD.md
✅ Generated PIP.md
```

**User**: "Generate UI mockups"

**Claude** (ui-mockup-generator):
```
I'll read PRD.md and generate detailed UI mockups.
[Asks design system questions...]
[Asks screen-specific questions for HomeScreen...]
[Asks screen-specific questions for AddTaskScreen...]
✅ Generated MOCKUP.md
```

**User**: "Implement the app"

**Claude** (flutter-creator):
```
I'll read MOCKUP.md and implement your task manager app.
[Creates Flutter project structure...]
[Implements HomeScreen...]
[Implements AddTaskScreen...]
[Writes tests following PIP.md...]
✅ Flutter code ready
```

**User**: "Generate and run tests"

**Claude** (flutter-testing):
```
I'll generate comprehensive tests and run them.
[Generates unit tests...]
[Generates widget tests...]
[Generates integration tests...]
[Runs tests and fixes failures...]
✅ All tests passing
✅ Coverage: 78%
```

**User**: "Complete! The app works perfectly."

## Troubleshooting

**Problem**: Skill doesn't read PRD.md
- **Solution**: Ensure PRD.md is in working directory
- **Check**: `ls PRD.md`

**Problem**: Mockup doesn't match PRD requirements
- **Solution**: Manually review PRD.md first, then regenerate mockup
- **Fix**: "Update mockup to reflect PRD change: [describe change]"

**Problem**: Implementation doesn't match mockup
- **Solution**: Verify flutter-creator read MOCKUP.md
- **Fix**: "Reimplement [screen name] following MOCKUP.md exactly"

**Problem**: Tests don't match implementation
- **Solution**: Ensure PIP.md was read by flutter-creator
- **Fix**: "Update tests to match current implementation"

## Time Estimates

| Step | Skill | Time |
|------|-------|------|
| 1. PRD generation | prd-generator | 15-30 min |
| 2. UI mockups | ui-mockup-generator | 20-40 min |
| 3. Implementation | flutter-creator | 2-6 hours |
| 4. Testing | flutter-testing | 1-2 hours |
| **Total** | | **3-8 hours** |

*Compare to typical development: 8-16 hours without AI assistance*

## Summary

The BuilderPack skills form a complete pipeline:

1. **prd-generator**: Define WHAT to build
2. **ui-mockup-generator**: Define HOW it LOOKS
3. **flutter-creator**: Build the CODE
4. **flutter-testing**: Verify it WORKS

Each skill reads outputs from previous steps, ensuring consistency and reducing rework.

**Key insight**: Spend time upfront (PRD + mockups) to save time later (implementation + testing).
