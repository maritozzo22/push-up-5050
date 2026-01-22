---
name: ui-mockup-generator
description: >
  Generate detailed UI mockups with ASCII art and CSS specifications for Flutter apps.
  Use after PRD is complete to create visual specifications before implementation.
  Triggers: "create mockup", "generate ui mockup", "design screens", "ui layout", "visual spec".
triggers:
  - create mockup
  - generate ui mockup
  - design screens
  - ui layout
  - visual spec
  - mockup from prd
  - screen design
  - interface mockup
---

# UI Mockup Generator

Generate detailed, implementation-ready UI mockups that bridge the gap between PRD and code—designed to ensure every screen is visually specified before writing a single line of Flutter.

## Philosophy: Visual Thinking Before Implementation

Vague UI specs lead to wrong implementations, endless revisions, and frustration. **Detailed visual specifications are the blueprint that ensures what gets built matches what was imagined.**

**Core principle: Visual Clarity Prevents Rework**

| Vague Specifications | Detailed Mockups |
|---------------------|------------------|
| "Add a login screen" | ASCII layout + element positioning + states |
| "Make it responsive" | Mobile mockup + responsive rules for desktop |
| "Use primary color" | Exact HEX codes + where each color applies |
| "Put navigation somewhere" | Navigation flow + route map + interaction types |
| "Add error handling" | Error state mockups + inline/empty/loading states |

### Before Generating Mockups, Ask

**Step 1: Understand Context**
- **What app is this for?** Read PRD.md first if it exists
- **What screens need mockups?** Get complete list of screens
- **What's the app type?** Game, productivity, utility, social (affects layout patterns)
- **Any reference images?** If user provides screenshots, analyze them for layout/color/style patterns

**Step 2: Design System Questions**
- **Color scheme?** Primary, secondary, background, accent, error colors (in HEX)
- **Typography?** Font style (modern, playful, professional), sizes
- **Visual style?** Minimal, playful, professional, dark mode, custom
- **Spacing system?** Standard padding/margin values (8, 12, 16, 24px)

**Step 3: Screen-Specific Questions (Ask for EACH screen before generating)**
- **What's the screen purpose?** What user does here
- **What are the main elements?** List all UI components
- **How should elements be arranged?** Top-to-bottom, left-to-right, grid, list
- **What states does this screen have?** Loading, error, empty, success, normal
- **How do you navigate away?** Back button, home indicator, swipe gestures
- **Any unique layout needs?** Custom shapes, overlapping elements, animations

**Step 4: Responsive Breakpoints**
- **Target platforms?** Windows desktop, Android, iOS, or all
- **Primary target?** Design for mobile-first or desktop-first
- **Special responsive needs?** Foldables, tablets, different orientations

### Core Principles

1. **Visual Clarity First**: Every element has a clear position, size, and purpose
2. **Complete State Coverage**: Every screen includes all states (loading, error, empty, success, normal)
3. **Responsive by Design**: Mobile mockup + responsive rules for larger screens
4. **Precise Specifications**: HEX colors, pixel dimensions, Flutter widget hints
5. **Navigation Explicit**: Flow, routes, and interaction types clearly specified
6. **Component Library**: Reusable components defined once, referenced everywhere

### Mental Model: The Mockup Hierarchy

```
MOCKUP.md
├── Design System (colors, typography, spacing)
├── Component Library (reusable widgets: Button, Card, Input, etc.)
├── Navigation Flow (user flows + route map + interaction types)
└── Screen Mockups (one per screen)
    ├── ASCII Layout (mobile visual representation)
    ├── Element List (all UI elements with positions)
    ├── State Variations (loading, error, empty, success)
    └── Responsive Rules (how layout adapts to larger screens)
```

Every level builds on the previous one. Design system informs components, components inform screens, screens inform navigation.

---

## Quick Start: The Step-by-Step Workflow

### Phase 1: Read PRD and Ask Questions

**Read PRD.md** if it exists to understand:
- App type and purpose
- Complete screen list
- User journey flows
- Design preferences

