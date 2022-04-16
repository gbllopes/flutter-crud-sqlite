import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  DataBaseHelper._();

  static final DataBaseHelper instance = DataBaseHelper._();

  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'dog-example.db'),
      onCreate: (db, version) async {
        await db.execute(_dog);
      },
      version: 1,
    );
  }

  String get _dog =>
      '''CREATE TABLE dogs(id INTEGER PRIMARY KEY AUTO AUTOINCREMENT, name TEXT, age INTEGER)''';
}
