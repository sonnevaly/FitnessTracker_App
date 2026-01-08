import 'running_session.dart';

/// Aggregated statistics for dashboard
class WeeklyStats {
  final int numberOfRuns;
  final double totalDistance;
  final int totalDuration;
  final double totalTrainingLoad;

  WeeklyStats({
    required this.numberOfRuns,
    required this.totalDistance,
    required this.totalDuration,
    required this.totalTrainingLoad,
  });

  factory WeeklyStats.fromSessions(List<RunningSession> sessions) {
    if (sessions.isEmpty) {
      return WeeklyStats(
        numberOfRuns: 0,
        totalDistance: 0,
        totalDuration: 0,
        totalTrainingLoad: 0,
      );
    }

    double distance = 0;
    int duration = 0;
    double load = 0;

    for (final s in sessions) {
      distance += s.distanceInKm;
      duration += s.durationInSeconds;
      load += s.trainingLoad;
    }

    return WeeklyStats(
      numberOfRuns: sessions.length,
      totalDistance: distance,
      totalDuration: duration,
      totalTrainingLoad: load,
    );
  }

  List<double> distancePerRun(List<RunningSession> sessions) =>
      sessions.map((e) => e.distanceInKm).toList();

  List<int> durationPerRun(List<RunningSession> sessions) =>
      sessions.map((e) => (e.durationInSeconds / 60).round()).toList();

  List<double> loadPerRun(List<RunningSession> sessions) =>
      sessions.map((e) => e.trainingLoad).toList();

  double get averagePace {
    if (totalDistance == 0) return 0;
    return (totalDuration / 60) / totalDistance;
  }

  String get formattedAveragePace {
    if (totalDistance == 0) return '0:00';

    final totalSeconds = (averagePace * 60).round();
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get formattedTotalDuration {
    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }

  String get fatigueLevel {
    if (totalTrainingLoad > 700) return 'High';
    if (totalTrainingLoad > 500) return 'Moderate';
    return 'Low';
  }

  String get recommendation {
    if (totalTrainingLoad > 700) {
      return 'Rest day recommended';
    }
    if (totalTrainingLoad > 500) {
      return 'Easy run recommended';
    }
    return 'You are ready for a hard run';
  }
}
