import 'package:flutter/material.dart';
import 'app_colors.dart';

class Formatters {
  static String distance(double km) {
    return '${km.toStringAsFixed(2)} km';
  }

  static String duration(int seconds) {
    final totalMinutes = seconds ~/ 60;

    if (totalMinutes < 60) {
      return '$totalMinutes min';
    }

    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }

  static String pace(double km, int seconds) {
    if (km == 0) return '0:00 /km';

    final paceSeconds = seconds / km;
    final minutes = paceSeconds ~/ 60;
    final remainSeconds = (paceSeconds % 60).toInt();

    return '${minutes}:${remainSeconds.toString().padLeft(2, '0')} /km';
  }

  static String date(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  static Color rpeColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
}
