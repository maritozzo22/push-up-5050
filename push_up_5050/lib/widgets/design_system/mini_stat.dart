import 'package:flutter/material.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';
import 'progress_bar.dart';

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final bool showBar;
  final double barValue;
  final IconData? icon;
  final Color? iconColor;
  final String? subtitle;

  const MiniStat({
    super.key,
    required this.label,
    required this.value,
    this.showBar = false,
    this.barValue = 0,
    this.icon,
    this.iconColor,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header row with label and optional icon
        Row(
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
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(
                icon,
                size: 14,
                color: iconColor ?? AppColors.primaryOrange,
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
        // Value row
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ),
            ],
          ],
        ),
        const Spacer(),
        if (showBar) ProgressBar(value: barValue),
      ],
    );
  }
}
