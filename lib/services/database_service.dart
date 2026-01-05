import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/running_session.dart';

/// Service for SQLite database operations
class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  /// Get database instance (creates if doesn't exist)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('fitness_tracker.db');
    return _database!;
  }

  /// Initialize database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  /// Create database tables
  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
    const realType = 'REAL NOT NULL';

    await db.execute('''
      CREATE TABLE sessions (
        id $idType,
        date $textType,
        durationInSeconds $integerType,
        distanceInKm $realType,
        rpe $integerType
      )
    ''');

    // Create index on date for faster queries
    await db.execute('''
      CREATE INDEX idx_session_date ON sessions(date)
    ''');
  }

  /// Insert a new session
  Future<void> insertSession(RunningSession session) async {
    final db = await database;
    await db.insert(
      'sessions',
      session.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get all sessions
  Future<List<RunningSession>> getAllSessions() async {
    final db = await database;
    final result = await db.query(
      'sessions',
      orderBy: 'date DESC',
    );

    return result.map((map) => RunningSession.fromMap(map)).toList();
  }

  /// Get sessions within a date range
  Future<List<RunningSession>> getSessionsInDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'date >= ? AND date <= ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
      orderBy: 'date DESC',
    );

    return result.map((map) => RunningSession.fromMap(map)).toList();
  }

  /// Get sessions from last N days
  Future<List<RunningSession>> getSessionsLastNDays(int days) async {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days));
    return getSessionsInDateRange(start, end);
  }

  /// Get a single session by ID
  Future<RunningSession?> getSessionById(String id) async {
    final db = await database;
    final result = await db.query(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;
    return RunningSession.fromMap(result.first);
  }

  /// Update a session
  Future<int> updateSession(RunningSession session) async {
    final db = await database;
    return db.update(
      'sessions',
      session.toMap(),
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  /// Delete a session
  Future<int> deleteSession(String id) async {
    final db = await database;
    return await db.delete(
      'sessions',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete all sessions (for testing)
  Future<int> deleteAllSessions() async {
    final db = await database;
    return await db.delete('sessions');
  }

  /// Calculate total distance of all sessions
  Future<double> calculateTotalDistance() async {
    final db = await database;
    final result = await db.rawQuery('SELECT SUM(distanceInKm) FROM sessions');
    final total = result.first.values.first;
    return (total as num?)?.toDouble() ?? 0.0;
  }

  /// Get total number of sessions
  Future<int> getSessionCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) FROM sessions');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  /// Check if database is empty
  Future<bool> isEmpty() async {
    final count = await getSessionCount();
    return count == 0;
  }

  /// Close database
  Future close() async {
    final db = await database;
    db.close();
  }
}