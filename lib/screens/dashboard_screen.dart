import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../models/weekly_stats.dart';
import '../services/database_service.dart';
import '../widgets/dashbaord/dashboard_header.dart';
import '../widgets/dashbaord/image_card.dart';
import '../widgets/dashbaord/stats_sections.dart';
import 'run_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String _selectedPeriod = 'This Week';
  bool _isLoading = false;

  WeeklyStats? _weeklyStats;

  final DatabaseService _db = DatabaseService.instance;

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
  }

  Future<void> _loadDashboardData() async {
    setState(() => _isLoading = true);

    // ✅ Seed mock data ONLY if database is empty
    await _db.seedMockDataIfEmpty();

    // Load all sessions from SQLite
    final sessions = await _db.getAllSessions();

    setState(() {
      _weeklyStats = WeeklyStats.fromSessions(sessions);
      _isLoading = false;
    });
  }

  void _onPeriodChanged(String period) {
    setState(() {
      _selectedPeriod = period;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 3,
                ),
              )
            : CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  const SliverToBoxAdapter(
                    child: DashboardHeader(),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 24),
                  ),

                  // 🔥 Hero Image Card
                  SliverToBoxAdapter(
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 20.0),
                      child: HeroImageCard(
                        onStart: () async {
                          // Navigate to run screen
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const RunTrackingScreen(),
                            ),
                          );

                          // 🔁 Reload dashboard when returning
                          _loadDashboardData();
                        },
                      ),
                    ),
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 32),
                  ),

                  // 📊 Stats Section (REAL DATA FROM SQLITE)
                  StatsSection(
                    selectedPeriod: _selectedPeriod,
                    onPeriodChanged: _onPeriodChanged,
                    stats: _weeklyStats,
                  ),

                  const SliverToBoxAdapter(
                    child: SizedBox(height: 100),
                  ),
                ],
              ),
      ),
    );
  }
}
