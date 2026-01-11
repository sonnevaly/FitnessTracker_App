import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class RpeService {
  static Color color(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }

  static String label(int rpe) {
    if (rpe <= 2) return 'Very Easy';
    if (rpe <= 4) return 'Easy';
    if (rpe <= 6) return 'Moderate';
    if (rpe <= 8) return 'Hard';
    return 'Very Hard';
  }
}
