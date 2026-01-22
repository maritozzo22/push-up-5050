# UI Mockup: Push-Up 5050

## Design System

### Color Palette
**Primary Colors**:
- **Primary Orange**: `#FF6B00` (main actions, buttons, active states)
- **Secondary Orange**: `#FF8C00` (gradients, highlights)
- **Deep Orange-Red**: `#FF4500` (borders, accents)

**Background Colors**:
- **Primary Background**: `#1A1A1A` (main screen background)
- **Secondary Background**: `#1E1E1E` (cards, elevated surfaces)
- **Card Background**: `#2A2A2A` (settings cards, series selection cards)

**Recovery Timer States**:
- **Full Recovery**: `#4CAF50` (green, 100-66% remaining)
- **Warning**: `#FF9800` (orange, 66-33% remaining)
- **Critical**: `#F44336` (red, 33-0% remaining)
- **Flashing**: `#F44336` (red, last 5 seconds, 500ms on/off animation)

**Text Colors**:
- **Primary Text**: `#FFFFFF` (white, main text)
- **Secondary Text**: `#FFFFFF` with 70% opacity (subtitles, hints)
- **Tertiary Text**: `#CCCCCC` (light gray, helper text)

**Semantic Colors**:
- **Success**: `#4CAF50` (completed calendar days, achievement unlocks)
- **Error**: `#F44336` (critical timer, errors)
- **Warning**: `#FF9800` (warning timer state)

### Typography

**Font Family**: Montserrat (Google Fonts)

**Text Styles**:
- **Logo Title**: 32px, Bold, `#FFFFFF` (screen titles, logo)
- **Headline Large**: 40px, Bold, `#FFFFFF` (workout screen title)
- **Headline Medium**: 24px, Bold, `#FFFFFF` (section headers)
- **Countdown Number**: 120px, Bold, `#FFFFFF` (workout countdown circle)
- **Body Large**: 18px, Regular, `#FFFFFF` (statistics badges, labels)
- **Body Medium**: 16px, Regular, `#FFFFFF` (body text, button text)
- **Body Small**: 14px, Regular, `#FFFFFF` 70% opacity (subtitles, hints)
- **Caption**: 12px, Regular, `#CCCCCC` (helper text)

### Spacing System
- **XS**: 4px (icon padding, tight gaps)
- **S**: 8px (small gaps, icon spacing)
- **M**: 12px (card padding, tight padding)
- **L**: 16px (standard padding, comfortable spacing)
- **XL**: 20px (large padding, section separation)
- **XXL**: 24px (extra large padding)
- **XXXL**: 30px (major section separation)

### Border Radius
- **Small**: 6px (progress bars, small elements)
- **Medium**: 12px (cards, buttons)
- **Large**: 20px (statistic badges)

### Elevation
- **Subtle**: 2px blur (cards, buttons)
- **Medium**: 4px blur (elevated cards)
- **Strong**: 8px blur (bottom navigation)

---

## Component Library

### PrimaryButton (Orange Button)
**Purpose**: Main call-to-action buttons (INIZIA, INIZIA ALLENAMENTO)
**Size**: Height 56px, full width minus 32px margins
**Padding**: Horizontal 24px, Vertical 16px
**Background**: Primary Orange `#FF6B00`
**Text**: 20px, Bold, `#FFFFFF` (white)
**Border Radius**: 12px
**Elevation**: 4px (shadow blurRadius 4)
**Flutter hint**: `ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFFF6B00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))))`

**States**:
- Normal: `#FF6B00` background, white text
- Pressed: Scale 0.95, darken by 10%
- Disabled: `#2A2A2A` background, `#CCCCCC` text

### SecondaryButton (Control Button)
**Purpose**: Workout control buttons (PAUSA, TERMINA)
**Size**: 80px width × 40px height
**Padding**: Horizontal 16px, Vertical 12px
**Background**: Primary Orange `#FF6B00` (PAUSA), Deep Orange-Red `#FF4500` (TERMINA)
**Text**: 16px, Regular, `#FFFFFF`
**Border Radius**: 12px
**Flutter hint**: `ElevatedButton` with fixed size

**States**:
- Normal: Orange background, white text
- Pressed: Scale 0.95 animation (5% reduction)

### CircularIconButton (Plus/Minus Button)
**Purpose**: Increment/decrement values (Series Selection screen)
**Size**: 48px diameter (circle)
**Background**: Primary Orange `#FF6B00`
**Icon**: White (add/remove icons, 24px)
**Border Radius**: Circle (24px)
**Elevation**: 2px
**Flutter hint**: `MaterialButton(shape: CircleBorder(), color: Color(0xFFFF6B00))`

### Card (Config Card)
**Purpose**: Container for settings, series selection
**Padding**: 16px
**Background**: `#2A2A2A` (dark gray)
**Border**: 1px solid `#FF6B00` (orange)
**Border Radius**: 12px
**Elevation**: 4px (blurRadius)
**Margin**: 8px vertical
**Flutter hint**: `Container(decoration: BoxDecoration(color: Color(0xFF2A2A2A), border: Border.all(color: Color(0xFFFF6B00)), borderRadius: BorderRadius.circular(12)))`

### StatisticsBadge
**Purpose**: Display real-time workout stats (reps, kcal)
**Size**: Variable width, 40px height
**Padding**: 12px horizontal, 12px vertical
**Background**: `#2A2A2A` (dark gray)
**Border Radius**: 20px (pill shape)
**Icon**: Orange circle, 12px diameter, white border 2px
**Text**: 18px, Regular, `#FFFFFF`
**Spacing**: 20px between badges
**Flutter hint**: `Container(decoration: BoxDecoration(color: Color(0xFF2A2A2A), borderRadius: BorderRadius.circular(20)))`

### CountdownCircle
**Purpose**: Main workout interaction element (push-up counting)
**Size**: 280px diameter (60% screen vertical)
**Shape**: Perfect circle
**Gradient**: Radial gradient `#FF8C00` (center) → `#FF4500` (edges)
**Outer Glow**: 2px `rgba(255, 140, 0, 0.3)`
**Shadow**: 8px `rgba(0, 0, 0, 0.4)`
**Text**: 120px, Bold, `#FFFFFF` (centered)
**Subtitle**: 24px, Regular, `#FFFFFF` (20px below number)
**Flutter hint**: `Container(decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [Color(0xFFFF8C00), Color(0xFFFF4500)])))`

**States**:
- Normal: Orange gradient, white text
- Tapped: Scale 1.1 animation, orange flash `rgba(255, 140, 0, 0.5)`
- Sensor Trigger: Same as tapped (visual feedback)

### RecoveryTimerBar
**Purpose**: Visual countdown during recovery period
**Size**: Full width minus 32px margins, 12px height
**Background**: `#333333` (dark gray)
**Fill**: Dynamic (starts green → orange → red → flashing)
**Border Radius**: 6px
**Text Labels**:
  - Series: Left of bar, 16px, `#FFFFFF` ("Serie 3 di 5")
  - Percentage: Right of bar, 16px, `#FFFFFF` ("60%")
**Flutter hint**: `LinearProgressIndicator` with custom colors

**Color States** (based on remaining time):
- 100-66%: `#4CAF50` (green)
- 66-33%: `#FF9800` (orange)
- 33-5%: `#F44336` (red)
- 5-0%: `#F44336` (red, flashing 500ms on/off)

