# STATE.md

**Project:** Push-Up 5050 - Engagement & Retention
**Last Updated:** 2026-01-26

## Project Reference

See: .planning/PROJECT.md (updated 2026-01-23)

**Core value:** Progressive push-up training app with gamification
**Current focus:** Phase 03.4 - Challenges & Streak Freeze

## Current Position

Phase: 3 of 5 (Milestone v2.5: Engagement & Retention)
Plan: 5 of 5 in current phase (gap closure)
Status: Phase 03.4 complete
Last activity: 2026-01-26 — Completed 03.4-05 (Fix Bonus Points Display Refresh)

Progress: █████████░ 79% (16 of 19 plans complete)

## Performance Metrics

**Velocity:**
- Total plans completed: 16
- Average duration: ~13 min
- Total execution time: 3.22 hours

**By Phase:**

| Phase | Plans | Complete | Avg/Plan |
|-------|-------|----------|----------|
| 03.1  | 3     | 3        | ~15 min  |
| 03.2  | 4     | 4        | ~15 min  |
| 03.3  | 4     | 4        | ~8 min   |
| 03.4  | 5     | 5        | ~13 min  |

**Recent Trend:**
- Latest: 03.4-05 (Fix Bonus Points Display Refresh)
- Phase 03.4 complete, ready for next milestone phase

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

**From 03.3-03:**
- **WillPopScope for Mandatory Dialog**: Used WillPopScope(onWillPop: () async => false) to prevent Android back button dismissal
- **Split Adjustment Options**: When target reached, show maintain/+10%/+20%; when missed, show -10%/-20%/-30%
- **Weekly Bonus Formula**: 500 base points for reaching target + 0.5 per excess push-up, capped at 250 excess (max 750 total)
- **Months-to-Goal Simplified**: Uses 50 / dailyGoal formula (ignores current progress) for clear preview

**From 03.3-04:**
- **Sunday OR Target Reached Trigger**: Popup shows on Sunday (end of week) OR immediately when target reached (early celebration)
- **Dual Streak Display**: Both daily (Giorno) and weekly (Settimana) streak badges displayed on home screen
- **One-Time Check Flag**: _weeklyReviewChecked prevents duplicate popup checks per session
- **Bonus Award Timing**: Awarded immediately when popup shows for achieved targets, stored in today's record

**From 03.4-01:**
- **Fixed 200-Point Challenge Bonus**: Weekly challenge awards fixed 200 points (unlike variable weekly bonus 500-750)
- **Challenge Target Formula**: dailyGoal × 7 (harder than weekly goal which is × 5, requires hitting daily goal every day)
- **Separate Challenge Tracking**: Weekly challenge completion tracked independently from weekly bonus - users can earn both
- **Bonus to Today's Record**: Challenge bonus added to current day's DailyRecord.pointsEarned

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

Last session: 2026-01-26
Stopped at: Completed 03.4-05 (Fix Bonus Points Display Refresh)
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
| 03.3-03 | Weekly Goals Review Popup | Complete |
| 03.3-04 | Weekly Bonus Award System | Complete |

## Phase 03.4 Plans

| Plan | Name | Status |
|------|------|--------|
| 03.4-01 | Weekly Challenge Tracking Infrastructure | Complete |
| 03.4-02 | Weekly Challenge UI Integration | Complete |
| 03.4-03 | Streak Freeze System | Complete |
| 03.4-04 | Wire Streak Freeze Auto-Activation | Complete |
| 03.4-05 | Fix Bonus Points Display Refresh | Complete |

**From 03.4-02:**
- **Weekly Challenge Card UI**: Trophy icon (🏆), progress bar, completion badge, bonus text
- **Challenge Completion Check**: Runs once per session via `_hasCheckedCompletion` flag
- **AchievementPopup Overlay**: Displays in Stack, auto-dismisses after 4s, cleared from state after 4.5s via Timer
- **Localization Keys**: 5 new keys (weeklyChallenge, weeklyChallengeTarget, weeklyChallengeCompleted, weeklyChallengeProgress, weeklyChallengeBonus)

**From 03.4-03:**
- **Monthly Freeze Allowance**: 1 streak freeze per month, resets on 1st using YYYY-MM format comparison
- **Week-Based Activation**: Streak freeze protects the entire week (Mon-Sun) when active
- **Auto-Activation Conditions**: Only triggers when weeklyTotal > 0 (user worked out) AND weeklyTotal < weeklyGoal (missed goal)
- **Snowflake Visual Indicator**: Icons.ac_unit_rounded with blue color (0xFF64B5F6) when active, orange calendar icon when inactive
- **No Freeze for Inactive Users**: Users with weeklyTotal = 0 don't get auto-activation (must work out to deserve protection)

**From 03.4-04:**
- **Auto-Activation in initState**: StatisticsScreen calls _checkStreakFreezeAutoActivation() after loadStats() and challenge check
- **Silent Activation**: No user-facing notification; snowflake icon appears automatically when freeze activates
- **State Refresh on Activation**: loadStats() called after successful activation to show updated freeze state immediately

**From 03.4-05:**
- **setState() After loadStats()**: Added setState(() {}) after await stats.loadStats() to force immediate StatefulWidget rebuild
- **Immediate Points Refresh**: Consumer<UserStatsProvider> rebuilds with fresh totalPoints when challenge bonus is awarded
- **No App Restart Required**: Points display shows +200 bonus immediately when popup appears
