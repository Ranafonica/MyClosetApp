import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../entity/closet_item.dart';

class ClosetDatabase {
  static final ClosetDatabase instance = ClosetDatabase._init();
  static Database? _database;

  ClosetDatabase._init();

  Future<Database> get database async {
    _database ??= await _initDB('closet.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 2, onCreate: _createDB);
  }

Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE closet_items (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT NOT NULL,
      imagePath TEXT NOT NULL,
      category TEXT NOT NULL
    )
  ''');
}

  Future<ClosetItem> create(ClosetItem item) async {
    final db = await instance.database;
    final id = await db.insert('closet_items', item.toMap());
    return item.copyWith(id: id);
  }

  Future<List<ClosetItem>> readAllItems() async {
    final db = await instance.database;
    final result = await db.query('closet_items');
    return result.map((json) => ClosetItem.fromMap(json)).toList();
  }

  Future<int> delete(int id) async {
    final db = await instance.database;
    return await db.delete('closet_items', where: 'id = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
