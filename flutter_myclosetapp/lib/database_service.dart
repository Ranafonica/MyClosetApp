import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  static Database? _database;

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    return openDatabase(
      join(path, 'mycloset.db'),
      onCreate: _onCreate,
      version: 1,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        createdAt TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE outfits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        topId INTEGER NOT NULL,
        bottomId INTEGER NOT NULL,
        shoesId INTEGER NOT NULL,
        likes INTEGER DEFAULT 0,
        isLiked INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
    
    // Tabla para prendas (similar estructura a tu ClosetItem)
    await db.execute('''
      CREATE TABLE closet_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        userId INTEGER NOT NULL,
        name TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        category TEXT NOT NULL,
        likes INTEGER DEFAULT 0,
        isLiked INTEGER DEFAULT 0,
        createdAt TEXT NOT NULL,
        FOREIGN KEY (userId) REFERENCES users (id)
      )
    ''');
  }

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<int> createUser(String name, String email, String password) async {
    final db = await database;
    return db.insert('users', {
      'name': name,
      'email': email,
      'password': _hashPassword(password), // Asegurar que se hashee aquí también
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
  final db = await database;
  final result = await db.query(
    'users',
    where: 'email = ?',
    whereArgs: [email],
    limit: 1,
  );
  
  return result.isNotEmpty ? {
    'id': result.first['id'],
    'name': result.first['name'],
    'email': result.first['email'],
    'createdAt': result.first['createdAt'],
  } : null;
}

  Future<bool> validateUser(String email, String hashedPassword) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
      limit: 1,
    );
    return result.isNotEmpty;
  }
}