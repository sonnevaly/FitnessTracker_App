import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/running_session.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Get database instance
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create tables
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE sessions (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        durationInSeconds INTEGER NOT NULL,
        distanceInKm REAL NOT NULL,
        rpe INTEGER NOT NULL
      )
    ''');
  }

  /// Insert session
  Future<void> insertSession(RunningSession session) async {
    final db = await database;
    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all sessions (History & Dashboard)
  Future<List<RunningSession>> getAllSessions() async {
    final db = await database;
    final result = await db.query(
      'sessions',
      orderBy: 'date DESC',
    );

    return result.map((e) => RunningSession.fromMap(e)).toList();
  }

  /// Get sessions from last N days (weekly/monthly)
  Future<List<RunningSession>> getSessionsLastNDays(int days) async {
    final db = await database;
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));

    final result = await db.query(
      'sessions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );

    return result.map((e) => RunningSession.fromMap(e)).toList();
  }

  /// Check if database is empty (used for mock seeding)
  Future<bool> isEmpty() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM sessions');
    return Sqflite.firstIntValue(result) == 0;
  }

  /// Seed mock data ONCE (dashboard demo data)
  Future<void> seedMockDataIfEmpty() async {
    if (!await isEmpty()) return;

    final mockSessions = [
      RunningSession(
        id: 'mock-1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        durationInSeconds: 1800,
        distanceInKm: 5.0,
        rpe: 5,
      ),
      RunningSession(
        id: 'mock-2',
        date: DateTime.now().subtract(const Duration(days: 3)),
        durationInSeconds: 2700,
        distanceInKm: 8.0,
        rpe: 6,
      ),
    ];

    for (final session in mockSessions) {
      await insertSession(session);
    }
  }

  /// Delete session (History screen)
  Future<void> deleteSession(String id) async {
    final db = await database;
    await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all sessions (reset/testing)
  Future<void> deleteAllSessions() async {
    final db = await database;
    await db.delete('sessions');
  }
}
