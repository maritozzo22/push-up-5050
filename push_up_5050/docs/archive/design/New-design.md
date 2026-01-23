CONTESTO
App Flutter già esistente. Obiettivo: redesign UI mantenendo logica/feature attuali. Non cambiare business logic. Solo UI + collegamenti ai metodi/route esistenti. Stile: dark glass + orange glow (come reference).

DESIGN SYSTEM (OBBLIGATORIO)
- Background: radial dark (top center più chiaro, fondo più scuro) + secondo radial arancio leggero in basso.
- Cards: frosted glass. Radius 24. Backdrop blur 12. Border 1px white 8% opacity. Shadow unica: blur 26, offset (0,16), opacity 0.30.
- Accent: gradiente arancio costante #FFB347 -> #FF5F1F. Glow #FF7A18 a bassa opacità.
- Font: Inter (fallback ok). Titoli 900, label 700/800, numeri 900.
- Spacing: griglia 8pt. Padding laterale 22.

COMPONENTI RIUSABILI (CREA WIDGET)
1) FrostCard(height, child)
2) ProgressBar(value 0..1)
3) StartButtonCircle(onTap) con press animation scale + glow pulse
4) PrimaryGradientButton(text, onTap)
5) OrangeCircleIconButton(icon, onTap, disabled)

ESEMPI DI CODICE (REFERENCE ESATTA)

A) BACKGROUND (mettere come primo layer in Stack)
class AppBackground extends StatelessWidget {
  const AppBackground({super.key});
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(0, -0.65),
                radius: 1.25,
                colors: [Color(0xFF1C222C), Color(0xFF0B0C0F)],
              ),
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, 0.90),
                  radius: 1.6,
                  colors: [Color(0x14FF7A18), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

B) FROST CARD (riusa ovunque)
class FrostCard extends StatelessWidget {
  final double height;
  final Widget child;
  const FrostCard({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF161A20).withOpacity(0.60),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.08), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 26,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

C) START BUTTON (press scale + glow pulse)
class StartButtonCircle extends StatefulWidget {
  final VoidCallback onTap;
  const StartButtonCircle({super.key, required this.onTap});

  @override
  State<StartButtonCircle> createState() => _StartButtonCircleState();
}

class _StartButtonCircleState extends State<StartButtonCircle>
    with SingleTickerProviderStateMixin {
  bool _pressed = false;
  late final AnimationController _glow;

  @override
  void initState() {
    super.initState();
    _glow = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
      lowerBound: 0.55,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _glow.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapCancel: () => setState(() => _pressed = false),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _pressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: AnimatedBuilder(
          animation: _glow,
          builder: (_, __) {
            return Container(
              width: 164,
              height: 164,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF7A18).withOpacity(_glow.value * 0.55),
                    blurRadius: 38,
                    spreadRadius: 10,
                  ),
                  BoxShadow(
                    color: const Color(0xFFFF7A18).withOpacity(_glow.value * 0.22),
                    blurRadius: 80,
                    spreadRadius: 18,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: const Text(
                'START',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

D) PROGRESS BAR (usare in “This Week” e “Totale pushups”)
class ProgressBar extends StatelessWidget {
  final double value; // 0..1
  const ProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        height: 9,
        color: Colors.white.withOpacity(0.08),
        child: FractionallySizedBox(
          widthFactor: value.clamp(0, 1),
          alignment: Alignment.centerLeft,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFFB347), Color(0xFFFF7A18)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

E) MINI STAT CELL (Home)
class MiniStat extends StatelessWidget {
  final String label; // es "THIS WEEK"
  final String value; // es "125"
  final bool showBar;
  final double barValue;
  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    this.showBar = false,
    this.barValue = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.0,
            color: Colors.white.withOpacity(0.55),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        if (showBar) ProgressBar(value: barValue),
      ],
    );
  }
}

F) TOP STATS CARD (Statistics Page – Totale/Goal + %)
Widget totalPushupsCard({
  required int total,
  required int goal,
}) {
  final progress = goal == 0 ? 0.0 : (total / goal).clamp(0.0, 1.0);
  return Row(
    children: [
      Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF7A18).withOpacity(0.25),
              blurRadius: 18,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(Icons.directions_run_rounded, color: Colors.black.withOpacity(0.82)),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'TOTALE PUSHUPS:',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color: Colors.white.withOpacity(0.70),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$total / $goal',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            ProgressBar(value: progress),
            const SizedBox(height: 6),
            Text(
              '${(progress * 100).round()}%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.white.withOpacity(0.55),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

HOME PAGE (LAYOUT ESATTO)
- Titolo alto centrato: “PUSHUP 5050”
- Bottone centrale: StartButtonCircle
- Card: “Today · {todayCount} Pushups” (FrostCard)
- Sotto: row 2 FrostCard:
  - left: MiniStat(THIS WEEK, weekTotal, showBar true, weekProgress)
  - right: MiniStat(GOAL, goal, showBar false)
- Nessun bottom menu.
- START onTap: naviga alla pagina già esistente (usa route/metodo esistente, non inventare).

STATISTICS PAGE (LAYOUT ESATTO)
- Back arrow arancio, titolo grande “STATISTICHE GLOBALI”
- Top row 2 cards:
  - A: totalPushupsCard(total, goal)
  - B: calorie card (stesso stile, icona fire, testo “CALORIE BRUCIATE: {kcal} kcal”)
- Card grande: “PROGRESSI SETTIMANALI” con area chart arancio (CustomPainter semplice ok)
- Row 3 mini-card: “GIORNI CONSECUTIVI”, “MEDIA GIORNALIERA”, “MIGLIOR GIORNO”
- Calendario mensile:
  - header mese/anno
  - weekday labels
  - grid 7 colonne, 5-6 righe
  - completato: fill gradiente arancio + glow leggero
  - non completato: background scuro + border opaco
  - oggi: ring sottile

DATI (COLLEGAMENTI)
Usa i miei provider/variabili già presenti. Se mancano, inserisci TODO con nome variabile attesa:
- todayCount: TODO
- weekTotal: TODO
- weekProgress: TODO
- goal: TODO
- total: TODO
- kcal: TODO
- weeklySeries: TODO List<double> (Lun..Dom)
- completedDays: TODO Set<int> (giorni completati nel mese)
- todayDay: TODO int (giorno del mese)

VINCOLI IMPLEMENTAZIONE
- Nessun pacchetto esterno obbligatorio (no google_fonts).
- Non cambiare modelli/dati/logica: solo UI.
- Output: codice Flutter completo di 2 schermate + widgets riusabili + punti di aggancio.
