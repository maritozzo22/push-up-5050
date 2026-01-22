import 'dart:ui';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0C0F),
        fontFamily: 'Inter', // fallback se Inter non è disponibile
        textTheme: const TextTheme().apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
      ),
      home: const WorkoutSetupPage(),
    );
  }
}

class WorkoutSetupPage extends StatefulWidget {
  const WorkoutSetupPage({super.key});

  @override
  State<WorkoutSetupPage> createState() => _WorkoutSetupPageState();
}

class _WorkoutSetupPageState extends State<WorkoutSetupPage> {
  int startingSeries = 1;
  int restSeconds = 60;
  int goalPushups = 100;

  void incStarting() => setState(() => startingSeries = (startingSeries + 1).clamp(1, 999));
  void decStarting() => setState(() => startingSeries = (startingSeries - 1).clamp(1, 999));

  void incRest() => setState(() => restSeconds = (restSeconds + 5).clamp(5, 9999));
  void decRest() => setState(() => restSeconds = (restSeconds - 5).clamp(5, 9999));

  void incGoal() => setState(() => goalPushups = (goalPushups + 5).clamp(5, 9999));
  void decGoal() => setState(() => goalPushups = (goalPushups - 5).clamp(5, 9999));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _Background(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Column(
                children: [
                  const SizedBox(height: 18),

                  // Top bar
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: const Color(0xFFFFB347).withOpacity(0.95),
                          size: 22,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Workout Setup',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),

                  const SizedBox(height: 34),

                  // Box 1: Starting Series
                  FrostCard(
                    height: 140,
                    child: _StepperCard(
                      titleTop: 'Starting Series',
                      value: startingSeries.toString(),
                      titleBottom: '',
                      onMinus: decStarting,
                      onPlus: incStarting,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Box 2: Rest Time
                  FrostCard(
                    height: 160,
                    child: _StepperCard(
                      titleTop: 'Rest Time',
                      value: restSeconds.toString(),
                      titleBottom: 'seconds',
                      onMinus: decRest,
                      onPlus: incRest,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Box 3: Goal Push-ups
                  FrostCard(
                    height: 160,
                    child: _StepperCard(
                      titleTop: 'Goal Push-ups',
                      value: goalPushups.toString(),
                      titleBottom: 'total',
                      onMinus: decGoal,
                      onPlus: incGoal,
                    ),
                  ),

                  const Spacer(),

                  // Begin button
                  _PrimaryButton(
                    text: 'BEGIN WORKOUT',
                    onTap: () {
                      debugPrint('begin: series=$startingSeries rest=$restSeconds goal=$goalPushups');
                    },
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/* ----------------------------- UI COMPONENTS ----------------------------- */

class _Background extends StatelessWidget {
  const _Background();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0, -0.55),
            radius: 1.2,
            colors: [
              const Color(0xFF1B202A).withOpacity(0.85),
              const Color(0xFF0B0C0F),
            ],
          ),
        ),
      ),
    );
  }
}

class FrostCard extends StatelessWidget {
  final double height;
  final Widget child;

  const FrostCard({super.key, required this.height, required this.child});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF1B1E24).withOpacity(0.55),
            border: Border.all(color: Colors.white.withOpacity(0.10), width: 1),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.35),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

class _StepperCard extends StatelessWidget {
  final String titleTop;
  final String value;
  final String titleBottom;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const _StepperCard({
    required this.titleTop,
    required this.value,
    required this.titleBottom,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          titleTop,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.white.withOpacity(0.65),
          ),
        ),
        const SizedBox(height: 14),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _CircleIconButton(icon: Icons.remove_rounded, onTap: onMinus),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  if (titleBottom.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      titleBottom,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.white.withOpacity(0.55),
                      ),
                    ),
                  ],
                ],
              ),
              _CircleIconButton(icon: Icons.add_rounded, onTap: onPlus),
            ],
          ),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  State<_CircleIconButton> createState() => _CircleIconButtonState();
}

class _CircleIconButtonState extends State<_CircleIconButton> {
  bool _pressed = false;

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
        duration: const Duration(milliseconds: 90),
        curve: Curves.easeOut,
        child: Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A18).withOpacity(0.35),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Icon(
            widget.icon,
            color: Colors.black.withOpacity(0.82),
            size: 26,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _PrimaryButton({required this.text, required this.onTap});

  @override
  State<_PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<_PrimaryButton> {
  bool _pressed = false;

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
        scale: _pressed ? 0.985 : 1.0,
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 68,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF7A18).withOpacity(0.35),
                blurRadius: 26,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.text,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
