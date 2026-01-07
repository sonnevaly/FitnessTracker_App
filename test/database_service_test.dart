import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:fitness_tracker/services/database_service.dart';
import 'package:fitness_tracker/models/running_session.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });

  group('DatabaseService - History Management', () {
    late DatabaseService dbService;

    setUp(() async {
      dbService = DatabaseService.instance;
      await dbService.database;
    });

    tearDown(() async {
      await dbService.deleteAllSessions();
    });

    test('Save and retrieve session', () async {
      final session = RunningSession(
        id: 'test-1', date: DateTime(2024, 1, 15),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      );

      await dbService.insertSession(session);
      final sessions = await dbService.getAllSessions();

      expect(sessions, hasLength(1));
      expect(sessions.first.id, equals('test-1'));
    });

    test('Sessions sorted by date (newest first)', () async {
      await dbService.insertSession(RunningSession(
        id: '1', date: DateTime(2024, 1, 10),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));
      await dbService.insertSession(RunningSession(
        id: '2', date: DateTime(2024, 1, 20),
        durationInSeconds: 3600, distanceInKm: 10.0, rpe: 7,
      ));

      final sessions = await dbService.getAllSessions();
      expect(sessions.first.id, equals('2'));
      expect(sessions.last.id, equals('1'));
    });

    test('Delete session from history', () async {
      await dbService.insertSession(RunningSession(
        id: 'delete-me', date: DateTime.now(),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));

      await dbService.deleteSession('delete-me');
      final sessions = await dbService.getAllSessions();
      expect(sessions, isEmpty);
    });

    test('Get sessions from last 7 days', () async {
      await dbService.insertSession(RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));
      await dbService.insertSession(RunningSession(
        id: '2', date: DateTime.now().subtract(Duration(days: 10)),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));

      final sessions = await dbService.getSessionsLastNDays(7);
      expect(sessions, hasLength(1));
      expect(sessions.first.id, equals('1'));
    });

    test('Calculate total distance', () async {
      await dbService.insertSession(RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));
      await dbService.insertSession(RunningSession(
        id: '2', date: DateTime.now(),
        durationInSeconds: 3600, distanceInKm: 10.0, rpe: 7,
      ));

      final totalDistance = await dbService.calculateTotalDistance();
      expect(totalDistance, equals(15.0));
    });

    test('Get session count', () async {
      await dbService.insertSession(RunningSession(
        id: '1', date: DateTime.now(),
        durationInSeconds: 1800, distanceInKm: 5.0, rpe: 6,
      ));

      final count = await dbService.getSessionCount();
      expect(count, equals(1));
    });
  });
}