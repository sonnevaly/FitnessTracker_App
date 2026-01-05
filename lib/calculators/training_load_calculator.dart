import '../models/running_session.dart';

/// Calculator for training load and fatigue metrics
class TrainingLoadCalculator {
  /// Calculate training load for a single session
  /// Formula: Duration (minutes) × RPE
  static double calculateLoad(int durationInSeconds, int rpe) {
    if (rpe < 1 || rpe > 10) {
      throw ArgumentError('RPE must be between 1 and 10');
    }
    return (durationInSeconds / 60) * rpe;
  }

  /// Calculate total weekly training load from list of sessions
  static double calculateWeeklyLoad(List<RunningSession> sessions) {
    if (sessions.isEmpty) return 0.0;

    double totalLoad = 0.0;
    for (var session in sessions) {
      totalLoad += session.trainingLoad;
    }
    return totalLoad;
  }

  /// Calculate average training load per session
  static double calculateAverageLoad(List<RunningSession> sessions) {
    if (sessions.isEmpty) return 0.0;
    return calculateWeeklyLoad(sessions) / sessions.length;
  }

  /// Get training load category
  static String getLoadCategory(double weeklyLoad) {
    if (weeklyLoad > 1000) return "Very High";
    if (weeklyLoad > 700) return "High";
    if (weeklyLoad > 500) return "Moderate";
    if (weeklyLoad > 300) return "Light";
    return "Very Light";
  }

  /// Calculate acute to chronic ratio (fitness vs fatigue)
  /// Acute = last 7 days, Chronic = last 28 days average
  static double calculateAcuteChronicRatio(
    List<RunningSession> last7Days,
    List<RunningSession> last28Days,
  ) {
    double acuteLoad = calculateWeeklyLoad(last7Days);
    
    if (last28Days.isEmpty) return 1.0;
    
    double chronicLoad = calculateWeeklyLoad(last28Days) / 4.0; // Weekly average
    
    if (chronicLoad == 0) return 1.0;
    
    return acuteLoad / chronicLoad;
  }

  /// Interpret acute to chronic ratio
  static String interpretAcuteChronicRatio(double ratio) {
    if (ratio < 0.8) return "Undertraining";
    if (ratio < 1.3) return "Optimal Training";
    if (ratio < 1.5) return "High Risk";
    return "Very High Risk";
  }
}