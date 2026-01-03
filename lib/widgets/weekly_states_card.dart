import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';

class WeeklyStatsCard extends StatelessWidget {
  final int totalRuns;
  final double totalDistance;
  final String totalDuration;
  final String averagePace;
  
  const WeeklyStatsCard({
    Key? key,
    required this.totalRuns,
    required this.totalDistance,
    required this.totalDuration,
    required this.averagePace,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Icon(Icons.calendar_today, color: AppColors.primary, size: 24),
              const SizedBox(width: 12),
              Text(
                'This Week',
                style: AppTextStyles.h2,
              ),
            ],
          ),
          
          const SizedBox(height: 20),
          
          // Stats Grid - Row 1
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Total Runs',
                  '$totalRuns',
                  Icons.directions_run,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Distance',
                  '${totalDistance.toStringAsFixed(1)} km',
                  Icons.straighten,
                  AppColors.success,
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Stats Grid - Row 2
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Duration',
                  totalDuration,
                  Icons.timer,
                  AppColors.warning,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Avg Pace',
                  '$averagePace/km',
                  Icons.speed,
                  AppColors.info,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTextStyles.h2.copyWith(color: color),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.caption,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}