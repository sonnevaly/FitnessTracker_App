import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/models/running_session.dart';
import 'package:fitness_tracker/models/weekly_stats.dart';

void main() {
  group('WeeklyStats - Data Analysis', () {
    test('Calculate stats from sessions', () {
      final sessions = [
        RunningSession(
          id: '1', date: DateTime.now(),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
        ),
        RunningSession(
          id: '2', date: DateTime.now(),
          durationInSeconds: 3600, distanceInKm: 10.0, rpe: 7,
        ),
      ];

      final stats = WeeklyStats.fromSessions(sessions);

      expect(stats.totalDistance, equals(15.0));
      expect(stats.totalDuration, equals(5400));
      expect(stats.numberOfRuns, equals(2));
      expect(stats.totalTrainingLoad, equals(600.0));
    });

    test('Get fatigue level from training load', () {
      final sessions = List.generate(
        7,
        (i) => RunningSession(
          id: '$i', date: DateTime.now().subtract(Duration(days: i)),
          durationInSeconds: 3600, distanceInKm: 10.0, rpe: 8,
        ),
      );

      final stats = WeeklyStats.fromSessions(sessions);
      expect(stats.fatigueLevel, equals("High"));
    });

    test('Get workout recommendation', () {
      final sessions = [
        RunningSession(
          id: '1', date: DateTime.now(),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 4,
        ),
      ];

      final stats = WeeklyStats.fromSessions(sessions);
      expect(stats.recommendation, contains("Push Day"));
    });

    test('Calculate average pace', () {
      final sessions = [
        RunningSession(
          id: '1', date: DateTime.now(),
          durationInSeconds: 1500, distanceInKm: 5.0, rpe: 5,
        ),
      ];

      final stats = WeeklyStats.fromSessions(sessions);
      expect(stats.averagePace, closeTo(5.0, 0.01));
    });
  });
}