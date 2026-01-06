import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import 'filter.dart';
import 'suggestion.dart';
import 'weekly_insight.dart';
import 'stat_card_graph.dart';
import '../charts/runs_bar_chart.dart';
import '../charts/distance_chart.dart';
import '../charts/duration.dart';

class StatsSection extends StatelessWidget {
  final String selectedPeriod;
  final Function(String) onPeriodChanged;
  final WeeklyStats? stats;

  const StatsSection({
    Key? key,
    required this.selectedPeriod,
    required this.onPeriodChanged,
    required this.stats,
  }) : super(key: key);

  String _getSubtitle(String unit, dynamic value) {
    if (selectedPeriod == 'This Week') {
      return '$value $unit this week';
    } else {
      return '$value $unit this month';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Your Progress',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    DefaultTabController.of(context)?.animateTo(2);
                  },
                  child: Text(
                    'See All',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: 16),
          
          FilterChips(
            selectedPeriod: selectedPeriod,
            onPeriodChanged: onPeriodChanged,
          ),
          
          SizedBox(height: 24),
          
          if (stats != null) ...[
            FriendlySuggestionCard(
              totalRuns: stats!.totalRuns,
              totalDistance: stats!.totalDistance,
              selectedPeriod: selectedPeriod,
            ),
            
            SizedBox(height: 16),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  StatCardWithGraph(
                    title: 'Total Runs',
                    subtitle: _getSubtitle('runs', stats!.totalRuns),
                    value: stats!.totalRuns,
                    icon: Icons.directions_run,
                    chart: RunsBarChart(period: selectedPeriod),
                  ),
                  SizedBox(height: 16),
                  StatCardWithGraph(
                    title: 'Distance',
                    subtitle: _getSubtitle('km', stats!.totalDistance.toStringAsFixed(1)),
                    value: stats!.totalDistance.toStringAsFixed(1),
                    icon: Icons.straighten,
                    chart: DistanceLineChart(period: selectedPeriod),
                  ),
                  SizedBox(height: 16),
                  StatCardWithGraph(
                    title: 'Duration',
                    subtitle: stats!.totalDuration,
                    value: stats!.totalDuration,
                    icon: Icons.timer,
                    chart: DurationBarChart(period: selectedPeriod),
                  ),
                ],
              ),
            ),
            
            SizedBox(height: 24),
            
            if (selectedPeriod == 'This Week')
              WeeklyInsightsCard(
                totalRuns: stats!.totalRuns,
                totalDistance: stats!.totalDistance,
                totalDuration: stats!.totalDuration,
              ),
          ],
        ],
      ),
    );
  }
}