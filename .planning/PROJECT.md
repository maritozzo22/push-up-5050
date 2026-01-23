# PROJECT.md

**Project Name:** Push-Up 5050 - Engagement & Retention
**Status:** Active Development
**Last Updated:** 2026-01-23

## Project Overview

Progressive push-up training mobile app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a goal of 50 push-ups/day within 30 consecutive days.

**Current Status**: Core Flutter app with Android widget infrastructure, onboarding tutorial, and goals persistence. Preparing Milestone v2.5 focused on engagement and retention features.

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

### v2.5 Features (Planned)
- Personalized onboarding with activity/capacity/frequency assessment
- Enhanced points system with aggressive formula (Base × (RepMult + SeriesMult) × StreakMult)
- Anti-cheat system with daily caps based on user level
- Weekly goals with Sunday review and goal progression
- Weekly challenges with badges and bonus points
- Streak freeze (1 per month) to prevent streak reset
- Smart notifications (streak at risk, progress alerts, personalized timing)

## Technical Stack

- **Language**: Dart (>=3.0.0 <4.0.0)
- **Framework**: Flutter
- **State Management**: Provider (ChangeNotifier pattern)
- **Storage**: shared_preferences (local JSON persistence)
- **Widget Framework**: home_widget package for Android home screen widgets
- **Notifications**: flutter_local_notifications

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

### Milestone 3: Engagement & Retention 📋 (PLANNED)
**Goal:** Increase user engagement and retention through personalization and enhanced gamification

**Planned Phases:**
- 03.1: Personalized Onboarding (4 requirements)
- 03.2: Enhanced Points System & Anti-Cheat (7 requirements)
- 03.3: Weekly Goals System (5 requirements)
- 03.4: Challenges & Streak Freeze (3 requirements)
- 03.5: Smart Notifications (4 requirements)

**Total:** 19 requirements across 5 phases

**Key Features:**
- Activity/capacity/frequency assessment on first launch
- Aggressive points formula: Base × (RepMult + SeriesMult) × StreakMult
- Daily caps to prevent cheating (goal × 1.5 to 2.5 based on level)
- Sunday weekly review popup with goal progression options
- Weekly challenges with badges and 200-point bonus
- Streak freeze (1/month) prevents streak reset
- Smart notifications (streak at risk, progress alerts, personalized timing)

## Current State

**Shipped:** v2.0 - Android Widgets Integration & App Polish (2026-01-23)

**Current Milestone:** v2.5 - Engagement & Retention (Planning)

**Latest Changes:**
- ROADMAP.md created for Milestone v2.5
- REQUIREMENTS.md created with 19 requirements across 6 categories
- 5 phases derived from requirements with 100% coverage

**Known Issues:**
- Widget verification plans pending (require physical Android device)
- 02.6-05: Widget Testing & Verification (PENDING)
- 02.7-04: Build, Deploy, Verify Widgets on Device (PENDING)

**Technical Debt:**
- TODO: Implement weekSeries in UserStatsProvider (low priority)
- TODO: Implement proper daily average calculation in StatisticsScreen (low priority)
- TODO: Replace hardcoded locale logic with intl package in OnboardingScreen (low priority)

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

### v2.5 Status (Planned)
- [ ] Personalized onboarding with 4-screen flow
- [ ] Enhanced points system with aggressive formula
- [ ] Anti-cheat daily caps enforced
- [ ] Weekly goals with Sunday review
- [ ] Weekly challenges with badges
- [ ] Streak freeze feature (1/month)
- [ ] Smart notifications system

---

*Last updated: 2026-01-23 for Milestone v2.5*
