# Roadmap: Push-Up 5050

## Overview

Progressive push-up training app with gamification and engagement features. Milestone v2.6 focuses on improvements and polish: fixing UX issues (default recovery time, goal-based workout completion), adding goal completion celebration, implementing Android adaptive icons, and fixing notification system for Android 12+.

## Milestones

- ✅ **v1.0 Core App** - Phases 01-04 (shipped)
- ✅ **v2.0 Android Widgets & App Polish** - Phases 02.1-02.11 (shipped 2026-01-23)
- ✅ **v2.5 Engagement & Retention** - Phases 03.1-03.5 (shipped 2026-01-27)
- 🚧 **v2.6 Improvements & Polish** - Phases 04.1-04.5 (in progress)

## Phases

<details>
<summary>✅ v2.5 Engagement & Retention (Phases 03.1-03.5) - SHIPPED 2026-01-27</summary>

### Phase 03.1: Personalized Onboarding
**Goal**: 4-screen onboarding flow with calculated recommendations
**Plans**: 3 plans

Plans:
- [x] 03.1-01: Onboarding flow with activity, capacity, frequency screens
- [x] 03.1-02: Daily goal recommendation screen with calculated targets
- [x] 03.1-03: Onboarding persistence and skip/revisit functionality

### Phase 03.2: Enhanced Points & Anti-Cheat
**Goal**: Aggressive points formula with level-based daily caps
**Plans**: 4 plans

Plans:
- [x] 03.2-01: Enhanced points formula (Base × (RepMult + SeriesMult) × StreakMult)
- [x] 03.2-02: Level-based daily caps (1.5x-2.5x based on user level)
- [x] 03.2-03: Points calculation integration with workout completion
- [x] 03.2-04: Anti-cheat enforcement and UI feedback

### Phase 03.3: Weekly Goals
**Goal**: Sunday weekly goal review with bonus points
**Plans**: 4 plans

Plans:
- [x] 03.3-01: Weekly goal tracking and storage
- [x] 03.3-02: Sunday review popup with progress summary
- [x] 03.3-03: 500-point bonus for reaching weekly targets
- [x] 03.3-04: Goal progression options (increase/maintain/lower)

### Phase 03.4: Challenges & Streak Freeze
**Goal**: Weekly challenges with streak freeze protection
**Plans**: 5 plans

Plans:
- [x] 03.4-01: Weekly challenge system with random challenges
- [x] 03.4-02: 200-point bonus and trophy badge for challenge completion
- [x] 03.4-03: Streak freeze system (1 per month)
- [x] 03.4-04: Auto-activation when user falls short of goal
- [x] 03.4-05: Snowflake indicator on calendar and stats

### Phase 03.5: Smart Notifications
**Goal**: Personalized notification timing with streak alerts
**Plans**: 3 plans

Plans:
- [x] 03.5-01: Notification scheduler with personalized timing
- [x] 03.5-02: Streak at risk alert (2+ missed days)
- [x] 03.5-03: Progress encouragement at 50%+ daily goal

</details>

---

## 🚧 v2.6 Improvements & Polish (In Progress)

**Milestone Goal:** Fix critical UX issues and polish platform-specific features

### Phase 04.1: Quick Fixes
**Goal**: Default recovery time changed from 30 to 10 seconds
**Depends on**: Phase 03.5 ✅
**Requirements**: WRK-01, WRK-02, WRK-03
**Success Criteria** (what must be TRUE):
  1. New users see 10 seconds as default recovery time in series selection ✅
  2. User can adjust recovery time between 5-120 seconds ✅
  3. User's configured recovery time persists across app restarts ✅
**Plans**: 2/2 complete

Plans:
- [x] 04.1-01: Update default recovery time to 10 seconds
- [x] 04.1-02: Verify recovery time configuration and persistence

### Phase 04.2: Goal-Based Logic
**Goal**: Workout auto-completes when daily goal is reached
**Depends on**: Phase 04.1 ✅
**Requirements**: GOAL-01, GOAL-02, GOAL-03, GOAL-04
**Success Criteria** (what must be TRUE):
  1. Workout session ends automatically when daily goal reps are reached ✅
  2. Series progression stops at goal completion (e.g., goal 10 = series 1+2+3+4) ✅
  3. User cannot start new workout after completing daily goal ✅
  4. Goal completion resets at midnight, allowing new workout ✅
