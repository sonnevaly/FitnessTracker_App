import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/calculators/training_load_calculator.dart';
import 'package:fitness_tracker/models/running_session.dart';

void main() {
  group('TrainingLoadCalculator', () {
    test('Calculate load from duration and RPE', () {
      final load = TrainingLoadCalculator.calculateLoad(3600, 7);
      expect(load, equals(420.0)); // (60 min) * 7 = 420
    });

    test('Throw error for invalid RPE', () {
      expect(
        () => TrainingLoadCalculator.calculateLoad(1800, 0),
        throwsA(isA<ArgumentError>()),
      );
      
      expect(
        () => TrainingLoadCalculator.calculateLoad(1800, 11),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('Calculate weekly load from sessions', () {
      final sessions = [
        RunningSession(
          id: '1', date: DateTime.now(),
          durationInSeconds: 1800, distanceInKm: 5.0, rpe: 5,
        ),
        RunningSession(
          id: '2', date: DateTime.now(),
          durationInSeconds: 3600, distanceInKm: 10.0, rpe: 7,
        ),
      ];

      final weeklyLoad = TrainingLoadCalculator.calculateWeeklyLoad(sessions);
      expect(weeklyLoad, equals(570.0)); // (30*5) + (60*7)
    });

    test('Get load category', () {
      expect(TrainingLoadCalculator.getLoadCategory(1100), equals("Very High"));
      expect(TrainingLoadCalculator.getLoadCategory(800), equals("High"));
      expect(TrainingLoadCalculator.getLoadCategory(600), equals("Moderate"));
      expect(TrainingLoadCalculator.getLoadCategory(400), equals("Light"));
      expect(TrainingLoadCalculator.getLoadCategory(200), equals("Very Light"));
    });
  });
}