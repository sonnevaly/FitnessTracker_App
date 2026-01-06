import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../providers/dashboard_provider.dart';
import '../../models/weekly_stats.dart';
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
                const Text(
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
          const SizedBox(height: 16),
          FilterChips(
            selectedPeriod: selectedPeriod,
            onPeriodChanged: onPeriodChanged,
          ),
          const SizedBox(height: 24),
          if (stats != null) ...[
            // Suggestion card
            FriendlySuggestionCard(
              totalRuns: stats!.numberOfRuns,
              totalDistance: stats!.totalDistance,
              selectedPeriod: selectedPeriod,
            ),
            const SizedBox(height: 16),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                children: [
                  // Total runs
                  StatCardWithGraph(
                    title: 'Total Runs',
                    subtitle: _getSubtitle('runs', stats!.numberOfRuns),
                    value: stats!.numberOfRuns,
                    icon: Icons.directions_run,
                    chart: RunsBarChart(period: selectedPeriod),
                  ),
                  const SizedBox(height: 16),

                  // Distance
                  StatCardWithGraph(
                    title: 'Distance',
                    subtitle: _getSubtitle(
                      'km',
                      stats!.totalDistance.toStringAsFixed(1),
                    ),
                    value: stats!.totalDistance.toStringAsFixed(1),
                    icon: Icons.straighten,
                    chart: DistanceLineChart(period: selectedPeriod),
                  ),
                  const SizedBox(height: 16),

                  // Duration
                  StatCardWithGraph(
                    title: 'Duration',
                    subtitle: stats!.formattedTotalDuration,
                    value: stats!.formattedTotalDuration,
                    icon: Icons.timer,
                    chart: DurationBarChart(period: selectedPeriod),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Weekly insight
            if (selectedPeriod == 'This Week')
              WeeklyInsightsCard(
                totalRuns: stats!.numberOfRuns,
                totalDistance: stats!.totalDistance,
                totalDuration: stats!.formattedTotalDuration,
              ),
          ],
        ],
      ),
    );
  }
}
