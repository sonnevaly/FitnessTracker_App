import 'package:flutter_test/flutter_test.dart';
import 'package:fitness_tracker/services/session_repository.dart';
import 'package:fitness_tracker/models/running_session.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  // 🔑 REQUIRED INITIALIZATION
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  final repo = SessionRepository();

  setUp(() async {
    await repo.deleteAllSessions();
  });

  test('Save and fetch session via repository', () async {
    final session = RunningSession(
      id: 'repo1',
      date: DateTime.now(),
      durationInSeconds: 900,
      distanceInKm: 3.0,
      rpe: 7,
    );

    await repo.saveSession(session);

    final sessions = await repo.getAllSessions();
    expect(sessions.length, 1);
    expect(sessions.first.rpe, 7);
  });

  test('Repository returns correct number of runs', () async {
    await repo.saveSession(
      RunningSession(
        id: 'repo2',
        date: DateTime.now(),
        durationInSeconds: 600,
        distanceInKm: 2.5,
        rpe: 5,
      ),
    );

    final sessions = await repo.getAllSessions();
    expect(sessions.length, 1);
  });
}
