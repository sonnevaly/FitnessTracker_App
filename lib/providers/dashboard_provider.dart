import 'package:flutter/material.dart';

// Weekly stats data model
class WeeklyStats {
  final int totalRuns;
  final double totalDistance;
  final String totalDuration;
  final String averagePace;
  
  WeeklyStats({
    required this.totalRuns,
    required this.totalDistance,
    required this.totalDuration,
    required this.averagePace,
  });
}

class DashboardProvider extends ChangeNotifier {
  // State
  bool _isLoading = false;
  WeeklyStats? _weeklyStats;
  
  // Getters
  bool get isLoading => _isLoading;
  WeeklyStats? get weeklyStats => _weeklyStats;
  
  // Load dashboard data method
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));
    
    // MOCK DATA - On Day 5, this will load from real database
    _weeklyStats = WeeklyStats(
      totalRuns: 5,
      totalDistance: 15.5,
      totalDuration: '2:30:00',
      averagePace: '6:15',
    );
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Refresh data (for pull-to-refresh)
  Future<void> refreshData() async {
    await loadDashboardData();
  }
}