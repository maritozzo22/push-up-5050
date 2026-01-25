# Requirements: Milestone v2.5 - Engagement & Retention

**Last Updated:** 2026-01-23
**Milestone:** v2.5
**Total Requirements:** 19

## Overview

Milestone v2.5 focuses on increasing user engagement and retention through personalized experiences, enhanced gamification, weekly goals, challenges, and smart notifications.

## Requirements by Category

### ONBOARDING (Personalized) - 4 requirements

**ONBD-01: User completes 4-screen onboarding flow**
- User completes activity level selection (beginner, intermediate, advanced)
- User completes capacity assessment (max push-ups in one set)
- User completes workout frequency preference (days per week)
- User completes daily goal target selection
- Flow is skippable with defaults (intermediate, 20 push-ups, 5 days/week, 50/day)

**ONBD-02: System calculates personalized recommendations**
- Starting series recommended based on capacity (1, 2, 5, or 10)
- Daily goal calculated from capacity and frequency
- Recovery time recommended based on activity level (beginner: 60s, intermediate: 45s, advanced: 30s)
- Recommendations shown to user for confirmation before saving

**ONBD-03: User can edit all recommendations in settings**
- Settings screen exposes starting series configuration
- Settings screen exposes daily goal target
- Settings screen exposes recovery time configuration
- All values editable with same UI patterns used in onboarding

**ONBD-04: Onboarding integrates with existing GoalsProvider persistence**
- Personalized recommendations saved via GoalsProvider
- Custom values from onboarding persist across app sessions
- Defaults used if onboarding skipped or not completed

### POINTS SYSTEM (Enhanced) - 5 requirements

**POINTS-01: Points calculated with new aggressive formula**
- Formula: Base × (RepMult + SeriesMult) × StreakMult
- Base = 10 points per series
- Total points awarded immediately upon series completion
- Formula applied consistently across all workout sessions

**POINTS-02: Rep multiplier = push-ups × 0.3**
- RepMult = push-ups in series × 0.3
- Example: Series 5 (5 push-ups) = 5 × 0.3 = 1.5
- Example: Series 10 (10 push-ups) = 10 × 0.3 = 3.0

**POINTS-03: Series multiplier = series × 0.8**
- SeriesMult = series number × 0.8
- Example: Series 5 = 5 × 0.8 = 4.0
- Example: Series 10 = 10 × 0.8 = 8.0

**POINTS-04: Points persisted to DailyRecord**
- DailyRecord.pointsEarned stores points for each day
- DailyRecord.multiplier stores the effective multiplier applied
- Points update immediately after each series completes

**POINTS-05: Total points persisted to UserStats**
- UserStats.totalPoints accumulates all daily points
- Total points displayed in statistics screen
- Total points used for level calculations

### WEEKLY GOALS - 5 requirements

**WEEKLY-01: Weekly target calculated as daily goal × 5**
- Weekly target = user's daily goal × 5 workout days
- Target updates when daily goal changes
- Target displayed in statistics screen

**WEEKLY-02: Sunday popup shows weekly progress percentage**
- Popup appears on first app launch on Sunday
- Shows percentage of weekly target completed
- Shows total push-ups this week vs weekly target
- User can dismiss popup with "Close" button

**WEEKLY-03: User receives bonus 500 points when weekly target reached**
- Bonus awarded when weekly push-ups >= weekly target
- Bonus points added to daily total for Sunday
- Achievement notification shows bonus points awarded

**WEEKLY-04: Popup offers goal increase options when target reached**
- If weekly target reached, popup shows three options:
  - "Maintain current goal" (no change)
  - "Increase by 10%" (daily goal × 1.1, rounded)
  - "Increase by 20%" (daily goal × 1.2, rounded)
- Selection updates GoalsProvider.dailyGoal immediately

**WEEKLY-05: Streak resets only if user completes 0 workouts in the week**
- Streak resets on Sunday ONLY if weekly push-ups = 0
- Any push-ups completed during week preserve streak
- Previous behavior (streak reset daily if goal not met) replaced

