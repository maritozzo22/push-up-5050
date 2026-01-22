# Codebase Concerns

**Analysis Date:** 2026-01-20

## Tech Debt

**Unimplemented Weekly Chart Data:**
- Issue: Weekly chart displays placeholder data instead of real user statistics
- Files: `push_up_5050/lib/widgets/statistics/weekly_chart_painter.dart` (lines 11-12, 50)
- Impact: Statistics screen shows misleading progress information
- Fix approach: Connect WeeklyChartCard to actual data from UserStatsProvider

**Missing Max Reps Tracking:**
- Issue: `getUserStats()` returns hardcoded maxRepsInOneSeries of 0
- Files: `push_up_5050/lib/repositories/storage_service.dart` (line 201)
- Impact: Missing important fitness metric in user statistics
- Fix approach: Track max reps per series in WorkoutSession and update statistics

**Haptic Intensity Hardcoded Italian:**
- Issue: HapticIntensityExtension.label returns Italian strings
- Files: `push_up_5050/lib/models/haptic_intensity.dart` (line 22)
- Impact: Breaking internationalization
- Fix approach: Use localized label method everywhere or remove hardcoded strings

## Known Bugs

**Memory Leak Potential:**
- Symptoms: App may not clean up resources on background/foreground transitions
- Files: `push_up_5050/lib/services/audio_service.dart`, `push_up_5050/lib/services/proximity_sensor_service.dart`
- Trigger: App backgrounding during workout session
- Workaround: Manual app restart

**JSON Corruption Handling:**
- Symptoms: App may crash on malformed stored data
- Files: `push_up_5050/lib/repositories/storage_service.dart`
- Trigger: Corrupted shared_preferences data
- Workaround: Automatic clearing of corrupted data (partial protection)

**Color Precision Issues in Tests:**
- Symptoms: Golden tests may fail due to color opacity differences
- Files: Test files throughout
- Trigger: Floating-point precision in color calculations
- Workaround: Use `.alpha` instead of `.opacity` in test comparisons

## Security Considerations

**Notification Permissions:**
- Risk: App requests sensitive notification permissions without proper fallback
- Files: `push_up_5050/lib/services/notification_service.dart`
- Current mitigation: Graceful degradation on permission denial
- Recommendations: Add option to disable notifications if permissions denied

**No Data Encryption:**
- Risk: User workout data stored in plain text in SharedPreferences
- Files: `push_up_5050/lib/repositories/storage_service.dart`
- Current mitigation: None
- Recommendations: Encrypt sensitive data before storage

**Proximity Sensor Permission:**
- Risk: Sensor access requires runtime permission not currently requested
- Files: `push_up_5050/lib/services/proximity_sensor_service.dart`
- Current mitigation: Graceful fallback to manual counting
- Recommendations: Implement proper permission request flow

## Performance Bottlenecks

**Large Test Files:**
- Problem: Test files exceed 800 lines each
- Files: `push_up_5050/test/screens/workout_execution/workout_execution_screen_test.dart` (1042 lines)
- Cause: Monolithic test suites
- Improvement path: Split into focused test files by feature

**JSON Encoding/Decoding:**
- Problem: Frequent JSON serialization during workout sessions
- Files: `push_up_5050/lib/repositories/storage_service.dart`
- Cause: Session saved on every rep update
- Improvement path: Implement batch saving with debouncing

**Widget Rebuilds:**
- Problem: Statistics screen may rebuild unnecessarily
- Files: `push_up_5050/lib/screens/statistics/statistics_screen.dart`
- Cause: No proper state management separation
- Improvement path: Use const widgets and selective providers

## Fragile Areas

**Date Parsing Logic:**
- Component: Date formatting for storage keys
- Files: `push_up_5050/lib/repositories/storage_service.dart`
- Why fragile: Manual string manipulation without validation
- Safe modification: Use DateFormat from intl package
- Test coverage: Present but could be expanded

**Notification Scheduling:**
- Component: Daily reminder scheduling
- Files: `push_up_5050/lib/services/notification_service.dart`
- Why fragile: Complex platform-specific logic with multiple failure points
- Safe modification: Add more robust error handling and retry logic
- Test coverage: Integration tests present

**Proximity Sensor Fallback:**
- Component: Sensor to manual button transition
- Files: `push_up_5050/lib/services/proximity_sensor_service.dart`
- Why fragile: State machine can get out of sync
- Safe modification: Add explicit state validation checks
- Test coverage: Present but could cover edge cases better

## Scaling Limits

**SharedPreferences Size Limit:**
- Current capacity: ~1MB total storage
- Limit: May hit limit with long-term user data
- Scaling path: Implement data pruning or switch to SQLite for large datasets

**Daily Records Growth:**
- Current capacity: No automatic cleanup
- Limit: Performance degradation after 1+ years of daily data
- Scaling path: Implement archive/cleanup of old records

**In-Memory Provider State:**
- Current capacity: Limited by device RAM
- Limit: May grow with session complexity
- Scaling path: Implement persistence for all provider states

## Dependencies at Risk

**proximity_sensor: ^1.3.8:**
- Risk: Package appears unmaintained (last update 2022)
- Impact: May break on future Android versions
- Migration plan: Implement custom sensor integration or remove sensor feature

**flutter_local_notifications: ^17.2.3:**
- Risk: Major version changes may break API
- Impact: Notification functionality may stop working
- Migration plan: Monitor for breaking changes in updates

**vibration: ^3.1.0:**
- Risk: Limited platform support
- Impact: Haptic feedback may not work on all devices
- Migration plan: Implement native vibration interface if issues arise

## Missing Critical Features

**Data Export/Backup:**
- Problem: No way to export user workout data
- Blocks: User data portability
- Priority: Medium

**Progress Analytics:**
- Problem: No trend analysis or insights
- Blocks: User motivation through progress insights
- Priority: Medium

**Workout History Search:**
- Problem: No search/filtering of past sessions
- Blocks: Data analysis for advanced users
- Priority: Low

## Test Coverage Gaps

**Service Layer Unit Tests:**
- What's not tested: Audio service, proximity sensor service
- Files: `push_up_5050/lib/services/`
- Risk: Changes may break critical functionality silently
- Priority: High

**Error Scenarios:**
- What's not tested: Low storage, permission denial, sensor unavailable
- Files: Service tests
- Risk: App fails gracefully not guaranteed
- Priority: High

**Widget Interaction Tests:**
- What's not tested: Complex widget state transitions
- Files: Widget test files
- Risk: UI may behave unexpectedly during user interactions
- Priority: Medium

---

*Concerns audit: 2026-01-20*