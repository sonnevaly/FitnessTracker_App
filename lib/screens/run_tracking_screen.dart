import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/run_tracking_provider.dart';
import '../utils/app_colors.dart';
import '../widgets/rpe_dialog.dart';

class RunTrackingScreen extends StatelessWidget {
  const RunTrackingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RunTrackingProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () {},
                    ),
                    Text(
                      'Track Run',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    ),
                  ],
                ),
                
                SizedBox(height: 40),
                
                // Large circular progress
                _buildProgressCircle(provider),
                
                SizedBox(height: 48),
                
                // Stats cards
                if (provider.isRunning) ...[
                  Row(
                    children: [
                      Expanded(
                        child: _buildMiniStatCard(
                          'Distance',
                          '${provider.formattedDistance} km',
                          Icons.straighten,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildMiniStatCard(
                          'Pace',
                          '${provider.formattedPace}',
                          Icons.speed,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 48),
                ],
                
                // Control buttons
                if (!provider.isRunning)
                  _buildStartButton(provider)
                else
                  _buildControlButtons(context, provider),
                
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  Widget _buildProgressCircle(RunTrackingProvider provider) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Outer circle
        Container(
          width: 240,
          height: 240,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 30,
                offset: Offset(0, 10),
              ),
            ],
          ),
        ),
        // Inner circle with gradient
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: provider.isRunning
                ? (provider.isPaused 
                    ? LinearGradient(
                        colors: [Color(0xFFFBBF24), Color(0xFFF59E0B)],
                      )
                    : AppColors.successGradient)
                : AppColors.primaryGradient,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  provider.isRunning
                      ? (provider.isPaused 
                          ? Icons.pause
                          : Icons.directions_run)
                      : Icons.play_arrow,
                  color: Colors.white,
                  size: 48,
                ),
                SizedBox(height: 12),
                Text(
                  provider.isRunning
                      ? provider.formattedDuration
                      : 'Ready',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (!provider.isRunning)
                  Text(
                    'to Run',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildMiniStatCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.textSecondary, size: 24),
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
      ),
    );
  }
  
  Widget _buildStartButton(RunTrackingProvider provider) {
    return Container(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () => provider.startRun(),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.cardDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: Text(
          'START RUN',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }
  
  Widget _buildControlButtons(BuildContext context, RunTrackingProvider provider) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (provider.isPaused) {
                  provider.resumeRun();
                } else {
                  provider.pauseRun();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.textDark,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                side: BorderSide(color: Colors.grey.shade200),
              ),
              child: Text(
                provider.isPaused ? 'RESUME' : 'PAUSE',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 56,
            child: ElevatedButton(
              onPressed: () => _showStopDialog(context, provider),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.cardDark,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                'STOP',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
  
  void _showStopDialog(BuildContext context, RunTrackingProvider provider) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => RPEDialog(
        onSave: (rpe) async {
          Navigator.pop(context);
          await provider.stopRun(rpe);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Run saved with RPE $rpe!'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
        },
      ),
    );
  }
}