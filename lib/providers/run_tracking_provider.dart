import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../calculators/distance_calculator.dart';
import '../models/running_session.dart';
import '../services/location_service.dart';
import '../services/session_repository.dart';

class RunTrackingProvider extends ChangeNotifier {
  // States
  bool _isRunning = false;
  bool _isPaused = false;
  int _duration = 0; // in seconds
  double _distance = 0.0; // in kilometers
  Timer? _timer;
  
  // Services
  final LocationService _locationService = LocationService();
  final SessionRepository _repository = SessionRepository();
  List<Position> _positions = [];
  
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
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:'
           '${seconds.toString().padLeft(2, '0')}';
  }
  
  String get formattedDistance {
    return '${_distance.toStringAsFixed(2)}';
  }
  
  String get formattedPace {
    if (_distance == 0) return '0:00';
    double secondsPerKm = _duration / _distance;
    int minutes = secondsPerKm ~/ 60;
    int seconds = (secondsPerKm % 60).round();
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
  
  // Start run method - NOW WITH REAL GPS
  Future<void> startRun() async {
    // Request GPS permission
    final hasPermission = await _locationService.requestPermission();
    if (!hasPermission) {
      throw Exception('Location permission required');
    }
    
    _isRunning = true;
    _isPaused = false;
    _duration = 0;
    _distance = 0.0;
    _positions.clear();
    
    // Start GPS tracking
    _locationService.startTracking((position) {
      _positions.add(position);
      
      // Calculate real distance when we have at least 2 points
      if (_positions.length >= 2) {
        final lastPos = _positions[_positions.length - 2];
        final currentPos = _positions.last;
        
        // Use DistanceCalculator for accurate distance
        final segmentDistance = DistanceCalculator.calculateDistance(
          lastPos.latitude,
          lastPos.longitude,
          currentPos.latitude,
          currentPos.longitude,
        );
        
        _distance += segmentDistance;
      }
      
      notifyListeners();
    });
    
    // Start timer for duration
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!_isPaused) {
        _duration++;
        notifyListeners();
      }
    });
    
    notifyListeners();
  }
  
  // Pause run method
  void pauseRun() {
    _isPaused = true;
    _locationService.pauseTracking();
    notifyListeners();
  }
  
  // Resume run method
  void resumeRun() {
    _isPaused = false;
    _locationService.resumeTracking();
    notifyListeners();
  }
  
  // Stop run and save to database
  Future<void> stopRun(int rpe) async {
    _timer?.cancel();
    _locationService.stopTracking();
    
    // Create session object
    final session = RunningSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now(),
      durationInSeconds: _duration,
      distanceInKm: _distance,
      rpe: rpe,
    );
    
    // Save to database
    await _repository.saveSession(session);
    
    // Reset for next run
    _isRunning = false;
    _isPaused = false;
    _duration = 0;
    _distance = 0.0;
    _positions.clear();
    
    notifyListeners();
  }
  
  // Get collected positions (for debugging or display)
  List<Position> getPositions() {
    return List.from(_positions);
  }
  
  @override
  void dispose() {
    _timer?.cancel();
    _locationService.dispose();
    super.dispose();
  }

  
}