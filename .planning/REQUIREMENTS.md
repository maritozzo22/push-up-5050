# Requirements: Push-Up 5050 v2.7

**Defined:** 2026-01-31
**Core Value:** Progressive push-up training app with gamification and engagement features

## v2.7 Requirements

Play Store Ready milestone - UI polish, proximity sensor fix, and enhanced achievements for Play Store release.

### Icon & Branding

- [x] **ICON-01**: App uses original icon.png as main launcher icon
- [x] **ICON-02**: Icon displays correctly on all Android launchers

### Settings

- [x] **SETT-01**: "Test notifications" section removed from Settings screen
- [x] **SETT-02**: Settings screen layout remains consistent after removal

### Statistics UI

- [ ] **STAT-01**: "Totale Pushup" card has no progress bar below
- [ ] **STAT-02**: "Totale Pushup" card text is centered and enlarged
- [ ] **STAT-03**: "Calorie Bruciate" card text is centered and enlarged
- [ ] **STAT-04**: Both cards maintain consistent visual hierarchy

### Goal Notification

- [ ] **GOAL-01**: Goal completion shows top banner notification (not full-screen popup)
- [ ] **GOAL-02**: Notification displays message: "Complimenti! Hai superato il goal di X pushup!"
- [ ] **GOAL-03**: Confetti animation falls from notification banner
- [ ] **GOAL-04**: Workout session continues after goal completion (non-blocking)
- [ ] **GOAL-05**: User can dismiss notification by tapping

### Achievements

- [ ] **ACHV-01**: System supports 20 total achievements (expanded from 11)
- [ ] **ACHV-02**: 9 new achievements added with appropriate unlock conditions
- [ ] **ACHV-03**: Achievement UI displays all 20 achievements correctly
- [ ] **ACHV-04**: Achievement unlock logic works for all new achievements

### Proximity Sensor

- [ ] **SENS-01**: Proximity sensor correctly counts push-ups (far→near = 1 rep)
- [ ] **SENS-02**: Proximity sensor toggle moved from Settings to Workout Setup screen
- [ ] **SENS-03**: User can enable/disable proximity sensor before workout starts
- [ ] **SENS-04**: Proximity sensor mode works with phone placed on ground

### Onboarding

- [ ] **ONBD-01**: Onboarding has improved visual design with better styling
- [ ] **ONBD-02**: Onboarding content is more detailed and helpful
- [ ] **ONBD-03**: Onboarding maintains 4+ screens structure
- [ ] **ONBD-04**: Onboarding flow is smooth and engaging

## Future Requirements

Deferred to future milestone.

### Notification System (Android 12+)

- **NOTIF-01**: Daily reminder notification arrives at configured fixed time
- **NOTIF-02**: Notifications work correctly on Android 12+ (API 31+)
- **NOTIF-03**: App requests POST_NOTIFICATIONS permission on Android 13+
- **NOTIF-04**: App requests SCHEDULE_EXACT_ALARM permission for fixed-time reminders

## Out of Scope

| Feature | Reason |
|---------|--------|
| iOS adaptive icon | Android-first milestone, iOS can follow |
| Notification channels customization | Only goal notification needed for v2.7 |
| Reducing onboarding screens | User wants to maintain 4+ screens |
| Full-screen goal popup | Replaced with top banner notification |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| ICON-01 | Phase 05 | Complete |
| ICON-02 | Phase 05 | Complete |
| SETT-01 | Phase 05 | Complete |
| SETT-02 | Phase 05 | Complete |
| STAT-01 | Phase 06 | Pending |
| STAT-02 | Phase 06 | Pending |
| STAT-03 | Phase 06 | Pending |
| STAT-04 | Phase 06 | Pending |
| GOAL-01 | Phase 07 | Pending |
| GOAL-02 | Phase 07 | Pending |
| GOAL-03 | Phase 07 | Pending |
| GOAL-04 | Phase 07 | Pending |
| GOAL-05 | Phase 07 | Pending |
| ACHV-01 | Phase 08 | Pending |
| ACHV-02 | Phase 08 | Pending |
| ACHV-03 | Phase 08 | Pending |
| ACHV-04 | Phase 08 | Pending |
| SENS-01 | Phase 09 | Pending |
| SENS-02 | Phase 09 | Pending |
| SENS-03 | Phase 09 | Pending |
| SENS-04 | Phase 09 | Pending |
| ONBD-01 | Phase 10 | Pending |
| ONBD-02 | Phase 10 | Pending |
| ONBD-03 | Phase 10 | Pending |
| ONBD-04 | Phase 10 | Pending |

**Coverage:**
- v2.7 requirements: 22 total
- Mapped to phases: 22/22 (100%)
- Unmapped: 0

**Phase Distribution:**
- Phase 05 (Icon & Settings): 4 requirements (ICON-01, ICON-02, SETT-01, SETT-02)
- Phase 06 (Statistics UI): 4 requirements (STAT-01, STAT-02, STAT-03, STAT-04)
- Phase 07 (Goal Notification): 5 requirements (GOAL-01, GOAL-02, GOAL-03, GOAL-04, GOAL-05)
- Phase 08 (Achievements): 4 requirements (ACHV-01, ACHV-02, ACHV-03, ACHV-04)
- Phase 09 (Proximity Sensor): 4 requirements (SENS-01, SENS-02, SENS-03, SENS-04)
- Phase 10 (Onboarding): 4 requirements (ONBD-01, ONBD-02, ONBD-03, ONBD-04)

---

*Requirements defined: 2026-01-31*
*Last updated: 2026-01-31 after roadmap creation*
