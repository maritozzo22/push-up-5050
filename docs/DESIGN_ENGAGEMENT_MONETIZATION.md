# Push-Up 5050 - Engagement & Monetization Design

**Versione:** 2.0
**Data:** 23 Gennaio 2026
**Status:** In Definizione

---

## 1. Obiettivi

1. **Aumentare la retention** attraverso feature engagement
2. **Monetizzare** con Ads + Sistema Premi (temi)
3. **Personalizzare** l'esperienza in base al livello dell'utente
4. **Mantenere semplice** - no backend, solo local

---

## 2. Onboarding Personalizzato

### 2.1 Nuove Schermate

#### Schermata 1: Livello di Attività
```
Quanto sei attivo?
○ Sedentario (poco o nessuno sport)
○ Moderatamente attivo (1-2 volte a settimana)
○ Molto attivo (3-4 volte a settimana)
○ Atleta (5+ volte a settimana)
```

#### Schermata 2: Capacità Push-up
```
Quante flessioni riesci a fare?
○ Principiante (1-10)
○ Intermedio (11-30)
○ Avanzato (31-50)
○ Atleta (50+)
```

#### Schermata 3: Frequenza Allenamento
```
Quante volte vuoi allenarti?
□ Tutti i giorni
□ 3-4 volte a settimana
□ 1-2 volte a settimana
```

#### Schermata 4: Obiettivo Personale
```
Qual è il tuo obiettivo principale?
○ Dimagrire / Bruciare calorie
○ Tonificare petto e braccia
○ Aumentare resistenza
○ Raggiungere 50 push-up consecutivi
```

### 2.2 Logica di Personalizzazione

In base alle risposte → il sistema calcola e consiglia:
- **Serie iniziali consigliate** (non da 1 fisso)
- **Goal giornaliero personalizzato** (non 50 fisso)
- **Tempo di recupero consigliato**
- **Prezzi temi shop** (livello più alto = prezzi più alti)

**Policy:** Consigliato + Editabile
- Il sistema calcola e consiglia i parametri
- L'utente può sempre modificare in settings

---

## 3. Sistema Punti Potenziato

### 3.1 Formula Punti (NUOVA - Aggressiva)

```
PUNTI BASE = (Serie completate × 10) + (Push-ups × 1)

MOLTIPLICATORE REP = Push-ups totali × 0.3
MOLTIPLICATORE SERIE = Serie completate × 0.8

MOLTIPLICATORE STREAK (conservato):
├─ 0-3 giorni: 1.0x
├─ 4-7 giorni: 1.2x
├─ 8-14 giorni: 1.5x
└─ 15-30 giorni: 2.0x

PUNTI FINALI = Punti Base × (Moltiplicatore Rep + Moltiplicatore Serie) × Moltiplicatore Streak
```

### 3.2 Esempio Calcolo

```
5 serie completate (1+2+3+4+5 = 15 rep totali)
├─ Punti Base = (5 × 10) + (15 × 1) = 65
├─ Moltiplicatore Rep = 15 × 0.3 = 4.5x
├─ Moltiplicatore Serie = 5 × 0.8 = 4.0x
├─ Moltiplicatore Totale = 8.5x
└─ Punti Finali = 65 × 8.5 = 552 punti

CON STREAK 15+ giorni (2.0x):
└─ Punti Finali = 552 × 2.0 = 1.104 punti
```

### 3.3 Salvataggio Persistente

Da aggiungere ai modelli:
```dart
// DailyRecord
int pointsEarned;  // Punti guadagnati nel workout
double multiplier; // Moltiplicatore usato

// UserStats
int totalPoints;   // Totale punti accumulati
```

---

## 4. Sistema Anti-Cheat

### 4.1 Cap Giornaliero

In base al livello + goal giornaliero → calcola **MAX PUSH-UP GIORNALIERO**

