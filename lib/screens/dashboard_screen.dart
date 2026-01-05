import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/dashboard_provider.dart';
import '../utils/app_colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
      context.read<DashboardProvider>().loadDashboardData()
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<DashboardProvider>();
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: provider.isLoading
            ? _buildLoadingState()
            : _buildContent(provider),
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
  
  Widget _buildContent(DashboardProvider provider) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.grid_view_rounded),
                  onPressed: () {},
                ),
                Row(
                  children: [
                    Text(
                      'Hello, Runner',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Icon(Icons.notifications_outlined),
                  ],
                ),
              ],
            ),
          ),
        ),
        
        // Main Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Discover how\nto track your runs',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
                height: 1.2,
              ),
            ),
          ),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 24)),
        
        // 🖼️ HERO IMAGE CARD (Instead of search + dark card)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: _buildHeroImageCard(context),
          ),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 32)),
        
        // Weekly Stats Header
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Weekly Stats',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                TextButton(
                  onPressed: () {},
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
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 16)),
        
        // Filter Chips
        SliverToBoxAdapter(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                _buildLevelChip('This Week', true),
                SizedBox(width: 12),
                _buildLevelChip('This Month', false),
                SizedBox(width: 12),
                _buildLevelChip('All Time', false),
              ],
            ),
          ),
        ),
        
        SliverToBoxAdapter(child: SizedBox(height: 24)),
        
        // 📊 STATS WITH GRAPHS
        if (provider.weeklyStats != null)
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatCardWithGraph(
                  'Total Runs',
                  '${provider.weeklyStats!.totalRuns} runs completed',
                  provider.weeklyStats!.totalRuns,
                  Icons.directions_run,
                  _buildRunsBarChart(),
                ),
                SizedBox(height: 16),
                _buildStatCardWithGraph(
                  'Distance',
                  '${provider.weeklyStats!.totalDistance.toStringAsFixed(1)} km covered',
                  provider.weeklyStats!.totalDistance.toStringAsFixed(1),
                  Icons.straighten,
                  _buildDistanceLineChart(),
                ),
                SizedBox(height: 16),
                _buildStatCardWithGraph(
                  'Duration',
                  provider.weeklyStats!.totalDuration,
                  provider.weeklyStats!.totalDuration,
                  Icons.timer,
                  _buildDurationBarChart(),
                ),
              ]),
            ),
          ),
        
        SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }
  
  // 🖼️ HERO IMAGE CARD (Replaces dark card + search)
  Widget _buildHeroImageCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to Run Tracking
        DefaultTabController.of(context)?.animateTo(1);
      },
      child: Container(
        height: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background Image
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF6366F1),
                      Color(0xFF8B5CF6),
                      Color(0xFFEC4899),
                    ],
                  ),
                ),
                child: Image.network(
                  'https://images.unsplash.com/photo-1476480862126-209bfaa8edc8?w=800&auto=format&fit=crop',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    // Fallback gradient if image fails
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xFF6366F1),
                            Color(0xFF8B5CF6),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Dark overlay
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.3),
                      Colors.black.withOpacity(0.6),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Start your run\ntracking today',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.play_arrow, size: 20, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            'Start Now',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildLevelChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isSelected ? Colors.transparent : Colors.grey.shade200,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : AppColors.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
  
  // 📊 STAT CARD WITH GRAPH
  Widget _buildStatCardWithGraph(
    String title,
    String subtitle,
    dynamic value,
    IconData icon,
    Widget chart,
  ) {
    return Container(
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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: AppColors.cardDark, size: 24),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          // Chart
          SizedBox(
            height: 120,
            child: chart,
          ),
        ],
      ),
    );
  }
  
  // 📊 RUNS BAR CHART
  Widget _buildRunsBarChart() {
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
  
  // 📊 DISTANCE LINE CHART
  Widget _buildDistanceLineChart() {
    return LineChart(
      LineChartData(
        gridData: FlGridData(show: false),
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
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 3),
              FlSpot(1, 5),
              FlSpot(2, 2),
              FlSpot(3, 0),
              FlSpot(4, 4),
              FlSpot(5, 0),
              FlSpot(6, 0),
            ],
            isCurved: true,
            color: AppColors.success,
            barWidth: 3,
            dotData: FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: AppColors.success.withOpacity(0.1),
            ),
          ),
        ],
      ),
    );
  }
  
  // 📊 DURATION BAR CHART
  Widget _buildDurationBarChart() {
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
}