import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';

class DurationBarChart extends StatelessWidget {
  const DurationBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final sessions = provider.recentSessions;

    // Sum duration per day
    final List<int> durationPerDay = List.filled(7, 0);

    for (var s in sessions) {
      final day = s.date.weekday - 1;
      if (day >= 0 && day < 7) {
        durationPerDay[day] += s.durationInSeconds;
      }
    }

    final maxValue = durationPerDay.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final v = durationPerDay[i];
          final h = maxValue == 0 ? 4.0 : (v / maxValue) * 80 + 4;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: h,
                  decoration: BoxDecoration(
                    color: Colors.orange,
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