```dart
if (livello == "Principiante" && goal == 20) {
  maxGiornaliero = goal * 1.5;  // Es: 30 max
} else if (livello == "Intermedio" && goal == 50) {
  maxGiornaliero = goal * 2;    // Es: 100 max
} else if (livello == "Avanzato" && goal == 80) {
  maxGiornaliero = goal * 2.5;  // Es: 200 max
}

// Se supera il cap → punti count fino al cap
puntiEffettivi = min(pushupsFatti, maxGiornaliero);
```

### 4.2 Prezzi Dinamici per Livello

| Livello | Moltiplicatore Prezzi |
|---------|----------------------|
| Principiante | 1.0x (base) |
| Intermedio | 1.5x |
| Avanzato | 2.0x |
| Atleta | 2.5x |

Esempio: Se un tema costa 1000 punti per Principiante:
- Intermedio: 1500 punti
- Avanzato: 2000 punti
- Atleta: 2500 punti

---

## 5. Obiettivo Settimanale

### 5.1 Logica

```
GOAL SETTIMANALE = Goal giornaliero × 5
```

### 5.2 Popup Domenicale

```dart
if (progressoSettimanale >= 0.8) {
  mostraPopup(
    "Obiettivo settimanale: ${progresso}% raggiunto! 🔥",
    "Vuoi aumentare l'obiettivo per la prossima settimana?",
    opzioni: [
      "Mantieni",
      "Aumenta (+10%)",
      "Aumenta (+20%)"
    ]
  );
}
```

### 5.3 Bonus Settimanale

```dart
if (obiettivoSettimanaleRaggiunto) {
  puntiBonus = 500;  // DA DEFINIRE ESATTAMENTE
}
```

### 5.4 Reset Streak

```dart
if (progressoSettimanale < obiettivoMinimo) {
  streak = 0;  // Reset streak
}
```

### 5.5 Esempio Pratico

```
PRINCIPIANTE - Settimana 1
├─ Goal giornaliero: 20
├─ Goal settimanale: 100 (20 × 5)
├─ Effettivo: 95 push-up
├─ Progresso: 95%
├─ Streak: MANTENUTA ✅
└─ Popup domenica: SÌ (≥80%)

UTENTE COSTANTE - Settimana 8
├─ Goal giornaliero: 50
├─ Goal settimanale: 250 (50 × 5)
├─ Effettivo: 280 push-up
├─ Progresso: 112%
├─ Bonus: +500 punti
└─ Popup: Aumenta a 55 giornaliero / 275 settimanale?
```

---

## 6. Ads Placement

### 6.1 Native Ad
- **Posizione:** Statistics screen, tra weekly chart e calendar
- **Style:** Integrato con design dell'app

### 6.2 Interstitial
- **Mostrato:** Dopo workout completato
- **NO:** Durante workout (interrupts flow)

### 6.3 Rewarded Video
- **Opzionale:** Dopo workout completamento
- **Call-to-action:** "Guarda video → 2x moltiplicatore!"
- **Workflow:**
  1. Utente completa workout
  2. Schermata: "Hai guadagnato X punti (con moltiplicatore Y)"
  3. Button: "Guarda video → Raddoppia moltiplicatore!"
  4. Guarda video → moltiplicatore * 2
  5. Punti finali salvati con nuovo moltiplicatore
- **Max:** 1-2 per giorno (avoid spam)

---

## 7. Shop Temi

### 7.1 Struttura Temi (Prezzi Base Principiante)

| Tema | Categoria | Prezzo Base | Descrizione |
|------|-----------|-------------|-------------|
| Dark Base | Gratis | 0 | Già presente (sfondo scuro) |
| Light | Premium | ? | Sfondo bianco/minimal |
| Ocean Blue | Premium | ? | Tonalità blu calme |
| Forest Green | Premium | ? | Tonalità natura |
| Sunset Orange | Premium | ? | Gradienti arancioni |
| Pastel Dream | Speciale | ? | Colori pastello |
| Neon Cyberpunk | Speciale | ? | Stile cyberpunk |
| Retro Arcade | Speciale | ? | Pixel art style |

**Nota:** Prezzi da calcolare con nuovo sistema punti

