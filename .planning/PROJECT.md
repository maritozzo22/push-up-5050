# PROJECT.md

**Project Name:** Push-Up 5050
**Status:** Active Development
**Last Updated:** 2026-01-31

## Current Milestone: v2.7 Play Store Ready

**Goal:** Polish the app for Play Store release with UI improvements, proximity sensor fix, and enhanced achievements

**Target features:**
- Restore original icon.png as main launcher icon
- Remove "Test notifications" section from Settings
- Improve Statistics cards (remove bar, center and enlarge text)
- Replace goal popup with top notification (non-blocking, continues workout)
- Add 9 new achievements (20 total)
- Fix proximity sensor and move toggle to Workout Setup
- Improve onboarding tutorial design and content

## Project Overview

Progressive push-up training mobile app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a personalized daily goal.

**Current Status**: v2.6 shipped with goal-based auto-completion, celebration popup, and adaptive icons. Preparing for Play Store release.

**Target Platforms**: Android (production), Windows (development)

## What We're Building

### Core Features (Implemented ✅)
- Progressive series counting with manual tap OR proximity sensor
- Real-time stats (reps, kcal: 0.45 per push-up)
- Recovery timer with color transitions (green → orange → red → flashing)
- 30-day calendar tracking
- Achievement system with points/levels
- Streak multipliers (1.0x → 2.0x based on consecutive days)

### v2.0 Features (Shipped ✅)
- Android home screen widget infrastructure (home_widget v0.9.0)
- Widget calendar synchronization with daily data
- Deep link handling for widget-to-app navigation
- 3-page onboarding tutorial (Welcome, How It Works, Goal Configuration)
- Bilingual IT/EN localization (24 onboarding keys)
- Goals persistence with custom daily/monthly targets
- App launcher icon configuration
- Overflow fixes for Series Selection and Statistics screens

### v2.5 Features (Shipped ✅)
- Personalized onboarding with activity/capacity/frequency assessment
- Enhanced points system with aggressive formula (Base × (RepMult + SeriesMult) × StreakMult)
- Anti-cheat system with daily caps based on user level (1.5x-2.5x multiplier)
- Weekly goals with Sunday review and goal progression options
- Weekly challenges with badges and 200-point bonus
- Streak freeze (1 per month) to prevent streak reset with snowflake indicator
- Smart notifications (streak at risk after 2 missed days, progress alerts at 50%+, personalized timing)

### v2.6 Features (Shipped ✅)
- Default recovery time reduced from 30 to 10 seconds
- Goal-based workout logic with auto-completion when daily target reached
- Goal completion popup with confetti animation and Italian congratulations message
- Android adaptive icon with foreground layer and #FF6B00 background
- Bug fixes: onboarding goal persistence, series selection cap, navigation, calorie card UI

### v2.7 Features (In Progress)
- Restore original icon.png as main launcher icon
- Remove "Test notifications" section from Settings
- Statistics cards improvements (remove progress bar, center and enlarge text)
- Goal notification from top (non-blocking, continues workout, confetti animation)
- Expand achievement system to 20 total achievements (+9 new)
- Fix proximity sensor functionality and move toggle to Workout Setup
- Improve onboarding tutorial design and content

## Technical Stack

- **Language**: Dart (>=3.0.0 <4.0.0)
- **Framework**: Flutter
- **State Management**: Provider (ChangeNotifier pattern)
- **Storage**: shared_preferences (local JSON persistence)
- **Widget Framework**: home_widget package for Android home screen widgets
- **Notifications**: flutter_local_notifications with smart scheduling

## Development Approach

**Test-Driven Development (TDD)** is MANDATORY:
1. Write test FIRST (RED)
2. Implement code (GREEN)
3. Refactor if needed
4. Only proceed when tests pass

**Test Coverage Goal**: 70%+ overall

## Project Structure

```
lib/
├── core/               # Constants, theme, utilities
├── models/             # Data models
├── providers/          # State management (Provider pattern)
├── repositories/       # Storage service
├── screens/            # UI screens
├── widgets/            # Reusable widgets
├── services/           # Device services (proximity, notifications, audio, scheduler)
└── l10n/               # Internationalization (IT/EN)
```

## Team & Workflow

- **Developer**: Solo project with AI assistance (Claude Code)
- **Methodology**: GSD (Get Shit Done) with phase-based planning
- **Version Control**: Git (local)

## Milestones

### Milestone v1.0: Core App ✅ (SHIPPED)
- Progressive workout system
- Statistics tracking
- Achievement system
- Settings and preferences

