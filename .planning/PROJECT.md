# PROJECT.md

**Project Name:** Push-Up 5050 - Engagement & Retention
**Status:** Active Development
**Last Updated:** 2026-01-27

## Project Overview

Progressive push-up training mobile app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a goal of 50 push-ups/day within 30 consecutive days.

**Current Status**: Engagement & Retention features complete with personalized onboarding, enhanced gamification, weekly goals, challenges, and smart notifications.

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

**Archive:** `.planning/milestones/v2.0-ROADMAP.md`

### Milestone 3: Engagement & Retention ✅ (SHIPPED 2026-01-27)
**Delivered:**
- Personalized onboarding (4-screen flow: activity, capacity, frequency, daily goal)
- Enhanced points system (aggressive formula: Base × (RepMult + SeriesMult) × StreakMult)
- Anti-cheat daily caps (goal × 1.5 to 2.5 based on level)
- Weekly goals (Sunday review, 500-point bonus, goal progression)
- Weekly challenges (200-point bonus, trophy badge)
- Streak freeze (1/month with auto-activation, snowflake indicator)
- Smart notifications (streak at risk, progress alerts, personalized timing)

**Phases completed:**
- 03.1: Personalized Onboarding (3/3 plans)
- 03.2: Enhanced Points & Anti-Cheat (4/4 plans)
- 03.3: Weekly Goals (4/4 plans)
- 03.4: Challenges & Streak Freeze (5/5 plans)
- 03.5: Smart Notifications (3/3 plans)

**Total:** 19 plans across 5 phases

**Archive:** `.planning/milestones/v2.5-ROADMAP.md`

## Current State

**Shipped:** v2.5 - Engagement & Retention (2026-01-27)

**Latest Changes:**
- Personalized onboarding flow with calculated recommendations
- Aggressive points formula with level-based daily caps
- Weekly goals system with Sunday review popup
- Weekly challenges with bonus points
- Streak freeze protection with visual indicator
- Smart notifications with personalized timing

**Known Issues:**
- Widget verification plans pending (require physical Android device)
- Notification testing pending (require physical Android device)
- 16 human verification items require physical device testing

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
| 2-hour window binning | Sufficient granularity for workout pattern analysis | — Pending |

## Success Criteria

### v2.5 Status ✅ COMPLETE
- [x] Personalized onboarding with 4-screen flow
- [x] Enhanced points system with aggressive formula
- [x] Anti-cheat daily caps enforced
- [x] Weekly goals with Sunday review
- [x] Weekly challenges with badges
- [x] Streak freeze feature (1/month)
- [x] Smart notifications system
- [x] All 19 requirements satisfied
- [x] All 19 plans complete
- [x] Git tag created

---

*Last updated: 2026-01-27 after v2.5 milestone*
