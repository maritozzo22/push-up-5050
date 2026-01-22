# PRD: Push-Up 5050

## One-Liner
A progressive push-up training app with gamification, proximity sensor counting, and 30-day challenge goals to reach 50 push-ups per day.

## Description
Push-Up 5050 is a fitness application designed to guide users through progressive push-up training with automatic series increment, recovery intervals, and comprehensive progress tracking. The app features both manual and proximity sensor-based counting, real-time statistics (kcal, reps, series), achievement system with points/levels, and a 30-day calendar to track progress toward the goal of 50 push-ups per day. The app uses a high-contrast orange/black theme for motivation and visibility during workouts.

## Type
- [x] Fitness/Training App
- [ ] Game
- [ ] Productivity App
- [ ] Utility App

## Target Audience
**Primary**: Fitness enthusiasts looking for structured progressive training
**Secondary**: Beginners wanting a guided push-up program with clear goals
**Problem Solved**: Provides structured progression, eliminates guesswork about reps/sets, motivates through gamification, tracks progress visually

---

## Platforms & Technical Requirements

### Development Platform
- **Primary**: Windows (for development and testing)
- **Testing**: Android preview on Windows for rapid iteration

### Production Platforms
- [x] Android
- [x] iOS
- [ ] Web

### Technical Stack
- **Framework**: Flutter 3.x+
- **Language**: Dart 3.x+
- **State Management**: Provider 6.x+
- **Storage**: shared_preferences (local only, no cloud sync in v1.0)

### Requirements
- [x] Offline support (local storage only)
- [x] Multi-language (Italian initially, extensible)
- [x] Persistent storage (workout sessions, stats, achievements)
- [ ] Network connectivity (not required for v1.0)
- [x] Device features:
  - Proximity sensor (with manual fallback)
  - Vibration/haptic feedback
  - Local notifications
  - Sound effects

---

## Core Features

### Features (Must-Have)

### Feature 1: Progressive Workout System
**Description**: Automatic series progression starting from user-defined point (1st, 2nd, 5th, or 10th series). Each series requires progressively more push-ups (1, 2, 3, 4, 5, 6...) with customizable recovery intervals between series (default 10 seconds).
**Priority**: Must-Have
**User Value**: Eliminates workout planning, ensures progressive overload, adapts to user fitness level

**Technical Details**:
- Series progression: Series N = N push-ups (e.g., Series 3 = 3 push-ups)
- Starting options: 1, 2, 5, or 10 (configurable before workout)
- Recovery timer: 10 seconds default, adjustable before workout (5-60 seconds range)
- Countdown decrements from target → 0 (e.g., "5" → "4" → "3" → "2" → "1" → "0")
- At 0: Recovery timer starts, then next series begins
- Visual feedback: Circle with radial gradient, scale animation on tap

### Feature 2: Dual Counting System
**Description**: Users can count push-ups via manual button press OR proximity sensor (phone near chest during push-up). Both methods update the same counter in real-time.
**Priority**: Must-Have
**User Value**: Flexibility in counting method, hands-free option for proper form, accessibility

**Technical Details**:
- **Manual Mode**: Tap large central circle to count each push-up
- **Sensor Mode**: Proximity sensor detects approach (≤5cm) → auto-count
- **Fallback**: Manual button always available even if sensor enabled
- **Visual Feedback**:
  - Circle scales up 10% on tap/sensor trigger
  - Orange flash overlay (rgba(255, 140, 0, 0.5))
  - Subtle bounce animation on statistics badges
- **Haptic Feedback**: Light vibration on each count (manual or sensor)
- **Error Handling**: If sensor unavailable, show toast notification, default to manual

### Feature 3: Real-Time Statistics Display
**Description**: During workout, display series completed, total reps, and kcal burned. Updates in real-time with each counted push-up.
**Priority**: Must-Have
**User Value**: Immediate feedback, motivation, track progress during session

**Technical Details**:
- **Metrics Displayed**:
  - "Rep Totali: X" (Total reps in current session)
  - "Kcal Bruciate: Y" (Calories burned: 0.45 kcal per push-up)
  - "Serie X di Y" (Current series of target series)
  - "Livello Attuale: [Beginner/Intermediate/Advanced]" (Level based on total push-ups)
- **Calculation**:
  - Kcal = Total Reps × 0.45 (constant, no weight configuration)
  - Level thresholds: <100 = Beginner, 100-500 = Intermediate, >500 = Advanced
- **Update Frequency**: Real-time (instant on each count)
- **UI Position**: Top bar badges (reps, kcal), bottom badge (level)

### Feature 4: Recovery Timer with Visual States
**Description**: After completing a series, start recovery timer with color-coded visual states indicating remaining recovery time. No skip button allowed.
**Priority**: Must-Have
**User Value**: Ensures proper rest between sets, visual urgency indicator, prevents premature next set

