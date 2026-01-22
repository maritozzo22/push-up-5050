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