### ProgressCircle (Stats Screen)
**Purpose**: Show overall progress toward 5050 goal
**Size**: 180px diameter
**Stroke**: 15px width, rounded cap
**Color**: Orange `#FF6B00` (fill), Transparent (background)
**Center Text**:
  - "1250 / 5050": 24px, Bold, `#FFFFFF`
  - "PUSHUP TOTALI": 14px, Regular, `#FFFFFF` 70% opacity
  - "25%": 18px, Bold, `#FF6B00` (orange)
**Flutter hint**: `CircularProgressIndicator(value: 0.25, strokeWidth: 15, color: Color(0xFFFF6B00))`

### CalendarDayCell
**Purpose**: Display single day in 30-day calendar
**Size**: 50px × 50px (approximate, responsive)
**Shape**: Circle
**Border Radius**: Circle (25px)

**States**:
- **Completed**: Background `#FF6B00` (orange), Checkmark icon (white, 20px), Rep count (14px, Bold, white)
- **Today**: Background `#2A2A2A` (dark gray), Orange border 2px, "OGGI: XX PUSHUP" label (10px, Bold, white)
- **Future**: Background `#2A2A2A` (dark gray), Target rep count (14px, white)
- **Missed**: Background `#2A2A2A` (dark gray), "X" mark (white, 20px)

**Flutter hint**: `Container(decoration: BoxDecoration(shape: BoxShape.circle, color: stateColor))`

### AchievementPopup
**Purpose**: Non-intrusive achievement unlock notification
**Size**: 90% screen width, auto height
**Position**: Top 20px (or bottom 100px above nav)
**Background**: `#1A1A1A` 90% opacity
**Border**: Orange 2px (`#FF6B00`)
**Border Radius**: 16px
**Elements**:
  - Icon: Trophy/star (48px, orange)
  - Title: 20px, Bold, `#FFFFFF`
  - Description: 16px, Regular, `#FFFFFF`
  - Points: "+XX punti" (14px, orange)
**Animation**: Slide-in from top (300ms), auto-dismiss after 3-4s
**Flutter hint**: `AnimatedPositioned` for slide-in/out

### BottomNavigationBar
**Purpose**: Primary navigation (Home, Stats, Profile)
**Height**: 56px
**Background**: `#1A1A1A` 90% opacity
**Elevation**: 8px
**Items**: 3 tabs (Home, Stats, Profile)
**Icon Size**: 24px
**Label**: 12px, Regular, below icon
**Selected Color**: `#FF6B00` (orange)
**Unselected Color**: `#FFFFFF` 70% opacity
**Flutter hint**: `BottomNavigationBar(selectedItemColor: Color(0xFFFF6B00))`

---

## Navigation Flow

### User Flow: Complete Workout Session

**Flow: App Launch → Home → Series Selection → Workout → Statistics → Achievement**

1. **App Launch**
   - Screen: HomeScreen
   - User can: View quick stats, tap "INIZIA", navigate to Stats/Profile
   - Navigates to: SeriesSelectionScreen (via "INIZIA" tap)

2. **Series Selection**
   - Screen: SeriesSelectionScreen
   - User can: Adjust starting series (1/2/5/10), adjust recovery time (5-60s), confirm
   - Navigates to: WorkoutExecutionScreen (via "INIZIA ALLENAMENTO" tap)

3. **Workout Execution**
   - Screen: WorkoutExecutionScreen
   - User can: Count push-ups (tap/sensor), pause/resume, end workout
   - Navigates to: HomeScreen (via "TERMINA" tap), shows AchievementPopup (if unlocked)

4. **View Statistics**
   - Screen: StatisticsScreen (via bottom nav)
   - User can: View calendar, check progress, tap days for details
   - Navigates to: Other screens via bottom nav

5. **Settings**
   - Screen: SettingsScreen (via Profile tap → Settings)
   - User can: Configure preferences
   - Navigates to: Back to previous screen

### Route Map

```
App
├── HomeScreen (initial)
│   ├── → SeriesSelectionScreen (push)
│   └── BottomNav
│       ├── → StatisticsScreen (switch)
│       └── → ProfileScreen (switch) [not in v1.0, placeholder]
│           └── → SettingsScreen (push)
├── SeriesSelectionScreen
│   └── → WorkoutExecutionScreen (push)
└── WorkoutExecutionScreen
    └── → HomeScreen (replace, on TERMINA)
        └── [AchievementPopup] (overlay, auto-dismiss)
```

### Navigation Types

- **Push**: Navigate to new screen, adds to back stack (SeriesSelection, WorkoutExecution)
- **Switch**: Replace current screen, no back stack (Bottom nav tabs)
- **Replace**: Replace current screen, remove from back stack (Workout → Home on TERMINA)
- **Overlay**: Show popup/notification, doesn't affect navigation stack (AchievementPopup)

### Navigation Elements

**Mobile Navigation**:
- Top bar: Not present (screens use full height)
- Bottom nav: 56px height, 3 icons (Home, Stats, Profile)
- Back button: In Workout screen (custom "TERMINA" button ends session)

**Desktop Navigation** (Windows):
- Bottom nav: Same as mobile (56px height)
- Layout: Centered, max width 600px
- Responsive: Elements scale appropriately, no sidebar

---

## Screen: HomeScreen

### Purpose
Entry point for app, quick overview of progress, start workout.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────────┐
│                                     │
│         PUSHUP 5050                 │  ← Logo/Title (32px, Bold, White)
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Push-up Oggi: 15 / 50      │   │  ← Quick Stat Badge 1
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Serie Attuale: 3 giorni    │   │  ← Quick Stat Badge 2
│  └─────────────────────────────┘   │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │    INIZIA     │           │  ← Primary Button (orange)
│         │               │           │
│         └───────────────┘           │
│                                     │
│                                     │
│                                     │
│                                     │
│                                     │
├─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│  ← Bottom Navigation (56px)
└─────────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Logo/Title Section** (padding top: 60px)
   - Position: Centered horizontally
   - Elements:
     - Text: "PUSHUP 5050", Logo Title (32px, Bold, White)
     - Spacing: 40px below title

2. **Quick Stats Section** (padding: 0px 16px)
   - Position: Below title, centered
   - Layout: Vertical stack, 20px spacing between badges
   - Elements:
     - Badge 1: "Push-up Oggi: 15 / 50" (StatisticsBadge component)
       - Icon: Orange circle (12px) with white border
       - Text: 18px, Regular, White
       - Background: `#2A2A2A`, 20px radius
     - Badge 2: "Serie Attuale: 3 giorni" (StatisticsBadge component)
       - Icon: Orange circle (12px) with white border
       - Text: 18px, Regular, White
       - Background: `#2A2A2A`, 20px radius

3. **START Button** (margin top: 60px, padding: 0px 16px)
   - Position: Centered horizontally
   - Size: Full width minus 32px margins, 56px height
   - Elements:
     - Button: PrimaryButton component
     - Text: "INIZIA", 20px, Bold, White
     - Background: `#FF6B00`, 12px radius
     - Elevation: 4px

