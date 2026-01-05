import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStat('Runs', '$totalRuns', Icons.directions_run)),
              Expanded(child: _buildStat('Distance', '${totalDistance.toStringAsFixed(1)} km', Icons.straighten)),
            ],
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStat('Duration', totalDuration, Icons.timer)),
              Expanded(child: _buildStat('Avg Pace', '$averagePace/km', Icons.speed)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textSecondary),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}