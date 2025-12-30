import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/running_session.dart';

class DatabaseService {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final path = join(await getDatabasesPath(), 'runs.db');

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        return db.execute('''
          CREATE TABLE sessions (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            date TEXT,
            duration INTEGER,
            distance REAL,
            rpe INTEGER
          )
        ''');
      },
    );
  }

  static Future<void> insertSession(RunningSession session) async {
    final db = await database;
    await db.insert('sessions', session.toMap());
  }

  static Future<List<RunningSession>> getAllSessions() async {
    final db = await database;
    final maps = await db.query('sessions');

    return maps.map((e) => RunningSession.fromMap(e)).toList();
  }
}