4. **Bottom Navigation** (height: 56px, fixed bottom)
   - Position: Fixed bottom, full width
   - Elements:
     - Home icon: Left, "Home" label below, Selected state (orange)
     - Stats icon: Center, "Stats" label below, Unselected (white 70%)
     - Profile icon: Right, "Profile" label below, Unselected (white 70%)
   - Background: `#1A1A1A` 90% opacity
   - Elevation: 8px

### State Variations

#### Normal State
As shown above (all elements populated with real data).

#### Loading State (First Launch)
```
┌─────────────────────────────────────┐
│                                     │
│         PUSHUP 5050                 │
│                                     │
│         [CircularProgress]          │  ← Loading indicator
│      Caricamento...                 │  ← Loading text
│                                     │
└─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```
- Replace stats badges with CircularProgressIndicator (centered)
- Show "Caricamento..." text (Caption, white 70%)
- START button disabled (`#2A2A2A` background)

#### Error State (Data Load Failed)
```
┌─────────────────────────────────────┐
│                                     │
│         PUSHUP 5050                 │
│                                     │
│         [⚠️ Error Icon]             │  ← Error icon (48px)
│      Impossibile caricare           │  ← Error message
│      i dati                         │
│                                     │
│      ┌──────────────┐               │
│      │   RIPROVA    │               │  ← Retry button
│      └──────────────┘               │
│                                     │
└─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```
- Replace stats badges with error icon + message
- Show "RIPROVA" button (SecondaryButton)
- Error message: "Impossibile caricare i dati" (Body Large, Error color `#F44336`)

#### Empty State (First Day, No Stats)
```
┌─────────────────────────────────────┐
│                                     │
│         PUSHUP 5050                 │
│                                     │
│         [🎯 Icon]                   │  ← Target icon (48px)
│      Inizia il tuo primo            │  ← Encouragement message
│      allenamento oggi!              │
│                                     │
│         ┌───────────────┐           │
│         │    INIZIA     │           │  ← START button enabled
│         └───────────────┘           │
│                                     │
└─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```
- Show target icon instead of stats badges
- Message: "Inizia il tuo primo allenamento oggi!" (Body Medium)
- START button enabled (normal state)

### Responsive Rules (Desktop/Windows)

**Breakpoint**: >600px width (desktop, tablet)

**Layout changes**:
1. **Content area**: Centered, max width 600px
2. **Bottom nav**: Same as mobile (56px height)
3. **Padding**: Increases to 24px on larger screens
4. **Stats badges**: Slightly larger (max width 300px each)

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│                 PUSHUP 5050                         │
│                                                     │
│          ┌─────────────────────────┐                │
│          │  Push-up Oggi: 15 / 50  │                │
│          └─────────────────────────┘                │
│                                                     │
│          ┌─────────────────────────┐                │
│          │  Serie Attuale: 3 giorni│                │
│          └─────────────────────────┘                │
│                                                     │
│              ┌───────────────┐                      │
│              │    INIZIA     │                      │
│              └───────────────┘                      │
│                                                     │
│         (content centered, max width 600px)         │
│                                                     │
├─────────────────────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]                │
└─────────────────────────────────────────────────────┘
```

**Flutter hints**:
- Use `LayoutBuilder` to detect breakpoint
- Wrap content in `Center` + `ConstrainedBox(maxWidth: 600)`
- Bottom nav remains full width

### Flutter Implementation Hints

**Widget structure**:
```dart
Scaffold(
  backgroundColor: Color(0xFF1A1A1A),
  body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            // Title
            Text('PUSHUP 5050', style: AppTextStyles.logoTitle),
            SizedBox(height: 40),

            // Quick Stats
            StatisticsBadge(label: 'Push-up Oggi', value: '15 / 50'),
            SizedBox(height: 20),
            StatisticsBadge(label: 'Serie Attuale', value: '3 giorni'),

            Spacer(),

            // START Button
            PrimaryButton(
              text: 'INIZIA',
              onPressed: () => navigateToSeriesSelection(),
            ),
          ],
        ),
      ),
    ),
  ),
  bottomNavigationBar: BottomNavigationBar(...),
)
```

**Components to use**:
- Title: `Text` with `AppTextStyles.logoTitle`
- Stats badges: `StatisticsBadge` custom widget
- Button: `PrimaryButton` custom widget (ElevatedButton)
- Loading: `CircularProgressIndicator` + Text
- Error/Empty: `Column` with Icon + Text + Button
- Bottom nav: `BottomNavigationBar`

**State handling**:
- Use `FutureBuilder` to load stats data
- Show loading indicator when `connectionState == waiting`
- Show error state when `hasError`
- Show empty state when data indicates first day
- Show normal state with real data otherwise

### Navigation

**From**: App launch (initial route)
**To**:
- SeriesSelectionScreen (via "INIZIA" tap, push navigation)
- StatisticsScreen (via bottom nav "Stats" tap, switch navigation)
- ProfileScreen (via bottom nav "Profile" tap, switch navigation) [placeholder in v1.0]

**Back behavior**:
- No back button (initial screen)
- Bottom nav switches between tabs

---

## Screen: SeriesSelectionScreen

### Purpose
Configure workout parameters (starting series, recovery time) before starting.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────────┐
│  ←          PUSHUP 5050             │  ← Back button + Title
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Serie di Partenza         │   │  ← Card 1 Title
│  ├─────────────────────────────┤   │
│  │                             │   │
│  │    [-]     1     [+]        │   │  ← Plus/Minus buttons + value
│  │                             │   │
│  │  Progressive Series         │   │  ← Hint text
│  │  (e.g., Series 3 = 3 push)  │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Tempo di Recupero         │   │  ← Card 2 Title
│  ├─────────────────────────────┤   │
│  │                             │   │
│  │    [-]     10    [+]        │   │  ← Plus/Minus buttons + value
│  │                             │   │
│  │  Base 10s, increases        │   │  ← Hint text
│  │  with series                │   │
│  └─────────────────────────────┘   │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │ INIZIA        │           │  ← Primary Button
│         │ ALLENAMENTO   │           │
│         └───────────────┘           │
│                                     │
└─────────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px)
   - Position: Fixed top
   - Elements:
     - Back button: Left, 24px padding, chevron left icon (white, 24px)
     - Title: Center, "PUSHUP 5050", Logo Title (32px, Bold, White)

2. **Card 1: Starting Series** (margin: 20px 16px)
   - Position: Below top bar
   - Size: Full width minus 32px margins, auto height
   - Elements:
     - Container: Card component (background `#2A2A2A`, orange border 1px, 12px radius)
     - Title: "Serie di Partenza", 18px, Bold, White, padding 16px top
     - Value row: Three columns (minus button, value, plus button)
       - Minus button: CircularIconButton (48px, orange, "-" icon)
       - Value: Large number (1/2/5/10), 48px, Bold, White, centered
       - Plus button: CircularIconButton (48px, orange, "+" icon)
       - Spacing: 16px between elements
     - Hint text: "Progressive Series (e.g., Series 3 = 3 pushups)", 14px, White 70% opacity, padding 16px bottom

