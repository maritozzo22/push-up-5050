# Example Output: UI Mockup for Task Manager App

This example demonstrates the complete output of ui-mockup-generator for a simple task manager app.

---

## UI Mockup: TaskManager

## Design System

### Color Palette
- **Primary**: #2196F3 (main actions, selected items, checkboxes)
- **Secondary**: #1976D2 (secondary actions, accents)
- **Background**: #FFFFFF (main), #F5F5F5 (secondary)
- **Surface**: #FFFFFF (cards, sheets, dialogs)
- **Error**: #E53935
- **Success**: #4CAF50
- **Warning**: #FF9800
- **On Primary**: #FFFFFF (text/icons on primary color)
- **On Background**: #212121 (main text), #757575 (secondary text)

### Typography
**Font Style**: Modern sans-serif (system default)

**Text Styles**:
- **Headline Large**: 32px, Bold, #212121 (screen titles)
- **Headline Medium**: 24px, Bold, #212121 (section headers)
- **Body Large**: 16px, Regular, #212121 (primary text, task titles)
- **Body Medium**: 14px, Regular, #212121 (secondary text, descriptions)
- **Caption**: 12px, Regular, #757575 (helper text, timestamps)

### Spacing System
- **XS**: 4px (tight gaps)
- **S**: 8px (small gaps, related items)
- **M**: 16px (standard padding/margin)
- **L**: 24px (large spacing, section separation)
- **XL**: 32px (major sections)

---

## Component Library

