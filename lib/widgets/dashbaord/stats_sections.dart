import 'package:flutter/material.dart';
import '../../utils/app_colors.dart';
import '../../models/weekly_stats.dart';
import '../../screens/history_screen.dart';
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
    return '$value $unit this week';
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const HistoryScreen(),
                      ),
                    );
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
                  StatCardWithGraph(
                    title: 'Total Runs',
                    subtitle: _getSubtitle('runs', stats!.numberOfRuns),
                    value: stats!.numberOfRuns,
                    icon: Icons.directions_run,
                    chart: const RunsBarChart(),
                  ),
                  const SizedBox(height: 16),
                  StatCardWithGraph(
                    title: 'Distance',
                    subtitle: _getSubtitle(
                      'km',
                      stats!.totalDistance.toStringAsFixed(1),
                    ),
                    value: stats!.totalDistance.toStringAsFixed(1),
                    icon: Icons.straighten,
                    chart: const DistanceLineChart(),
                  ),
                  const SizedBox(height: 16),
                  StatCardWithGraph(
                    title: 'Duration',
                    subtitle: stats!.formattedTotalDuration,
                    value: stats!.formattedTotalDuration,
                    icon: Icons.timer,
                    chart: const DurationBarChart(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
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
