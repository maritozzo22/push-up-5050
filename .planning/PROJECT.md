# PROJECT.md

**Project Name:** Push-Up 5050 - Android Widgets
**Status:** Active Development
**Last Updated:** 2026-01-23

## Project Overview

Progressive push-up training mobile app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a goal of 50 push-ups/day within 30 consecutive days.

**Current Status**: Core Flutter app with Android widget infrastructure, onboarding tutorial, and goals persistence.

**Target Platforms**: Android (production), Windows (development)

## What We're Building

### Core Features (Implemented)
- Progressive series counting with manual tap OR proximity sensor
- Real-time stats (reps, kcal: 0.45 per push-up)
- Recovery timer with color transitions (green → orange → red → flashing)
- 30-day calendar tracking
- Achievement system with points/levels
- Streak multipliers (1.0x → 2.0x based on consecutive days)

### v2.0 Features (Shipped)
- Android home screen widget infrastructure (home_widget v0.9.0)
- Widget calendar synchronization with daily data
- Deep link handling for widget-to-app navigation
- 3-page onboarding tutorial (Welcome, How It Works, Goal Configuration)
- Bilingual IT/EN localization (24 onboarding keys)
- Goals persistence with custom daily/monthly targets
- App launcher icon configuration
- Overflow fixes for Series Selection and Statistics screens

### New Feature: Android Home Screen Widgets (In Progress)

**3 Widget Types:**

1. **Widget 1 - Quick Stats**: Displays today's progress (push-ups completed / goal)
2. **Widget 2 - Calendar Preview**: Mini 30-day calendar showing workout history
3. **Widget 3 - Quick Start**: Large button to immediately start workout

**Widget Specifications:**
- Background: `#121212` (dark)
- Accent color: `#FF6B00` (orange)
- Border radius: `28px`
- All widgets open app on tap
- Update periodically to reflect latest data

## Technical Stack

- **Language**: Dart (>=3.0.0 <4.0.0)
- **Framework**: Flutter
- **State Management**: Provider (ChangeNotifier pattern)
- **Storage**: shared_preferences (local JSON persistence)
- **Widget Framework**: home_widget package for Android home screen widgets

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
├── repositories/       # Storage service
├── screens/            # UI screens
├── widgets/            # Reusable widgets
├── services/           # Device services
└── android_widget/     # Android widget integration
```

## Team & Workflow

- **Developer**: Solo project with AI assistance (Claude Code)
- **Methodology**: GSD (Get Shit Done) with phase-based planning
- **Version Control**: Git (local)

## Milestones

### Milestone 1: Core App ✅ (SHIPPED)
- Progressive workout system
- Statistics tracking
- Achievement system
- Settings and preferences

### Milestone 2: Android Widgets & App Polish ✅ (SHIPPED 2026-01-23)
**Delivered:**
- Widget infrastructure (home_widget v0.9.0 integration)
- Calendar synchronization service
- Deep link handling (pushup5050://)
- 3-page onboarding tutorial with bilingual support
- Goals persistence (custom daily/monthly targets)
- App launcher icon configuration
- Overflow fixes for key screens

**Phases completed:**
- 02.1: Foundation & Setup (3/3 plans)
- 02.2: Widget 1 - Quick Stats (5/6 plans)
- 02.6: Widget Redesign (4/5 plans)
- 02.7: Widget Rebuild (3/4 plans)
- 02.8: App Polish & Tutorial (5/5 plans) ✅
- 02.9: Fix Goals Persistence Integration (1/1 plan) ✅
- 02.10: Update ROADMAP.md Statuses (1/1 plan) ✅
- 02.11: Clean Up Empty Directories (1/1 plan) ✅

**Archive:** `.planning/milestones/v2.0-ROADMAP.md`

### Milestone 3: Future Work (PLANNING)
- Complete widget verification (requires physical device)
- iOS widgets (if needed)
- Advanced features

## Current State

**Shipped:** v2.0 - Android Widgets Integration & App Polish (2026-01-23)

**Latest Changes:**
- Fixed HomeScreen to use custom daily goal from GoalsProvider
- All goal persistence integration complete (100%)
- Onboarding tutorial functional with bilingual support
- Widget infrastructure ready for device testing

**Known Issues:**
- Widget verification plans pending (require physical Android device)
- 02.6-05: Widget Testing & Verification (PENDING)
- 02.7-04: Build, Deploy, Verify Widgets on Device (PENDING)

**Technical Debt:**
- TODO: Implement weekSeries in UserStatsProvider (low priority)
- TODO: Implement proper daily average calculation in StatisticsScreen (low priority)
- TODO: Replace hardcoded locale logic with intl package in OnboardingScreen (low priority)

## Next Milestone Goals

**Potential v2.1 Goals:**
1. Complete widget end-to-end verification on physical device
2. Finalize Widget 2 (Calendar Preview)
3. Finalize Widget 3 (Quick Start)
4. Performance testing and optimization

## Success Criteria

### v2.0 Status
- [x] Widget infrastructure integrated
- [x] Onboarding tutorial complete
- [x] Goals persistence working
- [x] Deep link handling implemented
- [x] App launcher icon configured
- [ ] All 3 widgets verified on physical device (requires device testing)
- [x] Key overflow issues resolved
- [x] All tests passing for completed features

---

*Last updated: 2026-01-23 after v2.0 milestone*