3. **Card 2: Rest Time** (margin: 20px 16px)
   - Position: Below Card 1
   - Size: Same as Card 1
   - Elements:
     - Container: Card component (same style)
     - Title: "Tempo di Recupero (secondi)", 18px, Bold, White, padding 16px top
     - Value row: Three columns (minus, value, plus)
       - Minus button: CircularIconButton (48px, orange, "-" icon)
       - Value: Number (5-60), 48px, Bold, White, centered (default 10)
       - Plus button: CircularIconButton (48px, orange, "+" icon)
       - Spacing: 16px between elements
     - Hint text: "Base 10s, increases with series", 14px, White 70% opacity, padding 16px bottom

4. **BEGIN WORKOUT Button** (margin: 40px 16px)
   - Position: Above bottom spacer
   - Size: Full width minus 32px margins, 56px height
   - Elements:
     - Button: PrimaryButton component
     - Text: "INIZIA ALLENAMENTO", 20px, Bold, White
     - Background: `#FF6B00`, 12px radius

5. **Bottom Spacer** (flexible)
   - Position: Below button
   - Purpose: Push content up, ensure button not hidden by nav bar

### State Variations

#### Normal State
As shown above (all controls functional, default values 1 and 10).

#### Validation State (Invalid Recovery Time)
```
┌─────────────────────────────────────┐
│  ←          PUSHUP 5050             │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────────────────────────┐   │
│  │   Tempo di Recupero         │   │
│  ├─────────────────────────────┤   │
│  │                             │   │
│  │    [-]     5     [+]        │   │  ← Minimum value reached
│  │                             │   │
│  │  ⚠️ Minimo 5 secondi        │   │  ← Error message (red)
│  └─────────────────────────────┘   │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │ INIZIA        │           │  ← Button enabled (value valid)
│         │ ALLENAMENTO   │           │
│         └───────────────┘           │
│                                     │
└─────────────────────────────────────┘
```
- Show inline error when user tries to go below 5 or above 60
- Error message: "Minimo 5 secondi" or "Massimo 60 secondi" (Caption, Error color)
- Button remains enabled (value clamped to valid range)

### Responsive Rules (Desktop/Windows)

**Breakpoint**: >600px width

**Layout changes**:
1. **Top bar**: Same as mobile
2. **Cards**: Centered, max width 400px each (not full width)
3. **Button**: Max width 400px, centered

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│  ←          PUSHUP 5050                             │
├─────────────────────────────────────────────────────┤
│                                                     │
│          ┌─────────────────────────┐                │
│          │   Serie di Partenza     │                │
│          ├─────────────────────────┤                │
│          │                         │                │
│          │    [-]     1     [+]    │                │
│          │                         │                │
│          │  Progressive Series     │                │
│          └─────────────────────────┘                │
│                                                     │
│          ┌─────────────────────────┐                │
│          │   Tempo di Recupero     │                │
│          ├─────────────────────────┤                │
│          │                         │                │
│          │    [-]     10    [+]    │                │
│          │                         │                │
│          │  Base 10s, increases    │                │
│          └─────────────────────────┘                │
│                                                     │
│              ┌───────────────┐                      │
│              │ INIZIA        │                      │
│              │ ALLENAMENTO   │                      │
│              └───────────────┘                      │
│                                                     │
│         (content centered, max width 400px)         │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Flutter hints**:
- Wrap cards and button in `Center` + `ConstrainedBox(maxWidth: 400)`
- Cards and button share same max width for visual consistency

### Flutter Implementation Hints

**Widget structure**:
```dart
Scaffold(
  backgroundColor: Color(0xFF1A1A1A),
  appBar: AppBar(
    leading: BackButton(),
    title: Text('PUSHUP 5050', style: AppTextStyles.logoTitle),
    backgroundColor: Color(0xFF1A1A1A),
  ),
  body: Center(
    child: ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 400),
      child: Column(
        children: [
          // Card 1: Starting Series
          ConfigCard(
            title: 'Serie di Partenza',
            value: startingSeries.toString(),
            hint: 'Progressive Series (e.g., Series 3 = 3 pushups)',
            onDecrement: () => decrementStartingSeries(),
            onIncrement: () => incrementStartingSeries(),
          ),
          SizedBox(height: 20),

          // Card 2: Rest Time
          ConfigCard(
            title: 'Tempo di Recupero (secondi)',
            value: restTime.toString(),
            hint: 'Base 10s, increases with series',
            onDecrement: () => decrementRestTime(),
            onIncrement: () => incrementRestTime(),
          ),

          Spacer(),

          // BEGIN WORKOUT Button
          PrimaryButton(
            text: 'INIZIA ALLENAMENTO',
            onPressed: () => startWorkout(),
          ),
        ],
      ),
    ),
  ),
)
```

**Components to use**:
- Top bar: `AppBar` with `leading: BackButton()`, `title: Text`
- Cards: `ConfigCard` custom widget (Container with Card styling)
- Plus/minus: `CircularIconButton` custom widget
- Button: `PrimaryButton` custom widget

**State handling**:
- Use `StatefulWidget` with `setState` for value updates
- Clamp restTime to range 5-60: `restTime = restTime.clamp(5, 60)`
- Validate before navigating to workout screen

### Navigation

**From**: HomeScreen (via "INIZIA" tap)
**To**: WorkoutExecutionScreen (via "INIZIA ALLENAMENTO" tap, push navigation)
**Back**: Back button returns to HomeScreen (pop navigation)

---

## Screen: WorkoutExecutionScreen ⭐ MOST CRITICAL

### Purpose
Main workout interface for counting push-ups, displaying real-time stats, managing recovery timer.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────────┐
│                                     │
│     Allenamento in Corso            │  ← Title (40px, Bold)
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Rep Totali: 23           │   │  ← Stat Badge 1
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Kcal Bruciate: 6         │   │  ← Stat Badge 2
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │       5       │           │  ← Countdown Circle
│         │               │           │    (280px diameter)
│         │  Tocca per     │           │
│         │    Contare    │           │
│         └───────────────┘           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Serie 3 di 5        60%    │   │  ← Recovery Timer Bar
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ⚡ Livello Attuale:        │   │  ← Level Badge
│  │     Intermediate            │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│  [PAUSA]              [TERMINA]     │  ← Control Buttons
│                                     │
└─────────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Title Section** (padding top: 30px)
   - Position: Centered horizontally
   - Elements:
     - Text: "Allenamento in Corso", Headline Large (40px, Bold, White)
     - Spacing: 20px below title

2. **Statistics Badges** (padding: 0px 16px)
   - Position: Below title, centered horizontally
   - Layout: Row with 20px spacing between badges
   - Elements:
     - Badge 1 (Left): "Rep Totali: 23"
       - Container: StatisticsBadge component
       - Icon: Orange circle (12px) with white border 2px
       - Text: 18px, Regular, White
       - Background: `#2A2A2A`, 20px radius
     - Badge 2 (Right): "Kcal Bruciate: 6"
       - Container: StatisticsBadge component (same style)
       - Icon: Orange circle (12px) with white border 2px
       - Text: 18px, Regular, White

3. **Countdown Circle** (margin top: 40px)
   - Position: Centered horizontally
   - Size: 280px diameter (perfect circle)
   - Shape: Radial gradient `#FF8C00` (center) → `#FF4500` (edges)
   - Effects:
     - Outer glow: 2px `rgba(255, 140, 0, 0.3)`
     - Shadow: 8px `rgba(0, 0, 0, 0.4)`
   - Elements:
     - Number: 120px, Bold, White (centered vertically/horizontally)
     - Subtitle: "Tocca per Contare", 24px, Regular, White (20px below number)
   - Interactivity:
     - Tap: Scale 1.1 animation (10% increase)
     - Visual feedback: Orange flash `rgba(255, 140, 0, 0.5)`
     - Haptic: Light vibration on tap
   - Flutter hint: `GestureDetector` with `AnimationController` for scale