**Use AskUserQuestion** to gather design system info:

```
Q: What's the primary color scheme?
Options:
- A) Blue professional (#2196F3 primary, #1976D2 secondary)
- B) Green nature (#4CAF50 primary, #388E3C secondary)
- C) Custom HEX codes (user specifies)
- D) Minimal grayscale (black, white, gray only)

Q: What visual style?
Options:
- A) Minimal (clean, white space, simple)
- B) Playful (colorful, rounded, animations)
- C) Professional (structured, grid-based, business)
- D) Dark mode (dark background, light text)
```

### Phase 2: Generate Design System Section

Create **Design System** section in MOCKUP.md with:

**Colors** (HEX only):
```markdown
### Color Palette
- **Primary**: #2196F3 (main actions, selected items)
- **Secondary**: #1976D2 (secondary actions, accents)
- **Background**: #FFFFFF (main), #F5F5F5 (secondary)
- **Surface**: #FFFFFF (cards, sheets)
- **Error**: #E53935
- **Success**: #4CAF50
- **Warning**: #FF9800
- **On Primary**: #FFFFFF (text/icons on primary color)
- **On Background**: #212121 (main text), #757575 (secondary text)
```

**Typography**:
```markdown
### Typography
**Font Style**: Modern sans-serif (system default)

**Text Styles**:
- **Headline Large**: 32px, Bold, #212121 (screen titles)
- **Headline Medium**: 24px, Bold, #212121 (section headers)
- **Body Large**: 16px, Regular, #212121 (primary text)
- **Body Medium**: 14px, Regular, #212121 (secondary text)
- **Caption**: 12px, Regular, #757575 (helper text)
```

**Spacing**:
```markdown
### Spacing System
- **XS**: 4px
- **S**: 8px (small gaps)
- **M**: 16px (standard padding/margin)
- **L**: 24px (large spacing)
- **XL**: 32px (section separation)
```

### Phase 3: Generate Component Library

Define reusable components with exact specifications:

```markdown
## Component Library

### PrimaryButton
**Purpose**: Main call-to-action buttons
**Size**: Height 48px, min-width 120px
**Padding**: Horizontal 24px, Vertical 16px
**Background**: Primary color (#2196F3)
**Text**: 16px, Bold, On Primary (#FFFFFF)
**Border Radius**: 8px
**Elevation**: 2px (shadow)
**Flutter hint**: `ElevatedButton(style: ElevatedButton.styleFrom(...))`

**States**:
- Normal: Primary background, white text
- Disabled: #BDBDBD background, #757575 text
- Loading: Show CircularProgressIndicator
- Pressed: Darken primary by 20%

### SecondaryButton
**Purpose**: Secondary actions, cancel buttons
**Size**: Height 48px, min-width 120px
**Padding**: Horizontal 24px, Vertical 16px
**Background**: Transparent
**Border**: 2px solid Primary (#2196F3)
**Text**: 16px, Bold, Primary (#2196F3)
**Border Radius**: 8px
**Flutter hint**: `OutlinedButton(style: OutlinedButton.styleFrom(...))`

### Card
**Purpose**: Container for related content
**Padding**: 16px
**Background**: Surface (#FFFFFF)
**Border Radius**: 12px
**Elevation**: 1px (subtle shadow)
**Margin**: 8px (vertical spacing between cards)
**Flutter hint**: `Card(elevation: 1, shape: RoundedRectangleBorder(...))`

### InputTextField
**Purpose**: User text input
**Height**: 56px
**Padding**: Horizontal 16px, Vertical 12px
**Border**: 1px solid #E0E0E0
**Border Radius**: 8px
**Text**: 16px, Regular, #212121
**Label**: 14px, Regular, #757575 (floats up when focused)
**Error**: 12px, Regular, Error (#E53935) (shows below input)
**Flutter hint**: `TextField(decoration: InputDecoration(...))`

**States**:
- Normal: Grey border
- Focused: Primary border (#2196F3, 2px)
- Error: Error border (#E53935, 2px)
- Disabled: #EEEEEE background, #BDBDBD border

### [Continue for all reusable components...]
```

