# Requirements: Push-Up 5050 v2.7 (Reduced Scope)

**Defined:** 2026-01-31
**Updated:** 2026-02-03 (Scope reduced - Phases 07, 08, 10 deferred to v2.8)
**Core Value:** Progressive push-up training app with gamification and engagement features

## v2.7 Requirements (Reduced Scope)

Play Store Ready milestone - Icon restoration, statistics polish, proximity sensor fix, and Android notifications fix.

**Note:** Goal Notification System (GOAL-xx), Achievement Expansion (ACHV-xx), and Onboarding Improvements (ONBD-xx) have been deferred to v2.8.

### Icon & Branding

- [x] **ICON-01**: App uses original icon.png as main launcher icon
- [x] **ICON-02**: Icon displays correctly on all Android launchers

### Settings

- [x] **SETT-01**: "Test notifications" section removed from Settings screen
- [x] **SETT-02**: Settings screen layout remains consistent after removal

### Statistics UI

- [x] **STAT-01**: "Totale Pushup" card has no progress bar below
- [x] **STAT-02**: "Totale Pushup" card text is centered and enlarged
- [x] **STAT-03**: "Calorie Bruciate" card text is centered and enlarged
- [x] **STAT-04**: Both cards maintain consistent visual hierarchy

### Proximity Sensor

- [ ] **SENS-01**: Proximity sensor correctly counts push-ups (far→near = 1 rep)
- [ ] **SENS-02**: Proximity sensor toggle moved from Settings to Workout Setup screen
- [ ] **SENS-03**: User can enable/disable proximity sensor before workout starts
- [ ] **SENS-04**: Proximity sensor mode works with phone placed on ground

### Android Notifications (Phase 11 - In Progress)

- [ ] **NOTIF-01**: All scheduled notifications work reliably on Android
- [ ] **NOTIF-02**: SCHEDULE_EXACT_ALARM permission handling is robust with user-friendly prompts
- [ ] **NOTIF-03**: Notification scheduling survives app restart and device reboot
- [ ] **NOTIF-04**: Notifications work correctly across Android 12+ and older versions

## Deferred to v2.8

The following requirements have been deferred to the next milestone:

### Goal Notification (Deferred)

- **GOAL-01**: Goal completion shows top banner notification (not full-screen popup)
- **GOAL-02**: Notification displays message: "Complimenti! Hai superato il goal di X pushup!"
- **GOAL-03**: Confetti animation falls from notification banner
- **GOAL-04**: Workout session continues after goal completion (non-blocking)
- **GOAL-05**: User can dismiss notification by tapping

### Achievements (Deferred)

- **ACHV-01**: System supports 20 total achievements (expanded from 11)
- **ACHV-02**: 9 new achievements added with appropriate unlock conditions
- **ACHV-03**: Achievement UI displays all 20 achievements correctly
- **ACHV-04**: Achievement unlock logic works for all new achievements

### Onboarding (Deferred)

- **ONBD-01**: Onboarding has improved visual design with better styling
- **ONBD-02**: Onboarding content is more detailed and helpful
- **ONBD-03**: Onboarding maintains 4+ screens structure
- **ONBD-04**: Onboarding flow is smooth and engaging

## Out of Scope

| Feature | Reason |
|---------|--------|
| iOS adaptive icon | Android-first milestone, iOS can follow |
| Notification channels customization | Only goal notification needed for v2.7 |
| Reducing onboarding screens | User wants to maintain 4+ screens |
| Full-screen goal popup | Replaced with top banner notification |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

### v2.7 Requirements (Reduced Scope)

| Requirement | Phase | Status |
|-------------|-------|--------|
| ICON-01 | Phase 05 | Complete |
| ICON-02 | Phase 05 | Complete |
| SETT-01 | Phase 05 | Complete |
| SETT-02 | Phase 05 | Complete |
| STAT-01 | Phase 06 | Complete |
| STAT-02 | Phase 06 | Complete |
| STAT-03 | Phase 06 | Complete |
| STAT-04 | Phase 06 | Complete |
| SENS-01 | Phase 09 | Pending |
| SENS-02 | Phase 09 | Pending |
| SENS-03 | Phase 09 | Pending |
| SENS-04 | Phase 09 | Pending |
| NOTIF-01 | Phase 11 | In Progress |
| NOTIF-02 | Phase 11 | In Progress |
| NOTIF-03 | Phase 11 | In Progress |
| NOTIF-04 | Phase 11 | In Progress |

**v2.7 Coverage:**
- v2.7 requirements: 16 total
- Mapped to phases: 16/16 (100%)
- Completed: 8/16 (50%)
- Pending: 8/16 (50%)

**v2.7 Phase Distribution:**
- Phase 05 (Icon & Settings): 4 requirements - Complete
- Phase 06 (Statistics UI): 4 requirements - Complete
- Phase 09 (Proximity Sensor): 4 requirements - Not Started
- Phase 11 (Android Notifications): 4 requirements - In Progress

### v2.8 Requirements (Deferred)

| Requirement | Phase | Status |
|-------------|-------|--------|
| GOAL-01 | Phase 07 | Deferred |
| GOAL-02 | Phase 07 | Deferred |
| GOAL-03 | Phase 07 | Deferred |
| GOAL-04 | Phase 07 | Deferred |
| GOAL-05 | Phase 07 | Deferred |
| ACHV-01 | Phase 08 | Deferred |
| ACHV-02 | Phase 08 | Deferred |
| ACHV-03 | Phase 08 | Deferred |
| ACHV-04 | Phase 08 | Deferred |
| ONBD-01 | Phase 10 | Deferred |
| ONBD-02 | Phase 10 | Deferred |
| ONBD-03 | Phase 10 | Deferred |
| ONBD-04 | Phase 10 | Deferred |

**v2.8 Deferred:** 13 requirements

---

*Requirements defined: 2026-01-31*
*Last updated: 2026-02-03 after scope reduction*
