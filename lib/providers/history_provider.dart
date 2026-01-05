import 'package:flutter/material.dart';
import '../calculators/fatigue_analyzer.dart';
import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import '../services/session_repository.dart';

class HistoryProvider extends ChangeNotifier {
  List<RunningSession> _sessions = [];
  bool _isLoading = false;
  
  // Repository
  final SessionRepository _repository = SessionRepository();
  
  // Getters
  List<RunningSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  
  // Get stats for the current week - REAL DATA FROM DATABASE
  WeeklyStats get weeklyStats {
    if (_sessions.isEmpty) return WeeklyStats.fromSessions([]);
    
    final now = DateTime.now();
    final monday = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);
    
    final weekSessions = _sessions.where((s) => 
        s.date.isAfter(startOfWeek.subtract(const Duration(seconds: 1)))
    ).toList();
    
    return WeeklyStats.fromSessions(weekSessions);
  }

  // Get fatigue analysis - REAL CALCULATIONS
  String get fatigueLevel => FatigueAnalyzer.analyzeFatigue(weeklyStats.totalTrainingLoad);
  
  String get recommendation {
    return FatigueAnalyzer.getRecommendation(
      weeklyStats.totalTrainingLoad,
      FatigueAnalyzer.daysSinceLastRest(_sessions),
    );
  }
  
  // Load history method - FROM DATABASE
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _sessions = await _repository.getAllSessions();
    } catch (e) {
      print('Error loading history: $e');
      _sessions = [];
    }
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Delete session method - FROM DATABASE
  Future<void> deleteSession(String id) async {
    try {
      await _repository.deleteSession(id);
      _sessions.removeWhere((session) => session.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting session: $e');
      throw e;
    }
  }

  // Add session method - TO DATABASE
  Future<void> addSession(RunningSession session) async {
    try {
      await _repository.saveSession(session);
      await loadHistory(); // Reload to update list and stats
    } catch (e) {
      print('Error adding session: $e');
      throw e;
    }
  }
  
  // Check overtraining - USING REAL DATA
  bool isOvertraining() {
    final last7Days = _sessions.where((session) => 
      session.date.isAfter(DateTime.now().subtract(const Duration(days: 7)))
    ).toList();
    
    return FatigueAnalyzer.isOvertraining(
      weeklyStats.totalTrainingLoad,
      last7Days,
    );
  }
}