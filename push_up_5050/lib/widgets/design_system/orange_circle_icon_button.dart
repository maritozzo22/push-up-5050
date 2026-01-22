import 'package:flutter/material.dart';

class OrangeCircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final bool disabled;

  const OrangeCircleIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final button = GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFB347), Color(0xFFFF5F1F)],
          ),
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
      ),
    );

    if (disabled) {
      return Opacity(
        opacity: 0.5,
        child: button,
      );
    }

    return button;
  }
}
