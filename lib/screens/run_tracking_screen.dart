import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../utils/app_text_styles.dart';
import '../widgets/custom_button.dart';

class RunTrackingScreen extends StatefulWidget {
  const RunTrackingScreen({Key? key}) : super(key: key);

  @override
  State<RunTrackingScreen> createState() => _RunTrackingScreenState();
}

class _RunTrackingScreenState extends State<RunTrackingScreen> {
  bool _isRunning = false;

  void _toggleRun() {
    setState(() {
      _isRunning = !_isRunning;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Large running icon
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: _isRunning 
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.primary.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isRunning ? Icons.pause_circle_filled : Icons.play_circle_filled,
                size: 120,
                color: _isRunning ? AppColors.success : AppColors.primary,
              ),
            ),
            
            const SizedBox(height: 48),
            
            // Placeholder stats
            Text(
              _isRunning ? 'Running...' : 'Ready to Run',
              style: AppTextStyles.h1,
            ),
            const SizedBox(height: 32),
            
            if (_isRunning) ...[
              _buildStatRow('Distance', '0.00 km'),
              const SizedBox(height: 16),
              _buildStatRow('Duration', '00:00'),
              const SizedBox(height: 16),
              _buildStatRow('Pace', '--:-- /km'),
            ] else ...[
              Text(
                'Press start to begin tracking',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
            
            const SizedBox(height: 48),
            
            // Start/Stop button
            CustomButton(
              text: _isRunning ? 'Stop Run' : 'Start Run',
              onPressed: _toggleRun,
              color: _isRunning ? AppColors.error : AppColors.success,
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.h2,
        ),
      ],
    );
  }
}