### TaskCard
**Purpose**: Display single task with checkbox, title, description, actions
**Size**: Min-height 80px, full width
**Padding**: 16px
**Background**: Surface (#FFFFFF)
**Border Radius**: 8px
**Elevation**: 1px (subtle shadow)
**Margin**: 8px (vertical spacing between cards)
**Flutter hint**: `Card(elevation: 1, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)))`

**Layout**:
```
┌─────────────────────────────────┐
│ ☐  Buy groceries                │  ← Checkbox + Title (Body Large)
│    From the supermarket          │  ← Description (Body Medium)
│                    [⋮] [🗑️]      │  ← Actions (right aligned)
└─────────────────────────────────┘
```

**Elements**:
- Checkbox: Left, 24px size, Primary color when checked
- Title: Left of checkbox, 8px gap, Body Large, #212121
- Description: Below title, 4px gap, Body Medium, #757575
- Actions: Right, 16px gap from content, more icon (⋮) + delete icon (🗑️)

**States**:
- Normal: White background, black text
- Completed: Green checkbox (#4CAF50), title strikethrough, opacity 0.7
- Pressed: Grey background (#EEEEEE)
- Swipe left: Reveals delete action (red background)

### PrimaryButton
**Purpose**: Main call-to-action buttons (add task, save)
**Size**: Height 48px, min-width 120px
**Padding**: Horizontal 24px, Vertical 16px
**Background**: Primary (#2196F3)
**Text**: 16px, Bold, #FFFFFF
**Border Radius**: 8px
**Elevation**: 2px (shadow)
**Flutter hint**: `ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF2196F3)))`

### SecondaryButton
**Purpose**: Secondary actions (cancel, dismiss)
**Size**: Height 48px, min-width 120px
**Padding**: Horizontal 24px, Vertical 16px
**Background**: Transparent
**Border**: 2px solid Primary (#2196F3)
**Text**: 16px, Bold, Primary (#2196F3)
**Border Radius**: 8px
**Flutter hint**: `OutlinedButton(style: OutlinedButton.styleFrom(side: BorderSide(color: Color(0xFF2196F3))))`

### FAB (FloatingActionButton)
**Purpose**: Add new task (fixed position)
**Size**: 56px diameter
**Background**: Primary (#2196F3)
**Icon**: Plus icon, #FFFFFF, 24px
**Border Radius**: 16px
**Elevation**: 6px (shadow)
**Position**: Bottom-right, 16px from edge
**Flutter hint**: `FloatingActionButton(backgroundColor: Color(0xFF2196F3), child: Icon(Icons.add))`

### InputTextField
**Purpose**: Task title and description input
**Height**: 56px
**Padding**: Horizontal 16px, Vertical 12px
**Border**: 1px solid #E0E0E0
**Border Radius**: 8px
**Text**: 16px, Regular, #212121
**Label**: 14px, Regular, #757575 (floats up when focused)
**Error**: 12px, Regular, Error (#E53935) (shows below input)
**Flutter hint**: `TextField(decoration: InputDecoration(border: OutlineInputBorder()))`

---

## Navigation Flow

### User Flow: Main App Flow

**Flow: Splash → Home → Add Task → Task Detail → Complete**

1. **SplashScreen** (3 seconds)
   - Shows app logo + name
   - Navigates to: HomeScreen

2. **HomeScreen**
   - Shows task list (today's tasks)
   - User can: Add task (FAB), tap task (view detail), swipe to delete
   - Navigates to:
     - AddTaskScreen (via FAB, push)
     - TaskDetailScreen (via task tap, push)
     - SettingsScreen (via settings icon, push)

3. **AddTaskScreen**
   - Input form for new task
   - User can: Enter title/description, save, cancel
   - Navigates to:
     - HomeScreen (via save, pop with result)
     - HomeScreen (via cancel, pop)

4. **TaskDetailScreen**
   - Show task details + edit
   - User can: Mark complete, edit, delete
   - Navigates to:
     - HomeScreen (via back, pop)
     - EditTaskScreen (via edit, push)

### Route Map

```
App
├── SplashScreen → HomeScreen
├── HomeScreen
│   ├── → AddTaskScreen (push)
│   ├── → TaskDetailScreen (push via task tap)
│   └── → SettingsScreen (push)
├── AddTaskScreen
│   └── → HomeScreen (pop with result)
├── TaskDetailScreen
│   ├── → EditTaskScreen (push)
│   └── Back: HomeScreen (pop)
└── SettingsScreen
    └── Back: HomeScreen (pop)
```

### Navigation Types

- **Push**: Navigate to new screen, adds to back stack (AddTaskScreen, TaskDetailScreen)
- **Pop with result**: Return to previous screen with data (AddTaskScreen → HomeScreen with new task)
- **Pop**: Return to previous screen (back button)

### Navigation Elements

**Mobile Navigation**:
- Top bar: Height 56px, back button + title
- FAB: Bottom-right, 56px, fixed position
- Back button: In top bar left (chevron icon)
- No bottom navigation (single-screen app)

---

## Screen: HomeScreen

### Purpose
Main screen showing today's tasks with FAB to add new tasks.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────┐
│ ← Tasks              ⚙️         │  ← Top bar (56px)
├─────────────────────────────────┤
│                                 │
│  Today, Jan 14                  │  ← Date header (padding 16px)
│  3 tasks remaining              │
│                                 │
│  ┌─────────────────────────────┐│
│  │ ☐  Buy groceries            ││
│  │    From the supermarket      ││  ← TaskCard 1
│  │                    [⋮] [🗑️]  ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │ ☑  Call doctor              ││
│  │    Appointment at 3pm        ││  ← TaskCard 2 (completed)
│  │                    [⋮] [🗑️]  ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │ ☐  Finish project report    ││
│  │    Due tomorrow              ││  ← TaskCard 3
│  │                    [⋮] [🗑️]  ││
│  └─────────────────────────────┘│
│                                 │
└─────────────────────────────────┘
                         [+        │  ← FAB (56px)
```

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px, elevation: 4px)
   - Position: Fixed top
   - Background: Surface (#FFFFFF)
   - Elements:
     - Back button: Hidden (home is root)
     - Title: Left, 16px padding, "Tasks", Headline Medium
     - Settings icon: Right, 16px padding, gear icon

2. **Date Header** (padding: 16px)
   - Position: Below top bar
   - Elements:
     - Date: "Today, Jan 14", Body Large, #212121
     - Count: "3 tasks remaining", Body Medium, #757575
     - Spacing: 4px between date and count

3. **Task List** (margin top: 8px)
   - Position: Below date header
   - Layout: Single column scrollable
   - Elements: TaskCard components (see Component Library)
   - Spacing: 8px vertical margin between cards
   - Scroll: Vertical scroll when list exceeds screen height

4. **FAB** (size: 56px, elevation: 6px)
   - Position: Fixed bottom-right, 16px from edges
   - Background: Primary (#2196F3)
   - Icon: Plus icon, #FFFFFF, 24px
   - Action: Opens AddTaskScreen

### State Variations

#### Loading State
```
┌─────────────────────────────────┐
│ ← Tasks              ⚙️         │
├─────────────────────────────────┤
│                                 │
│                                 │
│         [CircularProgress]      │  ← Centered loading indicator
│      Loading tasks...           │  ← Caption text
│                                 │
│                                 │
└─────────────────────────────────┘
```
- Hide date header and task list
- Show CircularProgressIndicator centered vertically
- Show "Loading tasks..." text (Caption, centered)
- FAB hidden during loading

#### Error State
```
┌─────────────────────────────────┐
│ ← Tasks              ⚙️         │
├─────────────────────────────────┤
│                                 │
│        [⚠️ Error Icon]          │  ← Error icon (48px)
│   Failed to load tasks          │  ← Body Large text
│   Please check connection       │  ← Body Medium text
│  [SecondaryButton]              │  ← "Retry" button
│         Retry                   │
│                                 │
└─────────────────────────────────┘
```
- Replace task list with error icon + message
- Show retry button (SecondaryButton) centered
- Error message: "Failed to load tasks" (Body Large, Error color)
- Subtext: "Please check connection" (Body Medium, #757575)
- FAB hidden during error

#### Empty State
```
┌─────────────────────────────────┐
│ ← Tasks              ⚙️         │
├─────────────────────────────────┤
│                                 │
│       [📋 Empty Icon]           │  ← Empty state icon (48px)
│    No tasks for today           │  ← Body Large text
│   Tap + to add your first task  │  ← Body Medium text
│                                 │
└─────────────────────────────────┘
                         [+        │
```
- Replace task list with empty state icon
- Show "No tasks for today" message (Body Large, #212121)
- Show "Tap + to add your first task" (Body Medium, #757575)
- FAB visible (encourages adding first task)

### Responsive Rules (Desktop)

**Breakpoint**: >600px width (tablet/desktop)

**Layout changes**:
1. **Top bar**: Height increases to 64px, title left-aligned
2. **Date header**: Moves to top bar right (date + count inline)
3. **Task list**: Centered, max-width 800px
4. **Cards**: Maximum width expanded, better use of horizontal space

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│ Tasks           Today, Jan 14    3 tasks      ⚙️    │  ← Top bar (64px)
├─────────────────────────────────────────────────────┤
│                                                     │
│         ┌─────────────────────────────────────┐    │
│         │  ┌───────────────────────────────┐  │    │
│         │  │ ☐  Buy groceries              │  │    │
│         │  │    From the supermarket        │  │    │  ← Task list
│         │  │                    [⋮] [🗑️]    │  │    │    centered
│         │  └───────────────────────────────┘  │    │    (max-width 800px)
│         │                                     │    │
│         │  ┌───────────────────────────────┐  │    │
│         │  │ ☑  Call doctor                │  │    │
│         │  │    Appointment at 3pm          │  │    │
│         │  │                    [⋮] [🗑️]    │  │    │
│         │  └───────────────────────────────┘  │    │
│         │                                     │    │
│         └─────────────────────────────────────┘    │
│                                                     │
└─────────────────────────────────────────────────────┘
                                              [+       │
```

**Flutter hints**:
- Use `LayoutBuilder` to detect breakpoint: `if (constraints.maxWidth > 600)`
- Desktop: `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 800), child: taskList))`
- Mobile: `taskList` (full width)
- Date header position: Desktop in top bar, mobile separate section

### Navigation

**From**: SplashScreen (after 3 seconds)
**To**:
- AddTaskScreen (via FAB tap, push navigation)
- TaskDetailScreen (via task card tap, push navigation)
- SettingsScreen (via settings icon tap, push navigation)

**Back behavior**:
- No back button (home is root screen)
- System back button exits app (with confirmation)

---

## Screen: AddTaskScreen

### Purpose
Form to add new task with title and description fields.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────┐
│ ← Add Task            ✓         │  ← Top bar (56px)
├─────────────────────────────────┤
│                                 │
│  Task Title                     │  ← Label
│  ┌─────────────────────────────┐│
│  │ Enter task title...         ││  ← Title input
│  └─────────────────────────────┘│
│                                 │
│  Description (optional)         │  ← Label
│  ┌─────────────────────────────┐│
│  │ Enter description...        ││  ← Description input
│  │                             ││     (multiline)
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │      [Error message]        ││  ← Error (shows when validation fails)
│  └─────────────────────────────┘│
│                                 │
└─────────────────────────────────┤
│  [Cancel]        [Save]         │  ← Actions (bottom bar, 56px)
└─────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px, elevation: 4px)
   - Position: Fixed top
   - Background: Surface (#FFFFFF)
   - Elements:
     - Back button: Left, 16px padding, chevron left icon
     - Title: Center, "Add Task", Headline Medium
     - Save icon: Right, 16px padding, checkmark icon (same as bottom save button)

2. **Form Content** (padding: 16px)
   - Position: Below top bar, scrollable
   - Elements:
     - **Title Label**: "Task Title", Body Medium, #757575, 8px bottom margin
     - **Title Input**: InputTextField, single line, placeholder "Enter task title..."
     - **Spacing**: 16px vertical margin
     - **Description Label**: "Description (optional)", Body Medium, #757575, 8px bottom margin
     - **Description Input**: InputTextField, multiline, min-height 100px, placeholder "Enter description..."
     - **Error Message**: Hidden by default, shows when validation fails, 12px, Error color

3. **Bottom Actions** (height: 56px, elevation: 4px)
   - Position: Fixed bottom
   - Background: Surface (#FFFFFF)
   - Elements:
     - Cancel button: Left, 16px padding, SecondaryButton, "Cancel"
     - Save button: Right, 16px padding, PrimaryButton, "Save" (disabled if title is empty)

### State Variations

#### Normal State
- All inputs visible and editable
- Save button disabled (gray) when title is empty
- Save button enabled (primary color) when title has text
- Error message hidden

#### Validation Error State
```
│  ┌─────────────────────────────┐│
│  │ Task title is required      ││  ← Error message visible
│  └─────────────────────────────┘│
```
- Error message appears below description input
- Error text: "Task title is required" (12px, Error color)
- Title input border changes to Error color (#E53935)
- Save button remains disabled

#### Loading State
- Save button shows CircularProgressIndicator
- Cancel button disabled
- All inputs disabled (read-only)
- Top bar back button disabled

#### Success State
- Screen closes automatically
- New task data passed back to HomeScreen
- No visual state (screen pops immediately)

### Responsive Rules (Desktop)

**Breakpoint**: >600px width

**Layout changes**:
1. **Form**: Centered, max-width 600px
2. **Bottom actions**: Move to top bar (cancel + save buttons in top bar right)
3. **Description input**: Expanded width (better use of horizontal space)

**Desktop layout**:
```
┌─────────────────────────────────────────────────────┐
│ ← Add Task              [Cancel] [Save]             │  ← Top bar with actions
├─────────────────────────────────────────────────────┤
│                                                     │
│              ┌─────────────────────────────────┐   │
│              │  Task Title                     │   │
│              │  ┌───────────────────────────┐  │   │  ← Form centered
│              │  │ Enter task title...       │  │   │    (max-width 600px)
│              │  └───────────────────────────┘  │   │
│              │                                 │   │
│              │  Description (optional)         │   │
│              │  ┌───────────────────────────┐  │   │
│              │  │ Enter description...      │  │   │
│              │  │                           │  │   │
│              │  │                           │  │   │
│              │  └───────────────────────────┘  │   │
│              └─────────────────────────────────┘   │
│                                                     │
└─────────────────────────────────────────────────────┘
```

**Flutter hints**:
- Desktop: `actions: [TextButton('Cancel'), TextButton('Save')]` in AppBar
- Mobile: No actions in AppBar, use bottom fixed bar with Row of buttons

### Navigation

**From**: HomeScreen (via FAB tap)
**To**:
- HomeScreen (via cancel, pop without result)
- HomeScreen (via save, pop with new task data)

**Back behavior**:
- Back button in top bar (same as cancel)
- System back button (same as cancel)
- Confirms if user has entered text (optional confirmation dialog)

---

## Screen: TaskDetailScreen

### Purpose
Show task details with option to mark complete or delete.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────┐
│ ← Task Details         [⋮]      │  ← Top bar (56px)
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────────┐│
│  │                             ││
│  │      [Completed Icon]       ││  ← Completion status
│  │      Task completed!        ││     (or checkbox if not complete)
│  │                             ││
│  └─────────────────────────────┘│
│                                 │
│  Buy groceries                  │  ← Title
│                                 │
│  ─────────────────────────      │  ← Divider
│                                 │
│  Description                    │  ← Section header
│                                 │
│  From the supermarket. Need:    │
│  - Milk                         │
│  - Bread                        │  ← Description content
│  - Eggs                         │
│  - Butter                       │
│                                 │
│  ─────────────────────────      │  ← Divider
│                                 │
│  Created: Jan 14, 9:00 AM       │  ← Metadata
│  Due: Jan 14, 6:00 PM           │
│                                 │
└─────────────────────────────────┤
│  [Delete]        [Edit]         │  ← Actions (bottom bar, 56px)
└─────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px, elevation: 4px)
   - Position: Fixed top
   - Background: Surface (#FFFFFF)
   - Elements:
     - Back button: Left, 16px padding, chevron left icon
     - Title: Center, "Task Details", Headline Medium
     - More icon: Right, 16px padding, vertical dots icon (opens menu: edit, delete)

2. **Completion Status** (padding: 24px)
   - Position: Below top bar
   - Background: Success color (#4CAF50) if completed, Surface (#FFFFFF) if not
   - Elements:
     - Icon: Checkmark circle icon, 48px, #FFFFFF (completed) or #757575 (not completed)
     - Text: "Task completed!" or "Mark as complete", Body Large, centered

3. **Task Title** (padding: horizontal 16px, top: 16px)
   - Position: Below completion status
   - Text: Task title, Headline Medium, #212121
   - Strikethrough if completed

4. **Divider** (height: 1px)
   - Background: #E0E0E0
   - Margin: 16px horizontal

5. **Description Section** (padding: 16px)
   - Position: Below divider
   - Elements:
     - Section header: "Description", Body Medium, #757575, 8px bottom margin
     - Content: Task description, Body Large, #212121, multiline

6. **Metadata Section** (padding: 16px)
   - Position: Below description
   - Elements:
     - Created date: "Created: Jan 14, 9:00 AM", Caption, #757575
     - Due date: "Due: Jan 14, 6:00 PM", Caption, #757575 (red if overdue)
     - Spacing: 4px between dates

7. **Bottom Actions** (height: 56px, elevation: 4px)
   - Position: Fixed bottom
   - Background: Surface (#FFFFFF)
   - Elements:
     - Delete button: Left, 16px padding, text button, "Delete", Error color
     - Edit button: Right, 16px padding, outlined button, "Edit"

### State Variations

#### Completed State
- Completion status background: Success (#4CAF50)
- Icon: Checkmark in white circle
- Text: "Task completed!", white
- Title: Strikethrough, opacity 0.7

#### Not Completed State
- Completion status background: Surface (#FFFFFF)
- Icon: Empty checkbox, gray (#757575)
- Text: "Tap to mark complete", gray
- Title: Normal, no strikethrough

#### Overdue State
- Due date text: Error color (#E53935)
- Completion status: Warning border (orange)
- Badge: "Overdue" visible next to title

### Responsive Rules (Desktop)

**Breakpoint**: >600px width

**Layout changes**:
1. **Content**: Centered, max-width 600px
2. **Bottom actions**: Move to top bar (edit + delete buttons in top bar right)
3. **Completion status**: Reduced padding (more compact)

**Flutter hints**:
- Desktop: `actions: [TextButton('Edit'), TextButton('Delete')]` in AppBar
- Mobile: No actions in AppBar, use bottom fixed bar

### Navigation

**From**: HomeScreen (via task tap)
**To**:
- HomeScreen (via back, pop)
- EditTaskScreen (via edit button/tap, push)

**Actions**:
- Mark complete: Toggles completion status, updates UI, auto-saves
- Delete: Shows confirmation dialog, then confirms and returns to HomeScreen

---

## Screen: SettingsScreen

### Purpose
App settings including theme, notifications, about.

### ASCII Layout (Mobile)

```
┌─────────────────────────────────┐
│ ← Settings            [⋮]       │  ← Top bar (56px)
├─────────────────────────────────┤
│                                 │
│  ┌─────────────────────────────┐│
│  │ 🎨  Dark Mode               ││  ← Setting item 1
│  │                        [ ○ ]││     (toggle switch)
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │ 🔔  Notifications            ││  ← Setting item 2
│  │                        [ ✓ ]││     (toggle switch on)
│  └─────────────────────────────┘│
│                                 │
│  ─────────────────────────      │  ← Section divider
│                                 │
│  ┌─────────────────────────────┐│
│  │ ℹ️  About                    ││  ← Setting item 3
│  │                         [→] ││     (chevron right)
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │ 📄  Privacy Policy           ││  ← Setting item 4
│  │                         [→] ││
│  └─────────────────────────────┘│
│                                 │
│  ┌─────────────────────────────┐│
│  │ 🚪  Logout                   ││  ← Setting item 5
│  │                         [→] ││
│  └─────────────────────────────┘│
│                                 │
│                                 │
│  Version 1.0.0                  │  ← Version info (bottom, centered)
│                                 │
└─────────────────────────────────┘
```

### Element Hierarchy (Top-to-Bottom)

1. **Top Bar** (height: 56px, elevation: 4px)
   - Position: Fixed top
   - Background: Surface (#FFFFFF)
   - Elements:
     - Back button: Left, 16px padding, chevron left icon
     - Title: Center, "Settings", Headline Medium

2. **Settings List** (padding: 8px)
   - Position: Below top bar
   - Layout: Single column
   - Elements: SettingItem components
   - Spacing: 8px vertical margin between items

**SettingItem Component**:
- Height: 56px
- Padding: 16px horizontal
- Background: Surface (#FFFFFF)
- Border Radius: 8px
- Elements:
  - Icon: Left, 24px, #757575
  - Label: Left of icon, 16px gap, Body Large, #212121
  - Control: Right (toggle, chevron, switch)

3. **Section Divider** (height: 1px, margin: 16px horizontal)
- Background: #E0E0E0
- Separates setting groups

4. **Version Info** (bottom, padding: 16px)
- Text: "Version 1.0.0"
- Style: Caption, #757575
- Position: Centered horizontally, 16px from bottom

### State Variations

#### Normal State
- All settings visible and editable
- Toggle switches show current state
- Chevron indicates navigation

#### Loading State
- Not applicable (settings load instantly from local storage)

#### Logout Confirmation
When user taps "Logout":
```
┌─────────────────────────────────┐
│                                 │
│         [Warning Icon]          │
│                                 │
│       Are you sure you          │
│       want to logout?           │
│                                 │
│      [Cancel]    [Logout]       │
│                                 │
└─────────────────────────────────┘
```
- Dialog centered on screen
- Warning icon, 48px
- Title: "Are you sure you want to logout?"
- Cancel button: Secondary
- Logout button: Primary, Error color

### Responsive Rules (Desktop)

**Breakpoint**: >600px width

**Layout changes**:
1. **Settings list**: Centered, max-width 600px
2. **Items**: Expanded width, better use of horizontal space

**Flutter hints**:
- Desktop: `Center(child: ConstrainedBox(constraints: BoxConstraints(maxWidth: 600), child: settingsList))`
- Mobile: `settingsList` (full width)

### Navigation

**From**: HomeScreen (via settings icon)
**To**:
- HomeScreen (via back, pop)
- AboutScreen (via about item tap, push)
- PrivacyPolicyScreen (via privacy policy item tap, push)
- LoginScreen (via logout, popToRoot)

---

## Notes

- All screens follow Material Design 3 guidelines
- Animations: Slide transitions for navigation, fade for state changes
- Ripple effects on all clickable elements
- Keyboard: On desktop, support Enter to save, Escape to cancel
- Accessibility: All interactive elements have semantic labels
- Internationalization: All strings hardcoded for v1.0, i18n ready for v2.0