### Phase 4: Generate Navigation Flow

Create **Navigation Flow** section with:

```markdown
## Navigation Flow

### User Flow: [Main App Flow]

**Flow: App Launch → Home → [Feature] → [Result]**

1. **App Launch**
   - Screen: SplashScreen (3 seconds)
   - Navigates to: HomeScreen

2. **HomeScreen**
   - Screen: HomeScreen
   - User can: Tap feature cards, use bottom navigation
   - Navigates to:
     - FeatureAScreen (via tap)
     - ProfileScreen (via bottom nav)
     - SettingsScreen (via bottom nav)

3. **[Continue for all screens in flow...]

### Route Map

```
App
├── SplashScreen → HomeScreen
├── HomeScreen
│   ├── → FeatureAScreen (push)
│   ├── → FeatureBScreen (push)
│   └── BottomNav
│       ├── → ProfileScreen (switch)
│       ├── → SettingsScreen (switch)
│       └── → HomeScreen (switch)
├── ProfileScreen
│   ├── → EditProfileScreen (push)
│   └── Back: HomeScreen
└── SettingsScreen
    ├── → ThemeSettingsScreen (push)
    └── Back: HomeScreen
```

### Navigation Types

- **Push**: Navigate to new screen, adds to back stack (FeatureAScreen)
- **Switch**: Replace current screen, no back stack (Bottom nav)
- **Pop**: Return to previous screen (back button)
- **Replace**: Replace current screen, remove from back stack (login → home)

### Navigation Elements

**Desktop Navigation**:
- Sidebar: Fixed width 200px, always visible
- Top bar: Height 60px, app title + settings icon
- Back button: In top bar left

**Mobile Navigation**:
- Top bar: Height 56px, back button + title
- Bottom nav: Height 56px, 3-5 icons
- Back button: In top bar left (chevron icon)
```

### Phase 5: Generate Screen Mockups (One at a Time)

**For EACH screen**:

1. **Ask screen-specific questions** (use AskUserQuestion)
2. **Generate ASCII layout** (mobile version)
3. **List all elements** with positions
4. **Generate all state variations** (loading, error, empty, success)
5. **Add responsive rules** for larger screens

#### Screen Mockup Template