**Plans**: 4/4 complete

Plans:
- [x] 04.2-01: Goal completion detection during workout
- [x] 04.2-02: Auto-complete workout at goal reached
- [x] 04.2-03: Prevent workout start after goal completion
- [x] 04.2-04: Midnight reset logic

### Phase 04.3: Goal Completion Popup
**Goal**: Congratulations popup when daily goal is achieved
**Depends on**: Phase 04.2 ✅
**Requirements**: UX-01, UX-02, UX-03, UX-04, UX-05
**Success Criteria** (what must be TRUE):
  1. Congratulations popup appears immediately when goal is reached ✅
  2. Popup displays Italian message: "Complimenti! Hai completato il tuo obiettivo di oggi. Ci vediamo domani!" ✅
  3. Popup includes button to return to Home screen ✅
  4. Popup appears when app opens after goal was completed earlier ✅
  5. No partial progress achievement popups (only goal completion) ✅
**Plans**: 4/4 complete

Plans:
- [x] 04.3-01: Goal completion popup widget
- [x] 04.3-02: Popup trigger on goal reached
- [x] 04.3-03: Popup trigger on app open after goal completion
- [x] 04.3-04: Home screen navigation from popup

### Phase 04.4: Android Adaptive Icon
**Goal**: Adaptive icon supports all launcher shapes
**Depends on**: Phase 04.3
**Requirements**: AND-01, AND-02, AND-03, AND-04, AND-05
**Success Criteria** (what must be TRUE):
  1. App icon uses Android Adaptive Icon system
  2. Icon displays correctly on all launcher shapes (round, square, teardrop, squircle)
  3. Icon background uses primary orange (#FF6B00)
  4. Icon foreground logo is clearly visible on all backgrounds
  5. Adaptive icons generated for all densities (hdpi, xhdpi, xxhdpi, xxxhdpi)
**Plans**: TBD

Plans:
- [ ] 04.4-01: Adaptive icon configuration in AndroidManifest
- [ ] 04.4-02: Foreground and background layer resources
- [ ] 04.4-03: Density-specific icon generation

### Phase 04.5: Notification Fix
**Goal**: Fixed-time notifications work correctly on Android 12+
**Depends on**: Phase 04.4
**Requirements**: NOTIF-01, NOTIF-02, NOTIF-03, NOTIF-04, NOTIF-05, NOTIF-06, NOTIF-07
**Success Criteria** (what must be TRUE):
  1. Daily reminder notification arrives at configured fixed time
  2. Notifications work correctly on Android 12+ (API 31+)
  3. App requests POST_NOTIFICATIONS permission on Android 13+
  4. App requests SCHEDULE_EXACT_ALARM permission for fixed-time reminders
  5. Notification service initializes correctly on app startup
  6. Graceful fallback when user denies notification permissions
  7. Notification tap opens app to correct screen
**Plans**: TBD

Plans:
- [ ] 04.5-01: POST_NOTIFICATIONS permission request for Android 13+
- [ ] 04.5-02: SCHEDULE_EXACT_ALARM permission request
- [ ] 04.5-03: Notification initialization with exact alarm
- [ ] 04.5-04: Graceful fallback for denied permissions
- [ ] 04.5-05: Notification tap handling and navigation
- [ ] 04.5-06: Testing on Android 12+

## Progress

**Execution Order:**
Phases execute in numeric order: 04.1 → 04.2 → 04.3 → 04.4 → 04.5

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 03.1 | v2.5 | 3/3 | Complete | 2026-01-25 |
| 03.2 | v2.5 | 4/4 | Complete | 2026-01-25 |
| 03.3 | v2.5 | 4/4 | Complete | 2026-01-26 |
| 03.4 | v2.5 | 5/5 | Complete | 2026-01-26 |
| 03.5 | v2.5 | 3/3 | Complete | 2026-01-27 |
| 04.1 | v2.6 | 2/2 | Complete | 2026-01-29 |
| 04.2 | v2.6 | 4/4 | Complete | 2026-01-29 |
| 04.3 | v2.6 | 4/4 | Complete | 2026-01-30 |
| 04.4 | v2.6 | 0/3 | Not started | - |
| 04.5 | v2.6 | 0/6 | Not started | - |

---

*Last updated: 2026-01-30 (Phase 04.3 complete)*
