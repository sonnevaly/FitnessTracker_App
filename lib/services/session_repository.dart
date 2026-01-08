import '../models/running_session.dart';
import '../models/weekly_stats.dart';
import 'database_service.dart';

/// Repository for managing running sessions
/// NOTE:
/// - This is NOT state management
/// - UI state is handled by StatefulWidgets
class SessionRepository {
  final DatabaseService _dbService = DatabaseService.instance;

  /// Save a new running session
  Future<void> saveSession(RunningSession session) async {
    try {
      await _dbService.insertSession(session);
    } catch (e) {
      print('Failed to save session: $e');
      rethrow;
    }
  }

  /// Get all sessions (used by History & Dashboard)
  Future<List<RunningSession>> getAllSessions() async {
    try {
      return await _dbService.getAllSessions();
    } catch (e) {
      print('Failed to get sessions: $e');
      rethrow;
    }
  }

  /// Get sessions from last 7 days (weekly view)
  Future<List<RunningSession>> getWeeklySessions() async {
    try {
      return await _dbService.getSessionsLastNDays(7);
    } catch (e) {
      print('Failed to get weekly sessions: $e');
      rethrow;
    }
  }

  /// Get sessions from last 30 days (monthly view)
  Future<List<RunningSession>> getMonthlySessions() async {
    try {
      return await _dbService.getSessionsLastNDays(30);
    } catch (e) {
      print('Failed to get monthly sessions: $e');
      rethrow;
    }
  }

  /// Get weekly statistics (Dashboard)
  Future<WeeklyStats> getWeeklyStats() async {
    try {
      final sessions = await getWeeklySessions();
      return WeeklyStats.fromSessions(sessions);
    } catch (e) {
      print('Failed to get weekly stats: $e');
      rethrow;
    }
  }

  /// Delete a session by ID
  Future<void> deleteSession(String id) async {
    try {
      await _dbService.deleteSession(id);
    } catch (e) {
      print('Failed to delete session: $e');
      rethrow;
    }
  }

  /// Delete all sessions (used for reset / testing)
  Future<void> deleteAllSessions() async {
    try {
      await _dbService.deleteAllSessions();
    } catch (e) {
      print('Failed to delete all sessions: $e');
      rethrow;
    }
  }

  /// Check if database has any sessions
  Future<bool> hasAnySessions() async {
    try {
      return !(await _dbService.isEmpty());
    } catch (e) {
      print('Failed to check sessions: $e');
      rethrow;
    }
  }
}
