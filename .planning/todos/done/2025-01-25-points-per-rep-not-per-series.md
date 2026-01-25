---
created: 2025-01-25T12:00
title: Points per rep (not per series)
area: core-logic
files:
  - push_up_5050/lib/providers/active_workout_provider.dart
---

## Problem

Currently points are awarded per series completion. Users should earn points for each rep completed, making the progression more rewarding and granular.

## Solution

Update point calculation to award points incrementally per rep instead of lump sum at series end.
