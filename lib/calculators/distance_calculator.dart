import 'dart:math';
import 'package:geolocator/geolocator.dart';

/// Calculator for GPS distance using Haversine formula
class DistanceCalculator {
  /// Earth's radius in kilometers
  static const double _earthRadiusKm = 6371.0;

  /// Calculate distance between two GPS coordinates using Haversine formula
  /// Returns distance in kilometers
  static double calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    // Convert latitude and longitude to radians
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);

    double lat1Rad = _toRadians(lat1);
    double lat2Rad = _toRadians(lat2);

    // Haversine formula
    double a = sin(dLat / 2) * sin(dLat / 2) +
        sin(dLon / 2) * sin(dLon / 2) * cos(lat1Rad) * cos(lat2Rad);

    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    // Distance in kilometers
    return _earthRadiusKm * c;
  }

  /// Calculate total distance from a list of GPS positions
  /// Returns distance in kilometers
  static double calculateTotalDistance(List<Position> positions) {
    if (positions.length < 2) {
      return 0.0;
    }

    double totalDistance = 0.0;

    for (int i = 0; i < positions.length - 1; i++) {
      double segmentDistance = calculateDistance(
        positions[i].latitude,
        positions[i].longitude,
        positions[i + 1].latitude,
        positions[i + 1].longitude,
      );

      // Only add if segment is reasonable (filter GPS noise)
      // Ignore jumps greater than 100m (likely GPS error)
      if (segmentDistance < 0.1) {
        totalDistance += segmentDistance;
      }
    }

    return totalDistance;
  }

  /// Filter GPS positions to remove noise and stationary points
  /// Returns filtered list with minimum distance threshold between points
  static List<Position> filterPositions(
    List<Position> positions, {
    double minDistanceKm = 0.01, // 10 meters minimum
  }) {
    if (positions.length < 2) return positions;

    List<Position> filtered = [positions.first];

    for (int i = 1; i < positions.length; i++) {
      double distance = calculateDistance(
        filtered.last.latitude,
        filtered.last.longitude,
        positions[i].latitude,
        positions[i].longitude,
      );

      // Only keep point if it's far enough from last point
      if (distance >= minDistanceKm) {
        filtered.add(positions[i]);
      }
    }

    return filtered;
  }

  /// Convert degrees to radians
  static double _toRadians(double degrees) {
    return degrees * pi / 180.0;
  }

  /// Convert radians to degrees
  static double _toDegrees(double radians) {
    return radians * 180.0 / pi;
  }

  /// Calculate bearing (direction) between two points
  /// Returns bearing in degrees (0-360)
  static double calculateBearing(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    double lat1Rad = _toRadians(lat1);
    double lat2Rad = _toRadians(lat2);
    double dLon = _toRadians(lon2 - lon1);

    double y = sin(dLon) * cos(lat2Rad);
    double x = cos(lat1Rad) * sin(lat2Rad) -
        sin(lat1Rad) * cos(lat2Rad) * cos(dLon);

    double bearing = atan2(y, x);
    bearing = _toDegrees(bearing);
    bearing = (bearing + 360) % 360;

    return bearing;
  }
}