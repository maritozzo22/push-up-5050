import 'package:flutter/material.dart';
import 'package:push_up_5050/widgets/design_system/frost_card.dart';

/// Calorie Card - displays calories burned.
///
/// Shows:
/// - Fire icon with orange gradient circle (TOP)
/// - "CALORIE BRUCIATE:" label
/// - "{kcal} kcal" value display
///
/// Used in Statistics Screen.
/// Calories calculated as: pushups × 0.45
/// Layout: Vertical (icon on top, text below)
class CalorieCard extends StatelessWidget {
  final int kcal;

  const CalorieCard({
    super.key,
    required this.kcal,
  });

  /// Create CalorieCard from total pushups.
  factory CalorieCard.fromPushups({required int totalPushups, Key? key}) {
    return CalorieCard(
      key: key,
      kcal: (totalPushups * 0.45).round(),
    );
  }

  @override
  Widget build(BuildContext context) {
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
            child: const Icon(
              Icons.local_fire_department_rounded,
              color: Colors.black87,
              size: 24,
            ),
          ),
          const SizedBox(height: 10),
          // Label
          Text(
            'CALORIE BRUCIATE',
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
              '$kcal kcal',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
          const Spacer(),
          // Small indicator bar at bottom
          Container(
            height: 4,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xFFFFB347), Color(0xFFFF7A18)],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}
