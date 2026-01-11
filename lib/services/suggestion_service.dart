import 'package:flutter/material.dart';

class SuggestionItem {
  final String title;
  final String message;
  final IconData icon;
  final Color color;

  const SuggestionItem({
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
  });
}

class SuggestionService {
  static SuggestionItem generate({
    required int totalRuns,
    required double totalDistance,
    required String period,
  }) {
    final hour = DateTime.now().hour;

    if (hour >= 5 && hour < 11) {
      if (totalRuns == 0) {
        return const SuggestionItem(
          title: 'Good Morning, Runner!',
          message: 'Perfect weather for a morning run. Start your day strong!',
          icon: Icons.wb_sunny,
          color: Color(0xFFFFA726),
        );
      }
      return const SuggestionItem(
        title: 'Great Morning Energy!',
        message: 'You’ve been consistent. Keep up the momentum!',
        icon: Icons.local_fire_department,
        color: Color(0xFFFF6B6B),
      );
    }

    if (hour >= 11 && hour < 17) {
      if (totalRuns < 2 && period == 'This Week') {
        return const SuggestionItem(
          title: 'Midday Boost Needed!',
          message: 'A quick 20-minute run can energize your afternoon.',
          icon: Icons.trending_up,
          color: Color(0xFF42A5F5),
        );
      }
      return SuggestionItem(
        title: 'You’re On Track!',
        message: 'Great progress! ${totalDistance.toStringAsFixed(1)} km covered.',
        icon: Icons.check_circle,
        color: const Color(0xFF66BB6A),
      );
    }

    if (hour >= 17 && hour < 21) {
      if (totalRuns < 3 && period == 'This Week') {
        return const SuggestionItem(
          title: 'Evening Run Time!',
          message: 'Beat the stress with a refreshing evening run.',
          icon: Icons.nightlight_round,
          color: Color(0xFF7E57C2),
        );
      }
      return SuggestionItem(
        title: 'Strong Week!',
        message: '$totalRuns runs completed. You’re crushing it!',
        icon: Icons.emoji_events,
        color: const Color(0xFFFFB300),
      );
    }

    return const SuggestionItem(
      title: 'Rest & Recover',
      message: 'Great work today! Your body needs quality rest.',
      icon: Icons.bedtime,
      color: Color(0xFF5C6BC0),
    );
  }
}