4. **Recovery Timer Bar** (margin top: 30px, padding: 0px 16px)
   - Position: Below countdown circle
   - Size: Full width minus 32px margins, 12px height
   - Elements:
     - Background: `#333333` (dark gray), 6px radius
     - Fill: Dynamic color (green → orange → red → flashing), based on remaining time
     - Label (Left): "Serie 3 di 5", 16px, Regular, White
     - Label (Right): "60%", 16px, Regular, White
   - Color States:
     - 100-66% remaining: `#4CAF50` (green)
     - 66-33% remaining: `#FF9800` (orange)
     - 33-5% remaining: `#F44336` (red)
     - 5-0% remaining: `#F44336` (red, flashing 500ms on/off)
   - Flutter hint: `LinearProgressIndicator` with custom `AnimationController`

5. **Level Badge** (margin top: 20px, padding: 0px 16px)
   - Position: Below recovery timer
   - Size: 80% screen width, auto height (40px min)
   - Elements:
     - Container: `#2A2A2A` background, 20px radius, 12px padding
     - Icon: Lightning bolt (orange, 24px)
     - Text: "Livello Attuale: Intermediate", 18px, Regular, White
     - Spacing: 8px between icon and text

6. **Control Buttons** (margin top: 40px, padding: 0px 16px)
   - Position: Above bottom spacer
   - Layout: Row with space-between (buttons at opposite corners)
   - Elements:
     - Button (Left): "PAUSA"
       - Size: 80px width × 40px height
       - Background: `#FF6B00`, 12px radius
       - Text: 16px, Regular, White
       - Animation: Scale 0.95 on press (5% reduction)
     - Button (Right): "TERMINA"
       - Size: 80px width × 40px height
       - Background: `#FF4500` (deep orange-red), 12px radius
       - Text: 16px, Regular, White
       - Animation: Scale 0.95 on press (5% reduction)

### State Variations

#### Normal State (Counting Push-ups)
As shown above (countdown circle displays current target, user can tap).

#### Recovery State (Between Series)
```
┌─────────────────────────────────────┐
│                                     │
│     Allenamento in Corso            │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Rep Totali: 10           │   │  ← Stats updated
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Kcal Bruciate: 4         │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │   ⏳ 7.5s     │           │  ← Recovery Timer (replaces countdown)
│         │               │           │    (green bar, 75% remaining)
│         └───────────────┘           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Serie 2 di 5        75%    │   │  ← Recovery Timer Bar (green)
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ⚡ Livello Attuale:        │   │
│  │     Intermediate            │   │
│  └─────────────────────────────┘   │
│                                     │
│  [RIPRENDI]            [TERMINA]     │  ← Pause changed to Resume
│                                     │
└─────────────────────────────────────┘
```
- Countdown circle replaced by recovery timer (e.g., "⏳ 7.5s")
- Recovery timer bar visible (green/orange/red based on time)
- "PAUSA" button changes to "RIPRENDI" (Resume)
- User cannot count push-ups during recovery (circle disabled)

#### Paused State (User Paused Workout)
```
┌─────────────────────────────────────⏸  │
│                                     │
│     Allenamento in Corso            │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Rep Totali: 23           │   │
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ ●  Kcal Bruciate: 6         │   │
│  └─────────────────────────────┘   │
│                                     │
│                                     │
│         ┌───────────────┐           │
│         │               │           │
│         │       5       │           │  ← Countdown frozen
│         │               │           │
│         │  ⏸ IN PAUSA   │           │  ← Subtitle indicates paused
│         └───────────────┘           │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Serie 3 di 5        60%    │   │  ← Timer bar frozen
│  └─────────────────────────────┘   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │  ⚡ Livello Attuale:        │   │
│  │     Intermediate            │   │
│  └─────────────────────────────┘   │
│                                     │
│  [RIPRENDI]            [TERMINA]     │  ← Pause changed to Resume
│                                     │
└─────────────────────────────────────┘
```
- Countdown circle frozen (shows current number)
- Subtitle changes to "⏸ IN PAUSA" (Paused)
- Recovery timer bar frozen (if active)
- "PAUSA" button changes to "RIPRENDI" (Resume)
- All interactions disabled except Resume/Terminate

#### Session Complete (Achievement Unlocked)
```
┌─────────────────────────────────────┐
│                                     │
│         ┌─────────┐                 │  ← Achievement Popup
│         │  🏆     │                 │    (slides in from top)
│         │ Dieci in│                 │
│         │ Un Row! │                 │
│         │  +150pt │                 │
│         └─────────┘                 │
│                                     │
│     Allenamento Completato!         │  ← Success message
│                                     │
│  ┌─────────────────────────────┐   │
│  │  Serie Completate: 5        │   │  ← Summary stats
│  │  Push-up Totali: 23         │   │
│  │  Kcal Bruciate: 10          │   │
│  └─────────────────────────────┘   │
│                                     │
│      ┌──────────────┐              │
│      │ SALVA E TORNA│              │  ← Save button
│      │   A HOME     │              │
│      └──────────────┘              │
│                                     │
└─────────────────────────────────────┘
```
- Achievement popup appears (auto-dismisses after 3-4s)
- Title changes to "Allenamento Completato!"
- Summary card shows final stats
- Single "SALVA E TORNA A HOME" button (centered)
- All other elements removed (countdown circle, badges, etc.)

### Responsive Rules (Desktop/Windows)

**Breakpoint**: >600px width

**Layout changes**:
1. **Countdown circle**: Increases to 320px diameter
2. **Control buttons**: Wider (120px each)
3. **Statistics badges**: Slightly larger spacing (30px)
4. **Content**: Centered, max width 600px

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│        Allenamento in Corso                         │
│                                                     │
│   ┌────────────────────┐  ┌────────────────────┐    │
│   │ ● Rep Totali: 23  │  │ ● Kcal Bruciate: 6 │    │  ← Wider spacing
│   └────────────────────┘  └────────────────────┘    │
│                                                     │
│                                                     │
│            ┌─────────────┐                         │
│            │             │                         │
│            │      5      │                         │  ← Larger circle (320px)
│            │             │                         │
│            │Tocca per    │                         │
│            │  Contare    │                         │
│            └─────────────┘                         │
│                                                     │
│   ┌───────────────────────────────────────┐        │
│   │  Serie 3 di 5                  60%    │        │  ← Timer bar
│   └───────────────────────────────────────┘        │
│                                                     │
│   ┌─────────────────────────────────────┐          │
│   │ ⚡ Livello Attuale: Intermediate     │          │
│   └─────────────────────────────────────┘          │
│                                                     │
│                                                     │
│       [PAUSA]                     [TERMINA]        │  ← Wider buttons
│                                                     │
│         (content centered, max width 600px)        │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Flutter hints**:
- Wrap content in `Center` + `ConstrainedBox(maxWidth: 600)`
- Countdown circle: Responsive size (280px mobile, 320px desktop)
- Buttons: `SizedBox(width: 120)` on desktop

