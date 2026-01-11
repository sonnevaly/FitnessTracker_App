import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';
import '../widgets/dashbaord/dashboard_header.dart';
import '../widgets/dashbaord/image_card.dart';
import '../widgets/dashbaord/suggestion.dart';
import '../widgets/dashbaord/stats_sections.dart';
import '../widgets/dashbaord/weekly_insight.dart';
import 'run_tracking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = false;
  List<RunningSession> sessions = [];
  WeeklyStats? stats;

  final SessionRepository repository = SessionRepository();

  @override
  void initState() {
    super.initState();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    setState(() => isLoading = true);

    final data = await repository.getAllSessions();

    setState(() {
      sessions = data;
      stats = WeeklyStats.fromSessions(data);
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    /// HEADER
                    const DashboardHeader(),

                    /// HERO IMAGE
                    HeroImageCard(
                      onStart: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const RunTrackingScreen(),
                          ),
                        ).then((_) => _loadDashboard());
                      },
                    ),

                    /// FRIENDLY SUGGESTION
                    if (stats != null)
                      FriendlySuggestionCard(
                        totalRuns: stats!.numberOfRuns,
                        totalDistance: stats!.totalDistance,
                        selectedPeriod: 'This Week',
                      ),

                    const SizedBox(height: 24),

                    /// STATS + GRAPHS
                    StatsSection(
                      sessions: sessions,
                      stats: stats,
                      onRefresh: _loadDashboard,
                    ),

                    const SizedBox(height: 24),

                    /// WEEKLY INSIGHTS
                    if (stats != null)
                      WeeklyInsightsCard(
                        totalRuns: stats!.numberOfRuns,
                        totalDistance: stats!.totalDistance,
                        totalDuration: stats!.formattedTotalDuration,
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }
}
