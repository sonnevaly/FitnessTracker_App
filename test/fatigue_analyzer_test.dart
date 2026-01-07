import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/calculators/fatigue_analyzer.dart';
import 'package:fitness_tracker/models/running_session.dart';

void main() {
  group('FatigueAnalyzer - Daily Suggestions', () {
    test('Analyze fatigue levels', () {
      expect(FatigueAnalyzer.analyzeFatigue(800), equals("High"));
      expect(FatigueAnalyzer.analyzeFatigue(600), equals("Moderate"));
      expect(FatigueAnalyzer.analyzeFatigue(400), equals("Low"));
      expect(FatigueAnalyzer.analyzeFatigue(200), equals("Very Low"));
    });

    test('Get workout recommendation based on load', () {
      final recommendation = FatigueAnalyzer.getRecommendation(800, 2);
      expect(recommendation, contains("Rest Day"));
    });

    test('Force rest after 6+ days without rest', () {
      final recommendation = FatigueAnalyzer.getRecommendation(400, 6);
      expect(recommendation, contains("Rest Day"));
      expect(recommendation, contains("6 days"));
    });

    test('Easy run recommendation for moderate load', () {
      final recommendation = FatigueAnalyzer.getRecommendation(600, 2);
      expect(recommendation, contains("Easy Run"));
    });

    test('Push day for low load', () {
      final recommendation = FatigueAnalyzer.getRecommendation(200, 2);
      expect(recommendation, contains("Push Day"));
    });

    test('Get short recommendations for UI', () {
      expect(FatigueAnalyzer.getShortRecommendation(800, 2), equals("Rest"));
      expect(FatigueAnalyzer.getShortRecommendation(600, 2), equals("Easy"));
      expect(FatigueAnalyzer.getShortRecommendation(400, 2), equals("Moderate"));
      expect(FatigueAnalyzer.getShortRecommendation(200, 2), equals("Push"));
    });

    test('Calculate days since last rest', () {
      final sessions = [
        RunningSession(
          id: '1', date: DateTime.now(),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 8,
        ),
        RunningSession(
          id: '2', date: DateTime.now().subtract(Duration(days: 2)),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 3, // Rest day
        ),
      ];

      final daysSinceRest = FatigueAnalyzer.daysSinceLastRest(sessions);
      expect(daysSinceRest, equals(2));
    });

    test('Check overtraining status', () {
      final sessions = List.generate(
        5,
        (i) => RunningSession(
          id: '$i', date: DateTime.now().subtract(Duration(days: i)),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 9,
        ),
      );

      expect(FatigueAnalyzer.isOvertraining(1100, []), isTrue);
      expect(FatigueAnalyzer.isOvertraining(500, sessions), isTrue);
      expect(FatigueAnalyzer.isOvertraining(400, []), isFalse);
    });
  });
}