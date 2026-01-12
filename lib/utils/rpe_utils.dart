import 'package:flutter/material.dart';
import 'app_colors.dart';
class RpeUtils {
  RpeUtils._();
  static Color getColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
  static String getLabel(int rpe) {
    if (rpe <= 2) return 'Very Easy';
    if (rpe <= 4) return 'Easy';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Very Hard';
  }

  /// Get intensity description for RPE value
  static String getDescription(int rpe) {
    if (rpe <= 2) return 'Recovery pace, very comfortable';
    if (rpe <= 4) return 'Comfortable pace, can talk easily';
    if (rpe <= 6) return 'Moderate effort, controlled breathing';
    if (rpe <= 8) return 'Hard effort, difficult to talk';
    return 'Maximum effort, cannot talk';
  }
}