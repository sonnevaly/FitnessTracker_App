import 'dart:async';
import 'package:flutter/material.dart';

class RunTrackingProvider extends ChangeNotifier {
  // States
  bool _isRunning = false;
  bool _isPaused = false;
  int _duration = 0; // in seconds
  double _distance = 0.0; // in kilometers
  
  Timer? _timer;
  
  // Getters
  bool get isRunning => _isRunning;
  bool get isPaused => _isPaused;
  int get duration => _duration;
  double get distance => _distance;
  
  // Formatted getters
  String get formattedDuration {
    int hours = _duration ~/ 3600;
    int minutes = (_duration % 3600) ~/ 60;
    int seconds = _duration % 60;
    return '${hours.toString().padLeft(2, '0')}:'
           '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }
  
  String get formattedDistance {
    return _distance.toStringAsFixed(2);
  }
  
  String get formattedPace {
    if (_distance == 0) return '0:00';
    double paceInSeconds = (_duration / _distance) / 60;
    int minutes = paceInSeconds.floor();
    int seconds = ((paceInSeconds - minutes) * 60).floor();
    return '${minutes}:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Start run method
  Future<void> startRun() async {
    _isRunning = true;
    _isPaused = false;
    _duration = 0;
    _distance = 0.0;
    
    // Start timer that updates every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _duration++;
        // FAKE distance increment (0.01 km per second = 36 km/h)
        // On Day 5, this will use real GPS data
        _distance += 0.01;
        notifyListeners();
      }
    });
    
    notifyListeners();
  }
  
  // Pause run method
  void pauseRun() {
    _isPaused = true;
    notifyListeners();
  }
  
  // Resume run method
  void resumeRun() {
    _isPaused = false;
    notifyListeners();
  }
  
  // Stop run method
  Future<void> stopRun(int rpe) async {
    _timer?.cancel();
    
    // 🧠 Capture final session data BEFORE reset
    final sessionData = {
      'duration': _duration,
      'distance': _distance,
      'rpe': rpe,
      'date': DateTime.now().toIso8601String(),
    };
    
    // TODO Day 5: Save to database
    // await DatabaseService.saveSession(sessionData);
    print('Session saved: $sessionData'); // For debugging
    
    // 🔄 Reset state for next run
    _isRunning = false;
    _isPaused = false;
    _duration = 0;
    _distance = 0.0;
    
    notifyListeners();
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}