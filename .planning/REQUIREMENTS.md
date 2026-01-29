# Requirements: Push-Up 5050 v2.6

**Defined:** 2026-01-29
**Core Value:** Progressive push-up training app with gamification and engagement features

## v2.6 Requirements

Improvements & Polish milestone - fixing UX issues and platform-specific features.

### Workout Configuration

- [ ] **WRK-01**: Default recovery time is 10 seconds (changed from 30)
- [ ] **WRK-02**: User can still configure recovery time between 5-120 seconds
- [ ] **WRK-03**: User's configured recovery time persists across app restarts

### Goal-Based Logic

- [ ] **GOAL-01**: Workout auto-completes when daily goal is reached
- [ ] **GOAL-02**: Series progression stops at goal completion (e.g., goal 10 = series 1+2+3+4)
- [ ] **GOAL-03**: User cannot start new workout after completing daily goal
- [ ] **GOAL-04**: Goal completion resets at midnight (new day = new workout allowed)

### User Experience

- [ ] **UX-01**: Congratulations popup appears when daily goal is achieved
- [ ] **UX-02**: Popup displays message: "Complimenti! Hai completato il tuo obiettivo di oggi. Ci vediamo domani!"
- [ ] **UX-03**: Popup includes button to return to Home screen
- [ ] **UX-04**: Popup appears immediately when goal is reached OR when app opens after goal completion
- [ ] **UX-05**: Achievement popup is NOT shown for partial progress (only goal completion)

### Android Platform

- [ ] **AND-01**: App icon uses Android Adaptive Icon system
- [ ] **AND-02**: Adaptive icon supports all launcher shapes (round, square, teardrop, squircle, etc.)
- [ ] **AND-03**: Icon background uses primary orange (#FF6B00)
- [ ] **AND-04**: Icon foreground logo is clearly visible on all backgrounds
- [ ] **AND-05**: Adaptive icons generated for all densities (hdpi, xhdpi, xxhdpi, xxxhdpi)

### Notifications

- [ ] **NOTIF-01**: Daily reminder notification arrives at configured fixed time
- [ ] **NOTIF-02**: Notifications work correctly on Android 12+ (API 31+)
- [ ] **NOTIF-03**: App requests POST_NOTIFICATIONS permission on Android 13+
- [ ] **NOTIF-04**: App requests SCHEDULE_EXACT_ALARM permission for fixed-time reminders
- [ ] **NOTIF-05**: Notification service initializes correctly on app startup
- [ ] **NOTIF-06**: Graceful fallback when user denies notification permissions
- [ ] **NOTIF-07**: Notification tap opens app to correct screen

## v2.7+ Requirements

Deferred to future milestone.

### Android Enhancements
- **AND-101**: Widget verification on physical Android device
- **AND-102**: Notification testing and refinement based on real device feedback

## Out of Scope

| Feature | Reason |
|---------|--------|
| iOS adaptive icon | Android-first milestone, iOS can follow |
| Notification channels customization | Fixed-time reminder is the only notification needed for v2.6 |
| Goal override/continue | Core philosophy: daily goal is a hard limit |
| Editing series mid-workout | Adds complexity, not in scope |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| WRK-01 | Phase 04.1 | Pending |
| WRK-02 | Phase 04.1 | Pending |
| WRK-03 | Phase 04.1 | Pending |
| GOAL-01 | Phase 04.2 | Pending |
| GOAL-02 | Phase 04.2 | Pending |
| GOAL-03 | Phase 04.2 | Pending |
| GOAL-04 | Phase 04.2 | Pending |
| UX-01 | Phase 04.3 | Pending |
| UX-02 | Phase 04.3 | Pending |
| UX-03 | Phase 04.3 | Pending |
| UX-04 | Phase 04.3 | Pending |
| UX-05 | Phase 04.3 | Pending |
| AND-01 | Phase 04.4 | Pending |
| AND-02 | Phase 04.4 | Pending |
| AND-03 | Phase 04.4 | Pending |
| AND-04 | Phase 04.4 | Pending |
| AND-05 | Phase 04.4 | Pending |
| NOTIF-01 | Phase 04.5 | Pending |
| NOTIF-02 | Phase 04.5 | Pending |
| NOTIF-03 | Phase 04.5 | Pending |
| NOTIF-04 | Phase 04.5 | Pending |
| NOTIF-05 | Phase 04.5 | Pending |
| NOTIF-06 | Phase 04.5 | Pending |
| NOTIF-07 | Phase 04.5 | Pending |

**Coverage:**
- v2.6 requirements: 23 total
- Mapped to phases: 23
- Unmapped: 0 ✓

---

*Requirements defined: 2026-01-29*
*Last updated: 2026-01-29 after initial definition*
