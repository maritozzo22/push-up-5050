# Roadmap: Push-Up 5050

## Overview

Push-Up 5050 is a progressive training app with gamification, currently in v2.7 Play Store Ready milestone. This roadmap covers 22 requirements across 6 phases, delivering UI polish, proximity sensor fixes, and enhanced achievements to prepare the app for public release on the Google Play Store.

## Milestones

- ✅ **v1.0 Core App** - Phases 01-04 (shipped)
- ✅ **v2.0 Android Widgets & App Polish** - Phases 02.1-02.11 (shipped 2026-01-23)
- ✅ **v2.5 Engagement & Retention** - Phases 03.1-03.5 (shipped 2026-01-27)
- ✅ **v2.6 Improvements & Polish** - Phases 04.1-04.4, 04.6 (shipped 2026-01-31)
- 🚧 **v2.7 Play Store Ready** - Phases 05, 06, 09, 11 (in progress - reduced scope)
- 📋 **v2.8 Feature Expansion** - Phases 07, 08, 10 (deferred from v2.7)

## Phases

<details>
<summary>✅ v2.6 Improvements & Polish (Phases 04.1-04.4, 04.6) - SHIPPED 2026-01-31</summary>

**Milestone Goal:** Faster workouts, goal-based auto-completion, celebration popup, adaptive icons, and critical bug fixes

### Phase 04.1: Quick Fixes
**Goal**: Address critical UI bugs discovered post-v2.5
**Requirements**: WRK-01, WRK-02, BUG-01, BUG-02, BUG-03
**Success Criteria** (what must be TRUE):
  1. Series selection cap works correctly at goal + 10
  2. Settings load dynamic daily goal from storage
  3. Navigation to Workout Summary works after goal completion
**Plans**: 2 plans (04.1-01, 04.1-02)

### Phase 04.2: Goal-Based Logic
**Goal**: Reduce default recovery and implement goal-based workout logic
**Requirements**: WRK-03, GOAL-01
**Success Criteria** (what must be TRUE):
  1. Default recovery time is 10 seconds (not 30)
  2. Workout auto-completes when daily goal reached
  3. Recovery skips when goal reached
**Plans**: 4 plans (04.2-01 through 04.2-04)

### Phase 04.3: Goal Completion Popup
**Goal**: Celebrate goal completion with confetti popup
**Requirements**: GOAL-02, GOAL-03
**Success Criteria** (what must be TRUE):
  1. Goal completion shows full-screen popup with congratulations message
  2. Confetti animation displays in popup
  3. Navigation goes to Workout Summary after popup
**Plans**: 3 plans (04.3-01 through 04.3-03)

### Phase 04.4: Android Adaptive Icon
**Goal**: Generate Android adaptive icon assets
**Requirements**: AND-01, AND-02, AND-03
**Success Criteria** (what must be TRUE):
  1. Android adaptive icon XML files exist in res/mipmap-anydpi-v26/
  2. Icon displays correctly on various launcher shapes
  3. Monochrome icon layer configured for Android 13+
**Plans**: 2 plans (04.4-01, 04.4-02)

### Phase 04.6: Bug Fixes & Testing
**Goal**: Verify all fixes via Chrome/web testing
**Requirements**: BUG-04, BUG-05, BUG-06, BUG-07
**Success Criteria** (what must be TRUE):
  1. Onboarding goal persists correctly
  2. Series selection cap at goal+10 works
  3. Navigation to Workout Summary works
  4. Calorie card displays correctly
**Plans**: 5 plans (04.6-01 through 04.6-05)

**Archive:** `.planning/milestones/v2.6-ROADMAP.md`

</details>

<details>
<summary>✅ v2.5 Engagement & Retention (Phases 03.1-03.5) - SHIPPED 2026-01-27</summary>

**Milestone Goal:** Personalized onboarding, enhanced gamification, weekly goals, challenges, streak freeze, smart notifications

- [x] Phase 03.1: Personalized Onboarding (3/3 plans) — completed 2026-01-25
- [x] Phase 03.2: Enhanced Points & Anti-Cheat (4/4 plans) — completed 2026-01-25
- [x] Phase 03.3: Weekly Goals (4/4 plans) — completed 2026-01-26
- [x] Phase 03.4: Challenges & Streak Freeze (5/5 plans) — completed 2026-01-26
- [x] Phase 03.5: Smart Notifications (3/3 plans) — completed 2026-01-27

**Archive:** `.planning/milestones/v2.5-ROADMAP.md`

</details>

<details>
<summary>✅ v2.0 Android Widgets & App Polish (Phases 02.1-02.11) - SHIPPED 2026-01-23</summary>

**Milestone Goal:** Widget infrastructure, calendar sync, deep links, onboarding, goals persistence, launcher icon, overflow fixes

- [x] Phase 02.1-02.11: Various polish features (22 plans total) — completed 2026-01-23

**Archive:** `.planning/milestones/v2.0-ROADMAP.md`

</details>

---

### 🚧 v2.7 Play Store Ready (In Progress - Reduced Scope)

**Milestone Goal:** Icon restoration, statistics polish, proximity sensor fix, and Android notifications fix

**Note:** Phases 07 (Goal Notification), 08 (Achievement Expansion), and 10 (Onboarding Improvements) have been deferred to v2.8.

