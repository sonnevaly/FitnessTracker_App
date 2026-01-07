import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/dashboard_provider.dart';

class DistanceLineChart extends StatelessWidget {
  const DistanceLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    final sessions = provider.recentSessions;

    // Sum distance per day
    final List<double> distancePerDay = List.filled(7, 0.0);

    for (var s in sessions) {
      final day = s.date.weekday - 1;
      if (day >= 0 && day < 7) {
        distancePerDay[day] += s.distanceInKm;
      }
    }

    final maxValue = distancePerDay.reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(7, (i) {
          final v = distancePerDay[i];
          final h = maxValue == 0 ? 4.0 : (v / maxValue) * 80 + 4;

          return Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 10,
                  height: h,
                  decoration: BoxDecoration(
                    color: Colors.green,
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
