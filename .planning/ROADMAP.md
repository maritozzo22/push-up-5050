# ROADMAP.md

**Project:** Push-Up 5050 - Android Widgets
**Last Updated:** 2026-01-22

## Overview

This roadmap defines the phases for implementing Android home screen widgets for the Push-Up 5050 app.

---

## Milestone 1: Core Flutter App

**Status:** ✅ COMPLETE

All core functionality has been implemented:
- Progressive workout system with series counting
- Statistics and calendar tracking
- Achievement system with unlock notifications
- Settings and user preferences

---

## Milestone 2: Android Widgets Integration

**Status:** 🔄 IN PROGRESS

### Phase 2.1: Foundation & Setup

**Goal:** Set up Android widget infrastructure in Flutter project

**Status:** ✅ COMPLETE

**Plans:**
- [x] 02.1-01-PLAN.md — Verify dependencies and fix widget ID mismatch (COMPLETE)
- [x] 02.1-02-PLAN.md — Integrate widget updates into app state providers (COMPLETE)
- [x] 02.1-03-PLAN.md — Add integration tests for widget updates (COMPLETE)

**Deliverables:**
- Working home_widget integration with corrected widget IDs
- WidgetData model with JSON serialization (already exists)
- Background update mechanism integrated into providers
- Unit and integration tests for widget data layer

**Acceptance Criteria:**
- `flutter pub get` succeeds with new dependencies
- Widget receiver registered in AndroidManifest.xml (already exists)
- WidgetData can serialize/deserialize to JSON (already exists)
- Widget updates trigger automatically on state changes
- All tests pass including integration tests

---

### Phase 2.2: Widget 1 - Quick Stats

**Goal:** Implement widget showing today's and total push-up progress

**Status:** 🔄 IN PROGRESS (5/6 plans complete)

**Plans:**
- [x] 02.2-01-PLAN.md — Implement widget data loading from home_widget (COMPLETE)
- [x] 02.2-02a-PLAN.md — Create widget drawable resources (COMPLETE)
- [x] 02.2-02b-PLAN.md — Update widget layout XML (COMPLETE)
- [x] 02.2-03a-PLAN.md — Configure Android deep link handling (COMPLETE)
- [x] 02.2-03b-PLAN.md — Implement Flutter deep link routing (COMPLETE)
- [ ] 02.2-04-PLAN.md — Add widget configuration (PENDING)

**Widget UI Specs** (based on mockup):
- Width/Height: 4x4 cells (standard widget size)
- Background: #121212 (dark)
- Accent: #FF6B00 (orange)
- Corner radius: 28dp
- Layout: Vertical 3-section structure

**Content Structure:**
- **Header Section**:
  - Top-left: "PUSHUP 5050" logo (small icon)
  - Centered: "PUSHUP 5050" title (large, bold, white)

- **Middle Section** (2 columns):
  - Left column:
    - "OGGI:" / "TODAY:" (orange, bold)
    - "41" (white, large) - today's count
    - "push-ups" (white, small)
  - Right column:
    - "TOTALE:" / "TOTAL:" (orange, bold)
    - "44 / 5050" (white, large) - total progress
    - "push-ups" (white, small)

- **Bottom Section**:
  - Orange rectangular button with "START" text (white, bold)

**Deliverables:**
- Widget 1 Android implementation
- Flutter service to update widget data
- Tap handler to open SeriesSelectionScreen
- Integration tests

**Acceptance Criteria:**
- Widget appears on home screen after adding
- Widget displays correct push-up count from app
- Widget updates within 5 seconds after app state changes
- Tapping START button opens SeriesSelectionScreen
- Visual style matches mockup exactly

---

### Phase 2.3: Widget 2 - Calendar Preview

**Goal:** Implement mini calendar widget showing workout history

**Status:** ⏳ NOT STARTED

**Plans:** TBD

**Tasks:**
1. Create calendar widget layout (XML)
2. Implement calendar rendering logic (7 columns x 5-6 rows)
3. Style day headers (L, M, M, G, V, S, D - Italian)
4. Style highlighted days (orange with glow effect, connected by line)
5. Style regular days (gray circles on dark background)
6. Handle tap to open Statistics screen
7. Write widget tests