### Flutter Implementation Hints

**Widget structure**:
```dart
Scaffold(
  backgroundColor: Color(0xFF1A1A1A),
  body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            // Title
            Text('Allenamento in Corso', style: AppTextStyles.headlineLarge),
            SizedBox(height: 20),

            // Statistics Badges
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StatisticsBadge(label: 'Rep Totali', value: '23'),
                SizedBox(width: 20),
                StatisticsBadge(label: 'Kcal Bruciate', value: '6'),
              ],
            ),
            SizedBox(height: 40),

            // Countdown Circle (or Recovery Timer)
            if (isRecovery)
              RecoveryTimer(secondsRemaining: 7.5)
            else
              CountdownCircle(
                number: currentSeries,
                onTap: () => countPushup(),
              ),
            SizedBox(height: 30),

            // Recovery Timer Bar
            RecoveryTimerBar(
              currentSeries: 3,
              totalSeries: 5,
              percentage: 0.6,
            ),
            SizedBox(height: 20),

            // Level Badge
            LevelBadge(level: 'Intermediate'),
            Spacer(),

            // Control Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ControlButton(
                  text: isPaused ? 'RIPRENDI' : 'PAUSA',
                  onPressed: () => togglePause(),
                ),
                ControlButton(
                  text: 'TERMINA',
                  color: Color(0xFFFF4500),
                  onPressed: () => endWorkout(),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ),
)
```

**Components to use**:
- Countdown circle: `CountdownCircle` custom widget with `AnimationController` for scale effect
- Recovery timer: `RecoveryTimer` custom widget (replaces countdown during recovery)
- Timer bar: `RecoveryTimerBar` custom widget with `LinearProgressIndicator`
- Statistics badges: `StatisticsBadge` component
- Level badge: `LevelBadge` custom widget
- Control buttons: `ControlButton` custom widget

**State handling**:
- Use `StatefulWidget` with `AnimationController` for countdown circle tap effect
- Use `Timer` for countdown decrement and recovery timer
- Manage states: `isPaused`, `isRecovery`, `currentSeries`, `repsInCurrentSeries`, `totalReps`
- Update statistics badges in real-time with `setState`
- Save session state on each update (for persistence)

**Animations**:
- Countdown circle tap: `ScaleTransition` (1.0 → 1.1 → 1.0, 200ms duration)
- Recovery timer color: `ColorTween` animation (green → orange → red)
- Achievement popup: `SlideTransition` (top → center → top, 3-4s duration)

### Navigation

**From**: SeriesSelectionScreen (via "INIZIA ALLENAMENTO" tap)
**To**: HomeScreen (via "TERMINA" tap, replace navigation)
**Overlay**: AchievementPopup (shows when achievement unlocked, auto-dismisses)

**Back behavior**:
- No system back button (custom "TERMINA" button ends session)
- If user backs out of app (Android back button): Show confirmation dialog "Sei sicuro di voler uscire? La sessione verrà salvata."

---

## Screen: StatisticsScreen

### Purpose
Display 30-day progress calendar, overall goal progress, achievements.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────────┐
│                                     │
│      ┌─────────────────┐            │  ← Progress Circle
│      │                 │  1250      │    (180px diameter)
│      │      ● 25%      │  / 5050    │
│      │                 │  PUSHUP    │
│      │                 │  TOTALI    │
│      └─────────────────┘            │
│                                     │
│      Giorno 14 di 30               │  ← Calendar Title
│                                     │
│  ┌───┬───┬───┬───┬───┐            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │ 1 │ 2 │ 3 │ 4 │ 5 │            │  ← Calendar Grid (5x6)
│  │ 50│ 60│ 75│ 80│ 75│            │    (30 days)
│  ├───┼───┼───┼───┼───┤            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │ 6 │ 7 │ 8 │ 9 │10 │            │
│  │ 70│ 75│ 70│ 80│100│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │11 │12 │13 │14 │15 │            │
│  │110│125│130│145│150│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │16 │17 │18 │19 │20 │            │
│  │160│175│190│210│230│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │21 │22 │23 │24 │25 │            │
│  │250│230│260│275│300│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ○ │ ○ │ ○ │ ○ │ ○ │            │
│  │26 │27 │28 │29 │30 │            │  ← Future days (gray)
│  │160│175│190│210│230│            │
│  └───┴───┴───┴───┴───┘            │
│                                     │
│ Mantieni il ritmo per               │  ← Motivational text
│ raggiungere 5050!                   │
│                                     │
├─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Progress Circle** (margin top: 20px)
   - Position: Centered horizontally
   - Size: 180px diameter
   - Elements:
     - Circle stroke: 15px width, rounded cap
     - Color: Orange `#FF6B00` (fill), Transparent (background)
     - Center text (column, centered):
       - "1250 / 5050": 24px, Bold, White
       - "PUSHUP TOTALI": 14px, Regular, White 70% opacity
       - "25%": 18px, Bold, Orange
   - Flutter hint: `CircularProgressIndicator(value: 0.25, strokeWidth: 15, color: Color(0xFFFF6B00))`

2. **Calendar Title** (margin top: 20px)
   - Position: Centered horizontally
   - Elements:
     - Text: "Giorno 14 di 30", 18px, Medium, White

3. **Calendar Grid** (margin: 15px 16px)
   - Position: Below title
   - Layout: 5 columns × 6 rows (30 days)
   - Spacing: 10px between cells
   - Elements:
     - Grid: `GridView.count(crossAxisCount: 5)`
     - Cells: `CalendarDayCell` custom widget

4. **Calendar Day Cell States**:
   - **Completed Day** (1-13):
     - Background: Orange `#FF6B00`
     - Icon: Checkmark (white, 20px)
     - Day number: 14px, Bold, White
     - Rep count: 12px, Regular, White
   - **Today** (14):
     - Background: Dark gray `#2A2A2A`
     - Border: Orange 2px
     - Day number: 14px, Bold, White
     - Label: "OGGI: 100 PUSHUP" (10px, Bold, White)
     - Rep count: 12px, Regular, White
   - **Future Day** (15-30):
     - Background: Dark gray `#2A2A2A`
     - Day number: 14px, Regular, White
     - Target reps: 12px, Regular, White 70% opacity

5. **Motivational Text** (margin: 20px 16px)
   - Position: Below calendar
   - Elements:
     - Text: "Mantieni il ritmo per raggiungere 5050!", 16px, Regular, White
     - Alignment: Center

6. **Bottom Navigation** (height: 56px, fixed bottom)
   - Position: Fixed bottom, full width
   - Elements:
     - Home icon: Left, "Home" label, Unselected (white 70%)
     - Stats icon: Center, "Stats" label, Selected state (orange)
     - Profile icon: Right, "Profile" label, Unselected (white 70%)

### State Variations

#### Normal State
As shown above (mix of completed, today, and future days).