**Technical Details**:
- **Duration**: User-configurable before workout (default 10s, range 5-60s)
- **Color States**:
  - Green (`#4CAF50`): Full recovery (100% → 66% remaining)
  - Orange (`#FF9800`): Warning (66% → 33% remaining)
  - Red (`#F44336`): Critical (33% → 0% remaining)
  - Flashing (`#F44336`): Urgent (last 5 seconds, 500ms on/off animation)
- **Visual Implementation**:
  - Progress bar below countdown circle (12px height, 6px radius)
  - Fill color transitions smoothly (1-second linear interpolation)
  - Percentage label shows "XX%" remaining
  - Circle countdown hidden during recovery, replaced by timer
- **Constraints**: No skip button, user must wait for full recovery
- **Sound**: Beep at 0 seconds (transition to next series)

### Feature 5: Session Persistence
**Description**: If user closes app mid-workout, session remains active and resumes on reopen. Session only ends when user explicitly clicks "Termina" (End) button.
**Priority**: Must-Have
**User Value**: Prevents data loss, accommodates interruptions (calls, texts), flexible workout timing

**Technical Details**:
- **Persistence**: Save session state to local storage on each update:
  - Current series number
  - Reps completed in current series
  - Total reps in session
  - Recovery time setting
  - Session start timestamp
- **Resumption**: On app launch, check for active session:
  - If active and <24 hours old: Auto-resume
  - If active and >24 hours old: Mark as abandoned, offer to start new
- **End Session**: Only via "Termina" button:
  - Save final stats to daily record
  - Check for achievement unlocks
  - Update streak (if daily goal met)
  - Clear active session flag

### Feature 6: 30-Day Goal Tracking System
**Description**: Track progress toward 50 push-ups per day goal within 30 consecutive days. Calendar view shows completed days with push-up counts.
**Priority**: Must-Have
**User Value**: Clear goal visualization, streak motivation, accountability

**Technical Details**:
- **Goal**: 50 push-ups per day (not per session, cumulative across all sessions)
- **Streak System**: Consecutive days with ≥50 push-ups
- **Calendar Display**:
  - Grid: 5 columns × 6 rows (30 days)
  - Completed days: Orange circles with checkmark + rep count
  - Today: Orange border + "OGGI: XX PUSHUP" label
  - Future days: Gray circles with target reps (progressive)
  - Missed days: Gray circles with "X" mark
- **Progress Circle**: Shows total push-ups vs. 5050 goal (1250/5050 = 25%)
- **Motivational Text**: "Mantieni il ritmo per raggiungere 5050!" (Keep the rhythm to reach 5050!)

### Feature 7: Gamification System
**Description**: Points, levels, achievements, and streak multipliers to motivate continued usage and goal completion.
**Priority**: Must-Have
**User Value**: Increased engagement, clear progression system, social comparison potential

**Technical Details**:

**Points Calculation**:
```
Base Points = (Series Completed × 10) + (Total Push-ups × 1) + (Consecutive Days × 50)
Multipliers:
- 1-3 day streak: ×1.0
- 4-7 day streak: ×1.2
- 8-14 day streak: ×1.5
- 15-30 day streak: ×2.0
Final Points = Base Points × Multiplier
```

**Level System**:
- Level 1 (Beginner): 0-999 points
- Level 2 (Intermediate): 1,000-4,999 points
- Level 3 (Advanced): 5,000-9,999 points
- Level 4 (Expert): 10,000-24,999 points
- Level 5 (Master): 25,000+ points

**Achievements** (unlocked when conditions met):
1. "Primo Passo" (First Step): Complete 1st series
2. "Dieci in Un Row" (Ten in a Row): Complete 10 push-ups in one session
3. "Centenario" (Centenary): Complete 100 total push-ups
4. "Settimana Perfetta" (Perfect Week): 7-day streak
10. "Maratona" (Marathon): Complete 500 push-ups in one day
11. "Mese da Leoni" (Lion Month): Complete all 30 days

**Achievement Popup**:
- Non-intrusive notification from top/bottom
- Auto-dismiss after 3-4 seconds
- Shows: Achievement name + icon + congratulatory text
- Sound effect: Characteristic "achievement unlock" chime
- Visual: Orange border, semi-transparent background, slide-in animation

### Feature 8: Local Notifications for Streak Retention
**Description**: If user hasn't completed daily goal by 9 PM, send notification reminding them to workout to maintain streak and multiplier.
**Priority**: Must-Have
**User Value**: Prevents streak loss, increases daily engagement, habit formation