**Widget UI Specs** (based on mockup):
- Width/Height: Responsive (landscape orientation recommended)
- Background: #121212 (dark)
- Accent: #FF6600 (orange with glow)
- Corner radius: 28px

**Content Structure:**
- **Header Row**: 7 day abbreviations (L, M, M, G, V, S, D)
  - Color: #AAAAAA (light gray)
- **Calendar Grid**: 5-6 rows of 7 columns each
  - Day circles: #333333 (dark gray) background
  - Day numbers: #AAAAAA (light gray) text
- **Highlighted Days** (e.g., days 20-21):
  - Background: Bright orange (#FF6600) with glow effect
  - Text: Black (#000000)
  - Connected by horizontal line to show consecutive streak

**Deliverables:**
- Widget 2 Android implementation
- Calendar data serialization
- Visual indicators for each day status

**Acceptance Criteria:**
- Calendar displays full month grid (31 days max)
- Day colors match app's calendar exactly
- Consecutive completed days show connecting line
- Widget opens Statistics screen on tap
- Updates within 5 seconds of completing a workout

---

### Phase 2.4: Widget 3 - Quick Start

**Goal:** Implement large circular button widget for immediate workout start

**Status:** ⏳ NOT STARTED

**Plans:** TBD

**Tasks:**
1. Create quick start widget layout (XML)
2. Style large circular button with gradient
3. Add "START" text with bold styling
4. Handle tap to start workout directly
5. Add top section with progress stats
6. Add bottom row with day selection buttons
7. Write widget tests

**Widget UI Specs** (based on mockup):
- Width/Height: Responsive (square-ish, 4x2 cells)
- Background: #121212 (dark)
- Accent: #FF6B00 (orange)
- Corner radius: 28px
- Layout: 3-section vertical structure

**Content Structure:**
- **Top Section** (black background):
  - Top-left: "PUSHUP 5050" small icon
  - Centered: "PUSHUP 5050" title (large, bold, white)
  - Left: "OGGI:" (orange) + "41" (white, large) + "push-ups" (small)
  - Right: "TOTALE:" (orange) + "44 / 5050" (white, large) + "push-ups" (small)

- **Middle Section**:
  - Large circular orange button with "START" text (white, bold, centered)
  - Gradient/glow effect on button

- **Bottom Section**:
  - Row of 7 circular day buttons (L, M, M, G, V, S, D)
  - First 2 buttons: Orange (completed days)
  - Remaining 5 buttons: Gray (pending days)
  - Text: White, centered in each button

**Deliverables:**
- Widget 3 Android implementation
- Deep link to workout start
- Progress stats display in header
- Day selection buttons at bottom

**Acceptance Criteria:**
- Widget displays large orange circular START button
- Tapping START button opens SeriesSelectionScreen directly
- Header shows today's and total progress
- Day buttons show completion status (orange/gray)
- Updates within 5 seconds of completing workout

---

### Phase 2.5: Polish & Testing

**Goal:** Finalize widgets with comprehensive testing and bug fixes

**Status:** ⏳ NOT STARTED

**Plans:** TBD

**Tasks:**
1. Performance testing (widget update frequency)
2. Battery usage optimization
3. Edge case handling (no data, empty state)
4. Multiple widget instances support
5. Widget configuration activity (if needed)
6. Golden tests for widget documentation
7. End-to-end integration testing

**Deliverables:**
- Performance metrics report
- All edge cases handled gracefully
- Multiple widget instances working
- Complete test coverage for widget layer

**Acceptance Criteria:**
- All tests pass (70%+ coverage)
- No battery drain issues
- Widgets handle empty states gracefully
- User can add multiple instances of each widget
- Golden tests pass for visual documentation

---

### Phase 2.6: Widget Redesign with New UI

**Goal:** Replace existing widgets with new Flutter-based design and implement full calendar synchronization

**Status:** ⏳ NOT STARTED

**Plans:**
- [ ] 02.6-01-PLAN.md — Create Calendar Service for Widget Data
- [ ] 02.6-02-PLAN.md — Integrate Calendar Service with Widget Updates
- [ ] 02.6-03-PLAN.md — Update Android Widget Providers with Calendar Rendering
- [ ] 02.6-04-PLAN.md — Implement Midnight Widget Update for Calendar Refresh
- [ ] 02.6-05-PLAN.md — Verify Widget Redesign End-to-End

**Tasks:**

#### Widget 4x4 (Large Widget)
1. Implement Flutter widget code using provided Pushup5050Widget design
2. Wire up real data from UserStatsProvider (today's push-ups, total/goal)
3. Connect START button to deep link (reuse existing functionality)
4. Implement 7-day calendar row at bottom:
   - Show days L M M G V S D (Italian)
   - Orange = completed day
   - Gray = pending/future day
   - Red with X = missed day (at midnight if no workout)
5. Add connecting line between consecutive orange days (streak indicator)
6. Update widget automatically when app state changes

#### Widget 2x1 (Small Widget)
1. Implement Flutter widget code using provided Pushup5050SmallWidget design
2. Wire up real data from UserStatsProvider
3. Implement 3-day calendar row (Yesterday - Today - Tomorrow):
   - Dynamic day labels based on current date
   - Orange = completed, Gray = pending, Red with X = missed
4. Update widget automatically when app state changes

#### Calendar Synchronization (Both Widgets)
1. Create CalendarWidgetService to read from DailyRecords
2. Implement midnight check to mark missed days
3. Update widget calendar at 00:00 if no workout completed
4. Connect orange dots with horizontal line for consecutive days
5. Handle month transitions correctly

#### Android Integration
1. Update widget providers to use FlutterEmbeddedView (new approach)
2. Register new widget sizes in AndroidManifest.xml
3. Update home_widget integration for new data structure
4. Ensure backward compatibility or deprecate old widgets

**Deliverables:**
- 4x4 widget with new design and functional calendar
- 2x1 widget with new design and 3-day calendar
- Full calendar synchronization (orange/gray/red states)
- Streak connecting lines between consecutive completed days
- Midnight missed day detection
- Automatic widget updates on data changes
- Integration tests for calendar logic

**Acceptance Criteria:**
- Widgets display new Flutter design exactly as provided
- Today's push-ups and total/goal sync from app
- START button opens SeriesSelectionScreen via deep link
- Calendar shows correct states for each day
- Consecutive completed days show orange connecting line
- Missed days appear with red X at midnight
- 3-day widget shows Yesterday-Today-Tomorrow correctly
- All widget updates occur within 5 seconds of app state change

---

### Phase 2.7: Widget Rebuild from Templates

**Goal:** Completely rebuild widgets from scratch using exact template designs provided

**Status:** 🔄 IN PROGRESS

**Plans:**
- [ ] 02.7-01-PLAN.md — Create widget drawable resources with exact template colors
- [ ] 02.7-02-PLAN.md — Create widget layouts matching template structure
- [ ] 02.7-03-PLAN.md — Update widget providers and AndroidManifest registration
- [ ] 02.7-04-PLAN.md — Build, deploy, and verify widgets on device

**Context:**
Previous widget work (2.6) is unsatisfactory. Widgets are either:
- Missing (4x4 widget not available in widget picker)
- Non-functional (2x1 widget doesn't work)
- Visually incorrect (don't match provided templates)

**Requirements:**

#### What to Keep (Reuse)
1. **Data sync layer**: WidgetCalendarService, WidgetData model
2. **Pushup data**: Today's count, total/goal from UserStatsProvider
3. **Calendar data**: WeekDayData, threeDayData from WidgetCalendarService
4. **Deep link**: START button → pushup5050://series_selection
5. **Update mechanism**: WidgetUpdateService integration with providers

#### What to Rebuild (From Scratch)
1. **Widget 4x4**: Use exact design from `template-widget 4x4.md`
2. **Widget 2x1**: Use exact design from `template-widget 2x1.md`
3. **Android widget providers**: New XML layouts with correct sizes
4. **Widget registration**: Proper sizing in AndroidManifest.xml

#### Widget 4x4 Specifications (from template)
```
Size: 4x4 cells (must appear as 4x4 in widget picker)
Layout: Vertical structure
- Top panel (gradient: #20262B to #111416) with curved bottom edge
- Stats: OGGI (left), OBIETTIVO (right)
- Center: Large circular START button (gradient orange, glow effect)
- Bottom: 7-day row (L M M G V S D) with day chips
Colors:
- Top A: #20262B, Top B: #111416
- Bottom A: #0F1113, Bottom B: #0B0D0F
- Orange: #F46A1E, Orange2: #EF7A1A
- Text soft: #B9C0C7
```

#### Widget 2x1 Specifications (from template)
```
Size: 2x1 cells (must appear as 2x1 in widget picker)
Layout: Vertical structure
- Top panel (62% height, gradient background)
- Centered stats: OGGI PUSHUPS + TOTALE PUSHUPS
- Bottom: 3-day row (Yesterday-Today-Tomorrow)
- Total displayed as 3 lines: "44 / 5050"
```

#### What Must Work
- [ ] Both widgets appear in widget picker with correct sizes
- [ ] Widget 4x4 displays exactly like template
- [ ] Widget 2x1 displays exactly like template
- [ ] START button opens SeriesSelectionScreen
- [ ] Calendar shows correct states (completed/missed/pending)
- [ ] Widgets update within 5 seconds of data changes

**Deliverables:**
- Working 4x4 widget (visible in picker, functional)
- Working 2x1 widget (visible in picker, functional)
- Android widget providers matching template designs
- Proper widget size registration in AndroidManifest

**Acceptance Criteria:**
- Widget picker shows both widgets with correct sizes
- Visual design matches templates exactly
- All functionality works (data sync, deep links, updates)

---

### Phase 2.8: App Polish & Tutorial

**Goal:** Complete app polish including UI fixes, onboarding tutorial, and branding assets

**Status:** PLANNED (4 plans in 3 waves)

**Depends on:** Phase 2.7

**Plans:**
- [ ] 02.8-01-PLAN.md — Launch Android emulator and install debug APK for testing (Wave 1)
- [ ] 02.8-02-PLAN.md — Fix bottom overflow issues in Series Selection and Statistics screens (Wave 2)
- [ ] 02.8-03-PLAN.md — Create 3-page onboarding tutorial with bilingual support and goal configuration (Wave 3)
- [ ] 02.8-04-PLAN.md — Set up app logo and icon from Icone-App-Pushup assets (Wave 1)

**Wave Structure:**
- Wave 1: 02.8-01 (emulator setup), 02.8-04 (icon setup - parallel, no dependencies)
- Wave 2: 02.8-02 (overflow fixes - depends on 02.8-01 for testing)
- Wave 3: 02.8-03 (onboarding - depends on overflow fixes being verified)

**Deliverables:**
- Working debug APK installed on emulator
- All bottom overflow issues resolved on Series Selection and Statistics screens
- Complete 3-page onboarding flow with PageView navigation
- Bilingual IT/EN onboarding support
- Goal configuration (daily/monthly) with persistence
- Settings screen "Restart Tutorial" option
- Configured app logo/icon using flutter_launcher_icons

**Acceptance Criteria:**
- App runs on emulator without crashes
- No RenderFlex overflow errors on Series Selection or Statistics screens
- Onboarding tutorial shows on first launch (full gate - cannot skip)
- User can set daily goal (default: 50) with +/- buttons
- Monthly goal auto-calculates (daily * 30) and is manually editable
- Progress preview shows estimated time to reach 5050
- Onboarding supports Italian and English based on device locale
- Settings has "Restart Tutorial" button
- App icon displays correctly on home screen

---

## Future Milestones

### Milestone 3: iOS Widgets (Future)
- iOS 14+ home screen widgets
- Similar functionality to Android widgets

### Milestone 4: Advanced Features (Future)
- Cloud sync across devices
- Social sharing challenges
- Workout video tutorials
- Custom workout programs

---

## Phase Status Legend

- ✅ Complete
- 🔄 In Progress
- ⏳ Not Started
- ❌ Blocked

---

*Last updated: 2026-01-22*
