# PROJECT.md

**Project Name:** Push-Up 5050 - Android Widgets
**Status:** Active Development
**Last Updated:** 2026-01-20

## Project Overview

Progressive push-up training mobile app with gamification elements. Users complete incremental push-up series (1, 2, 3, 4, 5...) with recovery intervals, tracking progress toward a goal of 50 push-ups/day within 30 consecutive days.

**Current Status**: Core Flutter app exists and functional. Adding Android home screen widgets.

**Target Platforms**: Android (production), Windows (development)

## What We're Building

### Core Features (Implemented)
- Progressive series counting with manual tap OR proximity sensor
- Real-time stats (reps, kcal: 0.45 per push-up)
- Recovery timer with color transitions (green → orange → red → flashing)
- 30-day calendar tracking
- Achievement system with points/levels
- Streak multipliers (1.0x → 2.0x based on consecutive days)

### New Feature: Android Home Screen Widgets (In Progress)

**3 Widget Types:**

1. **Widget 1 - Quick Stats**: Displays today's progress (push-ups completed / goal)
2. **Widget 2 - Calendar Preview**: Mini 30-day calendar showing workout history
3. **Widget 3 - Quick Start**: Large button to immediately start workout

**Widget Specifications:**
- Background: `#121212` (dark)
- Accent color: `#FF6B00` (orange)
- Border radius: `28px`
- All widgets open app on tap
- Update periodically to reflect latest data

## Technical Stack

- **Language**: Dart (>=3.0.0 <4.0.0)
- **Framework**: Flutter
- **State Management**: Provider (ChangeNotifier pattern)
- **Storage**: shared_preferences (local JSON persistence)
- **Widget Framework**: home_widget package for Android home screen widgets

## Development Approach

**Test-Driven Development (TDD)** is MANDATORY:
1. Write test FIRST (RED)
2. Implement code (GREEN)
3. Refactor if needed
4. Only proceed when tests pass

**Test Coverage Goal**: 70%+ overall

## Project Structure

```
lib/
├── core/               # Constants, theme, utilities
├── models/             # Data models
├── repositories/       # Storage service
├── screens/            # UI screens
├── widgets/            # Reusable widgets
├── services/           # Device services
└── android_widget/     # NEW: Android widget integration
```

## Team & Workflow

- **Developer**: Solo project with AI assistance (Claude Code)
- **Methodology**: GSD (Get Shit Done) with phase-based planning
- **Version Control**: Git (local)

## Milestones

### Milestone 1: Core App (COMPLETE)
- Progressive workout system
- Statistics tracking
- Achievement system
- Settings and preferences

### Milestone 2: Android Widgets (CURRENT)
- Widget 1: Quick Stats
- Widget 2: Calendar Preview
- Widget 3: Quick Start
- Widget data synchronization

## Success Criteria

- [ ] All 3 widgets display on Android home screen
- [ ] Widgets update in real-time as user completes workouts
- [ ] Tapping any widget opens the main app
- [ ] Widget UI matches design specifications (dark theme, orange accent)
- [ ] All tests pass (70%+ coverage)
- [ ] No performance degradation of main app

---

*Last updated: 2026-01-20*
