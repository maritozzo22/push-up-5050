# Phase 06: Statistics UI Polish - Research

**Researched:** 2026-01-31
**Domain:** Flutter Widget Layout and Typography Adjustments
**Confidence:** HIGH

## Summary

Phase 06 focuses on improving the readability and visual hierarchy of two statistics cards on the Statistics screen:
1. **TotalPushupsCard** - Remove progress bar, center and enlarge text
2. **CalorieCard** - Center and enlarge text with consistent styling

**Research findings:**
- **Target files identified:** `lib/widgets/statistics/total_pushups_card.dart` and `lib/widgets/statistics/calorie_card.dart`
- **Progress bar implementation:** Located in `lib/widgets/design_system/progress_bar.dart`, used by TotalPushupsCard
- **Current layout:** Both cards use `FrostCard` container with `Column` layout, 120px height, vertical text alignment
- **Text sizing:** Label at 8px, value at 13px - needs enlargement for better readability
- **Centering:** Text currently uses `textAlign: TextAlign.center` but not visually centered due to icon at top

**Primary recommendation:** Modify both card widgets by (1) removing `ProgressBar` widget and percentage text from TotalPushupsCard, (2) increasing font sizes for labels and values, (3) adjusting `mainAxisAlignment` to better center content vertically.

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| Flutter Widgets | Built-in | Text, Column, SizedBox | Standard Flutter layout primitives |
| FrostCard | Existing | Frosted glass container | Project's design system card wrapper |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| ProgressBar | Existing | Progress indicator | NOT used in this phase (removed) |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Modifying existing widgets | Creating new card variants | Simpler to modify existing; no new files needed |

**Installation:**
No new dependencies needed. All required libraries already in codebase.

## Architecture Patterns

### Recommended Project Structure
```
push_up_5050/lib/
├── widgets/
│   └── statistics/
│       ├── total_pushups_card.dart    # MODIFY: Remove progress bar, enlarge text
│       └── calorie_card.dart          # MODIFY: Enlarge text for consistency
└── screens/
    └── statistics/
        └── statistics_screen.dart     # Uses both cards (no changes needed)
```

### Pattern 1: Text Centering in Column
**What:** Use `MainAxisAlignment.center` and `CrossAxisAlignment.center` to center content
**When to use:** Cards need visually centered text
**Example:**
```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,  // Center vertically
  crossAxisAlignment: CrossAxisAlignment.center,  // Center horizontally
  children: [
    Icon(...),
    SizedBox(height: 8),
    Text(
      'LABEL',
      style: TextStyle(fontSize: 10),  // Enlarged from 8
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 4),
    Text(
      'value',
      style: TextStyle(fontSize: 20),  // Enlarged from 13
      textAlign: TextAlign.center,
    ),
  ],
)
```

### Pattern 2: Removing Widgets from Layout
**What:** Delete `ProgressBar` widget and related percentage `Text` from Column children
**When to use:** STAT-01 requirement - no progress bar below TotalPushupsCard
**Example:**
```dart
// BEFORE (lines 85-97 in total_pushups_card.dart)
const Spacer(),
ProgressBar(value: progress),
const SizedBox(height: 2),
Text(
  '$percentage%',
  style: TextStyle(fontSize: 8, ...),
),

// AFTER (remove all four lines above)
// Content ends with value text, card maintains height
```

### Anti-Patterns to Avoid
- **Hardcoding height values:** Don't make card height dynamic; keep 120px FrostCard for consistency
- **Breaking factory constructor:** Don't change `CalorieCard.fromPushups()` signature
- **Changing FrostCard wrapper:** Don't modify the card container, only internal layout

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Custom progress bar | ProgressBar widget | DELETE it | Requirement is to remove, not replace |
| New centered text widget | Standard Text with textAlign | Built-in Text | No custom widget needed |

**Key insight:** This is a removal and font sizing exercise, not new feature development.

## Common Pitfalls

### Pitfall 1: Text Appears Off-Center After Changes
**What goes wrong:** Text shifts to top or bottom after removing Spacer/progress bar
**Why it happens:** Removing `Spacer()` and `ProgressBar` changes Column layout distribution
**How to avoid:** Use `mainAxisAlignment: MainAxisAlignment.center` on Column after removing bottom elements
**Warning signs:** Text not visually centered in 120px card

