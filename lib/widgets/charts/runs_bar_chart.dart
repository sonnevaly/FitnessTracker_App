import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';

class RunsBarChart extends StatelessWidget {
  const RunsBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final sessions = provider.recentSessions;

    // Count runs per weekday (Mon-Sun)
    final List<int> runsPerDay = List.filled(7, 0);

    for (var s in sessions) {
      final weekday = s.date.weekday - 1; // Mon=0
      if (weekday >= 0 && weekday < 7) {
        runsPerDay[weekday]++;
      }
    }

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final value = runsPerDay[i];
          final height = value == 0 ? 4.0 : value * 20.0;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: height,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                const SizedBox(height: 6),
                Text(['Mon','Tue','Wed','Thu','Fri','Sat','Sun'][i],
                    style: const TextStyle(fontSize: 10)),
              ],
            ),
          );
        }),
      ),
    );
  }
}
