import 'package:flutter/material.dart';
import 'app_colors.dart';
class AppDecorations {
  AppDecorations._();
  static BoxDecoration get card => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Card with custom border radius
  static BoxDecoration cardWithRadius(double radius) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Card with custom color
  static BoxDecoration cardWithColor(Color color) => BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      );

  /// Card with no shadow (flat design)
  static BoxDecoration get cardFlat => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      );

  /// Card with stronger shadow (elevated)
  static BoxDecoration get cardElevated => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      );
  /// Circle with gradient (for progress indicators)
  static BoxDecoration circleGradient(Gradient gradient) => BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
      );

  /// Circle with solid color
  static BoxDecoration circleColor(Color color) => BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      );

  /// Circle with shadow
  static BoxDecoration get circleShadow => BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      );
  /// Dark button style for ElevatedButton
  static ButtonStyle get elevatedButtonDark => ElevatedButton.styleFrom(
        backgroundColor: AppColors.cardDark,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      );

  /// Light button style for ElevatedButton
  static ButtonStyle get elevatedButtonLight => ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textDark,
        side: BorderSide(color: Colors.grey.shade200),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      );
  /// Primary colored button style
  static ButtonStyle get elevatedButtonPrimary => ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      );
  /// Bottom navigation bar container style
  static BoxDecoration get bottomNavBar => BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      );
  /// Rounded container with border
  static BoxDecoration containerBorder({
    Color? color,
    Color? borderColor,
    double radius = 16,
    double borderWidth = 1,
  }) =>
      BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: borderColor ?? Colors.grey.shade200,
          width: borderWidth,
        ),
      );
}