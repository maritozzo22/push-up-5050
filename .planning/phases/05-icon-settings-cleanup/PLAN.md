# Phase 05: Icon & Settings Cleanup - Plan

**Status:** Ready for execution
**Planned:** 2026-01-31
**Plans:** 2 plans in 1 wave

## Overview

Restore original app branding by reverting to the original icon.png as the main launcher icon and remove the temporary "Test notifications" section from the Settings screen.

## Requirements Covered

- ICON-01: App uses original icon.png as main launcher icon
- ICON-02: Icon displays correctly on all Android launchers
- SETT-01: "Test notifications" section removed from Settings screen
- SETT-02: Settings screen layout remains consistent after removal

## Success Criteria

1. App launches with original icon.png as the launcher icon on all Android devices
2. Settings screen displays without "Test notifications" section
3. Settings layout remains visually consistent after section removal

## Plans

### Wave 1 (Can execute in parallel)

| Plan | Description | Type | Checkpoint |
|------|-------------|------|------------|
| 05-01 | Restore original icon.png as main launcher icon | Autonomous | Human verify |
| 05-02 | Remove "Test notifications" from Settings screen | Autonomous | None |

### Plan Details

**05-01: Restore original icon.png as main launcher icon**
- Remove adaptive icon configuration from `pubspec.yaml`
- Delete Android adaptive icon XML files in `mipmap-anydpi-v26/`
- Delete all `ic_launcher_foreground.png` files from mipmap directories
- Regenerate launcher icons with `flutter_launcher_icons`
- **Checkpoint**: Verify icon displays correctly on Android device

**05-02: Remove "Test notifications" from Settings screen**
- Remove the "Test Notifiche" section card (lines ~166-215)
- Remove the `_TestButtonTile` widget class definition (lines ~840-908)
- Verify layout consistency (spacing between cards)
- Run widget tests to ensure no regressions
- Fully autonomous (no checkpoint)

## Execution Order

1. Execute Wave 1 (both plans can run in parallel)
2. After 05-01 completes, user verifies icon on physical Android device
3. After both plans complete, phase is done

## Dependencies

- None - this phase has no dependencies on other v2.7 phases
- Depends on Phase 04.6 completion (already complete)

## Related Files

- `push_up_5050/pubspec.yaml` - Icon configuration
- `push_up_5050/assets/launcher/icon.png` - Original icon source
- `push_up_5050/android/app/src/main/res/mipmap-anydpi-v26/` - Adaptive icon XML (to be removed)
- `push_up_5050/lib/screens/settings/settings_screen.dart` - Settings UI

---

*Phase planned: 2026-01-31*
