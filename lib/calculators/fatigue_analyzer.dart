import '../models/running_session.dart';

/// Analyzer for fatigue levels and workout recommendations
class FatigueAnalyzer {
  /// Analyze fatigue level based on weekly training load
  static String analyzeFatigue(double weeklyLoad) {
    if (weeklyLoad > 700) return "High";
    if (weeklyLoad > 500) return "Moderate";
    if (weeklyLoad > 300) return "Low";
    return "Very Low";
  }

  /// Get workout recommendation based on training load and rest days
  static String getRecommendation(
    double weeklyLoad,
    int daysSinceLastRest,
  ) {
    // Force rest if no rest in 6+ days
    if (daysSinceLastRest >= 6) {
      return "Rest Day - You haven't rested in $daysSinceLastRest days";
    }

    // High load recommendations
    if (weeklyLoad > 700) {
      return "Rest Day - Your training load is very high";
    }

    // Moderate load recommendations
    if (weeklyLoad > 500) {
      if (daysSinceLastRest >= 4) {
        return "Rest Day - Time for recovery";
      }
      return "Easy Run - Keep intensity low";
    }

    // Low load recommendations
    if (weeklyLoad > 300) {
      return "Moderate Run - You can increase intensity";
    }

    // Very low load
    return "Push Day - You're fresh and ready to go hard!";
  }

  /// Get short recommendation (for display)
  static String getShortRecommendation(
    double weeklyLoad,
    int daysSinceLastRest,
  ) {
    if (daysSinceLastRest >= 6) return "Rest";
    if (weeklyLoad > 700) return "Rest";
    if (weeklyLoad > 500) return "Easy";
    if (weeklyLoad > 300) return "Moderate";
    return "Push";
  }

  /// Calculate days since last rest day
  /// Rest day = session with RPE <= 3 or no session
  static int daysSinceLastRest(List<RunningSession> recentSessions) {
    if (recentSessions.isEmpty) return 0;

    // Sort by date descending (most recent first)
    var sorted = List<RunningSession>.from(recentSessions);
    sorted.sort((a, b) => b.date.compareTo(a.date));

    int daysSinceRest = 0;
    DateTime today = DateTime.now();

    for (var session in sorted) {
      int daysDiff = today.difference(session.date).inDays;
      
      // If this session was easy (RPE <= 3), that's a rest
      if (session.rpe <= 3) {
        return daysDiff;
      }
      
      daysSinceRest = daysDiff + 1;
    }

    return daysSinceRest;
  }

  /// Check if user is overtraining
  static bool isOvertraining(
    double weeklyLoad,
    List<RunningSession> last7Days,
  ) {
    // High load
    if (weeklyLoad > 1000) return true;

    // Many consecutive high-intensity days
    int highIntensityDays = 0;
    for (var session in last7Days) {
      if (session.rpe >= 8) {
        highIntensityDays++;
      }
    }

    return highIntensityDays >= 5;
  }

  /// Get recovery recommendation
  static String getRecoveryRecommendation(double weeklyLoad) {
    if (weeklyLoad > 700) {
      return "Take 2-3 rest days. Focus on sleep, nutrition, and light stretching.";
    }
    if (weeklyLoad > 500) {
      return "Take 1-2 rest days. Do easy recovery activities like walking or yoga.";
    }
    return "You're recovering well. Continue with your current routine.";
  }

  /// Calculate recommended training load for next week
  static double recommendedNextWeekLoad(double currentWeekLoad) {
    // Increase by max 10% per week (safe progression)
    const double maxIncreasePercent = 1.10;
    
    if (currentWeekLoad < 300) {
      // Can increase more when load is low
      return currentWeekLoad * 1.20;
    }
    
    return currentWeekLoad * maxIncreasePercent;
  }

  /// Get fatigue color for UI
  static String getFatigueColor(String fatigueLevel) {
    switch (fatigueLevel) {
      case "High":
        return "red";
      case "Moderate":
        return "orange";
      case "Low":
        return "green";
      default:
        return "blue";
    }
  }
}