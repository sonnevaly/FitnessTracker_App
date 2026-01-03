import 'package:flutter/material.dart';
import '../models/mock_sessions.dart';

class HistoryProvider extends ChangeNotifier {
  List<MockSession> _sessions = [];
  bool _isLoading = false;
  
  List<MockSession> get sessions => _sessions;
  bool get isLoading => _isLoading;
  
  // Load history method
  Future<void> loadHistory() async {
    _isLoading = true;
    notifyListeners();
    
    // Simulate loading delay
    await Future.delayed(Duration(seconds: 1));
    
    // MOCK DATA - On Day 5, this will load from real database
    _sessions = [
      MockSession(
        id: '1',
        date: DateTime.now().subtract(Duration(days: 1)),
        distance: 5.2,
        duration: 1800,
        rpe: 6,
      ),
      MockSession(
        id: '2',
        date: DateTime.now().subtract(Duration(days: 3)),
        distance: 3.5,
        duration: 1200,
        rpe: 4,
      ),
      MockSession(
        id: '3',
        date: DateTime.now().subtract(Duration(days: 5)),
        distance: 7.0,
        duration: 2400,
        rpe: 8,
      ),
      MockSession(
        id: '4',
        date: DateTime.now().subtract(Duration(days: 7)),
        distance: 4.8,
        duration: 1650,
        rpe: 5,
      ),
    ];
    
    _isLoading = false;
    notifyListeners();
  }
  
  // Delete session method
  Future<void> deleteSession(String id) async {
    _sessions.removeWhere((session) => session.id == id);
    notifyListeners();
    
    // TODO Day 5: Delete from real database
    // await _databaseService.deleteSession(id);
  }
}