#### All Days Completed (Goal Reached)
```
┌─────────────────────────────────────┐
│                                     │
│      ┌─────────────────┐            │
│      │                 │  5050      │  ← 100% complete
│      │     ●100%       │  / 5050    │
│      │                 │  PUSHUP    │
│      │                 │  TOTALI    │
│      └─────────────────┘            │
│                                     │
│      Giorno 30 di 30               │
│                                     │
│  ┌───┬───┬───┬───┬───┐            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │  ← All days orange
│  │ 1 │ 2 │ 3 │ 4 │ 5 │            │
│  │ 50│ 60│ 75│ 80│ 75│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │26 │27 │28 │29 │30 │            │
│  │250│230│260│275│300│            │
│  └───┴───┴───┴───┴───┘            │
│                                     │
│    🎉 Obiettivo Raggiunto!          │  ← Success message
│      Complimenti!                   │
│                                     │
├─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```
- Progress circle shows 100% (5050/5050)
- All calendar days orange with checkmarks
- Motivational text replaced by "🎉 Obiettivo Raggiunto! Complimenti!"

#### Streak Broken (Missed Days)
```
┌─────────────────────────────────────┐
│                                     │
│      ┌─────────────────┐            │
│      │                 │  620       │
│      │      ● 12%      │  / 5050    │  ← Only 12% progress
│      │                 │  PUSHUP    │
│      │                 │  TOTALI    │
│      └─────────────────┘            │
│                                     │
│      Giorno 10 di 30               │
│                                     │
│  ┌───┬───┬───┬───┬───┐            │
│  │ ✓ │ ✓ │ ✓ │ ✓ │ ✓ │            │
│  │ 1 │ 2 │ 3 │ 4 │ 5 │            │  ← Days 1-7 completed
│  │ 50│ 60│ 75│ 80│ 75│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ✗ │ ✗ │ ✗ │ ○ │ ○ │            │
│  │ 8 │ 9 │10 │11 │12 │            │  ← Days 8-9 missed (X)
│  │  0│  0│  0│160│175│            │
│  ├───┼───┼───┼───┼───┤            │
│  │ ○ │ ○ │ ○ │ ○ │ ○ │            │
│  │13 │14 │15 │16 │17 │            │  ← Future days
│  │190│210│230│250│275│            │
│  └───┴───┴───┴───┴───┘            │
│                                     │
│  Non arrenderti! Riprendi           │  ← Encouraging message
│  la tua serie oggi.                 │
│                                     │
├─────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]│
└─────────────────────────────────────┘
```
- Progress circle shows reduced percentage (12%)
- Calendar shows X marks for missed days (8-9)
- Motivational text: "Non arrenderti! Riprendi la tua serie oggi."

### Responsive Rules (Desktop/Windows)

**Breakpoint**: >600px width

**Layout changes**:
1. **Progress circle**: Same size (180px)
2. **Calendar grid**: Slightly larger cells (60px × 60px)
3. **Content**: Centered, max width 600px

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│                                                     │
│       ┌─────────────────┐                          │
│       │                 │  1250      / 5050        │
│       │      ● 25%      │  PUSHUP    TOTALI        │
│       │                 │                          │
│       └─────────────────┘                          │
│                                                     │
│       Giorno 14 di 30                              │
│                                                     │
│   ┌────┬────┬────┬────┬────┐                      │
│   │ ✓  │ ✓  │ ✓  │ ✓  │ ✓  │                      │  ← Larger cells
│   │ 1  │ 2  │ 3  │ 4  │ 5  │                      │
│   │ 50 │ 60 │ 75 │ 80 │ 75 │                      │
│   ├────┼────┼────┼────┼────┤                      │
│   │ ✓  │ ✓  │ ✓  │ ✓  │ ✓  │                      │
│   │ 6  │ 7  │ 8  │ 9  │ 10 │                      │
│   │ 70 │ 75 │ 70 │ 80 │100 │                      │
│   └────┴────┴────┴────┴────┘                      │
│                                                     │
│   (calendar grid centered, max width 600px)        │
│                                                     │
│   Mantieni il ritmo per raggiungere 5050!          │
│                                                     │
├─────────────────────────────────────────────────────┤
│  [🏠 Home]  [📊 Stats]  [👤 Profile]               │
└─────────────────────────────────────────────────────┘
```

**Flutter hints**:
- Wrap content in `Center` + `ConstrainedBox(maxWidth: 600)`
- Calendar cells: `SizedBox(width: 60, height: 60)` on desktop

### Flutter Implementation Hints

**Widget structure**:
```dart
Scaffold(
  backgroundColor: Color(0xFF1A1A1A),
  body: SafeArea(
    child: Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            // Progress Circle
            ProgressCircle(
              current: 1250,
              goal: 5050,
              percentage: 0.25,
            ),
            SizedBox(height: 20),

            // Calendar Title
            Text('Giorno 14 di 30', style: AppTextStyles.headlineMedium),
            SizedBox(height: 15),

            // Calendar Grid
            CalendarGrid(
              days: 30,
              currentDay: 14,
              dailyRecords: dailyRecordsMap,
            ),
            SizedBox(height: 20),

            // Motivational Text
            Text(
              'Mantieni il ritmo per raggiungere 5050!',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  ),
  bottomNavigationBar: BottomNavigationBar(...),
)
```

**Components to use**:
- Progress circle: `ProgressCircle` custom widget (`CircularProgressIndicator`)
- Calendar grid: `CalendarGrid` custom widget (`GridView.count`)
- Calendar day cell: `CalendarDayCell` custom widget
- Bottom nav: `BottomNavigationBar`

**State handling**:
- Load daily records from storage (last 30 days)
- Calculate progress percentage: `totalPushups / 5050`
- Determine streak: consecutive days with ≥50 push-ups
- Update motivational text based on streak state

### Navigation

**From**: Bottom nav "Stats" tap (from any screen)
**To**:
- HomeScreen (via bottom nav "Home" tap, switch navigation)
- ProfileScreen (via bottom nav "Profile" tap, switch navigation)
- Calendar day detail (future feature, tap on day cell)

---

## Screen: AchievementPopup (Overlay Widget)

### Purpose
Non-intrusive notification when achievement is unlocked.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────────┐
│  ┌──────────────────────────┐      │  ← Popup container
│  │  🏆 Dieci in Un Row!     │      │     (slides in from top)
│  │                          │      │
│  │  Completa 10 push-up     │      │
│  │  in una serie!           │      │
│  │                          │      │
│  │  +150 punti              │      │
│  └──────────────────────────┘      │
│                                     │
│  (underlying content visible,      │
│   slightly dimmed)                 │
└─────────────────────────────────────┘
```

### Element Hierarchy

1. **Popup Container** (position: top 20px, horizontal margin 5%)
   - Size: 90% screen width, auto height
   - Position: Top of screen (overlay)
   - Animation: Slide-in from top (300ms), slide-out after 3-4s
   - Elements:
     - Background: `#1A1A1A` 90% opacity
     - Border: Orange 2px (`#FF6B00`)
     - Border Radius: 16px
     - Padding: 16px
     - Elevation: 8px (shadow)

2. **Content** (vertical column, centered):
   - Icon: Trophy/star (48px, orange)
   - Title: "Dieci in Un Row!" (20px, Bold, White)
   - Spacing: 8px below title
   - Description: "Completa 10 push-up in una serie!" (16px, Regular, White)
   - Spacing: 8px below description
   - Points: "+150 punti" (14px, Bold, Orange)

3. **Animation Behavior**:
   - Slide-in: Top → -20px (position) (300ms, curve: `easeOut`)
   - Display: 3-4 seconds at position
   - Slide-out: -20px → -100px (off-screen) (300ms, curve: `easeIn`)
   - Auto-dismiss: After slide-out, remove from widget tree
   - User dismiss: Tap anywhere to dismiss immediately (slide-out animation)

4. **Sound Effect**:
   - Play achievement unlock sound when popup appears
   - Sound: Characteristic chime/triumphant sound (2-3 seconds)

### State Variations

#### Normal Achievement (as shown above)
Standard achievement unlock notification.

#### Multiple Achievements (Stacked)
```
┌─────────────────────────────────────┐
│  ┌──────────────────────────┐      │  ← Achievement 2 (newest)
│  │  🏆 Maratona!            │      │
│  │  500 push-up oggi!       │      │
│  │  +500 punti              │      │
│  └──────────────────────────┘      │
│  ┌──────────────────────────┐      │  ← Achievement 1 (older)
│  │  🏆 Dieci in Un Row!     │      │     (sliding out)
│  │  Completa 10 push-up     │      │
│  │  +150 punti              │      │
│  └──────────────────────────┘      │
│                                     │
└─────────────────────────────────────┘
```
- If multiple achievements unlock simultaneously, show stacked
- Newest achievement on top, oldest below
- Each dismisses independently after 3-4s
- Max 3 visible at once (older ones dismissed immediately if >3)

### Flutter Implementation Hints

**Widget structure**:
```dart
class AchievementPopup extends StatefulWidget {
  final Achievement achievement;

  @override
  _AchievementPopupState createState() => _AchievementPopupState();
}

class _AchievementPopupState extends State<AchievementPopup>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1), // Start off-screen (top)
      end: Offset(0, -0.1), // End at top position
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // Auto-dismiss after 3-4 seconds
    Future.delayed(Duration(seconds: 4), () {
      if (mounted) {
        _controller.reverse().then((_) {
          // Remove from widget tree
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: GestureDetector(
        onTap: () {
          // Dismiss on tap
          _controller.reverse();
        },
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFF1A1A1A).withOpacity(0.9),
              border: Border.all(color: Color(0xFFFF6B00), width: 2),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events, size: 48, color: Color(0xFFFF6B00)),
                SizedBox(height: 8),
                Text(
                  widget.achievement.name,
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                SizedBox(height: 8),
                Text(
                  widget.achievement.description,
                  style: TextStyle(fontSize: 16, color: Colors.white),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  '+${widget.achievement.points} punti',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFFF6B00)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

**Usage**:
```dart
// Show popup when achievement unlocked
void showAchievementPopup(BuildContext context, Achievement achievement) {
  OverlayEntry? overlayEntry;

  overlayEntry = OverlayEntry(
    builder: (context) => AchievementPopup(achievement: achievement),
  );

  Overlay.of(context).insert(overlayEntry);

  // Auto-remove after animation completes (4.3s total)
  Future.delayed(Duration(milliseconds: 4300), () {
    overlayEntry?.remove();
  });
}
```

**Components to use**:
- Animation: `SlideTransition` with `AnimationController`
- Icon: `Icons.emoji_events` (trophy) or custom asset
- Sound: `AudioPlayer` to play achievement sound

**State handling**:
- Manage overlay entry lifecycle (insert, auto-remove)
- Play sound effect when popup appears
- Support stacking multiple popups (if needed)

### Navigation

**Trigger**: Automatic when achievement condition met
**Display**: Overlay (doesn't affect navigation stack)
**Dismiss**: Auto after 3-4s OR tap to dismiss immediately

---

## Responsive Design Summary

### Mobile (<600px width)
- Bottom navigation: 56px height, 3 icons
- Full-width elements (buttons, cards)
- Single-column layouts
- Countdown circle: 280px
- Progress circle: 180px

### Desktop/Tablet (>600px width)
- Content centered, max width 600px
- Bottom navigation: Same as mobile (56px height)
- Countdown circle: 320px (slightly larger)
- Progress circle: 180px (same)
- Calendar cells: 60px × 60px (larger)

### Flutter Responsive Implementation

```dart
// Use LayoutBuilder for responsive decisions
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth > 600) {
      // Desktop layout
      return DesktopLayout();
    } else {
      // Mobile layout
      return MobileLayout();
    }
  },
)

