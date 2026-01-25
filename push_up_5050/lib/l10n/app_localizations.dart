import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_it.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('it')
  ];

  /// No description provided for @appName.
  ///
  /// In it, this message translates to:
  /// **'PUSHUP 5050'**
  String get appName;

  /// No description provided for @homeTitle.
  ///
  /// In it, this message translates to:
  /// **'PUSHUP 5050'**
  String get homeTitle;

  /// No description provided for @workoutInProgress.
  ///
  /// In it, this message translates to:
  /// **'Allenamento in Corso'**
  String get workoutInProgress;

  /// No description provided for @statsTitle.
  ///
  /// In it, this message translates to:
  /// **'Statistiche'**
  String get statsTitle;

  /// No description provided for @settingsTitle.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settingsTitle;

  /// No description provided for @start.
  ///
  /// In it, this message translates to:
  /// **'INIZIA'**
  String get start;

  /// No description provided for @beginWorkout.
  ///
  /// In it, this message translates to:
  /// **'INIZIA ALLENAMENTO'**
  String get beginWorkout;

  /// No description provided for @pause.
  ///
  /// In it, this message translates to:
  /// **'PAUSA'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In it, this message translates to:
  /// **'RIPRENDI'**
  String get resume;

  /// No description provided for @end.
  ///
  /// In it, this message translates to:
  /// **'TERMINA'**
  String get end;

  /// No description provided for @saveAndReturn.
  ///
  /// In it, this message translates to:
  /// **'SALVA E TORNA A HOME'**
  String get saveAndReturn;

  /// No description provided for @startingSeries.
  ///
  /// In it, this message translates to:
  /// **'Serie di Partenza'**
  String get startingSeries;

  /// No description provided for @restTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo di Recupero (secondi)'**
  String get restTime;

  /// No description provided for @totalReps.
  ///
  /// In it, this message translates to:
  /// **'Rep Totali'**
  String get totalReps;

  /// No description provided for @kcalBurned.
  ///
  /// In it, this message translates to:
  /// **'Kcal Bruciate'**
  String get kcalBurned;

  /// No description provided for @currentLevel.
  ///
  /// In it, this message translates to:
  /// **'Livello Attuale'**
  String get currentLevel;

  /// No description provided for @currentSeries.
  ///
  /// In it, this message translates to:
  /// **'Serie'**
  String get currentSeries;

  /// No description provided for @ofWord.
  ///
  /// In it, this message translates to:
  /// **'di'**
  String get ofWord;

  /// No description provided for @todayPushups.
  ///
  /// In it, this message translates to:
  /// **'OGGI: {count} PUSHUP'**
  String todayPushups(int count);

  /// No description provided for @pushupTotal.
  ///
  /// In it, this message translates to:
  /// **'PUSHUP TOTALI'**
  String get pushupTotal;

  /// No description provided for @touchToCount.
  ///
  /// In it, this message translates to:
  /// **'Tocca per Contare'**
  String get touchToCount;

  /// No description provided for @progressiveSeriesHint.
  ///
  /// In it, this message translates to:
  /// **'Progressive Series (e.g., Series 3 = 3 pushups)'**
  String get progressiveSeriesHint;

  /// No description provided for @baseRecoveryHint.
  ///
  /// In it, this message translates to:
  /// **'Base 10s, increases with series'**
  String get baseRecoveryHint;

  /// No description provided for @levelBeginner.
  ///
  /// In it, this message translates to:
  /// **'Beginner'**
  String get levelBeginner;

  /// No description provided for @levelIntermediate.
  ///
  /// In it, this message translates to:
  /// **'Intermediate'**
  String get levelIntermediate;

  /// No description provided for @levelAdvanced.
  ///
  /// In it, this message translates to:
  /// **'Advanced'**
  String get levelAdvanced;

  /// No description provided for @levelExpert.
  ///
  /// In it, this message translates to:
  /// **'Expert'**
  String get levelExpert;

  /// No description provided for @levelMaster.
  ///
  /// In it, this message translates to:
  /// **'Master'**
  String get levelMaster;

  /// No description provided for @keepTheRhythm.
  ///
  /// In it, this message translates to:
  /// **'Mantieni il ritmo per raggiungere 5050!'**
  String get keepTheRhythm;

  /// No description provided for @goalReached.
  ///
  /// In it, this message translates to:
  /// **'🎉 Obiettivo Raggiunto! Complimenti!'**
  String get goalReached;

  /// No description provided for @dontGiveUp.
  ///
  /// In it, this message translates to:
  /// **'Non arrenderti! Riprendi la tua serie oggi.'**
  String get dontGiveUp;

  /// No description provided for @achievementUnlocked.
  ///
  /// In it, this message translates to:
  /// **'{name}'**
  String achievementUnlocked(String name);

  /// No description provided for @achievementPoints.
  ///
  /// In it, this message translates to:
  /// **'+{points} punti'**
  String achievementPoints(int points);

  /// No description provided for @workoutComplete.
  ///
  /// In it, this message translates to:
  /// **'Allenamento Completato!'**
  String get workoutComplete;

  /// No description provided for @seriesCompleted.
  ///
  /// In it, this message translates to:
  /// **'Serie Completate'**
  String get seriesCompleted;

  /// No description provided for @pushupsTotal.
  ///
  /// In it, this message translates to:
  /// **'Push-up Totali'**
  String get pushupsTotal;

  /// No description provided for @kcal.
  ///
  /// In it, this message translates to:
  /// **'Kcal Bruciate'**
  String get kcal;

  /// No description provided for @errorLoadingData.
  ///
  /// In it, this message translates to:
  /// **'Impossibile caricare i dati'**
  String get errorLoadingData;

  /// No description provided for @retry.
  ///
  /// In it, this message translates to:
  /// **'Riprova'**
  String get retry;

  /// No description provided for @sensorUnavailable.
  ///
  /// In it, this message translates to:
  /// **'Sensore non disponibile. Usa il pulsante manuale.'**
  String get sensorUnavailable;

  /// No description provided for @storageFull.
  ///
  /// In it, this message translates to:
  /// **'Spazio di archiviazione insufficiente. Libera spazio e riprova.'**
  String get storageFull;

  /// No description provided for @dontLoseStreak.
  ///
  /// In it, this message translates to:
  /// **'Non perdere la tua serie!'**
  String get dontLoseStreak;

  /// No description provided for @completePushupsReminder.
  ///
  /// In it, this message translates to:
  /// **'Completa i tuoi push-up oggi per mantenere il moltiplicatore. Ti mancano solo {count} push-up!'**
  String completePushupsReminder(int count);

  /// No description provided for @dayXofY.
  ///
  /// In it, this message translates to:
  /// **'Giorno {current} di {total}'**
  String dayXofY(int current, int total);

  /// No description provided for @settingsProximitySensor.
  ///
  /// In it, this message translates to:
  /// **'Sensore di Prossimità'**
  String get settingsProximitySensor;

  /// No description provided for @settingsProximitySensorDesc.
  ///
  /// In it, this message translates to:
  /// **'Conta le ripetizioni usando il sensore di prossimità'**
  String get settingsProximitySensorDesc;

  /// No description provided for @settingsHapticFeedback.
  ///
  /// In it, this message translates to:
  /// **'Feedback Aptico'**
  String get settingsHapticFeedback;

  /// No description provided for @settingsHapticFeedbackDesc.
  ///
  /// In it, this message translates to:
  /// **'Vibrazione leggera ad ogni ripetizione'**
  String get settingsHapticFeedbackDesc;

  /// No description provided for @settingsHapticIntensity.
  ///
  /// In it, this message translates to:
  /// **'Intensità Feedback Aptico'**
  String get settingsHapticIntensity;

  /// No description provided for @settingsDefaultRecoveryTime.
  ///
  /// In it, this message translates to:
  /// **'Tempo Recupero Predefinito'**
  String get settingsDefaultRecoveryTime;

  /// No description provided for @settingsDailyReminder.
  ///
  /// In it, this message translates to:
  /// **'Promemoria Giornaliero'**
  String get settingsDailyReminder;

  /// No description provided for @settingsDailyReminderDesc.
  ///
  /// In it, this message translates to:
  /// **'Ricordami di fare push-up ogni giorno'**
  String get settingsDailyReminderDesc;

  /// No description provided for @settingsReminderTime.
  ///
  /// In it, this message translates to:
  /// **'Orario Promemoria'**
  String get settingsReminderTime;

  /// No description provided for @soundsMaster.
  ///
  /// In it, this message translates to:
  /// **'Suoni Master'**
  String get soundsMaster;

  /// No description provided for @settingsSoundsMaster.
  ///
  /// In it, this message translates to:
  /// **'Suoni Master'**
  String get settingsSoundsMaster;

  /// No description provided for @settingsSoundsMasterDesc.
  ///
  /// In it, this message translates to:
  /// **'Attiva/disattiva tutti i suoni'**
  String get settingsSoundsMasterDesc;

  /// No description provided for @settingsBeepSound.
  ///
  /// In it, this message translates to:
  /// **'Beep di Recupero'**
  String get settingsBeepSound;

  /// No description provided for @settingsBeepSoundDesc.
  ///
  /// In it, this message translates to:
  /// **'Suono quando il recupero termina'**
  String get settingsBeepSoundDesc;

  /// No description provided for @settingsAchievementSound.
  ///
  /// In it, this message translates to:
  /// **'Suono Achievement'**
  String get settingsAchievementSound;

  /// No description provided for @settingsAchievementSoundDesc.
  ///
  /// In it, this message translates to:
  /// **'Suono quando sblocchi un achievement'**
  String get settingsAchievementSoundDesc;

  /// No description provided for @settingsVolume.
  ///
  /// In it, this message translates to:
  /// **'Volume'**
  String get settingsVolume;

  /// No description provided for @settingsResetDefaults.
  ///
  /// In it, this message translates to:
  /// **'Ripristina Predefiniti'**
  String get settingsResetDefaults;

  /// No description provided for @settingsResetConfirm.
  ///
  /// In it, this message translates to:
  /// **'Ripristinare tutte le impostazioni ai valori predefiniti?'**
  String get settingsResetConfirm;

  /// No description provided for @settingsResetConfirmYes.
  ///
  /// In it, this message translates to:
  /// **'Ripristina'**
  String get settingsResetConfirmYes;

  /// No description provided for @settingsResetConfirmNo.
  ///
  /// In it, this message translates to:
  /// **'Annulla'**
  String get settingsResetConfirmNo;

  /// No description provided for @language.
  ///
  /// In it, this message translates to:
  /// **'Lingua'**
  String get language;

  /// No description provided for @italian.
  ///
  /// In it, this message translates to:
  /// **'Italiano'**
  String get italian;

  /// No description provided for @english.
  ///
  /// In it, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @hapticOff.
  ///
  /// In it, this message translates to:
  /// **'Spento'**
  String get hapticOff;

  /// No description provided for @hapticLight.
  ///
  /// In it, this message translates to:
  /// **'Leggero'**
  String get hapticLight;

  /// No description provided for @hapticMedium.
  ///
  /// In it, this message translates to:
  /// **'Medio'**
  String get hapticMedium;

  /// No description provided for @home.
  ///
  /// In it, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @stats.
  ///
  /// In it, this message translates to:
  /// **'Statistiche'**
  String get stats;

  /// No description provided for @profile.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get profile;

  /// No description provided for @settings.
  ///
  /// In it, this message translates to:
  /// **'Impostazioni'**
  String get settings;

  /// No description provided for @loading.
  ///
  /// In it, this message translates to:
  /// **'Caricamento...'**
  String get loading;

  /// No description provided for @startFirstWorkout.
  ///
  /// In it, this message translates to:
  /// **'Inizia il tuo primo allenamento oggi!'**
  String get startFirstWorkout;

  /// No description provided for @pushupToday.
  ///
  /// In it, this message translates to:
  /// **'Push-up Oggi'**
  String get pushupToday;

  /// No description provided for @currentSeriesLabel.
  ///
  /// In it, this message translates to:
  /// **'Serie Attuale'**
  String get currentSeriesLabel;

  /// No description provided for @days.
  ///
  /// In it, this message translates to:
  /// **'giorni'**
  String get days;

  /// No description provided for @noActiveWorkout.
  ///
  /// In it, this message translates to:
  /// **'Nessun Allenamento Attivo'**
  String get noActiveWorkout;

  /// No description provided for @backToHome.
  ///
  /// In it, this message translates to:
  /// **'Torna alla Home'**
  String get backToHome;

  /// No description provided for @totalRepsLabel.
  ///
  /// In it, this message translates to:
  /// **'Rep Totali:'**
  String get totalRepsLabel;

  /// No description provided for @kcalLabel.
  ///
  /// In it, this message translates to:
  /// **'Kcal:'**
  String get kcalLabel;

  /// No description provided for @recovery.
  ///
  /// In it, this message translates to:
  /// **'Recupero...'**
  String get recovery;

  /// No description provided for @inPause.
  ///
  /// In it, this message translates to:
  /// **'IN PAUSA'**
  String get inPause;

  /// No description provided for @profileTitle.
  ///
  /// In it, this message translates to:
  /// **'Profilo'**
  String get profileTitle;

  /// No description provided for @level.
  ///
  /// In it, this message translates to:
  /// **'Livello'**
  String get level;

  /// No description provided for @points.
  ///
  /// In it, this message translates to:
  /// **'Punti'**
  String get points;

  /// No description provided for @streak.
  ///
  /// In it, this message translates to:
  /// **'Striscia'**
  String get streak;

  /// No description provided for @daysLabel.
  ///
  /// In it, this message translates to:
  /// **'Giorni'**
  String get daysLabel;

  /// No description provided for @achievementsTitle.
  ///
  /// In it, this message translates to:
  /// **'Achievements'**
  String get achievementsTitle;

  /// No description provided for @unlocked.
  ///
  /// In it, this message translates to:
  /// **'Sbloccato'**
  String get unlocked;

  /// No description provided for @pointsLowercase.
  ///
  /// In it, this message translates to:
  /// **'punti'**
  String get pointsLowercase;

  /// No description provided for @totalPointsLabel.
  ///
  /// In it, this message translates to:
  /// **'PUNTI TOTALI'**
  String get totalPointsLabel;

  /// No description provided for @pointsLabel.
  ///
  /// In it, this message translates to:
  /// **'PUNTI'**
  String get pointsLabel;

  /// No description provided for @dailyPointsLabel.
  ///
  /// In it, this message translates to:
  /// **'Punti Oggi'**
  String get dailyPointsLabel;

  /// No description provided for @pointsTotal.
  ///
  /// In it, this message translates to:
  /// **'totale'**
  String get pointsTotal;

  /// No description provided for @dailyCapReached.
  ///
  /// In it, this message translates to:
  /// **'Limite giornaliero raggiunto'**
  String get dailyCapReached;

  /// No description provided for @dailyCapReachedMessage.
  ///
  /// In it, this message translates to:
  /// **'Hai superato il limite di {cap} flessioni. Le flessioni extra vengono tracciate ma non premiate.'**
  String dailyCapReachedMessage(int cap);

  /// No description provided for @excessPushupsLabel.
  ///
  /// In it, this message translates to:
  /// **'Extra (non premiate)'**
  String get excessPushupsLabel;

  /// No description provided for @sensors.
  ///
  /// In it, this message translates to:
  /// **'Sensori'**
  String get sensors;

  /// No description provided for @feedback.
  ///
  /// In it, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @workout.
  ///
  /// In it, this message translates to:
  /// **'Allenamento'**
  String get workout;

  /// No description provided for @notifications.
  ///
  /// In it, this message translates to:
  /// **'Notifiche'**
  String get notifications;

  /// No description provided for @audio.
  ///
  /// In it, this message translates to:
  /// **'Audio'**
  String get audio;

  /// No description provided for @workoutSeriesBadge.
  ///
  /// In it, this message translates to:
  /// **'Serie {series}'**
  String workoutSeriesBadge(int series);

  /// No description provided for @workoutSeriesOfTotal.
  ///
  /// In it, this message translates to:
  /// **'Serie {current} di {total}'**
  String workoutSeriesOfTotal(int current, int total);

  /// No description provided for @achievementsCount.
  ///
  /// In it, this message translates to:
  /// **'Achievements ({unlocked}/{total})'**
  String achievementsCount(int unlocked, int total);

  /// No description provided for @unlockedDate.
  ///
  /// In it, this message translates to:
  /// **'Sbloccato: {date}'**
  String unlockedDate(String date);

  /// No description provided for @seriesCompletedLabel.
  ///
  /// In it, this message translates to:
  /// **'Serie Completate'**
  String get seriesCompletedLabel;

  /// No description provided for @seriesRange.
  ///
  /// In it, this message translates to:
  /// **'{start}-{end}'**
  String seriesRange(int start, int end);

  /// No description provided for @timeSpent.
  ///
  /// In it, this message translates to:
  /// **'Tempo Impiegato'**
  String get timeSpent;

  /// No description provided for @pointsEarnedLabel.
  ///
  /// In it, this message translates to:
  /// **'Punti Guadagnati'**
  String get pointsEarnedLabel;

  /// No description provided for @streakMultiplierLabel.
  ///
  /// In it, this message translates to:
  /// **'Moltiplicatore Streak'**
  String get streakMultiplierLabel;

  /// No description provided for @newlyUnlocked.
  ///
  /// In it, this message translates to:
  /// **'Nuovi Sbloccati'**
  String get newlyUnlocked;

  /// No description provided for @noAchievementsThisTime.
  ///
  /// In it, this message translates to:
  /// **'Nessun achievement sbloccato questa volta'**
  String get noAchievementsThisTime;

  /// No description provided for @continueToHome.
  ///
  /// In it, this message translates to:
  /// **'CONTINUA'**
  String get continueToHome;

  /// No description provided for @onboardingWelcomeTitle.
  ///
  /// In it, this message translates to:
  /// **'Benvenuto in Push-Up 5050'**
  String get onboardingWelcomeTitle;

  /// No description provided for @onboardingWelcomeSubtitle.
  ///
  /// In it, this message translates to:
  /// **'Il tuo viaggio verso 5050 flessioni inizia qui'**
  String get onboardingWelcomeSubtitle;

  /// No description provided for @onboardingPhilosophyTitle.
  ///
  /// In it, this message translates to:
  /// **'Prenditi il Tuo Tempo'**
  String get onboardingPhilosophyTitle;

  /// No description provided for @onboardingPhilosophyText.
  ///
  /// In it, this message translates to:
  /// **'Puoi impiegare 1 mese, 1 anno o 5 anni. L\'importante è la costanza.'**
  String get onboardingPhilosophyText;

  /// No description provided for @onboardingHowItWorksTitle.
  ///
  /// In it, this message translates to:
  /// **'Come Funziona'**
  String get onboardingHowItWorksTitle;

  /// No description provided for @onboardingProgressiveSeries.
  ///
  /// In it, this message translates to:
  /// **'Serie Progressive'**
  String get onboardingProgressiveSeries;

  /// No description provided for @onboardingProgressiveSeriesDesc.
  ///
  /// In it, this message translates to:
  /// **'Serie 1 = 1 flessione, Serie 2 = 2 flessioni...'**
  String get onboardingProgressiveSeriesDesc;

  /// No description provided for @onboardingStreakTracking.
  ///
  /// In it, this message translates to:
  /// **'Tracciamento Striscia'**
  String get onboardingStreakTracking;

  /// No description provided for @onboardingStreakTrackingDesc.
  ///
  /// In it, this message translates to:
  /// **'Tieni traccia dei giorni consecutivi per guadagnare moltiplicatori'**
  String get onboardingStreakTrackingDesc;

  /// No description provided for @onboardingPointsSystem.
  ///
  /// In it, this message translates to:
  /// **'Sistema Punti'**
  String get onboardingPointsSystem;

  /// No description provided for @onboardingPointsSystemDesc.
  ///
  /// In it, this message translates to:
  /// **'Guadagna punti per ogni allenamento completato'**
  String get onboardingPointsSystemDesc;

  /// No description provided for @onboardingAchievements.
  ///
  /// In it, this message translates to:
  /// **'Achievement'**
  String get onboardingAchievements;

  /// No description provided for @onboardingAchievementsDesc.
  ///
  /// In it, this message translates to:
  /// **'Sblocca badge mentre progredisci'**
  String get onboardingAchievementsDesc;

  /// No description provided for @onboardingGoalTitle.
  ///
  /// In it, this message translates to:
  /// **'Imposta i Tuoi Obiettivi'**
  String get onboardingGoalTitle;

  /// No description provided for @onboardingDailyGoal.
  ///
  /// In it, this message translates to:
  /// **'Obiettivo Giornaliero'**
  String get onboardingDailyGoal;

  /// No description provided for @onboardingMonthlyGoal.
  ///
  /// In it, this message translates to:
  /// **'Obiettivo Mensile'**
  String get onboardingMonthlyGoal;

  /// No description provided for @onboardingPushups.
  ///
  /// In it, this message translates to:
  /// **'flessioni'**
  String get onboardingPushups;

  /// No description provided for @onboardingProgressPreview.
  ///
  /// In it, this message translates to:
  /// **'A questo ritmo, raggiungerai 5050 in {time}'**
  String onboardingProgressPreview(String time);

  /// No description provided for @onboardingGetStarted.
  ///
  /// In it, this message translates to:
  /// **'Inizia'**
  String get onboardingGetStarted;

  /// No description provided for @onboardingBack.
  ///
  /// In it, this message translates to:
  /// **'Indietro'**
  String get onboardingBack;

  /// No description provided for @onboardingNext.
  ///
  /// In it, this message translates to:
  /// **'Avanti'**
  String get onboardingNext;

  /// No description provided for @settingsRestartTutorial.
  ///
  /// In it, this message translates to:
  /// **'Riavvia Tutorial'**
  String get settingsRestartTutorial;

  /// No description provided for @settingsRestartTutorialDesc.
  ///
  /// In it, this message translates to:
  /// **'Ripeti il flusso di onboarding'**
  String get settingsRestartTutorialDesc;

  /// No description provided for @onboardingActivityLevel.
  ///
  /// In it, this message translates to:
  /// **'Quanto sei attivo?'**
  String get onboardingActivityLevel;

  /// No description provided for @onboardingActivityLevelDesc.
  ///
  /// In it, this message translates to:
  /// **'Questo ci aiuta a personalizzare il tuo piano'**
  String get onboardingActivityLevelDesc;

  /// No description provided for @onboardingSedentary.
  ///
  /// In it, this message translates to:
  /// **'Sedentario'**
  String get onboardingSedentary;

  /// No description provided for @onboardingSedentaryDesc.
  ///
  /// In it, this message translates to:
  /// **'Poca o nessuna attività fisica'**
  String get onboardingSedentaryDesc;

  /// No description provided for @onboardingLightlyActive.
  ///
  /// In it, this message translates to:
  /// **'Leggermente Attivo'**
  String get onboardingLightlyActive;

  /// No description provided for @onboardingLightlyActiveDesc.
  ///
  /// In it, this message translates to:
  /// **'Attività fisica 1-3 giorni a settimana'**
  String get onboardingLightlyActiveDesc;

  /// No description provided for @onboardingActive.
  ///
  /// In it, this message translates to:
  /// **'Attivo'**
  String get onboardingActive;

  /// No description provided for @onboardingActiveDesc.
  ///
  /// In it, this message translates to:
  /// **'Attività fisica 3-5 giorni a settimana'**
  String get onboardingActiveDesc;

  /// No description provided for @onboardingVeryActive.
  ///
  /// In it, this message translates to:
  /// **'Molto Attivo'**
  String get onboardingVeryActive;

  /// No description provided for @onboardingVeryActiveDesc.
  ///
  /// In it, this message translates to:
  /// **'Attività fisica 6-7 giorni a settimana'**
  String get onboardingVeryActiveDesc;

  /// No description provided for @onboardingCapacityTitle.
  ///
  /// In it, this message translates to:
  /// **'Flessioni Massime'**
  String get onboardingCapacityTitle;

  /// No description provided for @onboardingCapacityQuestion.
  ///
  /// In it, this message translates to:
  /// **'Qual è il massimo numero di flessioni che riesci a fare in una sola serie?'**
  String get onboardingCapacityQuestion;

  /// No description provided for @onboardingMaxPushups.
  ///
  /// In it, this message translates to:
  /// **'flessioni massime'**
  String get onboardingMaxPushups;

  /// No description provided for @onboardingFrequencyTitle.
  ///
  /// In it, this message translates to:
  /// **'Frequenza degli Allenamenti'**
  String get onboardingFrequencyTitle;

  /// No description provided for @onboardingFrequencyDesc.
  ///
  /// In it, this message translates to:
  /// **'Quanti giorni a settimana pianifichi di allenarti?'**
  String get onboardingFrequencyDesc;

  /// No description provided for @onboardingDaysPerWeek.
  ///
  /// In it, this message translates to:
  /// **'giorni a settimana'**
  String get onboardingDaysPerWeek;

  /// No description provided for @onboardingDailyGoalSliderTitle.
  ///
  /// In it, this message translates to:
  /// **'Obiettivo Giornaliero'**
  String get onboardingDailyGoalSliderTitle;

  /// No description provided for @onboardingDailyGoalSliderDesc.
  ///
  /// In it, this message translates to:
  /// **'Imposta un obiettivo giornaliero realistico per mantenere la costanza'**
  String get onboardingDailyGoalSliderDesc;

  /// No description provided for @onboardingPushupsPerDay.
  ///
  /// In it, this message translates to:
  /// **'flessioni al giorno'**
  String get onboardingPushupsPerDay;

  /// No description provided for @onboardingPacePreview.
  ///
  /// In it, this message translates to:
  /// **'A questo ritmo, raggiungerai 5050 in circa {time}'**
  String onboardingPacePreview(String time);

  /// No description provided for @weeklyReviewTitle.
  ///
  /// In it, this message translates to:
  /// **'Revisione Settimanale'**
  String get weeklyReviewTitle;

  /// No description provided for @weeklyTargetAchieved.
  ///
  /// In it, this message translates to:
  /// **'Obiettivo Settimanale Raggiunto!'**
  String get weeklyTargetAchieved;

  /// No description provided for @weeklyProgressLabel.
  ///
  /// In it, this message translates to:
  /// **'Progresso Settimanale'**
  String get weeklyProgressLabel;

  /// No description provided for @weeklyBonusAwarded.
  ///
  /// In it, this message translates to:
  /// **'+{bonus} punti bonus'**
  String weeklyBonusAwarded(int bonus);

  /// No description provided for @weeklyBonusMessage.
  ///
  /// In it, this message translates to:
  /// **'Hai raggiunto il tuo obiettivo settimanale!'**
  String get weeklyBonusMessage;

  /// No description provided for @weeklyMissedMessage.
  ///
  /// In it, this message translates to:
  /// **'Non hai raggiunto il tuo obiettivo questa settimana.'**
  String get weeklyMissedMessage;

  /// No description provided for @weeklyGoalMaintain.
  ///
  /// In it, this message translates to:
  /// **'Mantieni obiettivo'**
  String get weeklyGoalMaintain;

  /// No description provided for @weeklyGoalIncrease10.
  ///
  /// In it, this message translates to:
  /// **'Aumenta del 10%'**
  String get weeklyGoalIncrease10;

  /// No description provided for @weeklyGoalIncrease20.
  ///
  /// In it, this message translates to:
  /// **'Aumenta del 20%'**
  String get weeklyGoalIncrease20;

  /// No description provided for @weeklyGoalDecrease10.
  ///
  /// In it, this message translates to:
  /// **'Riduci del 10%'**
  String get weeklyGoalDecrease10;

  /// No description provided for @weeklyGoalDecrease20.
  ///
  /// In it, this message translates to:
  /// **'Riduci del 20%'**
  String get weeklyGoalDecrease20;

  /// No description provided for @weeklyGoalDecrease30.
  ///
  /// In it, this message translates to:
  /// **'Riduci del 30%'**
  String get weeklyGoalDecrease30;

  /// No description provided for @monthlyToGoal.
  ///
  /// In it, this message translates to:
  /// **'{months} mesi per 50 push-up'**
  String monthlyToGoal(int months);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'it'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'it':
      return AppLocalizationsIt();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
