import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fitness_tracker/calculators/distance_calculator.dart';

void main() {
  group('DistanceCalculator', () {
    test('Calculate distance between two GPS points', () {
      final distance = DistanceCalculator.calculateDistance(
        40.7128, -74.0060,
        40.7589, -73.9851,
      );
      
      expect(distance, greaterThan(0));
      expect(distance, lessThan(10));
    });

    test('Return zero for same location', () {
      final distance = DistanceCalculator.calculateDistance(
        40.7128, -74.0060,
        40.7128, -74.0060,
      );
      
      expect(distance, closeTo(0.0, 0.01));
    });

    test('Calculate total distance from GPS positions', () {
      // Create positions with smaller segments (less than 100m each)
      final positions = [
        Position(
          latitude: 40.7128, longitude: -74.0060,
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.7129, longitude: -74.0060, // ~11 meters
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.7130, longitude: -74.0060, // ~11 meters more
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.7131, longitude: -74.0060, // ~11 meters more
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
      ];

      final totalDistance = DistanceCalculator.calculateTotalDistance(positions);
      expect(totalDistance, greaterThan(0.0));
      expect(totalDistance, lessThan(0.1)); // Should be ~0.03-0.04 km
    });

    test('Return zero for empty position list', () {
      final totalDistance = DistanceCalculator.calculateTotalDistance([]);
      expect(totalDistance, equals(0.0));
    });

    test('Return zero for single position', () {
      final positions = [
        Position(
          latitude: 40.7128, longitude: -74.0060,
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
      ];

      final totalDistance = DistanceCalculator.calculateTotalDistance(positions);
      expect(totalDistance, equals(0.0));
    });

    test('Filter out large GPS jumps (noise)', () {
      // Second position is 5km away - should be filtered as GPS error
      final positions = [
        Position(
          latitude: 40.7128, longitude: -74.0060,
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.7589, longitude: -73.9851, // ~5km away - GPS error!
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
      ];

      final totalDistance = DistanceCalculator.calculateTotalDistance(positions);
      // Should be 0 because segment > 0.1km is filtered as noise
      expect(totalDistance, equals(0.0));
    });

    test('Filter positions removes close points', () {
      final positions = [
        Position(
          latitude: 40.7128, longitude: -74.0060,
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.71281, longitude: -74.00601, // ~1 meter away
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
        Position(
          latitude: 40.7138, longitude: -74.0060, // ~100m away
          timestamp: DateTime.now(), accuracy: 5.0, altitude: 0.0,
          heading: 0.0, speed: 0.0, speedAccuracy: 0.0,
          altitudeAccuracy: 0.0, headingAccuracy: 0.0,
        ),
      ];

      final filtered = DistanceCalculator.filterPositions(positions);
      expect(filtered.length, equals(2)); // First and third (second too close)
    });

    test('Calculate bearing between two points', () {
      final bearing = DistanceCalculator.calculateBearing(
        40.7128, -74.0060,
        40.7589, -73.9851,
      );
      
      expect(bearing, greaterThanOrEqualTo(0));
      expect(bearing, lessThan(360));
    });
  });
}