import 'package:flutter/material.dart';
import 'app_colors.dart';

class RPEHelper {
  static Color color(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
}
