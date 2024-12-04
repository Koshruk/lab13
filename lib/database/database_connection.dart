import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:lab13_1/models/notes_model.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await openDatabase(
      join(await getDatabasesPath(), 'notes_database.db'),
      onCreate: (db, version) => db.execute(
        'CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, date_time DATE)',
      ),
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('DROP TABLE IF EXISTS notes');
          db.execute('CREATE TABLE notes(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT, date_time DATE)');
        }
      },
      version: 3,
    );
    return _database!;
  }

  newNote(Notes newNote) async {
    final db = await database;
    var res = await db.insert(
      'notes',
      {
        'text': newNote.text,
        'date_time': newNote.date,
      },
    );
    return res;
  }

  Future<List<Map<String, dynamic>>> getRows() async {
    final db = await database;
    final List<Map<String, dynamic>> res = await db.query('notes', orderBy: 'id DESC');
    return res;
  }

  Future<void> deleteDatabaseFile() async {
    String path = join(await getDatabasesPath(), 'notes_database.db');
    await deleteDatabase(path); // This will delete the entire database
  }
}