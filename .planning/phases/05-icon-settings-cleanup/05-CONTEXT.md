# Phase 05: Icon & Settings Cleanup - Context

**Gathered:** 2026-01-31
**Status:** Ready for planning

## Phase Boundary

Restore original app icon (icon.png) as the main launcher icon and remove the "Test notifications" section from the Settings screen. This is a cleanup phase with clear, specific requirements from the user.

## Implementation Decisions

### Icon Restoration
- Use `push_up_5050/assets/launcher/icon.png` as the main launcher icon
- Remove adaptive icon configuration (foreground/background layers) that was added in v2.6
- Ensure icon displays correctly on all Android launchers

### Settings Cleanup
- Remove the "Test notifications" section from Settings screen
- Maintain visual consistency of the layout after removal
- No other settings sections should be affected

### Claude's Discretion
- Exact method for removing adaptive icon configuration (Android manifest vs flutter_launcher_icons)
- How to handle any icon-related configuration files

## Specific Ideas

- User explicitly requested to restore `@push_up_5050/assets/launcher/icon.png` as the icon
- The "Test notifications" section should be completely removed from Settings

## Deferred Ideas

None — discussion stayed within phase scope.

---

*Phase: 05-icon-settings-cleanup*
*Context gathered: 2026-01-31*
