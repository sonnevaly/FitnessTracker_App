import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../utils/app_colors.dart';

class RunsBarChart extends StatelessWidget {
  final String period;

  const RunsBarChart({
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
        maxY: 3,
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
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 1, color: AppColors.cardDark, width: 12)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 2, color: AppColors.cardDark, width: 12)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 1, color: AppColors.cardDark, width: 12)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 0, color: AppColors.cardDark.withOpacity(0.3), width: 12)]),
          BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 1, color: AppColors.cardDark, width: 12)]),
          BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 0, color: AppColors.cardDark.withOpacity(0.3), width: 12)]),
          BarChartGroupData(x: 6, barRods: [BarChartRodData(toY: 0, color: AppColors.cardDark.withOpacity(0.3), width: 12)]),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 8,
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
          BarChartGroupData(x: 0, barRods: [BarChartRodData(toY: 4, color: AppColors.cardDark, width: 16)]),
          BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 6, color: AppColors.cardDark, width: 16)]),
          BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: AppColors.cardDark, width: 16)]),
          BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 3, color: AppColors.cardDark, width: 16)]),
        ],
      ),
    );
  }
}