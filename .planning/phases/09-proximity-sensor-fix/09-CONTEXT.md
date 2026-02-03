# Phase 09: Proximity Sensor Fix - Context

## Current State

The proximity sensor feature exists but has issues:

### Files Involved

1. **lib/services/proximity_sensor_service.dart**
   - Uses `proximity_sensor` package for Android hardware integration
   - Has debounce logic (300ms) to prevent multiple rapid triggers
   - Graceful degradation when sensor unavailable (Windows/desktop)
   - Stream of proximity events for reactive UI

2. **lib/screens/settings/settings_screen.dart**
   - Contains proximity sensor toggle in Settings screen (lines 174-186)
   - Toggle controls `AppSettingsService.proximitySensorEnabled`

3. **lib/main.dart**
   - ProximitySensorService is initialized at app root
   - Used to monitor sensor events during workout

### Known Issues

1. **Detection logic may not be working correctly**
   - Current logic: `event > 0` = near (trigger), `event <= 0` = far (ignore)
   - This follows `proximity_sensor` package documentation
   - But user reports sensor not counting push-ups

2. **Toggle in wrong location**
   - Currently in Settings screen
   - Should be in Workout Setup/Series Selection screen
   - User should be able to enable/disable BEFORE starting workout

3. **No feedback during workout**
   - User doesn't know if proximity mode is active
   - No indication when sensor triggers
   - Hard to debug if sensor is working

### User Workflow

Current (broken):
1. User goes to Settings
2. Enables proximity sensor toggle
3. Starts workout
4. Tries to use sensor (chest near phone on ground)
5. **No counts register**

Desired:
1. User goes to Workout Setup/Series Selection
2. Sees "Use Proximity Sensor" toggle
3. Enables it if desired
4. Starts workout
5. Phone on ground, chest approaches
6. **Each rep counts correctly**

## Technical Details

### Proximity Sensor Behavior

The `proximity_sensor` package emits:
- `event > 0`: object is NEAR sensor (trigger)
- `event <= 0`: object is FAR from sensor (ignore)

For push-up counting:
- **Far** → chest away from phone (user at top of push-up)
- **Near** → chest close to phone (user at bottom of push-up)
- Count should trigger on **Near** detection

### Testing Limitations

**Important:** Proximity sensor cannot be tested on:
- **Emulator**: No sensor hardware
- **Web**: Different API
- **Windows**: No sensor hardware

**Testing requires:**
- Physical Android device
- Phone placed on floor
- Actual push-up motion to test

## Success Metrics

After this phase:
1. Proximity sensor correctly counts push-ups (farnear = 1 rep)
2. Toggle appears in Workout Setup screen (not Settings)
3. User can enable/disable proximity before workout
4. Sensor works with phone placed on ground
