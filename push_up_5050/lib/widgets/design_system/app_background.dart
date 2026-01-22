import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class AppBackground extends StatelessWidget {
  const AppBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Sfondo nero puro
          const DecoratedBox(
            decoration: BoxDecoration(color: AppColors.pureBlack),
          ),
          // Glow arancione in basso
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: const Alignment(0, 0.90),
                  radius: 1.6,
                  colors: [
                    const Color(0x14FF7A18),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
