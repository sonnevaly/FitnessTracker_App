import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';
import '../services/suggestion_service.dart';
import '../services/weekly_insight_service.dart';
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
    final weeklyStats = WeeklyStats.fromSessions(data);

    setState(() {
      sessions = data;
      stats = weeklyStats;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final suggestion = stats == null
        ? null
        : SuggestionService.generate(
            totalRuns: stats!.numberOfRuns,
            totalDistance: stats!.totalDistance,
            period: 'This Week',
          );

    final insights = stats == null
        ? const <InsightItem>[]
        : WeeklyInsightService.generate(
            stats!.numberOfRuns,
            stats!.totalDistance,
          );

    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    const DashboardHeader(),

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

                    if (suggestion != null)
                      FriendlySuggestionCard(
                        suggestion: suggestion,
                      ),

                    const SizedBox(height: 24),

                    StatsSection(
                      sessions: sessions,
                      stats: stats,
                      onRefresh: _loadDashboard,
                    ),

                    const SizedBox(height: 24),

                    if (insights.isNotEmpty)
                      WeeklyInsightsCard(
                        insights: insights,
                      ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
      ),
    );
  }
}
