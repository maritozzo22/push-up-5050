# Piano Redesign Completo Push-Up 5050

## Data: 2025-01-16

---

## Obiettivo
Redesign completo UI con stile "dark glass + orange glow" mantenendo logica business esistente. Integrazione suoni WAV.

---

## SCELTE UTENTE
- **Sostituzione completa**: Nuova UI rimpiazzerà quella vecchia (no switch/option)
- **TODO placeholders**: Dati mancanti (weekTotal, weeklySeries, calendar) lasciati come TODO
- **Font Montserrat**: Mantiene font esistente invece di Inter

---

## RIASSUNTO ESECUZIONE (TODO List)

### Fase 1: Setup Audio
- [ ] Copia `sound-pushp-done.wav` in `assets/sounds/`
- [ ] Copia `Achievement-unlock.wav` in `assets/sounds/`
- [ ] Aggiorna `audio_service.dart` con `playPushupDone()` e `playGoalAchieved()`
- [ ] Aggiorna `app_settings_service.dart` con flags per nuovi suoni

### Fase 2: Integrazione Suoni
- [ ] Modifica `workout_execution_screen.dart` - suona `playPushupDone()` in `_handleCountRep`
- [ ] Modifica `workout_execution_screen.dart` - suona `playGoalAchieved()` quando goalReached
- [ ] Modifica `settings_screen.dart` - aggiungi toggle per nuovi suoni
- [ ] Test suoni su Android

### Fase 3: Design System Widgets
- [ ] Crea `lib/widgets/design_system/app_background.dart`
- [ ] Crea `lib/widgets/design_system/frost_card.dart`
- [ ] Crea `lib/widgets/design_system/progress_bar.dart`
- [ ] Crea `lib/widgets/design_system/start_button_circle.dart`
- [ ] Crea `lib/widgets/design_system/mini_stat.dart`
- [ ] Crea `lib/widgets/design_system/primary_gradient_button.dart`
- [ ] Crea `lib/widgets/design_system/orange_circle_icon_button.dart`

### Fase 4: Home Page Redesign
- [ ] Sostituisci `lib/screens/home/home_screen.dart` con nuovo design
- [ ] Aggiungi TODO methods in `user_stats_provider.dart` (weekTotal, etc.)
- [ ] Test navigazione e layout

### Fase 5: Statistics Widgets
- [ ] Crea `lib/widgets/statistics/total_pushups_card.dart`
- [ ] Crea `lib/widgets/statistics/calorie_card.dart`
- [ ] Crea `lib/widgets/statistics/weekly_chart_painter.dart`
- [ ] Crea `lib/widgets/statistics/monthly_calendar.dart`

### Fase 6: Statistics Page Redesign
- [ ] Sostituisci `lib/screens/statistics/statistics_screen.dart` con nuovo design
- [ ] Test visualizzazione dati e calendario

### Fase 7: Test Finali
- [ ] Golden tests per nuovi widgets (opzionale)
- [ ] Android build completo
- [ ] Test flusso completo: Home → Workout → Statistics

---

## DESIGN SYSTEM (OBBLIGATORIO)

### Background
```dart
// Gradiente principale: top-center più chiaro (#1C222C) → fondo scuro (#0B0C0F)
// Gradiente arancio: in basso, bassa opacità (#14FF7A18)
```

### FrostCard
- Radius: 24
- Backdrop blur: 12
- Border: 1px white 8% opacity
- Shadow: blur 26, offset (0,16), opacity 0.30
- Padding: 18h, 14v

### Accent Color
- Gradiente arancio: #FFB347 → #FF5F1F
- Glow: #FF7A18 a bassa opacità

