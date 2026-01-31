import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Total Pushups Card - displays total pushups vs goal.
///
/// Shows:
/// - Icon with orange gradient circle (TOP)
/// - "TOTALE PUSHUPS:" label
/// - "X / Y" value display
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

    return FrostCard(
      height: 120,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Column(
        children: [
          // Icon circle at top
          Container(
            width: 32,
            height: 32,
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
                  blurRadius: 10,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              Icons.directions_run_rounded,
              color: Colors.black.withOpacity(0.82),
              size: 16,
            ),
          ),
          const SizedBox(height: 4),
          // Label
          Text(
            'TOTALE PUSHUPS',
            style: TextStyle(
              fontSize: 8,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
              color: Colors.white.withOpacity(0.70),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          // Value
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              '$total / $goal',
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
