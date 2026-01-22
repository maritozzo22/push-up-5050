import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final double value;

  const ProgressBar({super.key, required this.value});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(999),
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 9,
          maxHeight: 9,
        ),
        color: Colors.white.withOpacity(0.08),
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
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