**Technical Details**:
- **Schedule**: Check at 9 PM daily
- **Trigger Condition**: If today's push-ups < 50
- **Notification Content**:
  - Title: "Non perdere la tua serie!" (Don't lose your streak!)
  - Body: "Completa i tuoi push-up oggi per mantenere il moltiplicatore. Ti mancano solo XX push-up!"
  - Action: "START" button (opens app to Series Selection screen)
- **Repeat**: If dismissed, resend once at 10 PM (final reminder)
- **Cancel**: Auto-cancel if daily goal reached

### Feature 9: Settings & Preferences
**Description**: Configure app behavior including proximity sensor toggle, recovery time defaults, sound/vibration preferences.
**Priority**: Must-Have
**User Value**: Personalization, accessibility, control over app behavior

**Technical Details**:
- **Proximity Sensor**:
  - Toggle: Enable/disable sensor counting
  - Fallback: Manual button always available
  - Status indicator: Shows if sensor available on device
- **Recovery Time**:
  - Default: 10 seconds
  - Range: 5-60 seconds
  - Applied per workout (can change before each session)
- **Sound Preferences**:
  - Countdown beep: On/Off (sound at 0s recovery)
  - Achievement sound: On/Off
  - Volume slider (if sounds enabled)
- **Haptic Feedback**:
  - Push-up count: Light/Medium/Off
  - Button press: Light/Off
- **Notifications**:
  - Daily reminder: On/Off
  - Reminder time: Default 9 PM, adjustable (6 PM - 11 PM)

---

## Features (Nice-to-Have)

### Feature 10: Statistics Dashboard with Charts
**Description**: Visual charts showing progress over time: push-ups per day, kcal per week, streak length, personal records.
**Priority**: Nice-to-Have (Future v2.0)
**User Value**: Deeper insights, trend analysis, motivation through visualization

**Technical Details**:
- Line chart: Push-ups per day (last 30 days)
- Bar chart: Kcal per week
- Pie chart: Distribution of workout times (morning/afternoon/evening)
- Personal records: Best day, longest streak, max push-ups in one session

### Feature 11: Social Sharing
**Description**: Share achievements, streaks, milestones to social media or with friends.
**Priority**: Nice-to-Have (Future v2.0)
**User Value**: Social accountability, motivation through sharing

### Feature 12: Custom Workout Programs
**Description**: Create custom progressive programs beyond the default 1-2-3-4-5 pattern.
**Priority**: Nice-to-Have (Future v2.0)

---

## User Journey

**Flow: App Launch → Start Workout → Complete Series → View Stats → Track Progress**

### 1. **App Launch**
   - User opens app
   - Sees: Home Screen with logo "PUSHUP 5050", quick stats badges, large orange "INIZIA" (Start) button
   - Navigation: Bottom nav bar (Home, Stats, Profile)
   - Can: Tap "INIZIA" button, view Stats, access Settings

### 2. **Workout Setup**
   - User taps "INIZIA" button
   - Navigates to: Series Selection Screen
   - Sees: Two cards (Starting Series, Rest Time) with plus/minus buttons, large "INIZIA ALLENAMENTO" button
   - Actions:
     - Tap minus/plus to adjust Starting Series (default 1, options 1/2/5/10)
     - Tap minus/plus to adjust Rest Time (default 10s, range 5-60s)
     - Tap "INIZIA ALLENAMENTO" to confirm

### 3. **Workout Execution**
   - User confirms settings
   - Navigates to: Workout Execution Screen
   - Sees:
     - Title: "Allenamento in Corso" (Workout in Progress)
     - Top badges: "Rep Totali: 0", "Kcal Bruciate: 0"
     - Center: Large orange circle with countdown "1" (or chosen starting series)
     - Bottom: "Livello Attuale: Beginner" badge
     - Bottom corners: "PAUSA" (Pause), "TERMINA" (End) buttons
   - Actions:
     - Tap circle OR bring phone close to chest (if sensor enabled) → countdown decrements
     - Each tap: Circle animates (scale + flash), stats badges update
     - When countdown reaches "0" → Recovery timer starts (green bar)
     - Timer transitions colors: Green → Orange → Red → Flashing
     - At 0s: Beep sounds, next series begins, countdown shows "2" (or next number)
     - Continue indefinitely until user clicks "TERMINA"
     - Can tap "PAUSA" to pause (freeze timer), tap again to resume

### 4. **Session Complete**
   - User taps "TERMINA" (End)
   - Sees: Summary modal:
     - "Allenamento Completato!" (Workout Complete!)
     - Series completed: X
     - Total push-ups: Y
     - Kcal burned: Z
     - Achievement unlocked: [Name] (if any)
     - Buttons: "SALVA E TORNA A HOME" (Save & Return Home)
   - Actions:
     - Tap "SALVA" → Stats saved to daily record, navigate to Home
     - Achievement popup appears (if unlocked) from top, auto-dismisses after 3-4s

### 5. **View Statistics**
   - User taps "Stats" in bottom nav
   - Navigates to: Statistics Screen
   - Sees:
     - Top: Large progress circle "1250 / 5050" (25%)
     - Middle: Calendar grid (30 days) with completed days (orange checks), today (border), future (gray)
     - Title: "Giorno 14 di 30" (Day 14 of 30)
     - Bottom: "Mantieni il ritmo per raggiungere 5050!" motivational text
   - Can: Tap calendar days to view details for that day, scroll to view future days

### 6. **Daily Reminder**
   - 9 PM arrives, user hasn't completed 50 push-ups today
   - Notification appears: "Non perdere la tua serie! Completa i tuoi push-up oggi per mantenere il moltiplicatore. Ti mancano solo XX push-up!"
   - User can: Tap notification → App opens to Series Selection screen

### 7. **App Closed Mid-Workout**
   - User receives call/text during workout, closes app
   - Session state saved: Current series, reps, stats
   - User reopens app → Workout resumes automatically from same state
   - User continues workout, taps "TERMINA" when done

---

## Screens

### Screen 1: Home Screen (HomeScreen)
**Purpose**: Entry point, quick stats overview, start workout
**Elements**:
- [x] Logo/Title: "PUSHUP 5050" - Centered, 32px, Montserrat Bold, White (`#FFFFFF`)
- [x] Quick Stats Badges: Below title, show today's progress
  - "Push-up Oggi: 0 / 50" (Today's Push-ups)
  - "Serie Attuale: 0" (Current Streak)
- [x] START Button: Large, full width minus 32px margins, orange (`#FF6B00`), 20px bold white text "INIZIA"
- [x] Bottom Navigation: 3 tabs (Home, Stats, Profile)
- [x] Background: Deep charcoal (`#1A1A1A`)

**Navigation**:
- From: App launch
- To: Series Selection Screen (on START tap), Stats Screen (on Stats tap)

**Responsive**:
- Windows: Centered layout, max width 600px
- Mobile: Full width, bottom nav always visible

### Screen 2: Series Selection Screen (SeriesSelectionScreen)
**Purpose**: Configure workout parameters before starting
**Elements**:
- [x] Title: "PUSHUP 5050" - Same as Home
- [x] Card 1: "Serie di Partenza" (Starting Series)
  - Label: White 18px
  - Plus/minus buttons: Circular orange, white icons
  - Center value: Large number (1, 2, 5, or 10)
  - Hint text: "Progressive Series (e.g., Series 3 = 3 pushups)"
- [x] Card 2: "Tempo di Recupero (secondi)" (Rest Time)
  - Label: White 18px
  - Plus/minus buttons: Same style
  - Center value: Number (default 10)
  - Hint text: "Base 10s, increases with series"
- [x] BEGIN WORKOUT Button: Full width, orange, 20px bold white "INIZIA ALLENAMENTO"
- [x] Card style: Background `#2A2A2A`, orange border 1px, radius 12px, shadow blurRadius 4
- [x] Spacing: 20px vertical between cards/button

**Navigation**:
- From: Home Screen (START tap)
- To: Workout Execution Screen (on BEGIN WORKOUT tap), back to Home (back button)

**Responsive**:
- Windows: Cards centered, max width 400px each
- Mobile: Full width cards, vertical stack

### Screen 3: Workout Execution Screen (WorkoutScreen) ⭐ MOST CRITICAL
**Purpose**: Main workout interface with counting, timer, stats
**Elements**:
- [x] Title: "Allenamento in Corso" - Top-center, 40px, Montserrat Bold, White, 30px from top
- [x] Statistics Badges (top bar):
  - Left: "Rep Totali: 23" - Orange circle icon (12px) + white text (18px)
  - Right: "Kcal Bruciate: 6" - Orange circle icon (12px) + white text (18px)
  - Rounded rectangles: 20px radius, 12px padding
  - Spacing: 20px between badges
- [x] Central Countdown Circle:
  - Perfect circle, 280px diameter (~60% screen vertical)
  - Radial gradient: `#FF8C00` center → `#FF4500` edges
  - Outer glow: 2px `rgba(255, 140, 0, 0.3)`
  - Shadow: 8px `rgba(0, 0, 0, 0.4)`
  - Countdown number: 120px, Montserrat Bold, White
  - Subtitle: "Tocca per Contare" (Touch to Count) - 24px, Montserrat Regular, White, 20px below number
  - Interactivity: Scale 1.1 on tap, orange flash `rgba(255, 140, 0, 0.5)`
- [x] Recovery Timer Bar (below circle, shown during recovery):
  - Horizontal bar: 12px height, 6px radius
  - Background: `#333333` (dark gray)
  - Fill: `#FF8C00` (orange), dynamic updates
  - States: Green `#4CAF50` → Orange `#FF9800` → Red `#F44336` → Flashing (500ms)
  - Percentage label: Right-aligned, 16px white "60%"
  - Series label: Left of bar, 16px white "Serie 3 di 5"
- [x] Level Badge (bottom):
  - Rounded rectangle: 20px radius, 12px padding
  - Width: 80% screen, centered
  - Lightning bolt icon: Orange, 24px
  - Text: "Livello Attuale: Intermediate" - 18px white
- [x] Control Buttons:
  - Pause (bottom-left): 80×40px, orange `#FF6B00`, "PAUSA" 16px white, radius 12px
  - End (bottom-right): 80×40px, bright orange `#FF5722`, "TERMINA" 16px white, radius 12px
  - Animation: Scale 0.95 on press (5%)
- [x] Haptic feedback: Light vibration on circle tap/sensor trigger
- [x] Sound: Beep at recovery timer 0s

**Navigation**:
- From: Series Selection Screen
- To: Home Screen (on TERMINA tap), can pause/resume

**Responsive**:
- Windows: Circle slightly larger (320px), buttons wider (120px)
- Mobile: Circle 280px, responsive button sizes

### Screen 4: Statistics Screen (StatisticsScreen)
**Purpose**: View progress, calendar, achievements
**Elements**:
- [x] Progress Circle (top):
  - 180px diameter
  - Orange stroke, 15px width, rounded cap
  - Center text:
    - "1250 / 5050" - 24px bold white
    - "PUSHUP TOTALI" - 14px white 70% opacity
    - "25%" - 18px orange bold
- [x] Calendar Grid (middle):
  - Title: "Giorno 14 di 30" - 18px white, 500 weight
  - Grid: 5 columns × 6 rows (30 days)
  - Completed days: Orange circles (`#FF6B00`) with checkmark icon + rep count
  - Today: Orange border 2px + "OGGI: 100 PUSHUP" label
  - Future days: Gray circles `#2A2A2A` with target rep counts
  - Spacing: 10px between cells
- [x] Motivational Text: "Mantieni il ritmo per raggiungere 5050!" - 16px white centered
- [x] Bottom Navigation: Home, Stats (active), Profile

**Navigation**:
- From: Bottom nav Stats tap
- To: Other screens via bottom nav

**Responsive**:
- Windows: Calendar grid larger cells, max width 600px
- Mobile: 5-column grid, scrollable if needed

### Screen 5: Settings Screen (SettingsScreen)
**Purpose**: Configure app preferences
**Elements**:
- [x] Title: "Impostazioni" (Settings) - 32px bold white
- [x] Proximity Sensor Toggle:
  - Label: "Sensore di Prossimità" - 18px white
  - Toggle switch: On/Off
  - Status text: "Disponibile" / "Non disponibile"
- [x] Recovery Time Slider:
  - Label: "Tempo di Recupero Predefinito" - 18px white
  - Slider: 5-60 seconds, current value displayed
- [x] Sound Toggles:
  - "Suono Countdown" - On/Off
  - "Suono Achievement" - On/Off
  - Volume slider (if enabled)
- [x] Haptic Feedback:
  - "Feedback Aptico" - Light/Medium/Off dropdown
- [x] Notifications:
  - "Promemoria Giornaliero" - On/Off
  - "Orario Promemoria" - Time picker (default 9 PM)
- [x] Save Button: "Salva Impostazioni"

**Navigation**:
- From: Profile tab in bottom nav
- To: Back to previous screen

### Screen 6: Achievement Popup (AchievementPopupWidget)
**Purpose**: Non-intrusive notification when achievement unlocked
**Elements**:
- [x] Container: Semi-transparent overlay, slide-in from top (or bottom)
- [x] Card: Orange border 2px, rounded corners 16px, background `#1A1A1A` 90% opacity
- [x] Content:
  - Icon: Trophy/star (orange, 48px)
  - Title: Achievement name - 20px bold white
  - Description: Congratulatory text - 16px white
  - Subtitle: "+XX punti" (points earned) - 14px orange
- [x] Auto-dismiss: 3-4 seconds, slide-out animation
- [x] Sound: Characteristic "achievement unlock" chime
- [x] Position: Top 20px (or bottom 100px above nav), not blocking main content

**Navigation**:
- Trigger: Automatically on achievement unlock
- Dismiss: Auto after 3-4s OR tap to dismiss

---

## Design & Styling

### Color Scheme
**Primary Colors**:
- Background: Deep charcoal `#1A1A1A` / `#1E1E1E`
- Primary Accent: Vibrant orange `#FF5722` / `#FF6B00` / `#FF8C00`
- Secondary Accent: Deep orange-red `#FF4500`
- Success Green: `#4CAF50` (recovery timer full)
- Warning Orange: `#FF9800` (recovery timer warning)
- Critical Red: `#F44336` (recovery timer critical)
- Text Primary: White `#FFFFFF`
- Text Secondary: Light gray `#CCCCCC` / 70% opacity white

**Semantic Usage**:
- Orange: Interactive elements (buttons, active states, achievements)
- Green: Full recovery, success states, completed calendar days
- Red: Critical recovery time, errors, missed days
- Gray: Inactive elements, future calendar days, disabled states
- White: All primary text, icons on dark backgrounds

### Typography
**Font Family**: Montserrat (Google Fonts)
- Bold: Used for titles, important numbers, emphasis
- Regular: Used for body text, labels, descriptions
- Medium: Used for secondary headings

**Font Sizes**:
- Logo/Title: 32px
- Workout Screen Countdown: 120px (largest element)
- Statistics/Labels: 18px
- Body Text: 16px
- Small Labels/Hints: 14px
- Achievement Title: 20px
- Achievement Description: 16px

**Text Styles**:
- Primary headings: Montserrat Bold, White, 32-40px
- Secondary headings: Montserrat Bold, White, 18-24px
- Body text: Montserrat Regular, White, 16px
- Hints/subtitles: Montserrat Regular, White 70% opacity, 14px

### Visual Style
- [x] High contrast (dark theme with orange accents)
- [x] Minimal/Clean (uncluttered layouts, focused on primary actions)
- [ ] Playful (moderate playfulness through animations, not cartoonish)
- [x] Professional (fitness app aesthetic, bold colors)
- [x] Dark mode (default and only theme in v1.0)
- [ ] Light mode (not in v1.0, consider for v2.0)

**Design Patterns**:
- Rounded corners: 12-20px radius (cards, buttons)
- Circular elements: Progress circles, countdown circle, calendar days
- Gradient fills: Radial gradient on countdown circle (center → edge)
- Shadows: Soft shadows for elevation (4-8px blur)
- Animations: Scale, fade, slide (smooth, 300ms duration)

**Inspirations**: Nike Training Club, Keep, Fitbit (dark mode, orange accent, clean fitness aesthetic)

---

## App Logic

### Data Flow

**Workout Session Flow**:
1. User selects Starting Series (e.g., 1) and Rest Time (e.g., 10s) → Tap "INIZIA ALLENAMENTO"
2. App creates WorkoutSession object:
   ```dart
   WorkoutSession {
     startingSeries: 1,
     currentSeries: 1,
     repsInCurrentSeries: 0,
     totalReps: 0,
     restTime: 10,
     startTime: DateTime.now(),
     isPaused: false,
     isActive: true
   }
   ```
3. App navigates to WorkoutScreen, displays countdown "1"
4. User taps circle OR sensor triggers → repsInCurrentSeries++ (1)
5. App updates UI: Countdown shows "0" (1 - 1 = 0)
6. App detects series complete → Starts recovery timer (10s)
7. Recovery timer counts down with color transitions
8. At 0s → Beep sounds, currentSeries++ (2), repsInCurrentSeries resets to 0
9. App displays countdown "2" (next series target)
10. Repeat steps 4-9 indefinitely
11. User taps "TERMINA" → App saves session to daily record, updates stats

**Statistics Update Flow**:
1. Each push-up counted:
   - totalReps++ (in session)
   - Calculate kcal: totalReps × 0.45
   - Update UI badges in real-time
2. Session ended:
   - Save to DailyRecord:
     ```dart
     DailyRecord {
       date: DateTime.now(),
       totalPushups: session.totalReps,
       totalKcal: session.totalReps * 0.45,
       seriesCompleted: session.currentSeries - 1
     }
     ```
   - Update UserStats:
     ```dart
     UserStats {
       totalPushupsAllTime: previous + session.totalReps,
       currentStreak: calculateStreak(),
       bestDay: max(bestDay, session.totalReps),
       level: calculateLevel(totalPushupsAllTime)
     }
     ```
   - Check achievements → Unlock if conditions met → Show popup
   - Check daily goal (50 push-ups) → Update streak if met

**Achievement Unlock Flow**:
1. Condition triggered (e.g., totalPushups reaches 100)
2. App checks AchievementUnlockStatus:
   ```dart
   if (!achievement.isUnlocked && conditionMet) {
     achievement.isUnlocked = true;
     achievement.unlockedAt = DateTime.now();
     showAchievementPopup(achievement);
     playAchievementSound();
     addPoints(achievement.points);
   }
   ```
3. Popup slides in from top (3-4s duration)
4. Popup auto-dismisses OR user taps to dismiss
5. Achievement saved to storage (persistent)

### State Management

**Global State** (Provider):
- `UserStats`: Total push-ups, current streak, level, points
- `DailyRecords`: Map<DateTime, DailyRecord> (30-day calendar)
- `Achievements`: List<Achievement> with unlock status
- `ActiveWorkoutSession`: WorkoutSession? (null if no active session)
- `Settings`: Proximity sensor enabled, recovery time, sound preferences

**Local State** (StatefulWidget):
- `WorkoutScreen`: Current countdown, recovery timer, isPaused
- `SeriesSelectionScreen`: Selected starting series, rest time
- `StatisticsScreen`: Selected calendar day for details

**Persistence**:
- Save on every significant change:
  - Workout session updates (each push-up, series complete)
  - Session end (final stats)
  - Achievement unlock
  - Settings change
- Load on app launch:
  - User stats
  - Daily records (last 30 days)
  - Achievements
  - Settings
  - Active session (if exists)

### Business Rules

**Series Progression**:
- Series N always requires N push-ups (no variation)
- Progression is infinite (no max series)
- User can start at series 1, 2, 5, or 10
- Recovery timer always same duration (no progressive increase)

**Counting Logic**:
- Manual tap OR sensor trigger → +1 rep
- Cannot decrement reps (no undo button)
- If series interrupted (user ends mid-series), count all completed reps

**Streak Calculation**:
- Streak = consecutive days with ≥50 push-ups
- If day missed (0 push-ups or <50), streak resets to 0
- Streak multiplier applies to all points earned during streak

**Points System**:
```
Base Points = (Series Completed × 10) + (Total Push-ups × 1) + (Consecutive Days × 50)
Multiplier = based on current streak (1.0, 1.2, 1.5, or 2.0)
Final Points = Base Points × Multiplier
```

**Level Thresholds**:
- Level 1 (Beginner): 0-999 points
- Level 2 (Intermediate): 1,000-4,999 points
- Level 3 (Advanced): 5,000-9,999 points
- Level 4 (Expert): 10,000-24,999 points
- Level 5 (Master): 25,000+ points

**Daily Goal**:
- Target: 50 push-ups per day
- Cumulative across all sessions in one day
- If <50: Streak at risk (notification sent at 9 PM)
- If ≥50: Streak maintained, points awarded

---

## Edge Cases

### What-If Scenarios

**Q: What if user closes app mid-workout?**
A: Session state saved to local storage immediately. On app relaunch:
- If session <24 hours old → Auto-resume from exact state
- If session >24 hours old → Mark as abandoned, prompt to start new workout
- User can continue workout, all progress preserved

**Q: What if proximity sensor is unavailable on device?**
A: Graceful degradation:
- Show toast notification: "Sensore non disponibile. Usa il pulsante manuale."
- Disable sensor toggle in settings (show "Non disponibile")
- Manual button always functional (fallback guaranteed)
- No impact on core workout functionality

**Q: What if user enters invalid recovery time (e.g., -5 or 999)?**
A: Input validation:
- Range enforced: 5-60 seconds
- Clamp values: <5 → 5, >60 → 60
- Show inline error if user tries to enter out-of-range value
- Use slider control (prevents invalid input)

**Q: What if user completes 0 push-ups (doesn't start workout)?**
A: Day marked as "missed" in calendar:
- No progress counted for that day
- Streak resets to 0
- Notification sent next day as reminder
- Calendar shows gray circle with "X"

**Q: What if user does >1000 push-ups in one day (excessive)?**
A: No cap enforced:
- System handles any number (64-bit integer)
- All push-ups counted toward daily goal
- Stats display normal (no special handling)
- User motivation: "Incredibile! Nuovo record personale!"

**Q: What if storage is full or data corrupted?**
A: Graceful degradation:
- Show error message: "Impossibile salvare i dati. Memoria piena."
- Continue workout in-memory (session not lost)
- Prompt user to free up storage
- Retry save operation periodically

**Q: What if user skips multiple days (e.g., vacation)?**
A: Streak reset:
- Each missed day resets streak to 0
- Calendar shows gray circles with "X" for missed days
- User can start fresh on return (no penalty beyond lost streak)
- Notification resumes on next active day

**Q: What if user reaches series 100+ (very long workout)?**
A: No issue:
- Series progression is infinite
- Countdown circle displays number correctly (e.g., "100")
- Recovery timer continues working
- Performance maintained (efficient state management)

**Q: What if user switches apps during workout (takes a call)?**
A: Session preserved:
- App lifecycle: `onPause` → save state
- User returns to app → `onResume` → restore state
- Workout resumes from exact point
- No data loss, no timer drift (use DateTime for timing)

### Error Handling

**Network Errors**: Not applicable (offline-only app in v1.0)

**Invalid Input**:
- Recovery time: Validate range (5-60s), clamp values
- Starting series: Validate [1, 2, 5, 10], default to 1
- Settings inputs: Use sliders/toggles (prevent invalid input)

**Storage Full**:
- Show error dialog: "Spazio di archiviazione insufficiente. Libera spazio e riprova."
- Continue in-memory (don't crash)
- Retry save operation every 60 seconds
- Clear old data (>30 days) if needed

**Crashes**:
- Implement crash reporting (e.g., Sentry) for production
- Save state frequently (minimize data loss)
- On relaunch: Check for orphaned sessions → offer recovery

**Sensor Failures**:
- Proximity sensor: Fallback to manual (see above)
- Vibration: Optional (continue without haptic feedback)
- Sound: Optional (continue without audio)

**Permission Denied**:
- Proximity sensor: Show explanation "Necessary for auto-counting", request again
- Notifications: Show explanation "Reminders to maintain streak", request again
- If permanently denied: Disable feature, show message in settings

---

## Out of Scope

The following features are intentionally excluded from v1.0:

**Social Features**:
- [ ] Friend leaderboards: **Deferred to v2.0** (requires backend infrastructure)
- [ ] Share achievements to social media: **Deferred to v2.0**
- [ ] Multiplayer challenges: **Deferred to v2.0**

**Advanced Analytics**:
- [ ] Detailed charts/graphs: **Deferred to v2.0** (nice-to-have)
- [ ] Personal best trends over time: **Deferred to v2.0**
- [ ] Workout duration tracking: **Deferred to v2.0**

**Customization**:
- [ ] Custom workout programs: **Deferred to v2.0** (complexity)
- [ ] Custom achievement creation: **Deferred to v2.0**
- [ ] Light theme: **Deferred to v2.0** (dark theme optimal for fitness)

**Backend/Cloud**:
- [ ] Cloud sync across devices: **Deferred to v2.0** (requires backend)
- [ ] Online leaderboards: **Deferred to v2.0**
- [ ] Account system/login: **Deferred to v2.0** (local-only in v1.0)

**Exercise Variety**:
- [ ] Other exercises (pull-ups, squats): **Deferred to future apps**
- [ ] Custom exercise types: **Deferred to v2.0**

**Rationale**: Focus on core push-up training experience, ensure robust functionality of essential features, avoid scope creep, deliver MVP quickly for user feedback.

---

## Success Criteria

**v1.0 Complete When**:
- [x] User can start workout from home screen
- [x] User can configure starting series and recovery time
- [x] User can count push-ups via manual button OR proximity sensor
- [x] Recovery timer works with color transitions (green → orange → red → flashing)
- [x] Statistics display in real-time (reps, kcal, level)
- [x] Session persists if app closed mid-workout
- [x] Calendar shows 30-day progress with completed/missed days
- [x] Achievements unlock with popup notifications
- [x] Daily reminder notification sent at 9 PM if goal not met
- [x] Streak system works correctly (consecutive days with ≥50 push-ups)
- [x] Points and levels calculate correctly
- [x] Settings page allows customization of preferences
- [x] All screens match mockup designs (orange/black theme)
- [x] App works on Windows (development), Android (production), iOS (production)
- [ ] All tests passing (70%+ coverage)
- [ ] Golden tests passing (no visual regressions)
- [ ] Performance acceptable (60fps animations, no lag)

**User Satisfaction Metrics** (Post-Launch):
- Daily Active Users (DAU) > 70% of installs (retention)
- Average session duration > 5 minutes
- Streak completion rate > 30% (users reaching 30-day goal)
- App Store rating > 4.0 stars
- Crash rate < 1%

---

## Appendix

### Competitive Analysis
- **Nike Training Club**: Premium design, video guides, subscription required
- **Pushups Workout**: Simple counter, lacks progression system
- **100 Push-ups**: Similar goal, but lacks gamification and sensor counting
- **Our Differentiation**: Progressive series, proximity sensor, streak gamification, minimalist design, free (no subscription)

### User Feedback Collection
- In-app feedback button (v1.1)
- App Store reviews monitoring
- Beta tester surveys before launch
- Analytics: Screen flow tracking, drop-off points (Series Selection → Workout Complete)

### Future Enhancements (v2.0+)
- Detailed charts and analytics
- Social features (leaderboards, sharing)
- Custom workout programs
- Light theme option
- Cloud sync and account system
- More exercise types (full-body fitness app)
- Apple Watch / Wear OS integration
- Voice coaching and encouragement
- Interval training (HIIT push-ups)