```markdown
## Screen: HomeScreen

### Purpose
Main app screen showing feature cards and navigation.

### ASCII Layout (Mobile)

┌─────────────────────────────┐
│ ← Home           ⚙️  [+]    │  ← Top bar (56px height)
├─────────────────────────────┤
│                             │
│  Welcome to AppName!        │  ← Hero text (padding 16px)
│  Select a feature to start  │
│                             │
├─────────────────────────────┤
│ ┌─────────────────────────┐ │
│ │ [Icon]                  │ │
│ │ Feature A               │ │
│ │ Description here        │ │  ← Feature Card 1 (padding 16px)
│ │ [PrimaryButton]         │ │     (margin 8px vertical)
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ [Icon]                  │ │
│ │ Feature B               │ │  ← Feature Card 2
│ │ Description here        │ │
│ │ [PrimaryButton]         │ │
│ └─────────────────────────┘ │
│                             │
│ ┌─────────────────────────┐ │
│ │ [Icon]                  │ │
│ │ Feature C               │ │  ← Feature Card 3
│ │ Description here        │ │
│ │ [PrimaryButton]         │ │
│ └─────────────────────────┘ │
├─────────────────────────────┤
│ [🏠 Home] [👤 Profile] [⚙️] │  ← Bottom nav (56px height)
└─────────────────────────────┘

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px, elevation: 4px)
   - Position: Fixed top
   - Background: Surface (#FFFFFF)
   - Elements:
     - Back button: Left, 24px padding, chevron left icon
     - Title: Center, "Home", Headline Medium
     - Settings icon: Right, 24px padding, gear icon
     - Add button: Right of settings, 16px gap, plus icon

2. **Hero Section** (padding: 16px)
   - Position: Below top bar
   - Elements:
     - Title: "Welcome to AppName!", Headline Large, centered
     - Subtitle: "Select a feature to start", Body Medium, centered
     - Spacing: 8px between title and subtitle

3. **Feature List** (margin top: 16px)
   - Position: Below hero section
   - Layout: Single column scrollable
   - Elements: FeatureCard components (see Component Library)
   - Spacing: 8px vertical margin between cards

4. **Bottom Navigation** (height: 56px, elevation: 8px)
   - Position: Fixed bottom
   - Background: Surface (#FFFFFF)
   - Elements:
     - Home icon: Left, "Home" label below, selected state
     - Profile icon: Center, "Profile" label below
     - Settings icon: Right, "Settings" label below
   - Selected item: Primary color icon, primary color text

### State Variations

#### Loading State
```markdown
┌─────────────────────────────┐
│ ← Home           ⚙️  [+]    │
├─────────────────────────────┤
│                             │
│      [CircularProgress]     │  ← Centered loading indicator
│      Loading features...    │  ← Caption text
│                             │
└─────────────────────────────┤
│ [🏠 Home] [👤 Profile] [⚙️] │
└─────────────────────────────┘
```
- Replace feature list with CircularProgressIndicator
- Show "Loading features..." text (Caption, centered)
- All other elements remain

#### Error State
```markdown
┌─────────────────────────────┐
│ ← Home           ⚙️  [+]    │
├─────────────────────────────┤
│                             │
│      [⚠️ Error Icon]        │  ← Error icon (48px)
│   Failed to load features   │  ← Body Large text
│  [SecondaryButton]          │  ← "Retry" button
│       Retry                 │
│                             │
└─────────────────────────────┤
│ [🏠 Home] [👤 Profile] [⚙️] │
└─────────────────────────────┘
```
- Replace feature list with error icon + message
- Show retry button (SecondaryButton)
- Error message: "Failed to load features" (Body Large, Error color)

#### Empty State
```markdown
┌─────────────────────────────┐
│ ← Home           ⚙️  [+]    │
├─────────────────────────────┤
│                             │
│      [📭 Empty Icon]        │  ← Empty state icon (48px)
│    No features available    │  ← Body Large text
│   Add your first feature    │  ← Body Medium text
│  [PrimaryButton]            │  ← "Add Feature" button
│     Add Feature             │
│                             │
└─────────────────────────────┤
│ [🏠 Home] [👤 Profile] [⚙️] │
└─────────────────────────────┘
```
- Replace feature list with empty state icon
- Show "No features available" message
- Show "Add Feature" button (PrimaryButton)

### Responsive Rules (Desktop)

**Breakpoint**: >600px width (tablet/desktop)

**Layout changes**:
1. **Top bar**: Height increases to 64px, settings + add buttons move to right side
2. **Feature list**: Changes to 2-column grid
3. **Bottom navigation**: Becomes sidebar navigation (fixed left, width 200px)
4. **Cards**: Maximum width 400px per card, centered in grid columns

**Desktop layout**:
```markdown
┌─────────────────────────────────────────────────────┐
│  ← Home         AppName            ⚙️  [+]         │  ← Top bar (64px)
├──────┬──────────────────────────────────────────────┤
│      │                                               │
│ Side │  Welcome to AppName!                          │
│ bar  │  Select a feature to start                    │
│      │                                               │
│ 🏠   │  ┌──────────────┐  ┌──────────────┐          │
│ 👤   │  │ [Icon]       │  │ [Icon]       │          │
│ ⚙️   │  │ Feature A    │  │ Feature B    │          │
│      │  │ Description  │  │ Description  │          │
│      │  │ [Button]     │  │ [Button]     │          │
│      │  └──────────────┘  └──────────────┘          │
│      │                                               │
│(200px)│  ┌──────────────┐  ┌──────────────┐          │
│      │  │ [Icon]       │  │ [Icon]       │          │
│      │  │ Feature C    │  │ Feature D    │          │
│      │  │ Description  │  │ Description  │          │
│      │  │ [Button]     │  │ [Button]     │          │
│      │  └──────────────┘  └──────────────┘          │
└──────┴───────────────────────────────────────────────┘

