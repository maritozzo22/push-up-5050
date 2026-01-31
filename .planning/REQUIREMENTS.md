# Requirements: Push-Up 5050 v2.7

**Defined:** 2026-01-31
**Core Value:** Progressive push-up training app with gamification and engagement features

## v2.7 Requirements

Play Store Ready milestone - UI polish, proximity sensor fix, and enhanced achievements for Play Store release.

### Icon & Branding

- [ ] **ICON-01**: App uses original icon.png as main launcher icon
- [ ] **ICON-02**: Icon displays correctly on all Android launchers

### Settings

- [ ] **SETT-01**: "Test notifications" section removed from Settings screen
- [ ] **SETT-02**: Settings screen layout remains consistent after removal

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
| ICON-01 | TBD | Pending |
| ICON-02 | TBD | Pending |
| SETT-01 | TBD | Pending |
| SETT-02 | TBD | Pending |
| STAT-01 | TBD | Pending |
| STAT-02 | TBD | Pending |
| STAT-03 | TBD | Pending |
| STAT-04 | TBD | Pending |
| GOAL-01 | TBD | Pending |
| GOAL-02 | TBD | Pending |
| GOAL-03 | TBD | Pending |
| GOAL-04 | TBD | Pending |
| GOAL-05 | TBD | Pending |
| ACHV-01 | TBD | Pending |
| ACHV-02 | TBD | Pending |
| ACHV-03 | TBD | Pending |
| ACHV-04 | TBD | Pending |
| SENS-01 | TBD | Pending |
| SENS-02 | TBD | Pending |
| SENS-03 | TBD | Pending |
| SENS-04 | TBD | Pending |
| ONBD-01 | TBD | Pending |
| ONBD-02 | TBD | Pending |
| ONBD-03 | TBD | Pending |
| ONBD-04 | TBD | Pending |

**Coverage:**
- v2.7 requirements: 22 total
- Mapped to phases: TBD
- Unmapped: 0

---

*Requirements defined: 2026-01-31*
*Last updated: 2026-01-31 after initial definition*
