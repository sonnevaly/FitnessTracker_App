import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../models/mock_sessions.dart';

class SessionListItem extends StatelessWidget {
  final MockSession session;
  
  const SessionListItem({Key? key, required this.session}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.directions_run,
            color: AppColors.primary,
            size: 28,
          ),
        ),
        title: Text(
          '${session.distance.toStringAsFixed(2)} km',
          style: AppTextStyles.h3,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              session.formattedDate,
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Icon(Icons.timer, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  session.formattedDuration,
                  style: AppTextStyles.caption,
                ),
                const SizedBox(width: 16),
                Icon(Icons.speed, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(
                  session.formattedPace,
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: _getRPEColor(session.rpe),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'RPE ${session.rpe}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
  
  Color _getRPEColor(int rpe) {
    if (rpe <= 3) return AppColors.success;
    if (rpe <= 6) return AppColors.info;
    if (rpe <= 8) return AppColors.warning;
    return AppColors.error;
  }
}