### CHALLENGES - 3 requirements

**CHAL-01: User can view weekly challenge**
- Challenge displayed in statistics screen
- Challenge format: "Complete X push-ups this week"
- Challenge target = daily goal × 7
- Progress bar shows current progress toward challenge
- Challenge resets every Sunday

**CHAL-02: User receives badge upon challenge completion**
- Badge notification shown when weekly challenge completed
- Badge displayed in achievements screen
- Badge name: "Weekly Challenge [date]"
- Challenge completion awards 200 bonus points

**CHAL-03: User has 1 streak freeze per month**
- Streak freeze prevents streak reset for one week
- User can activate streak freeze from settings or Sunday popup
- Streak freeze auto-activates if weekly push-ups > 0 but < goal
- Streak freeze counter resets on 1st of each month
- Visual indicator shows when streak freeze is active

### NOTIFICATIONS - 4 requirements

**NOTIF-01: User receives "streak at risk" notification after 2 missed days**
- Notification sent if no workout completed for 2 consecutive days
- Notification text: "Your streak is at risk! Complete a workout today to keep it going."
- Notification sent at user's preferred workout time (default 9:00 AM)

**NOTIF-02: User receives progress notification when close to daily goal**
- Notification sent when daily push-ups >= daily goal - 5
- Notification text: "Almost there! Just 5 more push-ups to reach your daily goal."
- Notification sent only once per day

**NOTIF-03: Notification time personalized to user's workout patterns**
- System tracks when user completes workouts
- Notification time set to median workout completion time
- Default to 9:00 AM if insufficient data
- User can manually set notification time in settings

**NOTIF-04: User receives new challenge notification on Sunday**
- Notification sent at 8:00 AM on Sunday
- Notification text: "New weekly challenge available! Check your progress."
- Opens statistics screen when tapped

### ANTI-CHEAT - 2 requirements

**ANTCHEAT-01: Daily push-up cap enforced based on user level and goal**
- Cap formula: daily goal × (1 + (level × 0.1))
- Level 1-5: cap = daily goal × 1.5
- Level 6-10: cap = daily goal × 2.0
- Level 11+: cap = daily goal × 2.5
- Push-ups beyond cap tracked but not counted toward totals

**ANTCHEAT-02: Points awarded only up to daily cap**
- Points calculation capped at daily push-up limit
- Excess push-ups logged separately (visible to user but not rewarded)
- User shown message: "Daily cap reached. Push-ups still tracked but not rewarded."

## Traceability

| Requirement | Phase | Status |
|-------------|-------|--------|
| ONBD-01 | 03.1 | Complete |
| ONBD-02 | 03.1 | Complete |
| ONBD-03 | 03.1 | Complete |
| ONBD-04 | 03.1 | Complete |
| POINTS-01 | 03.2 | Pending |
| POINTS-02 | 03.2 | Pending |
| POINTS-03 | 03.2 | Pending |
| POINTS-04 | 03.2 | Pending |
| POINTS-05 | 03.2 | Pending |
| ANTCHEAT-01 | 03.2 | Pending |
| ANTCHEAT-02 | 03.2 | Pending |
| WEEKLY-01 | 03.3 | Complete |
| WEEKLY-02 | 03.3 | Complete |
| WEEKLY-03 | 03.3 | Complete |
| WEEKLY-04 | 03.3 | Complete |
| WEEKLY-05 | 03.3 | Complete |
| CHAL-01 | 03.4 | Pending |
| CHAL-02 | 03.4 | Pending |
| CHAL-03 | 03.4 | Pending |
| NOTIF-01 | 03.5 | Pending |
| NOTIF-02 | 03.5 | Pending |
| NOTIF-03 | 03.5 | Pending |
| NOTIF-04 | 03.5 | Pending |

## Out of Scope (Deferred to Future Milestone)

- Social sharing (Instagram templates, shareable badges, challenge links)
- Monetization (Ads, shop themes)
- Premium features
- Multiplayer challenges