### 7.2 Prezzi Dinamici per Livello

| Tema | Principiante | Intermedio | Avanzato | Atleta |
|------|-------------|------------|----------|--------|
| Light | ? | ?×1.5 | ?×2.0 | ?×2.5 |
| Ocean Blue | ? | ?×1.5 | ?×2.0 | ?×2.5 |
| ... | ... | ... | ... | ... |

---

## 8. Feature Engagement

### 8.1 Challenges (Solo Local)

- **Weekly challenges:** Es: "500 push-up questa settimana"
- **Target giornaliero personalizzato**
- **Challenge mensile personalizzata**
- **Streak freeze:** 1 "getta jail" al mese
- **Challenge completamento** = badge speciale

### 8.2 Notifiche Smart

- "Hai saltato 2 giorni, non mollare!" (basato su streak)
- "Solo 15 push-up per il goal di oggi" (basato su progress)
- Notifica orario personalizzato (in base a quando si allena)
- Motivational quotes random
- "Nuovo challenge disponibile!" (domenica)

### 8.3 Social/Sharing

- **Share workout completato:** Instagram stories template
- **Badge/Medaglie condivisibili**
- **Export risultati immagine**
- **"Sfida un amico":** Genera link/text da condividere

### 8.4 Instagram Sharing Templates

**Template 1: Minimal**
- Sfondo arancione
- Stats principali
- Logo

**Template 2: Sportivo**
- Dark theme
- Grafico
- Badge

**Template 3: Divertente**
- Colori vivaci
- Emoji
- Quote motivazionali

---

## 9. Posticipato a v3.0

- 💎 Premium one-shot purchase
- 🧑 Personaggio che cresce con i punti
- 🏠 Camera/personalizzazione stanza

---

## 10. TO-DO

- [x] Definire onboarding personalizzato
- [x] Definire formula punti aggressiva
- [x] Definire sistema anti-cheat
- [x] Definire obiettivo settimanale
- [ ] **Calcolare prezzi temi shop con nuovi valori**
- [ ] Definire bonus punti settimanale esatto
- [ ] Implementare onboarding
- [ ] Implementare sistema punti potenziato
- [ ] Implementare shop temi
- [ ] Implementare challenges
- [ ] Implementare notifiche smart
- [ ] Implementare sharing Instagram

---

## 11. Casi d'Uso Reali (Calcolati con Nuova Formula)

### Formula Completa
```
PUNTI BASE = (Serie × 10) + (Push-ups × 1)
MOLTIPLICATORE REP = Push-ups × 0.3
MOLTIPLICATORE SERIE = Serie × 0.8
MOLTIPLICATORE STREAK = 1.0x / 1.2x / 1.5x / 2.0x

PUNTI FINALI = Punti Base × (Moltep Rep + Moltep Serie) × Moltep Streak
```

---

### Caso 1: Principiante (Senza Rewarded Video)

**Settimana 1 - Senza Streak**

| Giorno | Push-ups | Serie | Punti Base | Moltep Rep | Moltep Serie | Moltep Streak | Punti Finali |
|--------|----------|-------|------------|------------|--------------|---------------|--------------|
| Lun | 15 | 5 | 65 | 4.5x | 4.0x | 1.0x | **552** |
| Mar | 20 | 6 | 80 | 6.0x | 4.8x | 1.0x | **864** |
| Mer | 0 | 0 | 0 | 0 | 0 | - | **0** |
| Gio | 18 | 5 | 68 | 5.4x | 4.0x | 1.0x | **639** |
| Ven | 22 | 6 | 82 | 6.6x | 4.8x | 1.0x | **935** |
| Sab | 0 | 0 | 0 | 0 | 0 | - | **0** |
| Dom | 25 | 7 | 95 | 7.5x | 5.6x | 1.0x | **1.245** |
| **TOTALE** | **100** | - | - | - | - | - | **~4.200** |

**Obiettivo settimanale:** 100 ✅ RAGGIUNTO
**Bonus settimanale:** +500 punti
**TOTALE SETTIMANA 1:** ~4.700 punti

