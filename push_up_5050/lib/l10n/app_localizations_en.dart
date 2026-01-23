// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'PUSHUP 5050';

  @override
  String get homeTitle => 'PUSHUP 5050';

  @override
  String get workoutInProgress => 'Workout in Progress';

  @override
  String get statsTitle => 'Statistics';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get start => 'START';

  @override
  String get beginWorkout => 'START WORKOUT';

  @override
  String get pause => 'PAUSE';

  @override
  String get resume => 'RESUME';

  @override
  String get end => 'END';

  @override
  String get saveAndReturn => 'SAVE AND RETURN HOME';

  @override
  String get startingSeries => 'Starting Series';

  @override
  String get restTime => 'Recovery Time (seconds)';

  @override
  String get totalReps => 'Total Reps';

  @override
  String get kcalBurned => 'Kcal Burned';

  @override
  String get currentLevel => 'Current Level';

  @override
  String get currentSeries => 'Series';

  @override
  String get ofWord => 'of';

  @override
  String todayPushups(int count) {
    return 'TODAY: $count PUSHUP';
  }

  @override
  String get pushupTotal => 'TOTAL PUSHUPS';

  @override
  String get touchToCount => 'Tap to Count';

  @override
  String get progressiveSeriesHint =>
      'Progressive Series (e.g., Series 3 = 3 pushups)';

  @override
  String get baseRecoveryHint => 'Base 10s, increases with series';

  @override
  String get levelBeginner => 'Beginner';

  @override
  String get levelIntermediate => 'Intermediate';

  @override
  String get levelAdvanced => 'Advanced';

  @override
  String get levelExpert => 'Expert';

  @override
  String get levelMaster => 'Master';

  @override
  String get keepTheRhythm => 'Keep the rhythm to reach 5050!';

  @override
  String get goalReached => '🎉 Goal Reached! Congratulations!';

  @override
  String get dontGiveUp => 'Don\'t give up! Resume your series today.';

  @override
  String achievementUnlocked(String name) {
    return '$name';
  }

  @override
  String achievementPoints(int points) {
    return '+$points points';
  }

  @override
  String get workoutComplete => 'Workout Complete!';

  @override
  String get seriesCompleted => 'Series Completed';

  @override
  String get pushupsTotal => 'Total Push-ups';

  @override
  String get kcal => 'Kcal Burned';

  @override
  String get errorLoadingData => 'Unable to load data';

  @override
  String get retry => 'Retry';

  @override
  String get sensorUnavailable => 'Sensor unavailable. Use the manual button.';

  @override
  String get storageFull =>
      'Insufficient storage space. Free up space and try again.';

  @override
  String get dontLoseStreak => 'Don\'t lose your streak!';

  @override
  String completePushupsReminder(int count) {
    return 'Complete your push-ups today to maintain your multiplier. Only $count push-up to go!';
  }

  @override
  String dayXofY(int current, int total) {
    return 'Day $current of $total';
  }

  @override
  String get settingsProximitySensor => 'Proximity Sensor';

  @override
  String get settingsProximitySensorDesc =>
      'Count repetitions using the proximity sensor';

  @override
  String get settingsHapticFeedback => 'Haptic Feedback';

  @override
  String get settingsHapticFeedbackDesc => 'Light vibration on each repetition';

  @override
  String get settingsHapticIntensity => 'Haptic Intensity';

  @override
  String get settingsDefaultRecoveryTime => 'Default Recovery Time';

  @override
  String get settingsDailyReminder => 'Daily Reminder';

  @override
  String get settingsDailyReminderDesc => 'Remind me to do push-ups every day';

  @override
  String get settingsReminderTime => 'Reminder Time';

  @override
  String get soundsMaster => 'Master Sounds';

  @override
  String get settingsSoundsMaster => 'Master Sounds';

  @override
  String get settingsSoundsMasterDesc => 'Enable/disable all sounds';

  @override
  String get settingsBeepSound => 'Recovery Beep';

  @override
  String get settingsBeepSoundDesc => 'Sound when recovery ends';

  @override
  String get settingsAchievementSound => 'Achievement Sound';

  @override
  String get settingsAchievementSoundDesc =>
      'Sound when you unlock an achievement';

  @override
  String get settingsVolume => 'Volume';

  @override
  String get settingsResetDefaults => 'Reset to Defaults';

  @override
  String get settingsResetConfirm => 'Reset all settings to default values?';

  @override
  String get settingsResetConfirmYes => 'Reset';

  @override
  String get settingsResetConfirmNo => 'Cancel';

  @override
  String get language => 'Language';

  @override
  String get italian => 'Italian';

  @override
  String get english => 'English';

  @override
  String get hapticOff => 'Off';

  @override
  String get hapticLight => 'Light';

  @override
  String get hapticMedium => 'Medium';

  @override
  String get home => 'Home';

  @override
  String get stats => 'Stats';

  @override
  String get profile => 'Profile';

  @override
  String get settings => 'Settings';

  @override
  String get loading => 'Loading...';

  @override
  String get startFirstWorkout => 'Start your first workout today!';

  @override
  String get pushupToday => 'Push-ups Today';

  @override
  String get currentSeriesLabel => 'Current Series';

  @override
  String get days => 'days';

  @override
  String get noActiveWorkout => 'No Active Workout';

  @override
  String get backToHome => 'Back to Home';

  @override
  String get totalRepsLabel => 'Total Reps:';

  @override
  String get kcalLabel => 'Kcal:';

  @override
  String get recovery => 'Recovery...';

  @override
  String get inPause => 'PAUSED';

  @override
  String get profileTitle => 'Profile';

  @override
  String get level => 'Level';

  @override
  String get points => 'Points';

  @override
  String get streak => 'Streak';

  @override
  String get daysLabel => 'Days';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get unlocked => 'Unlocked';

  @override
  String get pointsLowercase => 'points';

  @override
  String get sensors => 'Sensors';

  @override
  String get feedback => 'Feedback';

  @override
  String get workout => 'Workout';

  @override
  String get notifications => 'Notifications';

  @override
  String get audio => 'Audio';

  @override
  String workoutSeriesBadge(int series) {
    return 'Series $series';
  }

  @override
  String workoutSeriesOfTotal(int current, int total) {
    return 'Series $current of $total';
  }

  @override
  String achievementsCount(int unlocked, int total) {
    return 'Achievements ($unlocked/$total)';
  }

  @override
  String unlockedDate(String date) {
    return 'Unlocked: $date';
  }

  @override
  String get seriesCompletedLabel => 'Series Completed';

  @override
  String seriesRange(int start, int end) {
    return '$start-$end';
  }

  @override
  String get timeSpent => 'Time Spent';

  @override
  String get pointsEarnedLabel => 'Points Earned';

  @override
  String get streakMultiplierLabel => 'Streak Multiplier';

  @override
  String get newlyUnlocked => 'Newly Unlocked';

  @override
  String get noAchievementsThisTime => 'No achievements unlocked this time';

  @override
  String get continueToHome => 'CONTINUE';

  @override
  String get onboardingWelcomeTitle => 'Welcome to Push-Up 5050';

  @override
  String get onboardingWelcomeSubtitle =>
      'Your journey to 5050 push-ups starts here';

  @override
  String get onboardingPhilosophyTitle => 'Take Your Time';

  @override
  String get onboardingPhilosophyText =>
      'You can take 1 month, 1 year, or 5 years. The only thing that matters is consistency.';

  @override
  String get onboardingHowItWorksTitle => 'How It Works';

  @override
  String get onboardingProgressiveSeries => 'Progressive Series';

  @override
  String get onboardingProgressiveSeriesDesc =>
      'Series 1 = 1 push-up, Series 2 = 2 push-ups...';

  @override
  String get onboardingStreakTracking => 'Streak Tracking';

  @override
  String get onboardingStreakTrackingDesc =>
      'Track consecutive days to earn multipliers';

  @override
  String get onboardingPointsSystem => 'Points System';

  @override
  String get onboardingPointsSystemDesc =>
      'Earn points for every workout completed';

  @override
  String get onboardingAchievements => 'Achievements';

  @override
  String get onboardingAchievementsDesc => 'Unlock badges as you progress';

  @override
  String get onboardingGoalTitle => 'Set Your Goals';

  @override
  String get onboardingDailyGoal => 'Daily Goal';

  @override
  String get onboardingMonthlyGoal => 'Monthly Goal';

  @override
  String get onboardingPushups => 'push-ups';

  @override
  String onboardingProgressPreview(String time) {
    return 'At this pace, you\'ll reach 5050 in $time';
  }

  @override
  String get onboardingGetStarted => 'Get Started';

  @override
  String get onboardingBack => 'Back';

  @override
  String get onboardingNext => 'Next';

  @override
  String get settingsRestartTutorial => 'Restart Tutorial';

  @override
  String get settingsRestartTutorialDesc =>
      'Go through the onboarding flow again';
}
