import 'package:flutter/material.dart';

import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';

class DashboardProvider extends ChangeNotifier {
  bool _isLoading = false;
  WeeklyStats? _weeklyStats;
  List<RunningSession> _recentSessions = [];

  final SessionRepository _repository = SessionRepository();

  // Getters
  bool get isLoading => _isLoading;
  WeeklyStats? get weeklyStats => _weeklyStats;
  List<RunningSession> get recentSessions => _recentSessions;

  // Load dashboard data from REAL database
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Get weekly sessions
      final sessions = await _repository.getWeeklySessions();

      // Build weekly stats from sessions
      _weeklyStats = WeeklyStats.fromSessions(sessions);

      // Get recent sessions (last 3)
      final allSessions = await _repository.getAllSessions();
      _recentSessions = allSessions.take(3).toList();
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
      _weeklyStats = WeeklyStats.fromSessions([]);
      _recentSessions = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }
}
