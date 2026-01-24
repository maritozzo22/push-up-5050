---
created: 2026-01-24T17:47
title: Replace Week card with Today Goal card
area: ui
files:
  - push_up_5050/lib/screens/home/home_screen.dart
---

## Problem

The "Settimana" (Week) card exists in the home screen. It should be replaced with an "Oggi" (Today) card that shows today's pushups progress toward the daily goal.

## Solution

1. Remove the Week card from HomeScreen
2. Create a new "Oggi" (Today) card that shows:
   - "Obiettivo oggi X/Numero" format
   - X = current pushups today
   - Numero = daily goal from settings (e.g., 50)
3. Merge this with the existing Goal card if they overlap
4. Example: "Obiettivo oggi 25/50" showing progress
