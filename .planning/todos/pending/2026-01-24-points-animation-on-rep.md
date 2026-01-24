---
created: 2026-01-24T17:47
title: Add points animation when counting reps
area: ui
files:
  - push_up_5050/lib/screens/workout_execution/workout_execution_screen.dart
  - push_up_5050/lib/providers/active_workout_provider.dart
---

## Problem

There's no animation showing points increasing when the user counts a repetition. The points display should animate/live-update to give immediate feedback.

## Solution

Add an animated counter widget for points that:
- Animates when `sessionPoints` increases
- Uses a counting animation (similar to existing rep counter)
- Gives visual feedback on each rep