#### Phase 05: Icon & Settings Cleanup ✅ COMPLETE
**Goal**: Restore original branding and clean up settings UI
**Depends on**: Phase 04.6
**Requirements**: ICON-01, ICON-02, SETT-01, SETT-02
**Success Criteria** (what must be TRUE):
  1. App launches with original icon.png as the launcher icon on all Android devices
  2. Settings screen displays without "Test notifications" section
  3. Settings layout remains visually consistent after section removal
**Plans**: 2 plans
**Status**: Complete ✅ (2026-01-31)

Plans:
- [x] 05-01-PLAN.md — Restore original icon.png as main launcher icon
- [x] 05-02-PLAN.md — Remove "Test notifications" from Settings screen

#### Phase 06: Statistics UI Polish ✅ COMPLETE
**Goal**: Improve statistics cards readability and visual hierarchy
**Depends on**: Phase 05
**Requirements**: STAT-01, STAT-02, STAT-03, STAT-04
**Success Criteria** (what must be TRUE):
  1. "Totale Pushup" card displays count without progress bar below
  2. "Totale Pushup" card text is centered and enlarged for better readability
  3. "Calorie Bruciate" card text is centered and enlarged with consistent styling
**Plans**: 2 plans

Plans:
- [x] 06-01-PLAN.md — Remove progress bar from TotalPushupsCard
- [x] 06-02-PLAN.md — Center and enlarge text in both Statistics cards

#### Phase 09: Proximity Sensor Fix 📋 NOT STARTED
**Goal**: Fix proximity sensor functionality and relocate control to Workout Setup
**Depends on**: None (dependency removed since Phase 08 deferred)
**Requirements**: SENS-01, SENS-02, SENS-03, SENS-04
**Success Criteria** (what must be TRUE):
  1. Proximity sensor correctly counts push-ups (far→near transition = 1 rep)
  2. Proximity sensor toggle appears in Workout Setup screen (not Settings)
  3. User can enable/disable proximity mode before workout starts
  4. Proximity sensor works reliably with phone placed on ground
**Plans**: 3 plans (to be created)

Plans:
- [ ] 09-01-PLAN.md — Fix proximity sensor detection logic
- [ ] 09-02-PLAN.md — Move proximity toggle from Settings to Workout Setup
- [ ] 09-03-PLAN.md — Test proximity sensor with physical device

#### Phase 11: Android Notifications Fix 🔄 IN PROGRESS
**Goal**: Fix all notification issues on Android - scheduled notifications not working despite permissions granted
**Depends on**: None (dependency on Phase 10 removed)
**Requirements**: NOTIF-01, NOTIF-02, NOTIF-03
**Success Criteria** (what must be TRUE):
  1. All scheduled notifications (daily reminder, streak at risk, progress, weekly challenge) work reliably on Android
  2. SCHEDULE_EXACT_ALARM permission handling is robust with user-friendly prompts
  3. Notification scheduling survives app restart and device reboot
  4. Notifications work correctly across Android 12+ and older versions
**Plans**: 4 plans

Plans:
- [x] 11-01-PLAN.md — Update package and add broadcast receivers to AndroidManifest.xml
- [x] 11-02-PLAN.md — Implement POST_NOTIFICATIONS permission request on startup
- [x] 11-03-PLAN.md — Implement exact alarm permission dialog with Settings integration
- [ ] 11-04-PLAN.md — Verify all notifications work on physical Android device

---

### 📋 v2.8 Feature Expansion (Planned - Deferred from v2.7)

**Deferred Phases:** Goal Notification System, Achievement Expansion, Onboarding Improvements

These phases were planned for v2.7 but have been deferred to focus on core Play Store readiness (sensor fix, notifications fix).

**Phase 07: Goal Notification System** (deferred)
- Replace blocking popup with non-blocking top banner notification
- 3 plans to be created

**Phase 08: Achievement Expansion** (deferred)
- Expand achievement system from 11 to 20 total achievements
- 3 plans to be created

**Phase 10: Onboarding Improvements** (deferred)
- Enhance onboarding visual design and content for better user engagement
- 3 plans to be created

## Progress

**Execution Order:**
Phases execute in numeric order: 05 → 06 → 09 → 11

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 04.1. Quick Fixes | v2.6 | 2/2 | Complete | 2026-01-29 |
| 04.2. Goal-Based Logic | v2.6 | 4/4 | Complete | 2026-01-29 |
| 04.3. Goal Completion Popup | v2.6 | 3/3 | Complete | 2026-01-30 |
| 04.4. Adaptive Icon | v2.6 | 2/2 | Complete | 2026-01-30 |
| 04.6. Bug Fixes & Testing | v2.6 | 5/5 | Complete | 2026-01-31 |
| 05. Icon & Settings Cleanup | v2.7 | 2/2 | Complete | 2026-01-31 |
| 06. Statistics UI Polish | v2.7 | 2/2 | Complete | 2026-01-31 |
| 09. Proximity Sensor Fix | v2.7 | 0/3 | Not started | - |
| 11. Android Notifications Fix | v2.7 | 3/4 | In Progress | 2026-02-03 |

**Overall Milestone Progress:** 7/12 plans complete (58%)

**Deferred to v2.8:** Phases 07, 08, 10

---

*Last updated: 2026-02-03 (Scope reduced - Phases 07, 08, 10 deferred to v2.8)*
