import 'package:flutter/material.dart';
import '../models/running_session.dart';
import '../services/session_repository.dart';
import '../models/weekly_stats.dart';

class DashboardProvider extends ChangeNotifier {
  // State
  bool _isLoading = false;
  WeeklyStats? _weeklyStats;
  List<RunningSession> _recentSessions = [];
  
  // Repository
  final SessionRepository _repository = SessionRepository();
  
  // Getters
  bool get isLoading => _isLoading;
  WeeklyStats? get weeklyStats => _weeklyStats;
  List<RunningSession> get recentSessions => _recentSessions;
  
  // Load dashboard data method - NOW CONNECTED TO REAL DATABASE
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Get real weekly sessions from database
      final sessions = await _repository.getWeeklySessions();
      
      // Create real weekly stats
      _weeklyStats = WeeklyStats.fromSessions(sessions);

      // Get recent sessions
      final allSessions = await _repository.getAllSessions();
      _recentSessions = allSessions.take(3).toList();

    } catch (e) {
      print('Error loading dashboard data: $e');
      // Fallback to empty stats if error
      _weeklyStats = WeeklyStats.fromSessions([]);
      _recentSessions = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Refresh data (for pull-to-refresh)
  Future<void> refreshData() async {
    await loadDashboardData();
  }
}