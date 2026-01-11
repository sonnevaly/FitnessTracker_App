import 'package:flutter/material.dart';

class InsightItem {
  final String text;
  final Color color;

  const InsightItem(this.text, this.color);
}

class WeeklyInsightService {
  static List<InsightItem> generate(int runs, double distance) {
    final List<InsightItem> insights = [];

    if (runs == 0) {
      insights.add(const InsightItem(
        'Start with 2–3 runs this week for best results',
        Colors.blue,
      ));
    } else if (runs < 3) {
      insights.add(const InsightItem(
        'Try to reach 3 runs this week for consistency',
        Colors.orange,
      ));
    } else {
      insights.add(const InsightItem(
        'Excellent frequency! You’re building great habits',
        Colors.green,
      ));
    }

    if (distance < 5) {
      insights.add(const InsightItem(
        'Aim for 10–15 km weekly for cardiovascular benefits',
        Colors.blue,
      ));
    } else if (distance < 15) {
      insights.add(const InsightItem(
        'Good progress! Increase distance gradually',
        Colors.orange,
      ));
    } else {
      insights.add(const InsightItem(
        'Amazing mileage! Remember to rest properly',
        Colors.green,
      ));
    }

    return insights;
  }
}
