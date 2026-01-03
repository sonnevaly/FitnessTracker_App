import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/run_tracking_provider.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_button.dart';
import '../widgets/rpe_dialog.dart';

class RunTrackingScreen extends StatelessWidget {
  const RunTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RunTrackingProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Track Run',
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
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large status circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: provider.isRunning 
                    ? (provider.isPaused 
                        ? AppColors.warning.withOpacity(0.1)
                        : AppColors.success.withOpacity(0.1))
                    : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                provider.isRunning 
                    ? (provider.isPaused 
                        ? Icons.pause_circle_filled 
                        : Icons.directions_run)
                    : Icons.play_circle_filled,
                size: 100,
                color: provider.isRunning 
                    ? (provider.isPaused 
                        ? AppColors.warning 
                        : AppColors.success)
                    : AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Live stats display (only when running)
            if (provider.isRunning) ...[
              _buildStatDisplay(
                'Duration',
                provider.formattedDuration,
                Icons.timer,
              ),
              const SizedBox(height: 16),
              _buildStatDisplay(
                'Distance',
                '${provider.formattedDistance} km',
                Icons.straighten,
              ),
              const SizedBox(height: 16),
              _buildStatDisplay(
                'Current Pace',
                '${provider.formattedPace} min/km',
                Icons.speed,
              ),
              const SizedBox(height: 48),
            ] else ...[
              Text(
                'Ready to Run',
                style: AppTextStyles.h1,
              ),
              const SizedBox(height: 16),
              Text(
                'Press START to begin tracking',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 48),
            ],
            
            // Control buttons
            if (!provider.isRunning) ...[
              // START button
              CustomButton(
                text: 'START',
                icon: Icons.play_arrow,
                onPressed: () => provider.startRun(),
                color: AppColors.success,
                height: 60,
              ),
            ] else ...[
              // PAUSE/RESUME and STOP buttons
              Row(
                children: [
                  Expanded(
                    child: CustomButton(
                      text: provider.isPaused ? 'RESUME' : 'PAUSE',
                      icon: provider.isPaused ? Icons.play_arrow : Icons.pause,
                      onPressed: () {
                        if (provider.isPaused) {
                          provider.resumeRun();
                        } else {
                          provider.pauseRun();
                        }
                      },
                      color: AppColors.warning,
                      height: 60,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: CustomButton(
                      text: 'STOP',
                      icon: Icons.stop,
                      onPressed: () => _showStopDialog(context, provider),
                      color: AppColors.error,
                      height: 60,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatDisplay(String label, String value, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 28, color: AppColors.primary),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption,
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  void _showStopDialog(BuildContext context, RunTrackingProvider provider) {
    showDialog(
      context: context,
      builder: (context) => RPEDialog(
        onSave: (rpe) {
          provider.stopRun();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Run saved with RPE $rpe!'),
              backgroundColor: AppColors.success,
            ),
          );
        },
      ),
    );
  }
}