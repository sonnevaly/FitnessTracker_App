import 'running_session.dart';

/// Aggregated statistics for dashboard
class WeeklyStats {
  final int numberOfRuns;
  final double totalDistance;
  final int totalDuration; // seconds

  WeeklyStats({
    required this.numberOfRuns,
    required this.totalDistance,
    required this.totalDuration,
  });

  factory WeeklyStats.fromSessions(List<RunningSession> sessions) {
    double distance = 0;
    int duration = 0;

    for (final s in sessions) {
      distance += s.distanceInKm;
      duration += s.durationInSeconds;
    }

    return WeeklyStats(
      numberOfRuns: sessions.length,
      totalDistance: distance,
      totalDuration: duration,
    );
  }

  /// Used by distance chart
  List<double> distancePerRun(List<RunningSession> sessions) =>
      sessions.map((e) => e.distanceInKm).toList();

  /// Used by duration chart (minutes)
  List<int> durationPerRun(List<RunningSession> sessions) =>
      sessions.map((e) => (e.durationInSeconds / 60).round()).toList();

  /// Average pace (min/km)
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

  /// Total duration formatted for UI
  String get formattedTotalDuration {
    final hours = totalDuration ~/ 3600;
    final minutes = (totalDuration % 3600) ~/ 60;

    if (hours > 0) {
      return '${hours}h ${minutes}m';
    }
    return '${minutes}m';
  }
}