// Use ConstrainedBox for content width
ConstrainedBox(
  constraints: BoxConstraints(maxWidth: 600),
  child: content,
)

// Use MediaQuery for sizing
final circleSize = MediaQuery.of(context).size.width > 600
    ? 320.0
    : 280.0;
```

---

## Implementation Priority

### Phase 1: Core Screens (Must-Have for v1.0)
1. **HomeScreen**: Entry point, start workout
2. **SeriesSelectionScreen**: Configure workout parameters
3. **WorkoutExecutionScreen**: Main workout interface ⭐ **MOST CRITICAL**
4. **StatisticsScreen**: View progress and calendar
5. **AchievementPopup**: Non-intrusive notification overlay

### Phase 2: Placeholder Screens (v1.0)
1. **ProfileScreen**: Placeholder for future expansion
2. **SettingsScreen**: Configure app preferences (if time permits)

---

## Notes for Developers

### Color Usage Guidelines
- **Primary Orange (`#FF6B00`)**: Use for all primary actions, buttons, active states
- **Deep Orange-Red (`#FF4500`)**: Use for critical actions (TERMINA button), borders
- **Green (`#4CAF50`)**: Use only for recovery timer (full recovery state), success indicators
- **Red (`#F44336`)**: Use only for recovery timer (critical state), errors
- **White (`#FFFFFF`)**: Use for all primary text on dark backgrounds
- **70% White**: Use for secondary text, hints, subtitles

### Typography Guidelines
- **Montserrat Bold**: Use for titles, important numbers, labels
- **Montserrat Regular**: Use for body text, descriptions, button text
- **Font sizes**: Follow defined text styles (do not use arbitrary sizes)

### Spacing Guidelines
- **16px**: Standard padding for most containers
- **20px**: Large spacing between major sections
- **8px**: Small gaps between related elements
- **10px**: Calendar grid cell spacing
- **12px**: Card padding, tight padding

### Animation Guidelines
- **300ms**: Standard animation duration (transitions, button presses)
- **500ms**: Flashing animation (recovery timer urgent state)
- **3-4s**: Achievement popup display duration
- **200ms**: Countdown circle tap animation
- **1s**: Recovery timer color transition

### Testing Checklist
- [ ] All screens match mockup visual specifications
- [ ] All states (normal, loading, error, empty, success) implemented
- [ ] Responsive design works on mobile and desktop
- [ ] Animations are smooth (60fps)
- [ ] Touch targets are at least 48×48px (mobile)
- [ ] Color contrast meets accessibility standards (WCAG AA)
- [ ] All navigation flows work correctly
- [ ] Achievement popup appears and dismisses correctly
- [ ] Recovery timer color transitions work as specified

---

## End of UI Mockup Document

**Next Steps**:
1. Implement components from Component Library first
2. Build screens in priority order (Home → Series Selection → Workout → Stats)
3. Add navigation flows between screens
4. Implement state management and persistence
5. Add animations and polish
6. Test on mobile and desktop platforms
7. Perform visual regression testing with golden tests