Sidebar:
- Fixed left, width 200px
- Background: #F5F5F5
- Navigation items: Icon + Label, vertical stack
- Selected item: Primary color background
```

**Flutter hints**:
- Use `LayoutBuilder` to detect breakpoint: `if (constraints.maxWidth > 600)`
- Desktop: `Row(children: [NavigationRail(width: 200), Expanded(child: content)])`
- Mobile: `Column(children: [content, BottomNavigationBar()])`
- Grid: `GridView.count(crossAxisCount: 2)` for desktop feature list

### Flutter Implementation Hints

**Widget structure**:
```dart
Scaffold(
  appBar: AppBar(title: Text('Home'), leading: BackButton()),
  body: LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth > 600) {
        return DesktopHomeLayout();  // Sidebar + grid
      } else {
        return MobileHomeLayout();  // Bottom nav + list
      }
    },
  ),
)
```

**Components to use**:
- Top bar: `AppBar` with `leading`, `title`, `actions`
- Feature cards: `Card` widget from Component Library
- Loading: `CircularProgressIndicator` centered
- Error/empty: `Column` with icon + text + button
- Bottom nav: `BottomNavigationBar`
- Desktop sidebar: `NavigationRail`

**State handling**:
- Use `FutureBuilder` for loading/success/error states
- Show loading indicator when `connectionState == waiting`
- Show error state when `hasError`
- Show empty state when `data.isEmpty`
- Show success state when data is present

### Navigation

**From**: SplashScreen (after 3 seconds)
**To**:
- FeatureAScreen (via feature card tap, push navigation)
- FeatureBScreen (via feature card tap, push navigation)
- ProfileScreen (via bottom nav tap, switch navigation)
- SettingsScreen (via settings icon tap, push navigation)

**Back behavior**:
- Desktop: No back button (sidebar always visible)
- Mobile: Back button in top bar, pops to SplashScreen

---

## Screen: [NextScreenName]

[Repeat template for each screen...]

---

## [Continue for all screens...]
```

### Phase 6: Review and Refine

After generating all screens:

1. **Review navigation flow**: Ensure every screen has clear "from" and "to" navigation
2. **Check component consistency**: Ensure all screens use components from Component Library
3. **Verify state coverage**: Ensure every screen has all 5 states (normal, loading, error, empty, success)
4. **Confirm responsive rules**: Ensure every screen has desktop/tablet responsive rules

---

## Output Format

**Single file**: `MOCKUP.md`

**File structure**:
```markdown
# UI Mockup: [AppName]

## Design System
- Colors
- Typography
- Spacing

## Component Library
- Button
- Card
- Input
- [etc.]

## Navigation Flow
- User flows
- Route map
- Navigation types

## Screen: ScreenName1
- ASCII layout (mobile)
- Element hierarchy
- State variations
- Responsive rules

## Screen: ScreenName2
[...]

## Screen: ScreenNameN
[...]
```

---

## Anti-Patterns to Avoid

❌ **Vague Element Descriptions**
Why wrong: "Button somewhere on screen" is impossible to implement correctly
Better: "Button positioned 16px from bottom, centered horizontally, 48px height"

❌ **Missing States**
Why wrong: Implementing only normal state leads to broken UI when loading/error/empty
Better: Always include all 5 states (normal, loading, error, empty, success) for every screen

