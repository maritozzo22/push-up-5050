# Phase 04.4: Android Adaptive Icon

**Goal**: Adaptive icon supports all launcher shapes

**Status**: In Progress

**Started**: 2026-01-30

---

## Overview

Android Adaptive Icons allow the app icon to display correctly across different device launcher shapes (round, square, teardrop, squircle, etc.). Android 8.0+ (API 26+) uses the Adaptive Icon system which separates the icon into two layers: background and foreground.

**Current State**: The app has a single square icon.png that doesn't use adaptive layers.

**Target State**: The app will use Android Adaptive Icon system with:
- Orange background (#FF6B00 - primary orange)
- Foreground layer with the app logo
- Generated icons for all densities (hdpi through xxxhdpi)

## Requirements Coverage

| Requirement | Plan | Status |
|-------------|------|--------|
| AND-01 | 04.4-01 | Pending |
| AND-02 | 04.4-03 | Pending |
| AND-03 | 04.4-01 | Pending |
| AND-04 | 04.4-02 | Pending |
| AND-05 | 04.4-02 | Pending |

## Success Criteria

1. App icon uses Android Adaptive Icon system (mipmap-anydpi-v26/ic_launcher.xml)
2. Icon displays correctly on all launcher shapes
3. Icon background uses primary orange (#FF6B00)
4. Icon foreground logo is clearly visible on all backgrounds
5. Adaptive icons generated for all densities

## Plans

### Plan 04.4-01: Configure pubspec.yaml for adaptive icons
**Wave**: 1
**Autonomous**: true
**Status**: Pending

Create foreground asset and update pubspec.yaml configuration for flutter_launcher_icons to generate adaptive icons with orange background.

### Plan 04.4-02: Generate adaptive icons
**Wave**: 2
**Autonomous**: true
**Status**: Pending

Run flutter_launcher_icons to generate adaptive icons for all densities.

### Plan 04.4-03: Verify adaptive icons on Android emulator
**Wave**: 3
**Autonomous**: false
**Status**: Pending

Build and verify adaptive icons display correctly on Android.

## Execution Order

```
Wave 1: 04.4-01 (pubspec.yaml configuration)
Wave 2: 04.4-02 (generate icons)
Wave 3: 04.4-03 (verification)
```

## Dependencies

- **Depends on**: Phase 04.3 ✅
- **Blocks**: Phase 04.5 (Notification Fix)

## Notes

- flutter_launcher_icons v0.13.1 is already in dev_dependencies
- Adaptive icons require separate foreground asset (transparent background)
- Current icon.png will be replaced as foreground asset
- Background color: #FF6B00 (AppColors.primaryOrange)
- Physical device testing recommended for full verification (various launcher shapes)
