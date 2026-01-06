import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';

class WeeklyInsightsCard extends StatelessWidget {
  final int totalRuns;
  final double totalDistance;
  final String totalDuration;

  const WeeklyInsightsCard({
    Key? key,
    required this.totalRuns,
    required this.totalDistance,
    required this.totalDuration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final insights = _generateInsights();
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: AppColors.warning, size: 24),
              SizedBox(width: 12),
              Text(
                'Weekly Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textDark,
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          ...insights.map((insight) => _buildInsightItem(insight)),
        ],
      ),
    );
  }

  Widget _buildInsightItem(_Insight insight) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: EdgeInsets.only(top: 6),
            decoration: BoxDecoration(
              color: insight.color,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              insight.text,
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<_Insight> _generateInsights() {
    List<_Insight> insights = [];
    
    if (totalRuns == 0) {
      insights.add(_Insight(
        'Start with 2-3 runs this week for best results',
        AppColors.info,
      ));
    } else if (totalRuns < 3) {
      insights.add(_Insight(
        'Try to reach 3 runs this week for consistency',
        AppColors.warning,
      ));
    } else if (totalRuns >= 4) {
      insights.add(_Insight(
        'Excellent frequency! You\'re building great habits',
        AppColors.success,
      ));
    }
    
    if (totalDistance < 5) {
      insights.add(_Insight(
        'Aim for 10-15 km weekly for cardiovascular benefits',
        AppColors.info,
      ));
    } else if (totalDistance >= 5 && totalDistance < 15) {
      insights.add(_Insight(
        'Good progress! Consider increasing distance gradually',
        AppColors.warning,
      ));
    } else {
      insights.add(_Insight(
        'Amazing mileage! Remember to include rest days',
        AppColors.success,
      ));
    }
    
    final dayOfWeek = DateTime.now().weekday;
    if (totalRuns >= 3 && dayOfWeek >= 5) {
      insights.add(_Insight(
        'Consider taking a rest day for muscle recovery',
        AppColors.accent,
      ));
    }
    
    return insights;
  }
}

class _Insight {
  final String text;
  final Color color;

  _Insight(this.text, this.color);
}