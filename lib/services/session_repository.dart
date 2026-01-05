import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import 'database_service.dart';

/// Repository for managing running sessions
class SessionRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Save a new session
  Future<void> saveSession(RunningSession session) async {
    try {
      await _dbService.insertSession(session);
    } catch (e) {
      print('Failed to save session: $e');
      rethrow;
    }
  }

  /// Get all sessions
  Future<List<RunningSession>> getAllSessions() async {
    try {
      return await _dbService.getAllSessions();
    } catch (e) {
      print('Failed to get sessions: $e');
      rethrow;
    }
  }

  /// Get sessions from last 7 days
  Future<List<RunningSession>> getWeeklySessions() async {
    try {
      return await _dbService.getSessionsLastNDays(7);
    } catch (e) {
      print('Failed to get weekly sessions: $e');
      rethrow;
    }
  }

  /// Get sessions from last 30 days
  Future<List<RunningSession>> getMonthlySessions() async {
    try {
      return await _dbService.getSessionsLastNDays(30);
    } catch (e) {
      print('Failed to get monthly sessions: $e');
      rethrow;
    }
  }

  /// Get weekly statistics
  Future<WeeklyStats> getWeeklyStats() async {
    try {
      final sessions = await getWeeklySessions();
      return WeeklyStats.fromSessions(sessions);
    } catch (e) {
      print('Failed to get weekly stats: $e');
      rethrow;
    }
  }

  /// Get a single session by ID
  Future<RunningSession?> getSessionById(String id) async {
    try {
      return await _dbService.getSessionById(id);
    } catch (e) {
      print('Failed to get session: $e');
      rethrow;
    }
  }

  /// Update an existing session
  Future<void> updateSession(RunningSession session) async {
    try {
      await _dbService.updateSession(session);
    } catch (e) {
      print('Failed to update session: $e');
      rethrow;
    }
  }

  /// Delete a session
  Future<void> deleteSession(String id) async {
    try {
      await _dbService.deleteSession(id);
    } catch (e) {
      print('Failed to delete session: $e');
      rethrow;
    }
  }

  /// Get total distance (all time)
  Future<double> getTotalDistance() async {
    try {
      return await _dbService.calculateTotalDistance();
    } catch (e) {
      print('Failed to get total distance: $e');
      rethrow;
    }
  }

  /// Get total number of runs
  Future<int> getTotalRuns() async {
    try {
      return await _dbService.getSessionCount();
    } catch (e) {
      print('Failed to get total runs: $e');
      rethrow;
    }
  }

  /// Check if there are any sessions
  Future<bool> hasAnySessions() async {
    try {
      return !(await _dbService.isEmpty());
    } catch (e) {
      print('Failed to check sessions: $e');
      rethrow;
    }
  }

  /// Get sessions for a specific date
  Future<List<RunningSession>> getSessionsForDate(DateTime date) async {
    try {
      final startOfDay = DateTime(date.year, date.month, date.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));
      return await _dbService.getSessionsInDateRange(startOfDay, endOfDay);
    } catch (e) {
      print('Failed to get sessions for date: $e');
      rethrow;
    }
  }

  /// Get fastest pace (best performance)
  Future<double?> getFastestPace() async {
    try {
      final sessions = await getAllSessions();
      if (sessions.isEmpty) return null;

      double fastest = sessions.first.paceMinPerKm;
      for (var session in sessions) {
        if (session.paceMinPerKm > 0 && session.paceMinPerKm < fastest) {
          fastest = session.paceMinPerKm;
        }
      }
      return fastest;
    } catch (e) {
      print('Failed to get fastest pace: $e');
      rethrow;
    }
  }

  /// Get longest run (by distance)
  Future<RunningSession?> getLongestRun() async {
    try {
      final sessions = await getAllSessions();
      if (sessions.isEmpty) return null;

      RunningSession longest = sessions.first;
      for (var session in sessions) {
        if (session.distanceInKm > longest.distanceInKm) {
          longest = session;
        }
      }
      return longest;
    } catch (e) {
      print('Failed to get longest run: $e');
      rethrow;
    }
  }

  /// Get longest run (by duration)
  Future<RunningSession?> getLongestDuration() async {
    try {
      final sessions = await getAllSessions();
      if (sessions.isEmpty) return null;

      RunningSession longest = sessions.first;
      for (var session in sessions) {
        if (session.durationInSeconds > longest.durationInSeconds) {
          longest = session;
        }
      }
      return longest;
    } catch (e) {
      print('Failed to get longest duration: $e');
      rethrow;
    }
  }

  /// Delete all sessions (for testing/reset)
  Future<void> deleteAllSessions() async {
    try {
      await _dbService.deleteAllSessions();
    } catch (e) {
      print('Failed to delete all sessions: $e');
      rethrow;
    }
  }
}