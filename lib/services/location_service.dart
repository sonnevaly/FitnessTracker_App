import 'dart:async';
import 'package:geolocator/geolocator.dart';

/// Service for GPS location tracking
class LocationService {
  StreamSubscription<Position>? _positionStream;
  final List<Position> _positions = [];

  /// Check if location services are enabled
  Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check current permission status
  Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permission
  Future<bool> requestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  /// Get current position once
  Future<Position?> getCurrentPosition() async {
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      print('Error getting current position: $e');
      return null;
    }
  }

  /// Start tracking GPS location
  /// Calls onPositionUpdate with each new position
  void startTracking(Function(Position) onPositionUpdate) {
    _positions.clear();

    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    _positionStream = Geolocator.getPositionStream(
      locationSettings: locationSettings,
    ).listen(
      (Position position) {
        _positions.add(position);
        onPositionUpdate(position);
      },
      onError: (error) {
        print('Error in position stream: $error');
      },
    );
  }

  /// Stop tracking GPS location
  void stopTracking() {
    _positionStream?.cancel();
    _positionStream = null;
  }

  /// Pause tracking (keeps positions but stops updates)
  void pauseTracking() {
    _positionStream?.pause();
  }

  /// Resume tracking
  void resumeTracking() {
    _positionStream?.resume();
  }

  /// Get all collected positions
  List<Position> getPositions() {
    return List.from(_positions);
  }

  /// Get number of positions collected
  int getPositionCount() {
    return _positions.length;
  }

  /// Clear all positions
  void clearPositions() {
    _positions.clear();
  }

  /// Check if currently tracking
  bool isTracking() {
    return _positionStream != null && !_positionStream!.isPaused;
  }

  /// Get last known position
  Position? getLastPosition() {
    if (_positions.isEmpty) return null;
    return _positions.last;
  }

  /// Get accuracy of last position
  double? getLastAccuracy() {
    if (_positions.isEmpty) return null;
    return _positions.last.accuracy;
  }

  /// Check if GPS signal is good
  bool hasGoodSignal() {
    if (_positions.isEmpty) return false;
    // Good signal if accuracy is better than 20 meters
    return _positions.last.accuracy < 20;
  }

  /// Dispose resources
  void dispose() {
    stopTracking();
    _positions.clear();
  }
}