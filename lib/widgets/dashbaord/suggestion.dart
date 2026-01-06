import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class FriendlySuggestionCard extends StatelessWidget {
  final int totalRuns;
  final double totalDistance;
  final String selectedPeriod;

  const FriendlySuggestionCard({
    Key? key,
    required this.totalRuns,
    required this.totalDistance,
    required this.selectedPeriod,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestion = _generateSuggestion();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            suggestion.color.withOpacity(0.1),
            suggestion.color.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: suggestion.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: suggestion.color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              suggestion.icon,
              color: suggestion.color,
              size: 28,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  suggestion.message,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _Suggestion _generateSuggestion() {
    final hour = DateTime.now().hour;
    
    if (hour >= 5 && hour < 11) {
      if (totalRuns == 0) {
        return _Suggestion(
          title: 'Good Morning, Runner!',
          message: 'Perfect weather for a morning run. Start your day strong!',
          icon: Icons.wb_sunny,
          color: Color(0xFFFFA726),
        );
      }
      return _Suggestion(
        title: 'Great Morning Energy! ⚡',
        message: 'You\'ve been consistent! Keep up the momentum.',
        icon: Icons.local_fire_department,
        color: Color(0xFFFF6B6B),
      );
    }
    
    if (hour >= 11 && hour < 17) {
      if (totalRuns < 2 && selectedPeriod == 'This Week') {
        return _Suggestion(
          title: 'Midday Boost Needed! 💪',
          message: 'A quick 20-minute run can energize your afternoon.',
          icon: Icons.trending_up,
          color: Color(0xFF42A5F5),
        );
      }
      return _Suggestion(
        title: 'You\'re On Track! 🎯',
        message: 'Great progress! ${totalDistance.toStringAsFixed(1)} km covered so far.',
        icon: Icons.check_circle,
        color: Color(0xFF66BB6A),
      );
    }
    
    if (hour >= 17 && hour < 21) {
      if (totalRuns < 3 && selectedPeriod == 'This Week') {
        return _Suggestion(
          title: 'Evening Run Time! 🌆',
          message: 'Beat the stress with a refreshing evening run.',
          icon: Icons.nightlight_round,
          color: Color(0xFF7E57C2),
        );
      }
      return _Suggestion(
        title: 'Strong Week! 🔥',
        message: '$totalRuns runs completed. You\'re crushing it!',
        icon: Icons.emoji_events,
        color: Color(0xFFFFB300),
      );
    }
    
    return _Suggestion(
      title: 'Rest & Recover 😴',
      message: 'Great work today! Your body needs quality rest.',
      icon: Icons.bedtime,
      color: Color(0xFF5C6BC0),
    );
  }
}

class _Suggestion {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  _Suggestion({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}