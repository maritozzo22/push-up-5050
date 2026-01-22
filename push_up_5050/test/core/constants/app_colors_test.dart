import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:push_up_5050/core/constants/app_colors.dart';

void main() {
  group('AppColors', () {
    test('primary orange should be correct HEX value', () {
      expect(AppColors.primaryOrange, const Color(0xFFFF6B00));
    });

    test('background should be correct HEX value', () {
      expect(AppColors.background, const Color(0xFF1A1A1A));
    });

    test('all recovery timer colors should be defined', () {
      expect(AppColors.recoveryFull, const Color(0xFF4CAF50));
      expect(AppColors.recoveryWarning, const Color(0xFFFF9800));
      expect(AppColors.recoveryCritical, const Color(0xFFF44336));
    });

    test('text colors should have correct opacity', () {
      expect(AppColors.textPrimary.opacity, 1.0);
      // textSecondary is 0xB3FFFFFF which is 179/255 ≈ 0.702
      expect(AppColors.textSecondary.alpha, 179);
    });
  });
}
