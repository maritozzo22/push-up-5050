# STATE.md

**Project:** Push-Up 5050 - Engagement & Retention
**Last Updated:** 2026-01-25

## Project Reference

See: .planning/PROJECT.md (updated 2026-01-23)

**Core value:** Progressive push-up training app with gamification
**Current focus:** Phase 03.3 - Weekly Goals System

## Current Position

Phase: 3 of 5 (Milestone v2.5: Engagement & Retention)
Plan: 2 of 4 in current phase
Status: In progress
Last activity: 2026-01-25 — Completed 03.3-02 (Weekly Target Calculation)

Progress: ████████░░ 70%

## Performance Metrics

**Velocity:**
- Total plans completed: 9
- Average duration: ~12 min
- Total execution time: 1.92 hours

**By Phase:**

| Phase | Plans | Total | Avg/Plan |
|-------|-------|-------|----------|
| 03.1  | 3     | 3     | ~15 min  |
| 03.2  | 4     | 4     | ~15 min  |
| 03.3  | 2     | 4     | ~7 min   |

**Recent Trend:**
- Latest: 03.3-02 (weekly target calculation)
- Trend: Phase 03.3 progressing ahead of schedule

*Updated after each plan completion*

## Accumulated Context

### Decisions

Decisions are logged in PROJECT.md Key Decisions table.
Recent decisions affecting current work:

- **Milestone v2.5 Scope**: Focus on engagement/retention features (onboarding, points, weekly goals, challenges, notifications, anti-cheat)
- **Phase Structure**: 5 phases derived from 19 requirements across 6 categories
- **Dependencies**: Points system is foundational (Phase 03.2), must complete before weekly goals (03.3) and challenges (03.4)
- **Onboarding First**: Phase 03.1 prioritized because it affects first-launch user experience
- **Anti-Cheat with Points**: Combined into Phase 03.2 to ensure points system ships with protection from day one

**From 03.1-01:**
- **Preset Slider Values**: Used discrete values [5, 10, 20, 30, 40, 50] instead of free-form input for better onboarding UX
- **startingSeries Calculation**: Tiered thresholds based on maxCapacity (<=10:1, <=20:2, <=30:5, >30:10)
- **recoveryTime Calculation**: Based on activity level (sedentary:60s, lightlyActive:45s, active/veryActive:30s)
- **Graceful i18n Fallback**: Try/catch pattern prevents crashes during development when keys are missing

**From 03.1-02:**
- **Simple Counter for Frequency**: Used 1-7 counter instead of day toggle (M T W T F S S) for cleaner, more intuitive UX
- **Preset Daily Goal Values**: Limited to 7 discrete values [20, 30, 40, 50, 60, 75, 100] to guide users toward realistic goals
- **Progress Preview Calculation**: Shows months/years to reach 5050 based on selected daily goal

**From 03.1-03:**
- **PageView for Onboarding**: Single StatefulWidget with PageView used instead of separate screens - simpler state management
- **Dot Indicator Pattern**: 4 dots with AnimatedContainer for smooth transitions (active: 24px, inactive: 8px)
- **Settings Restart Button**: Reused existing "Restart Tutorial" button in settings to launch new onboarding for easy testing
- **Old Onboarding Removed**: Deleted onboarding_screen.dart to avoid confusion and ensure new flow is used

**From 03.3-01:**
- **Monday Week Boundaries**: Used DateTime.weekday (1=Mon, 7=Sun) for ISO week calculation - getWeekStart() returns Monday 00:00:00
- **Week Number Format**: "YYYY-WW" format (e.g., "2026-04") for unique storage keys across year boundaries
- **Separate Flags for Review vs Bonus**: Review popup status and bonus award status tracked independently - user may see review but not earn bonus
- **Weekly Streak Logic**: Any push-ups (>0) in a week preserves streak (less strict than daily 50+ requirement)
- **No intl Package**: Week calculation uses built-in DateTime APIs only (no external dependencies)

**From 03.3-02:**
- **5 Workout Days Per Week**: Weekly target = daily goal × 5 (not × 7) to allow for 2 rest days while maintaining progression
- **Auto-Calculated Default**: Weekly goal default uses getDailyGoal() * 5 so it stays synced when daily goal changes
- **Green Highlight on Completion**: Weekly progress text changes to green (#4CAF50) when target is achieved

### Pending Todos

5 todos captured from user feedback:

| Title | Area | File |
|-------|------|------|
| Remove duplicate Points section | ui | workout_execution_screen.dart |
| Add points animation on rep | ui | workout_execution_screen.dart |
| Points per rep (not per series) | core-logic | active_workout_provider.dart |
| Move Points to Home page | ui | home_screen.dart |
| Replace Week with Today Goal | ui | home_screen.dart |

### Blockers/Concerns

None.

## Session Continuity

Last session: 2026-01-25
Stopped at: Completed 03.3-02 (Weekly Target Calculation)
Resume file: None

## Onboarding Widget Status

| Screen | Widget | Status | Commit |
|--------|--------|--------|--------|
| 1 | ActivityLevelSelection | Complete | 72a10b7 |
| 2 | CapacitySlider | Complete | 2465e0a |
| 3 | FrequencySelector | Complete | 76b5bac |
| 4 | DailyGoalSlider | Complete | 1accf84 |

## Phase 03.1 Plans

| Plan | Name | Status |
|------|------|--------|
| 03.1-01 | Onboarding Data Model & Widgets (Screens 1-2) | Complete |
| 03.1-02 | Onboarding Widgets (Screens 3-4) | Complete |
| 03.1-03 | Main Onboarding Flow Integration | Complete |

## Phase 03.2 Plans

| Plan | Name | Status |
|------|------|--------|
| 03.2-01 | Aggressive Points Formula (Calculator) | Complete |
| 03.2-02 | DailyRecord Points Tracking Fields | Complete |
| 03.2-03 | Points Integration (Providers & UI) | Complete |
| 03.2-04 | Daily Cap Anti-Cheat System | Complete |

## Phase 03.3 Plans

| Plan | Name | Status |
|------|------|--------|
| 03.3-01 | Weekly State Tracking Infrastructure | Complete |
| 03.3-02 | Weekly Target Calculation | Complete |
| 03.3-03 | Weekly Goals Review Popup | Pending |
| 03.3-04 | Weekly Bonus Award System | Pending |