### Font
- Montserrat (già configurato nell'app)
- Titoli: w900
- Label: w700/w800
- Numeri: w900

### Spacing
- Griglia 8pt
- Padding laterale: 22

---

## HOME PAGE (LAYOUT ESATTO)

```
Stack:
├── AppBackground (primo layer)
├── SafeArea
    └── Padding(22h)
        └── Column
            ├── Spacer
            ├── Text("PUSHUP 5050") - titolo centrato
            ├── SizedBox(32)
            ├── StartButtonCircle - naviga a '/series_selection'
            ├── SizedBox(24)
            ├── FrostCard("Today · {todayCount} Pushups")
            ├── SizedBox(16)
            └── Row
                ├── FrostCard(MiniStat: THIS WEEK, weekTotal, bar)
                └── FrostCard(MiniStat: GOAL, goal)
            ├── Spacer
```

### Dati (con collegamenti esistenti)
- `todayCount`: `UserStatsProvider.todayPushups` ✓
- `weekTotal`: TODO - da implementare in futuro
- `weekProgress`: TODO
- `goal`: 50 ✓

---

## STATISTICS PAGE (LAYOUT ESATTO)

```
Stack:
├── AppBackground
├── SafeArea
    └── SingleChildScrollView
        └── Padding(22h)
            └── Column
                ├── Row (back arrow + title "STATISTICHE GLOBALI")
                ├── SizedBox(24)
                ├── Row (2 cards)
                │   ├── totalPushupsCard(total, goal)
                │   └── calorieCard(kcal)
                ├── SizedBox(16)
                ├── FrostCard (Progressi settimanali + area chart)
                ├── SizedBox(16)
                ├── Row (3 mini-cards)
                │   ├── Giorni consecutivi
                │   ├── Media giornaliera
                │   └── Miglior giorno
                ├── SizedBox(24)
                ├── Calendario mensile
                │   ├── Header mese/anno
                │   ├── Weekday labels
                │   ├── Grid 7x5/6 con fill arancio
                └── SizedBox(32)
```

### Dati (con TODO)
- `total`: `UserStatsProvider.totalPushupsAllTime` ✓
- `goal`: 5050 ✓
- `kcal`: `total × 0.45` ✓
- `weeklySeries`: TODO
- `currentStreak`: `UserStatsProvider.currentStreak` ✓
- `completedDays`: `UserStatsProvider.daysCompleted` ✓
- `bestDay`: TODO
- `monthlyRecords`: TODO

---

## INTEGRAZIONE SUONI

### Suono 1: Push-up completato
- **File**: `push_up_5050/Sounds/sound-pushp-done.wav`
- **Destinazione**: `assets/sounds/pushup_done.wav`
- **Trigger**: Quando si preme il bottone push-up O sensore rileva
- **Location**: `workout_execution_screen.dart` metodo `_handleCountRep`

### Suono 2: Achievement/Goal raggiunto
- **File**: `push_up_5050/Sounds/Achievement-unlock.wav`
- **Destinazione**: `assets/sounds/achievement_unlock.wav`
- **Trigger**: Quando si raggiunge l'obiettivo impostato O si sblocca un achievement
- **Location**: `workout_execution_screen.dart` quando `goalReached == true`

### AudioService - Nuovi metodi
```dart
Future<void> playPushupDone() async
Future<void> playGoalAchieved() async
```

---

## FILE DA MODIFICARE/CREARE

### Nuovi widgets riusabili (7):
1. `lib/widgets/design_system/app_background.dart`
2. `lib/widgets/design_system/frost_card.dart`
3. `lib/widgets/design_system/progress_bar.dart`
4. `lib/widgets/design_system/start_button_circle.dart`
5. `lib/widgets/design_system/mini_stat.dart`
6. `lib/widgets/design_system/primary_gradient_button.dart`
7. `lib/widgets/design_system/orange_circle_icon_button.dart`

### Nuovi widgets statistics (4):
8. `lib/widgets/statistics/total_pushups_card.dart`
9. `lib/widgets/statistics/calorie_card.dart`
10. `lib/widgets/statistics/weekly_chart_painter.dart`
11. `lib/widgets/statistics/monthly_calendar.dart`

### Screen da sostituire (2):
12. `lib/screens/home/home_screen.dart` - SOSTITUISCI con nuovo design
13. `lib/screens/statistics/statistics_screen.dart` - SOSTITUISCI con nuovo design

### File da modificare (5):
1. `lib/services/audio_service.dart` - Nuovi metodi playPushupDone(), playGoalAchieved()
2. `lib/services/app_settings_service.dart` - Nuovi settings per suoni
3. `lib/providers/user_stats_provider.dart` - Nuovi metodi TODO per dati settimanali/mensili
4. `lib/screens/workout_execution/workout_execution_screen.dart` - Integrazione suono pushup
5. `lib/screens/settings/settings_screen.dart` - Toggle nuovi suoni

### File audio da copiare (2):
1. `push_up_5050/Sounds/sound-pushp-done.wav` → `assets/sounds/pushup_done.wav`
2. `push_up_5050/Sounds/Achievement-unlock.wav` → `assets/sounds/achievement_unlock.wav`

---

## VERIFICA FINALE

- [ ] Audio suona quando si preme push-up (workout_execution)
- [ ] Audio suona quando si raggiunge goal/achievement
- [ ] Home page ha nuovo design con glass effect + StartButtonCircle
- [ ] Statistics page ha nuovo design con cards e calendario
- [ ] Dati esistenti collegati (todayCount, total, goal, streak)
- [ ] TODO placeholders presenti per dati futuri
- [ ] Android build funziona
- [ ] Test esistenti ancora passano

---

## RIFERIMENTI
- Design spec completo: `New-design.md`
- Codice esempio widgets: Vedi sezioni A-F in New-design.md
