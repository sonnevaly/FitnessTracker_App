import 'running_session.dart';

class WeeklyStats {
  final double totalDistance;
  final int totalDuration;
  final int numberOfRuns;
  final double totalTrainingLoad;

  WeeklyStats({
    required this.totalDistance,
    required this.totalDuration,
    required this.numberOfRuns,
    required this.totalTrainingLoad,
  });

  /// Calculate stats from list of sessions
  factory WeeklyStats.fromSessions(List<RunningSession> sessions) {
    if (sessions.isEmpty) {
      return WeeklyStats(
        totalDistance: 0,
        totalDuration: 0,
        numberOfRuns: 0,
        totalTrainingLoad: 0,
      );
    }

    double totalDist = 0;
    int totalDur = 0;
    double totalLoad = 0;

    for (var session in sessions) {
      totalDist += session.distanceInKm;
      totalDur += session.durationInSeconds;
      totalLoad += session.trainingLoad;
    }

    return WeeklyStats(
      totalDistance: totalDist,
      totalDuration: totalDur,
      numberOfRuns: sessions.length,
      totalTrainingLoad: totalLoad,
    );
  }

  /// Returns average pace in minutes per km
  double get averagePace {
    if (totalDistance == 0) return 0.0;
    return (totalDuration / 60) / totalDistance;
  }

  /// Returns formatted average pace "5:24"
  String get formattedAveragePace {
    if (totalDistance == 0) return "0:00";
    
    int totalSeconds = (averagePace * 60).round();
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  /// Returns formatted total duration
  String get formattedTotalDuration {
    int hours = totalDuration ~/ 3600;
    int minutes = (totalDuration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  /// Returns formatted total distance
  String get formattedTotalDistance {
    return '${totalDistance.toStringAsFixed(2)} km';
  }

  /// Returns fatigue level based on training load
  String get fatigueLevel {
    if (totalTrainingLoad > 700) return "High";
    if (totalTrainingLoad > 500) return "Moderate";
    return "Low";
  }

  /// Returns workout recommendation based on load
  String get recommendation {
    if (totalTrainingLoad > 700) {
      return "Rest Day - Your body needs recovery";
    } else if (totalTrainingLoad > 500) {
      return "Easy Run - Keep it light today";
    } else {
      return "Push Day - You're ready to go hard!";
    }
  }

  /// Returns short recommendation
  String get shortRecommendation {
    if (totalTrainingLoad > 700) return "Rest";
    if (totalTrainingLoad > 500) return "Easy";
    return "Push";
  }

  @override
  String toString() {
    return 'WeeklyStats(runs: $numberOfRuns, distance: $formattedTotalDistance, duration: $formattedTotalDuration, load: ${totalTrainingLoad.toStringAsFixed(0)}, fatigue: $fatigueLevel)';
  }
}