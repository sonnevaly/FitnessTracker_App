import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/state_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textLight,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Stats',
              style: AppTextStyles.h2,
            ),
            const SizedBox(height: 16),
            
            // Placeholder stat cards
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'Total Runs',
                    value: '0',
                    icon: Icons.directions_run,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'Total Distance',
                    value: '0 km',
                    icon: Icons.straighten,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(
                  child: StatCard(
                    label: 'Avg Pace',
                    value: '--:--',
                    icon: Icons.speed,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    label: 'This Week',
                    value: '0 km',
                    icon: Icons.calendar_today,
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Placeholder for recent activity
            Text(
              'Recent Activity',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 64,
                      color: AppColors.textSecondary.withOpacity(0.5),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No runs yet',
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start your first run to see stats here!',
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}