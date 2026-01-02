import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF2196F3);
  static const Color primaryDark = Color(0xFF1976D2);
  static const Color primaryLight = Color(0xFF64B5F6);

  // Background colors
  static const Color background = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFFEEEEEE);

  // Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textLight = Color(0xFFFFFFFF);

  // Accent colors
  static const Color accent = Color(0xFFFF5722);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color info = Color(0xFF2196F3);

  // Chart colors
  static const Color chartBlue = Color(0xFF2196F3);
  static const Color chartGreen = Color(0xFF4CAF50);
  static const Color chartOrange = Color(0xFFFF9800);
  static const Color chartRed = Color(0xFFF44336);
  static const Color chartPurple = Color(0xFF9C27B0);

  // RPE (Rate of Perceived Exertion) colors
  static Color getRPEColor(int rpe) {
    if (rpe <= 3) return const Color(0xFF4CAF50); // Easy - Green
    if (rpe <= 5) return const Color(0xFF8BC34A); // Light Green
    if (rpe <= 7) return const Color(0xFFFFC107); // Moderate - Yellow
    if (rpe <= 8) return const Color(0xFFFF9800); // Orange
    return const Color(0xFFF44336); // Hard - Red
  }

  // Run type colors
  static Color getRunTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'tempo':
        return const Color(0xFFFF9800);
      case 'interval':
        return const Color(0xFFF44336);
      case 'long':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  // Gradient colors
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryLight, primary, primaryDark],
  );
}