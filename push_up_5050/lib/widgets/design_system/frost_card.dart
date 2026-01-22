import 'dart:ui';
import 'package:flutter/material.dart';

class FrostCard extends StatelessWidget {
  final double? height;
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const FrostCard({
    super.key,
    this.height,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          constraints: height != null
              ? BoxConstraints(
                  minHeight: height!,
                  maxHeight: height!,
                )
              : null,
          padding: padding ?? const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF161A20).withOpacity(0.60),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.30),
                blurRadius: 26,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
