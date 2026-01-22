import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';
import 'package:push_up_5050/widgets/design_system/progress_bar.dart';

/// Total Pushups Card - displays total pushups vs goal with progress bar.
///
/// Shows:
/// - Icon with orange gradient circle (TOP)
/// - "TOTALE PUSHUPS:" label
/// - "X / Y" value display
/// - Progress bar with percentage
///
/// Used in Statistics Screen.
/// Layout: Vertical (icon on top, text below)
class TotalPushupsCard extends StatelessWidget {
  final int total;
  final int goal;

  const TotalPushupsCard({
    super.key,
    required this.total,
    this.goal = 5050,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal == 0 ? 0.0 : (total / goal).clamp(0.0, 1.0);
    final percentage = (progress * 100).round();

    return FrostCard(
      height: 148,
      child: Column(
        children: [
          // Icon circle at top
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
            child: Icon(
              Icons.directions_run_rounded,
              color: Colors.black.withOpacity(0.82),
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          // Label
          Text(
            'TOTALE PUSHUPS',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: Colors.white.withOpacity(0.70),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$total / $goal',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // Progress bar
          ProgressBar(value: progress),
          const SizedBox(height: 6),
          // Percentage
          Text(
            '$percentage%',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: Colors.white.withOpacity(0.55),
            ),
          ),
        ],
      ),
    );
  }
}
