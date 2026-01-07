import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/models/running_session.dart';

void main() {
  group('RunningSession - Core Data', () {
    test('Calculate pace correctly', () {
      final session = RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1500, distanceInKm: 5.0, rpe: 5,
      );

      expect(session.paceMinPerKm, closeTo(5.0, 0.01));
    });

    test('Calculate training load', () {
      final session = RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 3600, distanceInKm: 10.0, rpe: 7,
      );

      expect(session.trainingLoad, equals(420.0));
    });

    test('Format pace as string', () {
      final session = RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1620, distanceInKm: 5.0, rpe: 6,
      );

      expect(session.formattedPace, equals('5:24'));
    });

    test('Format duration', () {
      final session = RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 3930, distanceInKm: 15.0, rpe: 6,
      );

      expect(session.formattedDuration, equals('1:05:30'));
    });

    test('Format distance', () {
      final session = RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1800, distanceInKm: 5.234, rpe: 5,
      );

      expect(session.formattedDistance, equals('5.23 km'));
    });

    test('Database serialization round trip', () {
      final original = RunningSession(
        id: 'test', date: DateTime(2024, 1, 15),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      );

      final map = original.toMap();
      final restored = RunningSession.fromMap(map);

      expect(restored.id, equals(original.id));
      expect(restored.distanceInKm, equals(original.distanceInKm));
      expect(restored.rpe, equals(original.rpe));
    });
  });
}