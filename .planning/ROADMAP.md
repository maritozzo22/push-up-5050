# Roadmap: Push-Up 5050

## Overview

Push-Up 5050 is a progressive training app with gamification, currently in v2.7 Play Store Ready milestone. This roadmap covers 22 requirements across 6 phases, delivering UI polish, proximity sensor fixes, and enhanced achievements to prepare the app for public release on the Google Play Store.

## Milestones

- ✅ **v1.0 Core App** - Phases 01-04 (shipped)
- ✅ **v2.0 Android Widgets & App Polish** - Phases 02.1-02.11 (shipped 2026-01-23)
- ✅ **v2.5 Engagement & Retention** - Phases 03.1-03.5 (shipped 2026-01-27)
- ✅ **v2.6 Improvements & Polish** - Phases 04.1-04.4, 04.6 (shipped 2026-01-31)
- 🚧 **v2.7 Play Store Ready** - Phases 05-11 (in progress)

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

### 🚧 v2.7 Play Store Ready (In Progress)

**Milestone Goal:** Polish app for Play Store release with UI improvements, proximity sensor fix, and enhanced achievements

#### Phase 05: Icon & Settings Cleanup
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

#### Phase 06: Statistics UI Polish
**Goal**: Improve statistics cards readability and visual hierarchy
**Depends on**: Phase 05
**Requirements**: STAT-01, STAT-02, STAT-03, STAT-04
**Success Criteria** (what must be TRUE):
  1. "Totale Pushup" card displays count without progress bar below
  2. "Totale Pushup" card text is centered and enlarged for better readability
  3. "Calorie Bruciate" card text is centered and enlarged with consistent styling
**Plans**: 2 plans

Plans:
- [ ] 06-01-PLAN.md — Remove progress bar from TotalPushupsCard
- [ ] 06-02-PLAN.md — Center and enlarge text in both Statistics cards

#### Phase 07: Goal Notification System
**Goal**: Replace blocking popup with non-blocking top banner notification
**Depends on**: Phase 06
**Requirements**: GOAL-01, GOAL-02, GOAL-03, GOAL-04, GOAL-05
**Success Criteria** (what must be TRUE):
  1. Goal completion shows top banner notification (not full-screen popup)
  2. Notification displays Italian message: "Complimenti! Hai superato il goal di X pushup!"
  3. Confetti animation falls from notification banner
  4. Workout session continues uninterrupted after goal completion
  5. User can dismiss notification by tapping
**Plans**: TBD

Plans:
- [ ] 07-01: Implement non-blocking top banner notification
- [ ] 07-02: Add confetti animation to goal notification
- [ ] 07-03: Update goal completion flow to continue workout

#### Phase 08: Achievement Expansion
**Goal**: Expand achievement system from 11 to 20 total achievements
**Depends on**: Phase 07
**Requirements**: ACHV-01, ACHV-02, ACHV-03, ACHV-04
**Success Criteria** (what must be TRUE):
  1. Achievement system supports 20 total achievements
  2. 9 new achievements unlock correctly under specified conditions
  3. Achievement UI displays all 20 achievements with proper layout
  4. All achievements (old and new) trigger unlock notifications
**Plans**: TBD

Plans:
- [ ] 08-01: Design and implement 9 new achievements
- [ ] 08-02: Update achievement UI for 20-item display
- [ ] 08-03: Test unlock logic for all achievements

#### Phase 09: Proximity Sensor Fix
**Goal**: Fix proximity sensor functionality and relocate control to Workout Setup
**Depends on**: Phase 08
**Requirements**: SENS-01, SENS-02, SENS-03, SENS-04
**Success Criteria** (what must be TRUE):
  1. Proximity sensor correctly counts push-ups (far→near transition = 1 rep)
  2. Proximity sensor toggle appears in Workout Setup screen (not Settings)
  3. User can enable/disable proximity mode before workout starts
  4. Proximity sensor works reliably with phone placed on ground
**Plans**: TBD

Plans:
- [ ] 09-01: Fix proximity sensor detection logic
- [ ] 09-02: Move proximity toggle from Settings to Workout Setup
- [ ] 09-03: Test proximity sensor with physical device

#### Phase 10: Onboarding Improvements
**Goal**: Enhance onboarding visual design and content for better user engagement
**Depends on**: Phase 09
**Requirements**: ONBD-01, ONBD-02, ONBD-03, ONBD-04
**Success Criteria** (what must be TRUE):
  1. Onboarding screens have improved visual design with better styling
  2. Onboarding content is more detailed and helpful for new users
  3. Onboarding maintains 4+ screen structure
  4. Onboarding flow is smooth with proper transitions and engagement
**Plans**: TBD

Plans:
- [ ] 10-01: Improve onboarding visual design
- [ ] 10-02: Enhance onboarding content and messaging
- [ ] 10-03: Test onboarding flow end-to-end

#### Phase 11: Android Notifications Fix
**Goal**: Fix all notification issues on Android - scheduled notifications not working despite permissions granted
**Depends on**: Phase 10
**Requirements**: NOTIF-01, NOTIF-02, NOTIF-03
**Success Criteria** (what must be TRUE):
  1. All scheduled notifications (daily reminder, streak at risk, progress, weekly challenge) work reliably on Android
  2. SCHEDULE_EXACT_ALARM permission handling is robust with user-friendly prompts
  3. Notification scheduling survives app restart and device reboot
  4. Notifications work correctly across Android 12+ and older versions
**Plans**: 4 plans

Plans:
- [ ] 11-01-PLAN.md — Update package and add broadcast receivers to AndroidManifest.xml
- [ ] 11-02-PLAN.md — Implement POST_NOTIFICATIONS permission request on startup
- [ ] 11-03-PLAN.md — Implement exact alarm permission dialog with Settings integration
- [ ] 11-04-PLAN.md — Verify all notifications work on physical Android device

## Progress

**Execution Order:**
Phases execute in numeric order: 05 → 06 → 07 → 08 → 09 → 10 → 11

| Phase | Milestone | Plans Complete | Status | Completed |
|-------|-----------|----------------|--------|-----------|
| 04.1. Quick Fixes | v2.6 | 2/2 | Complete | 2026-01-29 |
| 04.2. Goal-Based Logic | v2.6 | 4/4 | Complete | 2026-01-29 |
| 04.3. Goal Completion Popup | v2.6 | 3/3 | Complete | 2026-01-30 |
| 04.4. Adaptive Icon | v2.6 | 2/2 | Complete | 2026-01-30 |
| 04.6. Bug Fixes & Testing | v2.6 | 5/5 | Complete | 2026-01-31 |
| 05. Icon & Settings Cleanup | v2.7 | 2/2 | Complete | 2026-01-31 |
| 06. Statistics UI Polish | v2.7 | 0/2 | Not started | - |
| 07. Goal Notification System | v2.7 | 0/3 | Not started | - |
| 08. Achievement Expansion | v2.7 | 0/3 | Not started | - |
| 09. Proximity Sensor Fix | v2.7 | 0/3 | Not started | - |
| 10. Onboarding Improvements | v2.7 | 0/3 | Not started | - |
| 11. Android Notifications Fix | v2.7 | 0/4 | Not started | - |

**Overall Milestone Progress:** 2/20 plans complete (10%)

---

*Last updated: 2026-02-03 (Phase 11 plans created)*
