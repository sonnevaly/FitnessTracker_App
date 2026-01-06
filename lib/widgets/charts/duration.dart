import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_colors.dart';

class DurationBarChart extends StatelessWidget {
  final String period;

  const DurationBarChart({
    Key? key,
    required this.period,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (period == 'This Month') {
      return _buildMonthlyChart();
    }
    return _buildWeeklyChart();
  }

  Widget _buildWeeklyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 60,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                if (value.toInt() >= 0 && value.toInt() < days.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      days[value.toInt()],
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 30, color: AppColors.warning, width: 12)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 45, color: AppColors.warning, width: 12)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 25, color: AppColors.warning, width: 12)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 0, color: AppColors.warning.withOpacity(0.3), width: 12)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 35, color: AppColors.warning, width: 12)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 0, color: AppColors.warning.withOpacity(0.3), width: 12)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 0, color: AppColors.warning.withOpacity(0.3), width: 12)]),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 200,
        barTouchData: BarTouchData(enabled: false),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const weeks = ['Week 1', 'Week 2', 'Week 3', 'Week 4'];
                if (value.toInt() >= 0 && value.toInt() < weeks.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      weeks[value.toInt()],
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return Text('');
              },
            ),
          ),
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        barGroups: [
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 120, color: AppColors.warning, width: 16)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 180, color: AppColors.warning, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 150, color: AppColors.warning, width: 16)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 100, color: AppColors.warning, width: 16)]),
        ],
      ),
    );
  }
}