❌ **RGB or Named Colors**
Why wrong: RGB is verbose, named colors are ambiguous ("primary blue"?)
Better: Always use HEX codes only (#2196F3 not "rgb(33, 150, 243)" or "blue")

❌ **ASCII Art for Desktop Only**
Why wrong: Desktop layouts are too complex for ASCII, hard to visualize
Better: ASCII for mobile + responsive rules text for desktop/tablet

❌ **Generic Component Names**
Why wrong: "Button1", "Widget2" conveys nothing about purpose or styling
Better: Descriptive names (PrimaryButton, CancelButton, SubmitButton)

❌ **Ignoring Navigation**
Why wrong: Screens in isolation don't show how users move through app
Better: Always include navigation flow + route map + interaction types for every screen

❌ **Missing Responsive Rules**
Why wrong: Mobile-only mockups leave implementation guessing for desktop/tablet
Better: Every screen has "Responsive Rules" section with desktop/tablet layout changes

❌ **Pixel-Only Dimensions Without Flutter Hints**
Why wrong: Designers think in pixels, developers need Flutter widgets
Better: Include both: "200px width (use: SizedBox(width: 200))"

❌ **Single State Screens**
Why wrong: Real apps have loading, errors, empty data—not just happy path
Better: 5 ASCII layouts per screen (normal, loading, error, empty, success)

❌ **Component Duplication**
Why wrong: Defining same button/card/input in every screen creates inconsistency
Better: Define once in Component Library, reference by name in screens

❌ **No Typography Scale**
Why wrong: Arbitrary font sizes (13px, 17px, 23px) create visual chaos
Better: Defined text styles (Headline Large, Body Medium, Caption) used consistently

❌ **Hardcoded Values Instead of Design Tokens**
Why wrong: "padding: 16px" repeated 100 times makes global changes impossible
Better: "padding: AppSizes.paddingMedium" (define in Design System)

---

## Variation Guidance

**IMPORTANT**: Mockups should vary based on app type, user preferences, and context.

**Vary across dimensions**:
- **App type**: Games use playful layouts, productivity uses structured grids, utilities use minimal single-screens
- **Visual style**: Dark mode vs light mode, minimal vs colorful, professional vs playful
- **Navigation patterns**: Sidebar vs bottom nav vs top tabs vs drawer
- **Layout patterns**: List vs grid vs card-based vs single-column
- **Component styles**: Rounded corners vs sharp, filled vs outlined, elevated vs flat

**Context should drive mockup design**:
- **Game app** → Full-screen layouts, vibrant colors, overlay navigation, animated elements, custom widgets
- **Productivity app** → Structured grids, subtle colors, sidebar navigation, standard widgets, data-focused
- **Social app** → Card-based feeds, bottom navigation, profile-heavy, avatars, media-rich
- **Utility app** → Single-screen minimal, large buttons, clear actions, simple navigation, tool-focused

**Avoid one-size-fits-all**:
- ❌ Same bottom nav for every app (games don't use bottom nav)
- ❌ Same card style for every app (games use custom shapes, utilities use simple buttons)
- ❌ Same color scheme for every app (games are vibrant, finance is conservative)
- ❌ Same navigation pattern (desktop uses sidebars, mobile uses bottom nav)

**Layout should vary by screen purpose**:
- **Dashboard** → Grid layout, summary cards, charts
- **Feed/Stream** → Single column scrollable, card-based, infinite scroll
- **Form** → Vertical layout, input fields, submit button fixed bottom
- **Detail view** → Hero content, actions top-right, scrollable details
- **Settings** → Grouped sections, list items, toggles/switches

**Responsive behavior should vary**:
- **Desktop-first app** → Sidebar navigation, multi-column layouts, hover states
- **Mobile-first app** → Bottom navigation, single column, touch-optimized
- **Tablet** → Hybrid approach (sidebar + bottom nav, 2-3 column grids)

---

## Remember

**Detailed visual specifications are the blueprint for correct implementation.**

The best UI mockups:
- Use ASCII art for mobile layouts + responsive rules for larger screens
- Include all 5 states (normal, loading, error, empty, success) for every screen
- Specify exact HEX colors, pixel dimensions, and Flutter widget hints
- Define reusable components once in Component Library
- Make navigation explicit (flows, routes, interaction types)
- Ask questions before generating to understand user's vision
- Vary based on app type, visual style, and screen purpose
- Are complete specifications that need no guessing during implementation

**A hour spent on detailed mockups saves days of revision and rework.**

**Great UIs aren't guessed—they're designed first, then built.**
