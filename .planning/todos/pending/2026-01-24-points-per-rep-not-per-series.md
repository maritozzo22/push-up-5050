---
created: 2026-01-24T17:47
title: Calculate points per rep instead of per series
area: core-logic
files:
  - push_up_5050/lib/providers/active_workout_provider.dart
  - push_up_5050/lib/core/utils/calculator.dart
---

## Problem

Points are currently calculated and added at the END of each series (during recovery). They should be calculated and added ON EACH REPETITION to give immediate gratification and feedback.

## Solution

1. Move points calculation from `startRecovery()` to `countRep()`
2. Calculate incremental points per rep (divide series points by reps in series)
3. Update `_sessionPoints` immediately when `countRep()` is called
4. Each rep in series N should give: `calculateSeriesPoints() / N` points (approximate)
