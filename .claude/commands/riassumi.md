---
description: Crea un riassunto intelligente della sessione per passare a nuova chat con contesto ottimizzato
allowed-tools: Read, Write, Glob, Grep
argument-hint: [--breve | --dettagliato]
---

Sei un assistente incaricato di creare un **riassunto contestuale intelligente** della conversazione corrente per trasferire il contesto a una nuova sessione di chat AI.

## OBBIETTIVO

Generare due output:
1. **RIASSUNI.md** - File persistente nella root del progetto con riassunto dettagliato ma ottimizzato
2. **Messaggio breve** - Testo compatto da copiare-incollare in nuova chat (include sempre riferimento a RIASSUNI.md)

## LIVELLO DI DETTAGLIO

- **Default**: Medio (bilanciato)
- **--breve**: Solo essenziale (< 300 token)
- **--dettagliato**: Completo con più contesto (< 1500 token)

## PROCESSO INTELLIGENTE

### 1. Analizza lo stato attuale
- Leggi `RIASSUNI.md` se esiste
- Esamina la conversazione corrente
- Identifica lo stato del progetto (file modificati, decisioni prese, task in corso)
- Controlla se siamo in un repo git (branch, commit recenti)

### 2. Valuta cosa mantenere (sovrascrittura intelligente)
Per ogni voce del vecchio RIASSUNI.md, decidi:

**MANTIENI se:**
- Decisioni architetturali che potrebbero causare errori se cambiate
- Configurazioni o pattern su cui si sta ancora lavorando
- Bug risolti che potrebbero ripresentarsi
- TODO ancora validi e non completati
- Informazioni ambientali (stack, tecnologie)

**COMPATTA o ELIMINA se:**
- Informazioni obsolete (task completati da tempo)
- Dettagli ridondanti con la nuova conversazione
- Decisioni superate da nuove scelte
- Errori risolti che non sono più rilevanti

**AGGIUNGI:**
- Nuove decisioni architetturali prese
- Bug/errori risolti recentemente (in brevissimo, NO codice)
- Task pendenti attuali
- Riferimenti a file specifici se inerenti al lavoro in corso
- Problemi aperti/non risolti
- Comandi o skill utilizzati nella sessione

### 3. Valuta se analizzare file del progetto
Analizza file del progetto SOLO SE necessario per:
- Capire lo stato attuale del codice
- Identificare pattern architetturali implementati
- Capire quali file sono stati modificati recentemente

Usa Read, Glob, o Grep con giudizio - non analizzare tutto indiscriminatamente.

### 4. Adatta la lunghezza al contesto
- **--breve**: Solo essenziale (< 300 token)
- **Progetto semplice/lineare**: Riassunto medio (500-800 token)
- **Progetto complesso con molti errori**: Riassunto dettagliato (800-1200 token)
- **--dettagliato**: Completo (< 1500 token)

## FORMATO RIASSUNI.md

```markdown
# Riassunto Sessione
**Ultimo aggiornamento**: [DATA ORA]
**Sessione nº**: [N progressivo se tracciato]

---

## HOW TO USE - Per il nuovo LLM
Questo file contiene il contesto completo della sessione precedente.
Inizia leggendo "Stato Progetto" e "Prossimi Passi" per capire dove siamo.

## Stato Progetto
[Breve descrizione di dove siamo nel progetto]

## Ambiente / Stack
- **Linguaggi**: [es. Python, TypeScript]
- **Framework**: [es. Next.js, Flask]
- **Database**: [se presente]
- **Tool principali**: [es. Docker, Git, npm]

## Decisioni Architetturali Importanti
[SOLO decisioni che potrebbero causare errori se cambiate o lavoro in corso]
- [Decisione 1]: [motivo se cambia causa problemi]
- [Decisione 2]: [motivo]

## Bug/Errori Risolti
[Elenco brevissimo - NO codice, solo concetto e soluzione]
- Bug X: risolto facendo Y
- Errore Z: fixato con W

## Problemi Aperti / Da Investigare
[Distinti dai TODO - problemi non ancora risolti]
- [Problema 1]: [descrizione brevissima]
- [Problema 2]: [descrizione brevissima]

## Task Pending / TODO
[Se non gestiti altrove, altrimenti riferimento al documento]
- [ ] Task da fare
- [ ] Altro task

## File Rilevanti
[SOLO file inerenti al lavoro attuale]
- `path/to/file`: descrizione breve perché importante
- `path/altro/file`: motivo del riferimento

## Git State (se in repo)
- **Branch**: [nome branch]
- **Ultimi commit**: [breve descrizione]

## Prossimi Passi
[Cosa deve fare la nuova chat per continuare - il più importante]

---

*Messaggio per nuova chat:*
[QUI INSERISCI MESSAGGIO BREVETTO DA COPIARE]
```

## FORMATO MESSAGGIO BREVE

Testo **ultra-compatto** in formato naturale che l'AI capisce immediatamente:

```
PROGETTO: [DESCRIZIONE] | FASE: [FASE CORRENTE]

CONTESTO COMPLETO: Leggi RIASSUNI.md nella root del progetto.

AMBIENTE: [linguaggi/framework principali]

DECISIONI CRITICHE:
- [Decision1]: [motivo]
- [Decision2]: [motivo]

BUG RISOLTI:
- [Bug]: [soluzione]

PROBLEMI APERTI:
- [Problema]: [descrizione]

TODO:
- [ ] [Task1]
- [ ] [Task2]

FILE: [path/file1], [path/file2]

PROSEGUIO: [azione specifica da fare]
```

## ISTRUZIONI FINALI

1. Scrivi/sovrascrivi `RIASSUNI.md` nella root del progetto
2. Stampa il messaggio breve tra separatori visibili
3. Mostra il path completo del file creato
4. Sii SINTETICO - ogni parola deve avere valore
5. Nessun codice nei bug risolti, solo concetti
6. Nessuna ridondanza - se l'info c'è già, non ripeterla
7. Pensa come se dovessi trasferire il contesto al tuo "te stesso futuro" con 0 memoria

Inizia l'analisi e genera entrambi gli output.
