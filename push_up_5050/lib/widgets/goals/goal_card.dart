import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:push_up_5050/models/goal.dart';
import 'package:push_up_5050/widgets/design_system/progress_bar.dart';

/// Goal card widget displaying goal progress with glass effect.
///
/// Shows:
/// - Goal title (top)
/// - Description with current/target values
/// - Progress bar
/// - Percentage indicator
class GoalCard extends StatelessWidget {
  final Goal goal;

  const GoalCard({
    super.key,
    required this.goal,
  });

  IconData _getIconForName(String iconName) {
    switch (iconName) {
      case 'calendar_week':
        return Icons.calendar_view_week_rounded;
      case 'calendar_month':
        return Icons.calendar_month_rounded;
      case 'military_tech':
        return Icons.military_tech_rounded;
      case 'emoji_events':
        return Icons.emoji_events_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'workspace_premium':
        return Icons.workspace_premium_rounded;
      default:
        return Icons.flag_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFF161A20).withOpacity(0.55),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: goal.isCompleted
                  ? const Color(0xFFFF7A18).withOpacity(0.3)
                  : Colors.white.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Title
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: goal.isCompleted
                          ? const LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
                            )
                          : null,
                      color: goal.isCompleted
                          ? null
                          : Colors.white.withOpacity(0.1),
                    ),
                    child: Icon(
                      _getIconForName(goal.iconName),
                      size: 16,
                      color: goal.isCompleted
                          ? Colors.black87
                          : Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      goal.title,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                        color: goal.isCompleted
                            ? const Color(0xFFFF7A18)
                            : Colors.white.withOpacity(0.60),
                      ),
                    ),
                  ),
                  if (goal.isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF7A18).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'COMPLETATO',
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF7A18),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              // Value display
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  '${goal.current} / ${goal.target}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                goal.description,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.50),
                ),
              ),
              const SizedBox(height: 10),
              // Progress bar
              ProgressBar(value: goal.progress),
              const SizedBox(height: 4),
              // Percentage
              Text(
                '${goal.percentage}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withOpacity(0.55),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
