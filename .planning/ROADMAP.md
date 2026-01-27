# ROADMAP.md

**Project:** Push-Up 5050 - Engagement & Retention
**Last Updated:** 2026-01-26

## Overview

This roadmap defines the phases for implementing Milestone v2.5: Engagement & Retention features. The milestone focuses on increasing user engagement through personalized onboarding, enhanced gamification (aggressive points system, weekly goals, challenges), smart notifications, and anti-cheat measures.

## Milestones

- ✅ **v1.0 Core App** - Progressive workout system (SHIPPED)
- ✅ **v2.0 Android Widgets** - Widget infrastructure & app polish (SHIPPED 2026-01-23)
- ✅ **v2.5 Engagement & Retention** - Phases 03.1-03.5 (SHIPPED 2026-01-26)

---

<details>
<summary>✅ Milestone 1: Core Flutter App (SHIPPED)</summary>

All core functionality has been implemented:
- Progressive workout system with series counting
- Statistics and calendar tracking
- Achievement system with unlock notifications
- Settings and user preferences

</details>

<details>
<summary>✅ Milestone 2: Android Widgets Integration (SHIPPED 2026-01-23)</summary>

**Phases completed:**
- 02.1: Foundation & Setup (3/3 plans)
- 02.2: Widget 1 - Quick Stats (5/6 plans)
- 02.6: Widget Redesign (4/5 plans)
- 02.7: Widget Rebuild (3/4 plans)
- 02.8: App Polish & Tutorial (5/5 plans)
- 02.9: Fix Goals Persistence Integration (1/1 plan)
- 02.10: Update ROADMAP.md Statuses (1/1 plan)
- 02.11: Clean Up Empty Directories (1/1 plan)

**Archive:** `.planning/milestones/v2.0-ROADMAP.md`

</details>

## ✅ Milestone 3: Engagement & Retention (SHIPPED 2026-01-26)

**Milestone Goal:** Increase user engagement and retention through personalized experiences, enhanced gamification, weekly goals, challenges, and smart notifications.

### Phase 03.1: Personalized Onboarding

**Goal:** New users receive personalized workout recommendations based on their fitness level

**Depends on:** Nothing (first phase of milestone)

**Requirements:** ONBD-01, ONBD-02, ONBD-03, ONBD-04

**Success Criteria** (what must be TRUE):
1. User completes 4-screen onboarding flow (activity, capacity, frequency, goal) on first launch
2. System calculates personalized recommendations (starting series, daily goal, recovery time)
3. Onboarding is mandatory (no skip button) per anti-cheat requirements
4. Values cannot be edited after onboarding (anti-cheat: prevents gaming points system)
5. Personalized values persist across app sessions via StorageService

**Plans:**
- [ ] 03.1-01-PLAN.md — Create OnboardingData model and first two screen widgets (Activity Level, Capacity)
- [ ] 03.1-02-PLAN.md — Create remaining onboarding widgets (Frequency, Daily Goal)
- [ ] 03.1-03-PLAN.md — Create main PersonalizedOnboardingScreen with PageView and integrate with main.dart

---

### Phase 03.2: Enhanced Points System & Anti-Cheat

**Goal:** Points system redesigned for aggressive progression while preventing abuse

