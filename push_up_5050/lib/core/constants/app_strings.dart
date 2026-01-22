class AppStrings {
  // App Name
  static const String appName = 'PUSHUP 5050';

  // Screen Titles
  static const String homeTitle = 'PUSHUP 5050';
  static const String workoutInProgress = 'Allenamento in Corso';
  static const String statsTitle = 'Statistiche';
  static const String settingsTitle = 'Impostazioni';

  // Buttons
  static const String start = 'INIZIA';
  static const String beginWorkout = 'INIZIA ALLENAMENTO';
  static const String pause = 'PAUSA';
  static const String resume = 'RIPRENDI';
  static const String end = 'TERMINA';
  static const String saveAndReturn = 'SALVA E TORNA A HOME';

  // Labels
  static const String startingSeries = 'Serie di Partenza';
  static const String restTime = 'Tempo di Recupero (secondi)';
  static const String totalReps = 'Rep Totali';
  static const String kcalBurned = 'Kcal Bruciate';
  static const String currentLevel = 'Livello Attuale';
  static const String currentSeries = 'Serie';
  static const String of = 'di';
  static const String todayPushups = 'OGGI: {count} PUSHUP';
  static const String pushupTotal = 'PUSHUP TOTALI';

  // Hints
  static const String touchToCount = 'Tocca per Contare';
  static const String progressiveSeriesHint = 'Progressive Series (e.g., Series 3 = 3 pushups)';
  static const String baseRecoveryHint = 'Base 10s, increases with series';

  // Levels
  static const String levelBeginner = 'Beginner';
  static const String levelIntermediate = 'Intermediate';
  static const String levelAdvanced = 'Advanced';
  static const String levelExpert = 'Expert';
  static const String levelMaster = 'Master';

  // Motivational
  static const String keepTheRhythm = 'Mantieni il ritmo per raggiungere 5050!';
  static const String goalReached = '🎉 Obiettivo Raggiunto! Complimenti!';
  static const String dontGiveUp = 'Non arrenderti! Riprendi la tua serie oggi.';

  // Achievements
  static const String achievementUnlocked = '{name}';
  static const String achievementPoints = '+{points} punti';
  static const String workoutComplete = 'Allenamento Completato!';
  static const String seriesCompleted = 'Serie Completate';
  static const String pushupsTotal = 'Push-up Totali';
  static const String kcal = 'Kcal Bruciate';

  // Errors
  static const String errorLoadingData = 'Impossibile caricare i dati';
  static const String retry = 'Riprova';
  static const String sensorUnavailable = 'Sensore non disponibile. Usa il pulsante manuale.';
  static const String storageFull = 'Spazio di archiviazione insufficiente. Libera spazio e riprova.';

  // Notifications
  static const String dontLoseStreak = 'Non perdere la tua serie!';
  static const String completePushupsReminder = 'Completa i tuoi push-up oggi per mantenere il moltiplicatore. Ti mancano solo {count} push-up!';

  // Calendar
  static String dayXofY(int current, int total) => 'Giorno $current di $total';

  // Settings Screen
  static const String settingsProximitySensor = 'Sensore di Prossimità';
  static const String settingsProximitySensorDesc =
      'Conta le ripetizioni usando il sensore di prossimità';
  static const String settingsHapticFeedback = 'Feedback Aptico';
  static const String settingsHapticFeedbackDesc =
      'Vibrazione leggera ad ogni ripetizione';
  static const String settingsHapticIntensity = 'Intensità Feedback Aptico';
  static const String settingsDefaultRecoveryTime = 'Tempo Recupero Predefinito';
  static const String settingsDailyReminder = 'Promemoria Giornaliero';
  static const String settingsDailyReminderDesc =
      'Ricordami di fare push-up ogni giorno';
  static const String settingsReminderTime = 'Orario Promemoria';
  static const String soundsMaster = 'Suoni Master';
  static const String settingsSoundsMaster = 'Suoni Master';
  static const String settingsSoundsMasterDesc = 'Attiva/disattiva tutti i suoni';
  static const String settingsBeepSound = 'Beep di Recupero';
  static const String settingsBeepSoundDesc =
      'Suono quando il recupero termina';
  static const String settingsAchievementSound = 'Suono Achievement';
  static const String settingsAchievementSoundDesc =
      'Suono quando sblocchi un achievement';
  static const String settingsVolume = 'Volume';
  static const String settingsResetDefaults = 'Ripristina Predefiniti';
  static const String settingsResetConfirm =
      'Ripristinare tutte le impostazioni ai valori predefiniti?';
  static const String settingsResetConfirmYes = 'Ripristina';
  static const String settingsResetConfirmNo = 'Annulla';
}
