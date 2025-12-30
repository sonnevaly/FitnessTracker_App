import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_tracker/services/database_service.dart';
import 'package:fitness_tracker/models/running_session.dart';

void main() {
  // Initialize the FFI (Foreign Function Interface) for SQLite.
  // This allows running SQLite tests on the host machine (Windows/Mac/Linux)
  // without needing a physical device or emulator.
  sqfliteFfiInit();
  
  // Set the global database factory to use the FFI implementation
  databaseFactory = databaseFactoryFfi;

  group('DatabaseService Integration Tests', () {
    
    // Setup runs before every test to ensure a clean state
    setUp(() async {
      // Since DatabaseService uses a static singleton, the database file persists.
      // We manually delete all rows from the 'sessions' table to reset the state.
      final db = await DatabaseService.database;
      await db.delete('sessions');
    });

    test('getAllSessions returns empty list when database is empty', () async {
      final sessions = await DatabaseService.getAllSessions();
      expect(sessions, isEmpty);
    });

    test('insertSession saves a session correctly', () async {
      final session = RunningSession(
        date: DateTime.now(),
        duration: 1800, // 30 mins
        distance: 5.0,  // 5 km
        rpe: 7,
      );

      await DatabaseService.insertSession(session);

      final sessions = await DatabaseService.getAllSessions();
      
      expect(sessions.length, 1);
      final retrieved = sessions.first;

      expect(retrieved.duration, 1800);
      expect(retrieved.distance, 5.0);
      expect(retrieved.rpe, 7);
      // ID should be assigned by the database (auto-increment)
      expect(retrieved.id, isNotNull);
    });

    test('Multiple sessions are retrieved correctly', () async {
      final s1 = RunningSession(date: DateTime.now(), duration: 100, distance: 1.0, rpe: 1);
      final s2 = RunningSession(date: DateTime.now(), duration: 200, distance: 2.0, rpe: 2);
      
      await DatabaseService.insertSession(s1);
      await DatabaseService.insertSession(s2);

      final sessions = await DatabaseService.getAllSessions();
      expect(sessions.length, 2);
    });

    test('Data types are preserved (Double/Real)', () async {
      // Testing that distance (REAL) preserves decimal points
      final session = RunningSession(date: DateTime.now(), duration: 1000, distance: 12.345, rpe: 5);

      await DatabaseService.insertSession(session);
      final sessions = await DatabaseService.getAllSessions();
      
      expect(sessions.first.distance, 12.345);
    });
  });
}