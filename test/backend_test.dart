import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/models/running_session.dart';
import 'package:fitness_tracker/models/weekly_stats.dart';
import 'package:fitness_tracker/calculators/distance_calculator.dart';
import 'package:fitness_tracker/calculators/training_load_calculator.dart';
import 'package:fitness_tracker/calculators/fatigue_analyzer.dart';

void main() {
  group('RunningSession Model Tests', () {
    test('Should calculate pace correctly', () {
      final session = RunningSession(
        id: 'test1',
        date: DateTime.now(),
        durationInSeconds: 1620, // 27 minutes
        distanceInKm: 5.0,
        rpe: 7,
      );

      expect(session.paceMinPerKm, closeTo(5.4, 0.1));
    });

    test('Should calculate training load correctly', () {
      final session = RunningSession(
        id: 'test2',
        date: DateTime.now(),
        durationInSeconds: 1800, // 30 minutes
        distanceInKm: 5.0,
        rpe: 7,
      );

      expect(session.trainingLoad, 210.0); // 30 * 7 = 210
    });

    test('Should format pace correctly', () {
      final session = RunningSession(
        id: 'test3',
        date: DateTime.now(),
        durationInSeconds: 1620, // 27 minutes
        distanceInKm: 5.0,
        rpe: 7,
      );

      expect(session.formattedPace, '5:24');
    });

    test('Should format duration correctly', () {
      final session = RunningSession(
        id: 'test4',
        date: DateTime.now(),
        durationInSeconds: 3665, // 1 hour 1 minute 5 seconds
        distanceInKm: 10.0,
        rpe: 5,
      );

      expect(session.formattedDuration, '1:01:05');
    });

    test('Should convert to/from Map correctly', () {
      final session = RunningSession(
        id: 'test5',
        date: DateTime(2025, 1, 1, 10, 0),
        durationInSeconds: 1800,
        distanceInKm: 5.5,
        rpe: 6,
      );

      final map = session.toMap();
      final restored = RunningSession.fromMap(map);

      expect(restored.id, session.id);
      expect(restored.distanceInKm, session.distanceInKm);
      expect(restored.rpe, session.rpe);
    });
  });

  group('WeeklyStats Tests', () {
    test('Should calculate stats from empty list', () {
      final stats = WeeklyStats.fromSessions([]);

      expect(stats.numberOfRuns, 0);
      expect(stats.totalDistance, 0.0);
      expect(stats.totalDuration, 0);
      expect(stats.totalTrainingLoad, 0.0);
    });

    test('Should calculate stats from multiple sessions', () {
      final sessions = [
        RunningSession(
          id: '1',
          date: DateTime.now(),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 7,
        ),
        RunningSession(
          id: '2',
          date: DateTime.now(),
          durationInSeconds: 2400,
          distanceInKm: 6.0,
          rpe: 6,
        ),
      ];

      final stats = WeeklyStats.fromSessions(sessions);

      expect(stats.numberOfRuns, 2);
      expect(stats.totalDistance, 11.0);
      expect(stats.totalDuration, 4200);
      expect(stats.totalTrainingLoad, 450.0); // (30*7) + (40*6) = 210 + 240
    });

    test('Should determine fatigue level correctly', () {
      final highLoad = WeeklyStats(
        totalDistance: 50,
        totalDuration: 18000,
        numberOfRuns: 7,
        totalTrainingLoad: 800,
      );

      final lowLoad = WeeklyStats(
        totalDistance: 15,
        totalDuration: 5400,
        numberOfRuns: 2,
        totalTrainingLoad: 200,
      );

      expect(highLoad.fatigueLevel, 'High');
      expect(lowLoad.fatigueLevel, 'Low');
    });
  });

  group('Distance Calculator Tests', () {
    test('Should calculate distance between two close points', () {
      // Two points approximately 100m apart
      final distance = DistanceCalculator.calculateDistance(
        11.5564,
        104.9282,
        11.5574,
        104.9282,
      );

      // Should be around 0.1 km (100m)
      expect(distance, greaterThan(0.09));
      expect(distance, lessThan(0.12));
    });

    test('Should calculate distance between same point as zero', () {
      final distance = DistanceCalculator.calculateDistance(
        11.5564,
        104.9282,
        11.5564,
        104.9282,
      );

      expect(distance, closeTo(0.0, 0.001));
    });

    test('Should calculate bearing correctly', () {
      // North direction
      final bearing = DistanceCalculator.calculateBearing(
        11.5564,
        104.9282,
        11.5574,
        104.9282,
      );

      // Should be close to 0 degrees (north)
      expect(bearing, lessThan(10));
    });
  });

  group('Training Load Calculator Tests', () {
    test('Should calculate load correctly', () {
      final load = TrainingLoadCalculator.calculateLoad(1800, 7);
      expect(load, 210.0); // 30 minutes * 7
    });

    test('Should throw error for invalid RPE', () {
      expect(
        () => TrainingLoadCalculator.calculateLoad(1800, 11),
        throwsArgumentError,
      );
    });

    test('Should calculate weekly load correctly', () {
      final sessions = [
        RunningSession(
          id: '1',
          date: DateTime.now(),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 7,
        ),
        RunningSession(
          id: '2',
          date: DateTime.now(),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 5,
        ),
      ];

      final load = TrainingLoadCalculator.calculateWeeklyLoad(sessions);
      expect(load, 360.0); // (30*7) + (30*5) = 210 + 150
    });

    test('Should categorize load correctly', () {
      expect(TrainingLoadCalculator.getLoadCategory(1100), "Very High");
      expect(TrainingLoadCalculator.getLoadCategory(800), "High");
      expect(TrainingLoadCalculator.getLoadCategory(600), "Moderate");
      expect(TrainingLoadCalculator.getLoadCategory(400), "Light");
      expect(TrainingLoadCalculator.getLoadCategory(200), "Very Light");
    });
  });

  group('Fatigue Analyzer Tests', () {
    test('Should analyze fatigue correctly', () {
      expect(FatigueAnalyzer.analyzeFatigue(800), "High");
      expect(FatigueAnalyzer.analyzeFatigue(600), "Moderate");
      expect(FatigueAnalyzer.analyzeFatigue(400), "Low");
      expect(FatigueAnalyzer.analyzeFatigue(200), "Very Low");
    });

    test('Should recommend rest for high load', () {
      final rec = FatigueAnalyzer.getShortRecommendation(800, 2);
      expect(rec, "Rest");
    });

    test('Should recommend push for low load', () {
      final rec = FatigueAnalyzer.getShortRecommendation(200, 1);
      expect(rec, "Push");
    });

    test('Should force rest after 6 days', () {
      final rec = FatigueAnalyzer.getShortRecommendation(300, 6);
      expect(rec, "Rest");
    });

    test('Should detect overtraining', () {
      final sessions = [
        RunningSession(
          id: '1',
          date: DateTime.now(),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 9,
        ),
        RunningSession(
          id: '2',
          date: DateTime.now().subtract(const Duration(days: 1)),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 9,
        ),
        RunningSession(
          id: '3',
          date: DateTime.now().subtract(const Duration(days: 2)),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 9,
        ),
        RunningSession(
          id: '4',
          date: DateTime.now().subtract(const Duration(days: 3)),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 9,
        ),
        RunningSession(
          id: '5',
          date: DateTime.now().subtract(const Duration(days: 4)),
          durationInSeconds: 1800,
          distanceInKm: 5.0,
          rpe: 9,
        ),
      ];

      final isOvertraining = FatigueAnalyzer.isOvertraining(1350, sessions);
      expect(isOvertraining, true);
    });
  });
}