---

### Caso 2: Principiante (CON Rewarded Video 2x)

**Settimana 1 - Con Rewarded**

| Giorno | Push-ups | Punti Base | Moltep Totale | Rewarded | Bonus | Punti Finali |
|--------|----------|------------|---------------|----------|-------|--------------|
| Lun | 15 | 65 | 8.5x | 2x | 0 | **1.105** |
| Mar | 20 | 80 | 10.8x | 2x | 0 | **1.728** |
| Mer | 0 | 0 | - | - | 0 | **0** |
| Gio | 18 | 68 | 9.4x | 2x | 0 | **1.278** |
| Ven | 22 | 82 | 11.4x | 2x | 0 | **1.870** |
| Sab | 0 | 0 | - | - | 0 | **0** |
| Dom | 25 | 95 | 13.1x | 2x | 500 | **3.055** |
| **TOTALE** | **100** | - | - | - | 500 | **~9.000** |

**TOTALE SETTIMANA 1 con Rewarded:** ~9.000 punti

---

### Caso 3: Utente Costante - Settimana 8 (Streak 2.0x)

| Giorno | Push-ups | Serie | Punti Base | Moltep Rep | Moltep Serie | Moltep Streak | Punti Finali |
|--------|----------|-------|------------|------------|--------------|---------------|--------------|
| Lun | 50 | 10 | 150 | 15x | 8x | 2x | **6.900** |
| Mar | 45 | 9 | 135 | 13.5x | 7.2x | 2x | **5.670** |
| Mer | 50 | 10 | 150 | 15x | 8x | 2x | **6.900** |
| Gio | 0 | 0 | 0 | 0 | 0 | - | **0** |
| Ven | 55 | 11 | 165 | 16.5x | 8.8x | 2x | **8.415** |
| Sab | 50 | 10 | 150 | 15x | 8x | 2x | **6.900** |
| Dom | 30 | 7 | 100 | 9x | 5.6x | 2x | **2.920** |
| **TOTALE** | **280** | - | - | - | - | - | **~37.700** |

**Con Rewarded 2x e bonus:** ~75.000+ punti a settimana!

---

## 12. Shop Temi - Prezzi Definitivi

### Prezzi Base (Principiante)

| Tema | Categoria | Prezzo | Tempo Sblocco (No Rewarded) | Tempo Sblocco (Con Rewarded) |
|------|-----------|--------|----------------------------|------------------------------|
| Dark Base | Gratis | 0 | Già incluso | Già incluso |
| Light | Premium | **5.000** | 1 settimana | 3-4 giorni |
| Ocean Blue | Premium | **7.500** | 2 settimane | 5-6 giorni |
| Forest Green | Premium | **7.500** | 2 settimane | 5-6 giorni |
| Sunset Orange | Premium | **10.000** | 2.5-3 settimane | 1 settimana |
| Pastel Dream | Speciale | **15.000** | 3-4 settimane | 1.5-2 settimane |
| Neon Cyberpunk | Speciale | **25.000** | 5-6 settimane | 2.5-3 settimane |
| Retro Arcade | Speciale | **25.000** | 5-6 settimane | 2.5-3 settimane |

### Prezzi per Livello (Moltiplicatori)

| Tema | Principiante | Intermedio | Avanzato | Atleta |
|------|-------------|------------|----------|--------|
| Light | 5.000 | 7.500 | 10.000 | 12.500 |
| Ocean Blue | 7.500 | 11.250 | 15.000 | 18.750 |
| Forest Green | 7.500 | 11.250 | 15.000 | 18.750 |
| Sunset Orange | 10.000 | 15.000 | 20.000 | 25.000 |
| Pastel Dream | 15.000 | 22.500 | 30.000 | 37.500 |
| Neon Cyberpunk | 25.000 | 37.500 | 50.000 | 62.500 |
| Retro Arcade | 25.000 | 37.500 | 50.000 | 62.500 |