### Milestone v2.0: Android Widgets & App Polish ✅ (SHIPPED 2026-01-23)
**Delivered:**
- Widget infrastructure (home_widget v0.9.0 integration)
- Calendar synchronization service
- Deep link handling (pushup5050://)
- 3-page onboarding tutorial with bilingual support
- Goals persistence (custom daily/monthly targets)
- App launcher icon configuration
- Overflow fixes for key screens

**Archive:** `.planning/milestones/v2.0-ROADMAP.md`

### Milestone v2.5: Engagement & Retention ✅ (SHIPPED 2026-01-27)
**Delivered:**
- Personalized onboarding (4-screen flow: activity, capacity, frequency, daily goal)
- Enhanced points system (aggressive formula: Base × (RepMult + SeriesMult) × StreakMult)
- Anti-cheat daily caps (goal × 1.5 to 2.5 based on level)
- Weekly goals (Sunday review, 500-point bonus, goal progression)
- Weekly challenges (200-point bonus, trophy badge)
- Streak freeze (1/month with auto-activation, snowflake indicator)
- Smart notifications (streak at risk, progress alerts, personalized timing)

**Phases completed:** 19 plans across 5 phases
**Archive:** `.planning/milestones/v2.5-ROADMAP.md`

### Milestone v2.6: Improvements & Polish ✅ (SHIPPED 2026-01-31)
**Delivered:**
- Default recovery time reduced from 30 to 10 seconds
- Goal-based workout logic with auto-completion when daily target reached
- Goal completion popup with confetti animation and Italian congratulations message
- Android adaptive icon with foreground layer and #FF6B00 background
- Bug fixes: onboarding goal persistence, series selection cap, navigation, calorie card UI

**Phases completed:** 20 plans across 5 phases
**Archive:** `.planning/milestones/v2.6-ROADMAP.md`

### Milestone v2.7: Play Store Ready 🔄 (IN PROGRESS)
**Target:**
- Icon restoration (use original icon.png)
- Settings cleanup (remove test notifications)
- Statistics cards polish (remove bar, larger centered text)
- Goal notification system (top banner, non-blocking, confetti)
- Achievement expansion (11 → 20 total)
- Proximity sensor fix + UI relocation
- Onboarding improvements (better design, 4+ screens)

**Phases:** Planning in progress

## Current State

**Shipped:** v2.6 - Improvements & Polish (2026-01-31)

**Latest Changes:**
- Default recovery time is now 10 seconds (was 30)
- Workshops auto-complete when daily goal is reached
- Goal completion popup with confetti animation
- Android adaptive icon assets generated
- Dynamic daily goal reading from storage
- Series selection capped at goal + 10
- All fixes verified via Chrome/web testing

**Known Issues:**
- Proximity sensor not functional (fix planned in v2.7)
- Some features require physical Android device for verification

**Technical Debt:**
- Minor: weeklyGoal calculated dynamically vs explicit storage
- TODO: Implement weekSeries in UserStatsProvider (low priority)
- TODO: Implement proper daily average calculation in StatisticsScreen (low priority)
- TODO: Replace hardcoded locale logic with intl package (low priority)

## Key Decisions

| Decision | Rationale | Status |
|----------|-----------|--------|
| PageView for onboarding | Single screen state management simpler than navigation | ✓ Good |
| 5 workout days per week | Allows 2 rest days while maintaining progression | ✓ Good |
| Sunday OR early-achievement trigger | Immediate gratification when target reached | ✓ Good |
| Dual streak display | Both daily and weekly streaks visible on home | ✓ Good |
| BuildContext for localization | Service layer needs translations without coupling | ✓ Good |
| Direct StorageService access | Avoids circular dependencies in scheduler | ✓ Good |
| 10-second default recovery | Faster workouts for better user experience | ✓ Good |
| Goal completion auto-ends workout | Prevents over-training when daily target reached | ✓ Good |

## Success Criteria

### v2.7 Status 🔄 IN PLANNING
- [ ] Restore original icon.png as main launcher
- [ ] Remove "Test notifications" from Settings
- [ ] Statistics cards polished (no bar, centered/larger text)
- [ ] Goal notification from top (non-blocking)
- [ ] 20 total achievements (9 new)
- [ ] Proximity sensor fixed + moved to Workout Setup
- [ ] Onboarding improved

---

*Last updated: 2026-01-31 after v2.7 milestone initiation*