### Pitfall 2: Inconsistent Font Sizes Between Cards
**What goes wrong:** TotalPushupsCard and CalorieCard have different text sizes
**Why it happens:** Modifying one card but not the other
**How to avoid:** Use matching font sizes in both cards (label: 10px, value: 20px recommended)
**Warning signs:** Visual hierarchy broken between the two cards

### Pitfall 3: Tests Finding Removed Elements
**What goes wrong:** Tests look for progress bar or percentage text that no longer exists
**Why it happens:** Statistics screen tests may check for these elements
**How to avoid:** Update test expectations to NOT find ProgressBar widget and percentage text
**Warning signs:** Test failures after modification

## Code Examples

### Current TotalPushupsCard Structure (BEFORE)
```dart
// lib/widgets/statistics/total_pushups_card.dart (lines 30-99)
return FrostCard(
  height: 120,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  child: Column(
    children: [
      // Icon circle at top
      Container(...),  // Lines 36-59
      const SizedBox(height: 4),
      // Label
      Text(
        'TOTALE PUSHUPS',
        style: TextStyle(fontSize: 8, ...),  // NEEDS: 10+
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 2),
      // Value
      FittedBox(
        child: Text(
          '$total / $goal',
          style: TextStyle(fontSize: 13, ...),  // NEEDS: 20+
        ),
      ),
      const Spacer(),  // REMOVE THIS
      ProgressBar(value: progress),  // REMOVE THIS
      const SizedBox(height: 2),  // REMOVE THIS
      Text('$percentage%', ...),  // REMOVE THIS
    ],
  ),
);
```

### Modified TotalPushupsCard (AFTER)
```dart
return FrostCard(
  height: 120,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,  // ADD: Vertical centering
    children: [
      // Icon circle at top
      Container(...),
      const SizedBox(height: 8),  // INCREASED from 4
      // Label
      Text(
        'TOTALE PUSHUPS',
        style: TextStyle(
          fontSize: 10,  // CHANGED from 8
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: Colors.white.withOpacity(0.70),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),  // INCREASED from 2
      // Value
      Text(
        '$total / $goal',
        style: const TextStyle(
          fontSize: 20,  // CHANGED from 13
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      // Removed: Spacer, ProgressBar, SizedBox, percentage Text
    ],
  ),
);
```

### Modified CalorieCard (AFTER)
```dart
// lib/widgets/statistics/calorie_card.dart (lines 32-91)
return FrostCard(
  height: 120,
  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,  // ADD: Vertical centering
    children: [
      // Icon circle at top
      Container(...),
      const SizedBox(height: 8),  // INCREASED from 4
      // Label
      Text(
        'CALORIE BRUCIATE',
        style: TextStyle(
          fontSize: 10,  // CHANGED from 8
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
          color: Colors.white.withOpacity(0.70),
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 6),  // INCREASED from 2
      // Value
      Text(
        '$kcal kcal',
        style: const TextStyle(
          fontSize: 20,  // CHANGED from 13
          fontWeight: FontWeight.w900,
          color: Colors.white,
        ),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 8),  // KEPT for balance
    ],
  ),
);
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| 8px/13px text sizing | 10px/20px text sizing | This phase | Better readability |
| Progress bar showing | Progress bar removed | This phase | Cleaner visual hierarchy |

**Deprecated/outdated:**
- None - this is pure UI polish within existing patterns

## Open Questions

None - all implementation details are clear from codebase analysis.

## Sources

### Primary (HIGH confidence)
- `lib/widgets/statistics/total_pushups_card.dart` - Target file for STAT-01, STAT-02
- `lib/widgets/statistics/calorie_card.dart` - Target file for STAT-03
- `lib/widgets/design_system/progress_bar.dart` - Progress bar implementation to be removed
- `lib/widgets/design_system/frost_card.dart` - Card container (unchanged)
- `lib/screens/statistics/statistics_screen.dart` - Consumer of both cards
- `test/screens/statistics/statistics_screen_test.dart` - Existing tests to update

### Secondary (MEDIUM confidence)
- `lib/core/constants/app_colors.dart` - Color constants (unchanged)
- `test/golden_tests/statistics_screen_golden_test.dart` - Golden tests requiring update

### Tertiary (LOW confidence)
- None - all findings from direct codebase analysis

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH - Built-in Flutter widgets only
- Architecture: HIGH - Direct analysis of existing code
- Pitfalls: HIGH - Common Flutter layout issues well-understood

**Research date:** 2026-01-31
**Valid until:** 60 days (stable Flutter APIs, existing codebase)
