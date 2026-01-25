// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appName => 'PUSHUP 5050';

  @override
  String get homeTitle => 'PUSHUP 5050';

  @override
  String get workoutInProgress => 'Allenamento in Corso';

  @override
  String get statsTitle => 'Statistiche';

  @override
  String get settingsTitle => 'Impostazioni';

  @override
  String get start => 'INIZIA';

  @override
  String get beginWorkout => 'INIZIA ALLENAMENTO';

  @override
  String get pause => 'PAUSA';

  @override
  String get resume => 'RIPRENDI';

  @override
  String get end => 'TERMINA';

  @override
  String get saveAndReturn => 'SALVA E TORNA A HOME';

  @override
  String get startingSeries => 'Serie di Partenza';

  @override
  String get restTime => 'Tempo di Recupero (secondi)';

  @override
  String get totalReps => 'Rep Totali';

  @override
  String get kcalBurned => 'Kcal Bruciate';

  @override
  String get currentLevel => 'Livello Attuale';

  @override
  String get currentSeries => 'Serie';

  @override
  String get ofWord => 'di';

  @override
  String todayPushups(int count) {
    return 'OGGI: $count PUSHUP';
  }

  @override
  String get pushupTotal => 'PUSHUP TOTALI';

  @override
  String get touchToCount => 'Tocca per Contare';

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
  String get keepTheRhythm => 'Mantieni il ritmo per raggiungere 5050!';

  @override
  String get goalReached => '🎉 Obiettivo Raggiunto! Complimenti!';

  @override
  String get dontGiveUp => 'Non arrenderti! Riprendi la tua serie oggi.';

  @override
  String achievementUnlocked(String name) {
    return '$name';
  }

  @override
  String achievementPoints(int points) {
    return '+$points punti';
  }

  @override
  String get workoutComplete => 'Allenamento Completato!';

  @override
  String get seriesCompleted => 'Serie Completate';

  @override
  String get pushupsTotal => 'Push-up Totali';

  @override
  String get kcal => 'Kcal Bruciate';

  @override
  String get errorLoadingData => 'Impossibile caricare i dati';

  @override
  String get retry => 'Riprova';

  @override
  String get sensorUnavailable =>
      'Sensore non disponibile. Usa il pulsante manuale.';

  @override
  String get storageFull =>
      'Spazio di archiviazione insufficiente. Libera spazio e riprova.';

  @override
  String get dontLoseStreak => 'Non perdere la tua serie!';

  @override
  String completePushupsReminder(int count) {
    return 'Completa i tuoi push-up oggi per mantenere il moltiplicatore. Ti mancano solo $count push-up!';
  }

  @override
  String dayXofY(int current, int total) {
    return 'Giorno $current di $total';
  }

  @override
  String get settingsProximitySensor => 'Sensore di Prossimità';

  @override
  String get settingsProximitySensorDesc =>
      'Conta le ripetizioni usando il sensore di prossimità';

  @override
  String get settingsHapticFeedback => 'Feedback Aptico';

  @override
  String get settingsHapticFeedbackDesc =>
      'Vibrazione leggera ad ogni ripetizione';

  @override
  String get settingsHapticIntensity => 'Intensità Feedback Aptico';

  @override
  String get settingsDefaultRecoveryTime => 'Tempo Recupero Predefinito';

  @override
  String get settingsDailyReminder => 'Promemoria Giornaliero';

  @override
  String get settingsDailyReminderDesc =>
      'Ricordami di fare push-up ogni giorno';

  @override
  String get settingsReminderTime => 'Orario Promemoria';

  @override
  String get soundsMaster => 'Suoni Master';

  @override
  String get settingsSoundsMaster => 'Suoni Master';

  @override
  String get settingsSoundsMasterDesc => 'Attiva/disattiva tutti i suoni';

  @override
  String get settingsBeepSound => 'Beep di Recupero';

  @override
  String get settingsBeepSoundDesc => 'Suono quando il recupero termina';

  @override
  String get settingsAchievementSound => 'Suono Achievement';

  @override
  String get settingsAchievementSoundDesc =>
      'Suono quando sblocchi un achievement';

  @override
  String get settingsVolume => 'Volume';

  @override
  String get settingsResetDefaults => 'Ripristina Predefiniti';

  @override
  String get settingsResetConfirm =>
      'Ripristinare tutte le impostazioni ai valori predefiniti?';

  @override
  String get settingsResetConfirmYes => 'Ripristina';

  @override
  String get settingsResetConfirmNo => 'Annulla';

  @override
  String get language => 'Lingua';

  @override
  String get italian => 'Italiano';

  @override
  String get english => 'English';

  @override
  String get hapticOff => 'Spento';

  @override
  String get hapticLight => 'Leggero';

  @override
  String get hapticMedium => 'Medio';

  @override
  String get home => 'Home';

  @override
  String get stats => 'Statistiche';

  @override
  String get profile => 'Profilo';

  @override
  String get settings => 'Impostazioni';

  @override
  String get loading => 'Caricamento...';

  @override
  String get startFirstWorkout => 'Inizia il tuo primo allenamento oggi!';

  @override
  String get pushupToday => 'Push-up Oggi';

  @override
  String get currentSeriesLabel => 'Serie Attuale';

  @override
  String get days => 'giorni';

  @override
  String get noActiveWorkout => 'Nessun Allenamento Attivo';

  @override
  String get backToHome => 'Torna alla Home';

  @override
  String get totalRepsLabel => 'Rep Totali:';

  @override
  String get kcalLabel => 'Kcal:';

  @override
  String get recovery => 'Recupero...';

  @override
  String get inPause => 'IN PAUSA';

  @override
  String get profileTitle => 'Profilo';

  @override
  String get level => 'Livello';

  @override
  String get points => 'Punti';

  @override
  String get streak => 'Striscia';

  @override
  String get daysLabel => 'Giorni';

  @override
  String get achievementsTitle => 'Achievements';

  @override
  String get unlocked => 'Sbloccato';

  @override
  String get pointsLowercase => 'punti';

  @override
  String get totalPointsLabel => 'PUNTI TOTALI';

  @override
  String get pointsLabel => 'PUNTI';

  @override
  String get dailyPointsLabel => 'Punti Oggi';

  @override
  String get pointsTotal => 'totale';

  @override
  String get dailyCapReached => 'Limite giornaliero raggiunto';

  @override
  String dailyCapReachedMessage(int cap) {
    return 'Hai superato il limite di $cap flessioni. Le flessioni extra vengono tracciate ma non premiate.';
  }

  @override
  String get excessPushupsLabel => 'Extra (non premiate)';

  @override
  String get sensors => 'Sensori';

  @override
  String get feedback => 'Feedback';

  @override
  String get workout => 'Allenamento';

  @override
  String get notifications => 'Notifiche';

  @override
  String get audio => 'Audio';

  @override
  String workoutSeriesBadge(int series) {
    return 'Serie $series';
  }

  @override
  String workoutSeriesOfTotal(int current, int total) {
    return 'Serie $current di $total';
  }

  @override
  String achievementsCount(int unlocked, int total) {
    return 'Achievements ($unlocked/$total)';
  }

  @override
  String unlockedDate(String date) {
    return 'Sbloccato: $date';
  }

  @override
  String get seriesCompletedLabel => 'Serie Completate';

  @override
  String seriesRange(int start, int end) {
    return '$start-$end';
  }

  @override
  String get timeSpent => 'Tempo Impiegato';

  @override
  String get pointsEarnedLabel => 'Punti Guadagnati';

  @override
  String get streakMultiplierLabel => 'Moltiplicatore Streak';

  @override
  String get newlyUnlocked => 'Nuovi Sbloccati';

  @override
  String get noAchievementsThisTime =>
      'Nessun achievement sbloccato questa volta';

  @override
  String get continueToHome => 'CONTINUA';

  @override
  String get onboardingWelcomeTitle => 'Benvenuto in Push-Up 5050';

  @override
  String get onboardingWelcomeSubtitle =>
      'Il tuo viaggio verso 5050 flessioni inizia qui';

  @override
  String get onboardingPhilosophyTitle => 'Prenditi il Tuo Tempo';

  @override
  String get onboardingPhilosophyText =>
      'Puoi impiegare 1 mese, 1 anno o 5 anni. L\'importante è la costanza.';

  @override
  String get onboardingHowItWorksTitle => 'Come Funziona';

  @override
  String get onboardingProgressiveSeries => 'Serie Progressive';

  @override
  String get onboardingProgressiveSeriesDesc =>
      'Serie 1 = 1 flessione, Serie 2 = 2 flessioni...';

  @override
  String get onboardingStreakTracking => 'Tracciamento Striscia';

  @override
  String get onboardingStreakTrackingDesc =>
      'Tieni traccia dei giorni consecutivi per guadagnare moltiplicatori';

  @override
  String get onboardingPointsSystem => 'Sistema Punti';

  @override
  String get onboardingPointsSystemDesc =>
      'Guadagna punti per ogni allenamento completato';

  @override
  String get onboardingAchievements => 'Achievement';

  @override
  String get onboardingAchievementsDesc => 'Sblocca badge mentre progredisci';

  @override
  String get onboardingGoalTitle => 'Imposta i Tuoi Obiettivi';

  @override
  String get onboardingDailyGoal => 'Obiettivo Giornaliero';

  @override
  String get onboardingMonthlyGoal => 'Obiettivo Mensile';

  @override
  String get onboardingPushups => 'flessioni';

  @override
  String onboardingProgressPreview(String time) {
    return 'A questo ritmo, raggiungerai 5050 in $time';
  }

  @override
  String get onboardingGetStarted => 'Inizia';

  @override
  String get onboardingBack => 'Indietro';

  @override
  String get onboardingNext => 'Avanti';

  @override
  String get settingsRestartTutorial => 'Riavvia Tutorial';

  @override
  String get settingsRestartTutorialDesc => 'Ripeti il flusso di onboarding';

  @override
  String get onboardingActivityLevel => 'Quanto sei attivo?';

  @override
  String get onboardingActivityLevelDesc =>
      'Questo ci aiuta a personalizzare il tuo piano';

  @override
  String get onboardingSedentary => 'Sedentario';

  @override
  String get onboardingSedentaryDesc => 'Poca o nessuna attività fisica';

  @override
  String get onboardingLightlyActive => 'Leggermente Attivo';

  @override
  String get onboardingLightlyActiveDesc =>
      'Attività fisica 1-3 giorni a settimana';

  @override
  String get onboardingActive => 'Attivo';

  @override
  String get onboardingActiveDesc => 'Attività fisica 3-5 giorni a settimana';

  @override
  String get onboardingVeryActive => 'Molto Attivo';

  @override
  String get onboardingVeryActiveDesc =>
      'Attività fisica 6-7 giorni a settimana';

  @override
  String get onboardingCapacityTitle => 'Flessioni Massime';

  @override
  String get onboardingCapacityQuestion =>
      'Qual è il massimo numero di flessioni che riesci a fare in una sola serie?';

  @override
  String get onboardingMaxPushups => 'flessioni massime';

  @override
  String get onboardingFrequencyTitle => 'Frequenza degli Allenamenti';

  @override
  String get onboardingFrequencyDesc =>
      'Quanti giorni a settimana pianifichi di allenarti?';

  @override
  String get onboardingDaysPerWeek => 'giorni a settimana';

  @override
  String get onboardingDailyGoalSliderTitle => 'Obiettivo Giornaliero';

  @override
  String get onboardingDailyGoalSliderDesc =>
      'Imposta un obiettivo giornaliero realistico per mantenere la costanza';

  @override
  String get onboardingPushupsPerDay => 'flessioni al giorno';

  @override
  String onboardingPacePreview(String time) {
    return 'A questo ritmo, raggiungerai 5050 in circa $time';
  }

  @override
  String get weeklyReviewTitle => 'Revisione Settimanale';

  @override
  String get weeklyTargetAchieved => 'Obiettivo Settimanale Raggiunto!';

  @override
  String get weeklyProgressLabel => 'Progresso Settimanale';

  @override
  String weeklyBonusAwarded(int bonus) {
    return '+$bonus punti bonus';
  }

  @override
  String get weeklyBonusMessage =>
      'Hai raggiunto il tuo obiettivo settimanale!';

  @override
  String get weeklyMissedMessage =>
      'Non hai raggiunto il tuo obiettivo questa settimana.';

  @override
  String get weeklyGoalMaintain => 'Mantieni obiettivo';

  @override
  String get weeklyGoalIncrease10 => 'Aumenta del 10%';

  @override
  String get weeklyGoalIncrease20 => 'Aumenta del 20%';

  @override
  String get weeklyGoalDecrease10 => 'Riduci del 10%';

  @override
  String get weeklyGoalDecrease20 => 'Riduci del 20%';

  @override
  String get weeklyGoalDecrease30 => 'Riduci del 30%';

  @override
  String monthlyToGoal(int months) {
    return '$months mesi per 50 push-up';
  }
}
