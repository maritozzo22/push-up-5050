# Phase 09: Proximity Sensor Fix

**Phase ID:** 09
**Status:** 📋 PLANNED (Not Started)
**Created:** 2026-02-03

## Goal

Fix proximity sensor functionality so it correctly counts push-ups, and relocate the sensor toggle from Settings to Workout Setup screen for better UX.

## Requirements

| ID | Requirement | Status |
|----|-------------|--------|
| SENS-01 | Proximity sensor correctly counts push-ups (farnear transition = 1 rep) | Pending |
| SENS-02 | Proximity sensor toggle appears in Workout Setup screen (not Settings) | Pending |
| SENS-03 | User can enable/disable proximity mode before workout starts | Pending |
| SENS-04 | Proximity sensor mode works with phone placed on ground | Pending |

## Success Criteria

1. Proximity sensor correctly counts push-ups (farnear = 1 rep)
2. Toggle appears in Workout Setup screen (not Settings)
3. User can enable/disable proximity mode before workout starts
4. Proximity sensor works reliably with phone placed on ground

## Dependencies

**Removed:** Originally depended on Phase 08 (deferred to v2.8)
**Current:** No dependencies - can execute independently

## Plans

| Plan | Description | Status |
|------|-------------|--------|
| 09-01-PLAN.md | Fix proximity sensor detection logic | Not started |
| 09-02-PLAN.md | Move proximity toggle from Settings to Workout Setup | Not started |
| 09-03-PLAN.md | Test proximity sensor with physical device | Not started |

## Execution Order

1. **09-01**: Fix detection logic first (core functionality)
2. **09-02**: Move toggle to better UX location
3. **09-03**: Test on physical device (verification)

## Testing Notes

**Physical device required** - proximity sensor cannot be tested on:
- Emulator (no sensor hardware)
- Web (different API)
- Windows (no sensor hardware)

**Testing requires:**
- Physical Android device with proximity sensor
- Phone placed on floor
- Actual push-up motion to verify counting

## Related Files

- `lib/services/proximity_sensor_service.dart` - Core sensor service
- `lib/screens/settings/settings_screen.dart` - Remove toggle from here
- `lib/screens/series_selection/series_selection_screen.dart` - Add toggle here
- `lib/main.dart` - Service initialization
- `lib/l10n/app_*.arb` - Localization keys

## Phase Completion

**When is this phase complete?**
- All 3 plans have SUMMARY.md files
- All 4 requirements verified as satisfied
- Physical device testing confirms sensor works

**Verification:** Create 09-VERIFICATION.md after all plans complete
