# STATE.md

**Project:** Push-Up 5050 - Android Widgets
**Last Updated:** 2026-01-23

## Current State

**Phase:** Phase 2.8 - App Polish & Tutorial
**Next Phase:** Phase 2.8 - App Polish & Tutorial (1 plan remaining)
**Status:** Plan 03 complete

**Progress: ████████████████░░ 50%** (Phase 2.8: 2/4 plans complete)

## Recent Activity

### 2026-01-23
- **Completed Phase 2.8 Plan 03:** Onboarding Tutorial with Goal Configuration
  - Created 3-page onboarding flow (Welcome, How It Works, Goal Configuration)
  - Added 24 localization keys for English and Italian
  - Extended StorageService with dailyGoal, monthlyGoal, onboardingCompleted, resetOnboarding
  - Integrated first-run detection gate in main.dart with FutureBuilder
  - Added Restart Tutorial button in Settings with confirmation dialog
  - Commits: 472162b, 1f84c35, 0b61166, 5b05748, 9d94613, 96dd41d

- **Completed Phase 2.8 Plan 04:** App Launcher Icon Configuration
  - Generated standard launcher icons (ic_launcher.png) for all Android densities
  - Created adaptive icon configuration with black background (#000000)
  - Generated adaptive icon foreground assets for all densities
  - Created colors.xml with ic_launcher_background color
  - Successfully built debug APK with new icons
  - Commit: 33e98ff

### 2026-01-22
- **Completed Phase 2.7 Plan 03:** Widget Provider Implementation
  - Updated PushupWidgetQuickStartProvider to use R.layout.pushup_widget_4x4
  - Added getDayLabels() method for locale-based day labels (IT: L M M G V S D, EN: M T W T F S S)
  - Updated updateCalendarDays() to use new widget_day_chip_* drawables
  - Verified PushupWidgetSmallProvider uses R.layout.pushup_widget_2x1
  - Created pushup_widget_2x1_info.xml for correct size registration
  - AndroidManifest verified with correct widget info file references
  - Commits: da5651d, 62a15cb, 7c5b37a

- **Completed Phase 2.7 Plan 02:** Widget Layouts
  - Created pushup_widget_4x4.xml with 4 vertical sections matching template
  - Created pushup_widget_2x1.xml with centered stats and 3-day view
  - Created pushup_widget_4x4_info.xml with targetCellWidth=4 targetCellHeight=4 (fixes 2x2 bug)
  - Updated pushup_widget_small_info.xml to point to new 2x1 layout
  - View IDs preserved for provider compatibility: today_count, total_count, start_button_container, day_1-7, day_yesterday_*, day_today_*, day_tomorrow_*
  - Commits: 24991c8, bb77f98, 5d3971a

- **Completed Phase 2.7 Plan 01:** Widget Drawable Resources
  - Created centralized widget_colors.xml with 13 color values matching templates
  - Created 4x4 widget drawables (6 files): background, top panel, start button, day chips
  - Created 2x1 widget drawables (3 files): background, top panel, day chip selector
  - All colors use @color/widget_* references for consistency
  - Corner radii: 28dp (4x4), 26dp (2x1) as per template specs
  - Commits: 6774c57, b2b8382, 32e3b4a

- **Completed Phase 2.6 Plan 04:** WorkManager Midnight Update for Calendar Refresh
  - Added WorkManager dependency (androidx.work:work-runtime-ktx:2.9.0)
  - Created MidnightWidgetUpdateWorker for 00:01 daily widget refresh
  - Created WidgetUpdateReceiver for boot-persistent scheduling
  - Added MethodChannel endpoint for Flutter-side scheduling trigger
  - WidgetUpdateService.initialize() now schedules midnight update automatically
  - Added 4 tests for midnight update functionality
  - All 26 tests passing
  - Commits: 170894d, 03b0999, 73b83d8, 08d3b09, 1f36674, 7fa07a0

- **Completed Phase 2.6 Plan 03:** Update Android Widget Providers with Calendar Rendering
  - Created drawable resources: day_indicator_glow, streak_connector, day_indicator_missed_new
  - Updated PushupWidgetQuickStartProvider to parse weekDayData from JSON
  - Updated PushupWidgetSmallProvider to parse threeDayData from JSON
  - Updated widget layouts with reduced day circle sizes (24dp)
  - Added 8 integration tests for calendar widget data flow
  - All tests passing
  - Commits: ef73cf4, ab7b3a9, e56b48c, fefaf20, 515e89d

- **Completed Phase 2.6 Plan 02:** Integrate Calendar Service with Widget Updates
  - WidgetUpdateService integrates with WidgetCalendarService via optional dependency
  - Added buildWidgetData() method for calendar-enriched widget data
  - Includes week data (7 days Mon-Sun) and 3-day data (Ieri/Oggi/Domani)
  - UserStatsProvider uses buildWidgetData() in _updateWidgets()
  - Backward compatible: works without calendar service (graceful degradation)
  - 5 new calendar integration tests added
  - Commits: 1e64a61, 6ca01ef, dba5262

- **Completed Phase 2.6 Plan 01:** Create Calendar Service for Widget Data
  - Created WidgetCalendarService with week data generation (Mon-Sun)
  - Added CalendarDayStatus enum (completed, missed, pending, today)
  - Added WeekDayData and WeekData models with JSON serialization
  - Implemented getWeekData(), getThreeDayData(), isDayMissed() methods
  - Italian day labels: L, M, M, G, V, S, D (Lunedi-Domenica)
  - 3-day view labels: I (Ieri), O (Oggi), D (Domani)
  - Streak line calculation for consecutive days
  - Extended WidgetData with weekDayData, threeDayData, hasStreakLine
  - Added WidgetData.withCalendarData() factory
  - 20 tests passing, backward compatibility maintained
  - Commits: 5dac759, f657cef

### 2026-01-21
- **Completed Phase 2.2 Plan 03b:** Implement Flutter Deep Link Handling
  - Added routeName constant to SeriesSelectionScreen (/series_selection)
  - Created DeepLinkService with MethodChannel communication
  - Integrated deep link handling into main.dart with navigatorKey
  - Converted MyApp to StatefulWidget for service initialization
  - Commits: ea8b656, 20e260c, 2dd45e5

### 2026-01-21 (Earlier)
- **Completed Phase 2.2 Plan 03a:** Configure Android Deep Link Handling
  - Added deep link intent filter to AndroidManifest (pushup5050://series_selection)
  - Extended MainActivity with MethodChannel for deep link communication
  - Updated widget START button to use deep link PendingIntent
  - Commits: ea8b656, 20e260c, 22ea682

### 2026-01-21 (Earlier)
- **Completed Phase 2.2 Plan 02b:** Update Widget Layout XML
  - Created widget_font.xml with sans-serif-medium and sans-serif font families
  - Added logo content description strings (EN/IT)
  - Updated pushup_widget_stats.xml layout to use drawable resources
  - Applied proper typography (today: 36sp, total: 28sp, labels: 12sp, units: 11sp)
  - Note: Drawable resources from plan 02a were created as blocking fix (Rule 3)
  - Commits: 8b651b1, b8a7237, 4ac5b18

### 2026-01-21 (Earlier)
- **Completed Phase 2.2 Plan 02a:** Create Widget Drawable Resources
  - Created widget_background.xml with 28dp corner radius and dark theme (#121212)
  - Created widget_start_button_background.xml with orange glow effect (#FF6B00)
  - Created widget_start_button_selector.xml for pressed state handling
  - Created ic_widget_logo.xml as 24dp vector drawable with clock icon
  - All drawables follow app design system colors
- **Commits:** f81bd11, df70832, 6957f0c

### 2026-01-21 (Earlier)
- **Completed Phase 2.2 Plan 01:** Implement Widget Data Loading from home_widget
  - Updated PushupWidgetStatsProvider.kt to read from home_widget storage
  - Uses HomeWidgetPlugin.getData() with 'pushup_json_data' key
  - Parses JSON with JSONObject for todayPushups, totalPushups, goalPushups
  - Created integration tests for WidgetData JSON serialization (5 tests)
  - Added localized widget strings (EN: TODAY/TOTAL, IT: OGGI/TOTALE)
  - All tests passing
- **Commits:** 2bf6396 (test), d988470 (feat), 614ddc0 (feat)

### 2026-01-21 (Earlier)
- **Completed Phase 2.1 Plan 03:** Add Integration Tests
  - Created integration_test/widget_update_integration_test.dart
  - 11 integration tests covering widget update flow
  - WidgetData serialization/deserialization tests
  - WidgetUpdateService functionality tests
  - Provider integration tests (UserStatsProvider, ActiveWorkoutProvider)
  - All tests passing
- **Commit:** fa8406e

### 2026-01-21 (Earlier)
- **Completed Phase 2.1 Plan 02:** Integrate Widget Updates into App State
  - Added WidgetUpdateService dependency to UserStatsProvider
  - Added WidgetUpdateService dependency to ActiveWorkoutProvider
  - Initialized WidgetUpdateService in main.dart
  - Widgets now update automatically when stats load or workout completes
  - All tests passing
- **Commits:** f979cb9, f6c2dd2, 2f90232

### 2026-01-21 (Earlier)
- **Completed Phase 2.1 Plan 01:** Verify & Fix Widget Infrastructure
  - Upgraded home_widget from 0.5.0 to 0.9.0 for Flutter SDK compatibility
  - Fixed WidgetUpdateService API to match home_widget v0.9.0
  - Corrected widget ID constants to match AndroidManifest receiver names
  - All 26 tests passing (17 widget_update_service + 9 widget_data)
- **Commits:** b07afa7 (chore), 8cc4831 (fix)

### 2026-01-21 (Planning)
- **Created Phase 2.1 execution plan:** 3 plans in 3 waves
  - Plan 01 (Wave 1): Verify dependencies, fix widget ID mismatch
  - Plan 02 (Wave 2): Integrate widget updates into app state providers
  - Plan 03 (Wave 3): Add integration tests for end-to-end widget updates
- **Updated ROADMAP.md** with Phase 2.1 plan breakdown
- **Updated STATE.md** with current planning status

### 2026-01-20
- **Mapped codebase** (7 analysis documents in `.planning/codebase/`)
- **Initialized GSD project framework**
- **Created PROJECT.md** with project overview
- **Created ROADMAP.md** with 5 phases for Android widgets
- **Completed RESEARCH.md** for Phase 2.1 (Foundation & Setup)

## Current Work

**Phase 2.6: Widget Redesign — IN PROGRESS**

### Plans Status:
1. **02.6-01-PLAN.md** — ✅ Create Calendar Service for Widget Data (COMPLETE)
2. **02.6-02-PLAN.md** — ✅ Integrate Calendar Service with Widget Updates (COMPLETE)
3. **02.6-03-PLAN.md** — ✅ Update Android Widget Providers with Calendar Rendering (COMPLETE)
4. **02.6-04-PLAN.md** — ✅ WorkManager Midnight Update (COMPLETE)
5. **02.6-05-PLAN.md** — Pending: Widget Testing & Verification

## Completed Work

### Milestone 1: Core Flutter App ✅
- Progressive workout system
- Statistics tracking
- Achievement system
- Settings and preferences
- All existing features functional

### Phase 2.1 Foundation & Setup ✅
**All 3 plans complete:**

#### Plan 01: Verify & Fix Widget Infrastructure
- Upgraded home_widget to 0.9.0 (b07afa7)
- Fixed WidgetUpdateService API and widget IDs (8cc4831)
- All tests passing (26 unit tests)

#### Plan 02: Integrate Widget Updates into App State
- UserStatsProvider widget integration (f979cb9)
- ActiveWorkoutProvider widget integration (f6c2dd2)
- main.dart WidgetUpdateService initialization (2f90232)
- All tests passing

#### Plan 03: Add Integration Tests
- Created integration_test/widget_update_integration_test.dart (fa8406e)
- 11 integration tests covering:
  - WidgetData serialization/deserialization
  - WidgetUpdateService functionality
  - Provider integration
  - App launch verification
- All tests passing

### Phase 2.1 Research ✅
- Researched home_widget plugin capabilities
- Verified existing infrastructure
- Identified widget ID mismatch issue
- Documented standard patterns and pitfalls

### Phase 2.2 Plan 01: Widget Data Loading ✅
- PushupWidgetStatsProvider reads from home_widget storage (d988470)
- Integration tests for WidgetData JSON serialization (2bf6396)
- Localized widget strings (EN/IT) created (614ddc0)
- Data flow: Flutter -> WidgetUpdateService -> home_widget -> Android widget

### Phase 2.2 Plan 02a: Widget Drawable Resources ✅
- Widget background with 28dp corner radius (created as part of 02b)
- START button with glow effect using layer-list (created as part of 02b)
- Button selector for pressed state (created as part of 02b)
- Logo icon as 24dp vector drawable (created as part of 02b)

### Phase 2.2 Plan 02b: Widget Layout XML ✅
- Font family resource created (sans-serif-medium)
- Layout updated to use drawable resources
- Proper typography applied (36sp, 28sp, 12sp, 11sp)
- Logo icon in header
- Localized labels with string resources

### Phase 2.2 Plan 03a: Android Deep Link Handling ✅
- AndroidManifest intent-filter for pushup5050://series_selection (ea8b656)
- MainActivity MethodChannel for deep link communication (20e260c)
- Widget START button deep link PendingIntent (22ea682)
- Custom URL scheme (no HTTPS verification needed)
- FLAG_ACTIVITY_CLEAR_TOP + FLAG_ACTIVITY_SINGLE_TOP prevents duplicate activities

### Phase 2.2 Plan 03b: Flutter Deep Link Handling ✅
- SeriesSelectionScreen routeName constant added (ea8b656)
- DeepLinkService created with MethodChannel communication (20e260c)
- MyApp converted to StatefulWidget for service initialization (2dd45e5)
- navigatorKey pattern for programmatic navigation from service layer
- onGenerateRoute handler for /series_selection route

### Phase 2.6 Plan 01: Calendar Service for Widget Data ✅
- Created WidgetCalendarService with 424 lines (5dac759)
- Created 20 tests with 469 lines (f657cef)
- CalendarDayStatus enum: completed, missed, pending, today
- WeekDayData: day, dayLabel, status, pushups, isPartOfStreak
- WeekData: 7 days (Mon-Sun) with hasStreakLine flag
- Italian labels: L, M, M, G, V, S, D for week; I, O, D for 3-day
- getWeekData(), getThreeDayData(), isDayMissed() methods
- Extended WidgetData with weekDayData, threeDayData, hasStreakLine
- WidgetData.withCalendarData() factory for easy integration

### Phase 2.6 Plan 02: Integrate Calendar Service with Widget Updates ✅
- WidgetUpdateService with optional WidgetCalendarService dependency (1e64a61)
- Added buildWidgetData() method for calendar-enriched widget data
- UserStatsProvider updated to use buildWidgetData() in _updateWidgets() (6ca01ef)
- Calendar integration tests with MockStorageService (dba5262)
- Backward compatible: works without calendar service
- 5 new tests: week data, 3-day data, streak line, storage save, graceful degradation

### Phase 2.6 Plan 03: Update Android Widget Providers with Calendar Rendering ✅
- Created drawable resources: day_indicator_glow, streak_connector, day_indicator_missed_new (ef73cf4)
- Updated PushupWidgetQuickStartProvider with weekDayData parsing (ab7b3a9)
- Updated PushupWidgetSmallProvider with threeDayData parsing (e56b48c)
- Updated widget layouts with 24dp day circles (fefaf20)
- Added 8 integration tests for calendar data flow (515e89d)
- All tests passing

### Phase 2.6 Plan 04: WorkManager Midnight Update ✅
- Added WorkManager dependency (androidx.work:work-runtime-ktx:2.9.0) (170894d)
- Created MidnightWidgetUpdateWorker for 00:01 daily widget refresh (03b0999)
- Created WidgetUpdateReceiver for boot-persistent scheduling (73b83d8)
- Registered receiver in AndroidManifest with BOOT_COMPLETED intent (08d3b09)
- Added MethodChannel endpoint for Flutter-side scheduling (1f36674)
- WidgetUpdateService.initialize() now schedules midnight update automatically
- Added 4 tests for midnight update functionality (7fa07a0)
- All 26 tests passing

## Known Issues

**None** - All issues resolved.

## Technical Debt

1. **TODO:** Implement widget data caching for offline scenarios (future enhancement)
2. **TODO:** Add widget configuration UI (if needed for user preferences)
3. **TODO:** Consider widget update frequency optimization (currently 30-min via updatePeriodMillis)
4. **TODO:** Streak connector lines not yet rendered in layouts (drawable created but not implemented)

## Dependencies Status

| Package | Version | Status |
|---------|---------|--------|
| home_widget | ^0.9.0 | ✅ Upgraded, working |
| flutter | SDK | ✅ Working |
| provider | ^6.1.1 | ✅ Working |
| shared_preferences | ^2.2.2 | ✅ Working |
| proximity_sensor | ^1.3.8 | ✅ Working |
| audioplayers | ^6.5.1 | ✅ Working |
| flutter_local_notifications | ^17.2.3 | ✅ Working |

## Test Coverage

| Component | Coverage | Status |
|-----------|----------|--------|
| Core app | ~70% | ✅ Meets goal |
| WidgetUpdateService | 100% | ✅ All 17 tests pass |
| WidgetData model | 100% | ✅ All 9 tests pass |
| WidgetCalendarService | 100% | ✅ All 20 tests pass |
| Widget Android integration | 100% | ✅ All 8 calendar tests pass |
| Widget integration (provider level) | 100% | ✅ Code complete |
| Widget integration (E2E) | 100% | ✅ All 11 integration tests pass |

**Total widget-related tests:** 70 (17 update + 9 data + 20 calendar + 8 Android calendar + 11 E2E)

## Decisions Made

### From Phase 2.1-01
- **home_widget v0.9.0 required**: Upgraded from 0.5.0 to fix Flutter SDK compatibility (ViewConfiguration issue)
- **Widget ID naming**: Widget IDs must match AndroidManifest.xml receiver class names without package prefix (e.g., "PushupWidgetStatsProvider")
- **API pattern for updates**: saveWidgetData(id, data) then updateWidget(androidName: 'ClassName')

### From Phase 2.1-02
- **Dependency injection pattern**: WidgetUpdateService injected via constructor into both UserStatsProvider and ActiveWorkoutProvider
- **Single shared instance**: WidgetUpdateService created once in main.dart and shared across providers
- **Silent failure for widget updates**: Try-catch blocks with empty catch blocks - widgets are optional, failures should not crash app
- **Widget update triggers**: After loadStats() in UserStatsProvider, after endWorkout() in ActiveWorkoutProvider

### From Phase 2.1-03
- **Integration test on Windows**: Tests run on Windows desktop during development. Widget updates return false (expected) since home_widget platform features are Android-only.
- **Test isolation**: Each test clears SharedPreferences in setUp() to ensure clean state between test runs.
- **Service availability**: WidgetUpdateService.isAvailable returns true (home_widget handles platform checks gracefully), updateAllWidgets returns bool for success/failure.

### From Phase 2.2-01
- **HomeWidgetPlugin.getData() for reading**: Android widgets use HomeWidgetPlugin.getData() with 'pushup_json_data' key to read data from home_widget storage
- **JSON parsing with JSONObject**: Uses JSONObject.optInt() for safe field extraction with fallback to defaults
- **Shared key pattern**: 'pushup_json_data' key used on both Flutter and Kotlin sides for data access
- **Graceful degradation**: Zeros as defaults when data unavailable or parsing fails

### From Phase 2.2-02a/02b
- **Drawable layer-list for glow effects**: Using offset items in layer-list creates shadow/glow effect on buttons
- **Selector for pressed states**: state_pressed in selector provides visual feedback on button tap
- **Vector drawables for scalability**: 24dp standard size for icons, scales without quality loss
- **System fonts instead of embedded fonts**: Using sans-serif-medium instead of embedding Montserrat (smaller APK, simpler implementation)

### From Phase 2.2-03a
- **Custom URL scheme over HTTPS**: Used pushup5050:// instead of https:// to avoid web asset verification complexity
- **MethodChannel full-duplex communication**: Both getInitialDeepLink (Flutter query) and onDeepLink (Android notification) implemented
- **Activity flags for single-instance**: FLAG_ACTIVITY_NEW_TASK | CLEAR_TOP | SINGLE_TOP prevents duplicate activities

### From Phase 2.2-03b
- **StatefulWidget for MyApp**: Converted from StatelessWidget to enable initState lifecycle for DeepLinkService initialization
- **navigatorKey pattern**: Used GlobalKey<NavigatorState> to enable programmatic navigation from service layer (outside widget tree)
- **postFrameCallback initialization**: Delayed DeepLinkService.initialize() until after first frame to ensure FlutterEngine is ready
- **Route name constants**: Static routeName on screen widgets enables type-safe navigation

### From Phase 2.6-01
- **Test double instead of mockito**: Used custom MockStorageService class instead of mockito due to build_runner issues on Windows; simpler implementation with same test coverage
- **JSON serialization for calendar data**: WeekDayData serialized as Map<String, dynamic> in WidgetData for easier Android widget consumption
- **Italian day labels hardcoded**: L, M, M, G, V, S, D and I/O/D hardcoded in service (no localization library needed for single-character labels)
- **Streak calculation per-widget**: hasStreakLine calculated per week for visual display; separate from app-level streak count

### From Phase 2.6-02
- **Optional dependency injection**: WidgetCalendarService is nullable in WidgetUpdateService constructor, graceful degradation when unavailable
- **buildWidgetData() method**: Centralized widget data creation with calendar enrichment, separates data building from update logic
- **Backward compatibility**: New calendar fields in WidgetData default to empty lists when calendar service unavailable

### From Phase 2.6-03
- **Layer-list for glow effect**: Used multiple layer items with different opacity and offset values to create outer glow matching New-design.md specification
- **JSON-first calendar data**: Android widget providers are passive consumers - Flutter WidgetCalendarService is authoritative source
- **Status string matching**: Used exact string matching ("completed", "missed", "pending", "today") between Flutter and Android for simplicity
- **Reduced day button size**: Changed from 28dp/32dp to 24dp for more compact calendar display
- **Italian labels hardcoded**: Day labels (L,M,M,G,V,S,D and I,O,D) in both layout XML and provider code

### From Phase 2.6-04
- **WorkManager 2.9.0 for background scheduling**: Selected for battery-efficient, boot-persistent periodic tasks with automatic retry
- **00:01 update time**: One minute past midnight avoids edge cases with day transitions and ensures calendar refresh happens after midnight
- **No charging/idle constraints**: Removed constraints to ensure widgets update immediately for accurate calendar display regardless of device state
- **MethodChannel for scheduling**: Allows Flutter app to trigger midnight update scheduling on first launch, ensuring activation without user intervention
- **Graceful degradation**: Midnight update failure is non-fatal - widgets still update on app launch and user-triggered actions

### From Phase 2.7-01
- **Centralized color resources**: All widget colors defined in widget_colors.xml using exact hex values from Flutter templates
- **Template exact match**: Colors (topA=#20262B, topB=#111416, bottomA=#0F1113, bottomB=#0B0D0F, orange=#F46A1E, orange2=#EF7A1A) match template specifications precisely
- **@color references**: All drawables use @color/widget_* references instead of hardcoded hex values for maintainability
- **Corner radius difference**: 4x4 uses 28dp, 2x1 uses 26dp (exactly as specified in templates)
- **Curved edge simulation**: 4x4 top panel's quadraticBezier curve from Flutter approximated using layer-list with rounded corners (Android XML limitation)
- **X mark with rotated shapes**: Missed day chip uses rotated rectangles instead of path element for better Android compatibility

### From Phase 2.7-02
- **4x4 layout structure**: FrameLayout root with LinearLayout vertical container for 4-section stack (top panel, stats, START button, 7-day row)
- **2x1 3-line total format**: Total displayed as 3 separate TextViews (value / slash / goal) matching template's "44 / 5050" visual
- **View ID preservation**: All IDs from existing layouts preserved (today_count, total_count, start_button_container, day_1-7) so providers work without code changes
- **resizeMode=none**: Both widgets use fixed size (no resizing) because templates are designed for specific aspect ratios
- **4x4 size bug fix**: Created pushup_widget_4x4_info.xml with targetCellWidth=4 targetCellHeight=4 (previous widget was incorrectly registered as 2x2)

### From Phase 2.7-03
- **Locale-based day labels**: Added getDayLabels() method checking locale.language for Italian/English labels
- **Drawable name migration**: Updated from day_indicator_* to widget_day_chip_* for visual consistency
- **Widget class name preservation**: Kept receiver names unchanged for HomeWidgetPlugin compatibility
- **Info file naming convention**: Created pushup_widget_2x1_info.xml for clearer size-based naming

### From Phase 2.8-04
- **Source icon selection**: Used GooglePlayStore.png (512x512) from Icone-App-Pushup folder as it meets the recommended size for flutter_launcher_icons
- **Adaptive icon background**: Black (#000000) matches the app's dark theme
- **Foreground layer**: Uses the same icon image for consistency - the push-up figure is centered and recognizable
- **No iOS icons**: iOS generation was disabled (ios: false) in pubspec.yaml as iOS is not a priority for this phase

### From Phase 2.8-03
- **PageController for onboarding navigation**: Used PageView with PageController for swipeable onboarding screens, consistent with Flutter best practices
- **Long-press acceleration pattern**: Reused SeriesSelectionScreen pattern (1x -> 4x over 5 seconds) for consistent UX across goal selection screens
- **FutureBuilder for loading state**: Added loading spinner while checking onboarding status to avoid janky transitions
- **Monthly goal auto-calculated**: Monthly goal defaults to daily * 30, but users can override manually for flexibility
- **localeName property**: AppLocalizations uses `localeName` property (String) not `appLocale` for language detection

## Next Steps

1. **Phase 2.8 Plan 01:** Launch Android emulator and install debug APK
2. **Phase 2.8 Plan 02:** Fix bottom overflow issues in screens
3. **Phase 2.8 Plan 03:** ~~Create onboarding tutorial with goal configuration~~ (COMPLETE)
4. **Phase 2.8 Plan 04:** ~~App Launcher Icon Configuration~~ (COMPLETE)

---

## Roadmap Evolution

- **2026-01-23:** Phase 2.8 added - App Polish & Tutorial
  - Task 1: Launch Android emulator and install debug APK
  - Task 2: Fix bottom overflow issues in screens
  - Task 3: Create onboarding tutorial with goal configuration (daily/monthly goals)
  - Task 4: Set up app logo and icon from `push_up_5050/Icone-App-Pushup/`

- **2026-01-22:** Phase 2.7 Plan 03 completed - Widget Provider Implementation
  - Updated providers to use new layouts (pushup_widget_4x4, pushup_widget_2x1)
  - Added locale-based day label support
  - Created pushup_widget_2x1_info.xml

- **2026-01-22:** Phase 2.7 Plan 02 completed - Widget Layouts
  - Created 4x4 layout with 4 vertical sections (top panel, stats, START button, 7-day row)
  - Created 2x1 layout with centered stats and 3-day view
  - Fixed 4x4 size registration (was 2x2, now 4x4)
  - View IDs preserved for provider compatibility

- **2026-01-22:** Phase 2.7 Plan 01 completed - Widget Drawable Resources
  - Created centralized widget_colors.xml with exact template colors
  - Created 9 drawable resources (6 for 4x4, 3 for 2x1)

- **2026-01-22:** Phase 2.7 added - Widget Rebuild from Templates (2.6 rejected)
  - Previous widget work unsatisfactory (4x4 missing, 2x1 non-functional)
  - Will rebuild from scratch using exact template designs provided
  - Keep: data sync, calendar service, deep links
  - Rebuild: XML layouts, widget providers, size registration
- **2026-01-22:** Phase 2.6 Plan 04 completed - WorkManager midnight update for calendar refresh
- **2026-01-22:** Phase 2.6 Plan 03 completed - Android widget providers updated with calendar rendering
- **2026-01-22:** Phase 2.6 Plan 02 completed - WidgetUpdateService integrated with WidgetCalendarService
- **2026-01-22:** Phase 2.6 Plan 01 completed - WidgetCalendarService created with 20 tests

---

*Last updated: 2026-01-23*
*Last session: 2026-01-23*
*Stopped at: Completed Phase 2.8 Plan 03 - Onboarding Tutorial with Goal Configuration*
*Resume file: None (Plan complete, awaiting checkpoint verification)*
