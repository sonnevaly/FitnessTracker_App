import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/services/location_service.dart';

void main() {
  group('LocationService - GPS Tracking', () {
    late LocationService locationService;

    setUp(() {
      locationService = LocationService();
    });

    tearDown(() {
      locationService.dispose();
    });

    test('Initial state is not tracking', () {
      expect(locationService.isTracking(), isFalse);
    });

    test('Get position count starts at zero', () {
      expect(locationService.getPositionCount(), equals(0));
    });

    test('Clear positions empties the list', () {
      locationService.clearPositions();
      expect(locationService.getPositions(), isEmpty);
    });

    test('Get last position returns null when empty', () {
      expect(locationService.getLastPosition(), isNull);
    });

    test('Has good signal returns false when no positions', () {
      expect(locationService.hasGoodSignal(), isFalse);
    });

    test('Request permission returns boolean', () async {
      final hasPermission = await locationService.requestPermission();
      expect(hasPermission, isA<bool>());
    });

    test('Check permission returns status', () async {
      final permission = await locationService.checkPermission();
      expect(permission, isNotNull);
    });

    test('Check if location services enabled', () async {
      final isEnabled = await locationService.isLocationServiceEnabled();
      expect(isEnabled, isA<bool>());
    });
  });
}