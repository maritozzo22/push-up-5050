# Phase 04.1: Quick Fixes - PLAN

**Phase:** 04.1 - Quick Fixes
**Milestone:** v2.6 - Improvements & Polish
**Created:** 2026-01-29
**Status:** Ready for execution

## Phase Goal

Change the default recovery time from 30 to 10 seconds for new users. This is a simple configuration change that improves the user experience by making workouts more efficient.

## Success Criteria

1. New users see **10 seconds** as default recovery time in series selection
2. User can adjust recovery time between 5-120 seconds
3. User's configured recovery time persists across app restarts

## Current State Analysis

### What's Already Correct
- **`AppSettingsService._defaultRecoveryTime = 10`** (line 40) - Already set to 10 seconds ✓
- **Test**: `app_settings_service_test.dart` line 30 already expects 10 seconds ✓

### What Needs to Change
- **`SeriesSelectionScreen._restTime = 30`** (line 41) - Local default needs to change from 30 to 10
- **Tests**: Multiple tests expect 30 seconds as the default

## Implementation Plans

### Plan 04.1-01: Update Default Recovery Time to 10 Seconds

**Files to modify:**
- `push_up_5050/lib/screens/series_selection/series_selection_screen.dart` (line 41)
- `push_up_5050/test/screens/series_selection/series_selection_screen_test.dart` (multiple locations)

**Steps:**
1. Update `SeriesSelectionScreen._restTime` from 30 to 10
2. Update test assertions from 30 to 10:
   - Line 128: `'rest time default value is 30'` → `'rest time default value is 10'`
   - Line 129: `find.text('30')` → `find.text('10')`
   - Line 227: `find.text('30')` → `find.text('10')`
   - Line 267: `'Value should change from 30 to 31'` → `'Value should change from 10 to 11'`
   - Line 554-571: Update rest time persistence tests

**Acceptance Criteria:**
- New users see 10 seconds as default recovery time
- All tests pass after update
- No existing functionality broken

---

### Plan 04.1-02: Verify Recovery Time Configuration and Persistence

**Goal:** Ensure the recovery time system works correctly with the new default

**Tests to verify:**
1. `app_settings_service_test.dart` - Default recovery time is 10 seconds (already passes)
2. `series_selection_screen_test.dart` - Default value is now 10 seconds
3. Persistence still works (saved values persist across sessions)

**Manual verification (optional):**
- Install app on fresh device/emulator
- Navigate to Series Selection screen
- Verify recovery time shows "10" by default

**Acceptance Criteria:**
- Unit tests verify constant equals 10 seconds
- Widget tests verify UI shows "10" by default
- Existing saved values (30, 45, 60, etc.) still load correctly

---

## Dependencies

- **Depends on:** Phase 03.5 (Smart Notifications) - Completed ✓
- **Precedes:** Phase 04.2 (Goal-Based Logic)

## Risk Assessment

**Risk Level:** LOW

- Simple constant change
- Limited code impact
- No migration logic needed
- No UI changes required

## Notes

- **No migration needed:** Existing users keep their configured value
- **Silent change:** No notification or announcement to existing users
- **New installs only:** 10 seconds applies to new installations

## Execution Order

1. Execute Plan 04.1-01 (update default from 30 to 10)
2. Execute Plan 04.1-02 (verify tests and persistence)

---

*Phase: 04.1-quick-fixes*
*Plan created: 2026-01-29*