**Depends on:** Phase 03.1 (onboarding sets user's baseline capacity)

**Requirements:** POINTS-01, POINTS-02, POINTS-03, POINTS-04, POINTS-05, ANTCHEAT-01, ANTCHEAT-02

**Success Criteria** (what must be TRUE):
1. Points calculated with new formula: Base × (RepMult + SeriesMult) × StreakMult
2. Rep multiplier = push-ups × 0.3, Series multiplier = series × 0.8
3. Points persisted to DailyRecord.pointsEarned and DailyRecord.multiplier
4. Total points accumulated in UserStats.totalPoints and displayed in statistics
5. Daily cap enforced based on user level (goal × 1.5 to 2.5), excess push-ups tracked but not rewarded

**Plans:**
- [ ] 03.2-01-PLAN.md — Implement new aggressive points formula in Calculator (TDD: getRepMultiplier, getSeriesMultiplier, calculateSeriesPoints)
- [ ] 03.2-02-PLAN.md — Add pointsEarned and multiplier fields to DailyRecord model with JSON persistence
- [ ] 03.2-03-PLAN.md — Wire points calculation into workout flow, display totalPoints in statistics
- [ ] 03.2-04-PLAN.md — Implement daily cap calculation and anti-cheat enforcement

---

### Phase 03.3: Weekly Goals System

**Goal:** Users work toward weekly targets with Sunday review and goal progression

**Depends on:** Phase 03.2 (points system required for weekly bonuses)

**Requirements:** WEEKLY-01, WEEKLY-02, WEEKLY-03, WEEKLY-04, WEEKLY-05

**Success Criteria** (what must be TRUE):
1. Weekly target calculated as daily goal × 5 and displayed in statistics
2. Sunday popup shows weekly progress percentage (push-ups completed / weekly target)
3. User receives 500 bonus points when weekly target is reached
4. Popup offers goal increase options (maintain, +10%, +20%) when target reached
5. Streak resets only if user completes 0 workouts in the week (any push-ups preserve streak)

**Plans:**
- [x] 03.3-01-PLAN.md — Weekly state tracking infrastructure (week utilities, flag tracking, weekly streak)
- [x] 03.3-02-PLAN.md — Weekly target calculation (daily goal × 5) with persistence and display
- [x] 03.3-03-PLAN.md — Weekly review popup UI with bonus calculation and goal adjustment
- [x] 03.3-04-PLAN.md — HomeScreen integration with popup trigger and provider registration

---

### Phase 03.4: Challenges & Streak Freeze

**Goal:** Weekly challenges provide additional motivation with streak protection

**Depends on:** Phase 03.3 (weekly goals system required for challenges)

**Requirements:** CHAL-01, CHAL-02, CHAL-03

**Success Criteria** (what must be TRUE):
1. User can view weekly challenge in statistics screen ("Complete X push-ups this week")
2. User receives badge notification and 200 bonus points upon challenge completion
3. User has 1 streak freeze per month (prevents streak reset, auto-activates if weekly push-ups > 0)

**Plans:**
- [x] 03.4-01-PLAN.md — Weekly challenge tracking infrastructure (completion flags, target calculation, bonus award)
- [x] 03.4-02-PLAN.md — Weekly challenge UI (WeeklyChallengeCard widget, localization, popup notification)
- [x] 03.4-03-PLAN.md — Streak freeze system (1 per month, auto-activation, snowflake indicator)
- [x] 03.4-04-PLAN.md — Wire autoActivateStreakFreezeIfNeeded() into StatisticsScreen initialization
- [x] 03.4-05-PLAN.md — Ensure bonus points display refreshes immediately after award

---

### Phase 03.5: Smart Notifications

**Goal:** Contextual notifications keep users engaged without spamming

**Depends on:** Phase 03.3 (weekly goals), Phase 03.4 (challenges), Phase 03.1 (workout patterns)

**Requirements:** NOTIF-01, NOTIF-02, NOTIF-03, NOTIF-04

**Success Criteria** (what must be TRUE):
1. User receives "streak at risk" notification after 2 missed days
2. User receives progress notification when within 5 push-ups of daily goal
3. Notification time personalized to user's workout patterns (median completion time)
4. User receives new challenge notification on Sunday at 8:00 AM

**Plans:**
- [x] 03.5-01-PLAN.md — Workout time tracking and personalization infrastructure (NotificationTimeSlot, WorkoutTimeAnalyzer, StorageService methods, NotificationPreferencesProvider)
- [x] 03.5-02-PLAN.md — NotificationService smart notification methods and localization (scheduleStreakAtRiskNotification, scheduleProgressNotification, scheduleWeeklyChallengeNotification, IT/EN strings)
- [x] 03.5-03-PLAN.md — NotificationScheduler and wiring (condition checking, scheduling logic, deep link navigation, provider registration, HomeScreen triggers)

---

## Future Milestones

### Milestone 4: Social Features (Future)
- Social sharing (Instagram templates, shareable badges)
- Multiplayer challenges
- Challenge links and invitations

### Milestone 5: Monetization (Future)
- Ad integration
- Shop themes
- Premium features

---

## Progress

**Execution Order:**
Phases execute in numeric order: 03.1 → 03.2 → 03.3 → 03.4 → 03.5

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 03.1 Personalized Onboarding | v2.5 | 3/3 | Complete | 2026-01-24 |
| 03.2 Enhanced Points & Anti-Cheat | v2.5 | 4/4 | Complete | 2026-01-24 |
| 03.3 Weekly Goals | v2.5 | 4/4 | Complete | 2026-01-25 |
| 03.4 Challenges & Streak Freeze | v2.5 | 5/5 | Complete | 2026-01-26 |
| 03.5 Smart Notifications | v2.5 | 3/3 | Complete | 2026-01-26 |

---

## Phase Status Legend

- ✅ Complete
- 🔄 In Progress
- ⏳ Not started
- ❌ Blocked

---

*Last updated: 2026-01-26 (Phase 03.5 complete - Milestone v2.5 complete)*
