import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';
import '../widgets/dashbaord/stats_sections.dart';

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
            : StatsSection(
                sessions: sessions,
                stats: stats,
                onRefresh: _loadDashboard,
              ),
      ),
    );
  }
}
