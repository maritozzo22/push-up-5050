---
created: 2026-01-24T17:47
title: Move Points card from Statistics to Home page
area: ui
files:
  - push_up_5050/lib/screens/statistics/statistics_screen.dart
  - push_up_5050/lib/screens/home/home_screen.dart
---

## Problem

The "Punti" (Points) section is currently displayed in the Statistics screen. It should be on the HOME page instead, replacing the "Oggi X Pushup" card.

## Solution

1. Remove Points card from StatisticsScreen
2. Add Points card to HomeScreen in place of "Oggi X Pushup" card
3. Display `totalPoints` or `sessionPoints` (decide which is more relevant for home)
4. Ensure the design matches the existing home page style
