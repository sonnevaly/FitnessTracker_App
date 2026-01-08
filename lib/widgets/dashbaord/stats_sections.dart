import 'package:flutter/material.dart';
import '../../models/running_session.dart';
import '../../models/weekly_stats.dart';
import '../../screens/history_screen.dart';
import '../charts/distance_chart.dart';
import '../charts/duration_chart.dart';
import '../charts/run_bar_chart.dart';
import 'stat_card_graph.dart';

class StatsSection extends StatelessWidget {
  final List<RunningSession> sessions;
  final WeeklyStats? stats;
  final VoidCallback onRefresh;

  const StatsSection({
    super.key,
    required this.sessions,
    required this.stats,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (stats == null) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Your Progress',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                  onRefresh(); // 🔥 refresh after history change
                },
                child: const Text('See All'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          StatCardWithGraph(
            title: 'Total Runs',
            subtitle: '${stats!.numberOfRuns} runs',
            icon: Icons.directions_run,
            chart: RunsBarChart(runs: stats!.numberOfRuns),
          ),

          const SizedBox(height: 16),

          StatCardWithGraph(
            title: 'Distance',
            subtitle: '${stats!.totalDistance.toStringAsFixed(2)} km',
            icon: Icons.straighten,
            chart: DistanceLineChart(
              distances: stats!.distancePerRun(sessions),
            ),
          ),

          const SizedBox(height: 16),

          StatCardWithGraph(
            title: 'Duration',
            subtitle: stats!.formattedTotalDuration,
            icon: Icons.timer,
            chart: DurationBarChart(
              durationsInMinutes: stats!.durationPerRun(sessions),
            ),
          ),
        ],
      ),
    );
  }
}
