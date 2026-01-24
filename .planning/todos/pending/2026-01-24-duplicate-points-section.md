---
created: 2026-01-24T17:47
title: Remove duplicate Points section in workout
area: ui
files:
  - push_up_5050/lib/screens/workout_execution/workout_execution_screen.dart
---

## Problem

The Points section is duplicated in the workout screen. There are two points displays when there should only be one showing "session points" in the main card.

## Solution

1. Identify the duplicate points display widget
2. Remove the redundant card/section
3. Keep only the main session points card
