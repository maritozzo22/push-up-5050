import 'package:flutter/material.dart';
import 'progress_bar.dart';

class MiniStat extends StatelessWidget {
  final String label;
  final String value;
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
