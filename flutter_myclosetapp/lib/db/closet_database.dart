import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:icloset/pages/closet_items.dart';

class ClosetDatabase {
  static final ClosetDatabase instance = ClosetDatabase._init();
  static Database? _database;

  ClosetDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('closet.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS closet_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        category TEXT NOT NULL,
        likes INTEGER DEFAULT 0,
        isLiked INTEGER DEFAULT 0
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS outfits (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        top_id INTEGER NOT NULL,
        bottom_id INTEGER NOT NULL,
        shoes_id INTEGER NOT NULL,
        likes INTEGER DEFAULT 0,
        isLiked INTEGER DEFAULT 0,
        created_at TEXT NOT NULL
      )
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS outfit_accessories (
        outfit_id INTEGER NOT NULL,
        item_id INTEGER NOT NULL,
        PRIMARY KEY(outfit_id, item_id)
      )
    ''');
  }

  Future<ClosetItem> create(ClosetItem item) async {
    final db = await database;
    
    final id = await db.insert('closet_items', {
      'name': item.name,
      'imagePath': item.imagePath,
      'category': item.category,
      'likes': item.likes,
      'isLiked': item.isLiked ? 1 : 0,
    });
    
    return item.copyWith(id: id);
  }

  Future<List<ClosetItem>> readAllItems() async {
    final db = await database;
    final maps = await db.query('closet_items');
    
    return List.generate(maps.length, (i) {
      return ClosetItem(
        id: maps[i]['id'] as int? ?? 0,
        name: maps[i]['name'] as String? ?? '',
        imagePath: maps[i]['imagePath'] as String? ?? '',
        category: maps[i]['category'] as String? ?? 'Otros',
        likes: maps[i]['likes'] as int? ?? 0,
        isLiked: (maps[i]['isLiked'] as int?) == 1,
      );
    });
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(
      'closet_items',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<Outfit> createOutfit(Outfit outfit) async {
    final db = await database;
    
    final outfitId = await db.insert('outfits', {
      'name': outfit.name,
      'top_id': outfit.top.id ?? 0,
      'bottom_id': outfit.bottom.id ?? 0,
      'shoes_id': outfit.shoes.id ?? 0,
      'likes': outfit.likes,
      'isLiked': outfit.isLiked ? 1 : 0,
      'created_at': outfit.createdAt.toIso8601String(),
    });
    
    if (outfit.accessories != null && outfit.accessories!.isNotEmpty) {
      final batch = db.batch();
      for (final accessory in outfit.accessories!) {
        batch.insert('outfit_accessories', {
          'outfit_id': outfitId,
          'item_id': accessory.id ?? 0,
        });
      }
      await batch.commit();
    }
    
    return outfit.copyWith(id: outfitId);
  }

  Future<List<Outfit>> readAllOutfits() async {
    final db = await database;
    final outfitMaps = await db.query('outfits');
    final allItems = await readAllItems();
    final accessories = await db.query('outfit_accessories');
    
    return List.generate(outfitMaps.length, (i) {
      final outfitMap = outfitMaps[i];
      
      final top = allItems.firstWhere(
        (item) => item.id == (outfitMap['top_id'] as int? ?? 0),
        orElse: () => ClosetItem(
          id: 0,
          name: 'No disponible',
          imagePath: '',
          category: 'Otros',
        ),
      );
      
      final bottom = allItems.firstWhere(
        (item) => item.id == (outfitMap['bottom_id'] as int? ?? 0),
        orElse: () => ClosetItem(
          id: 0,
          name: 'No disponible',
          imagePath: '',
          category: 'Otros',
        ),
      );
      
      final shoes = allItems.firstWhere(
        (item) => item.id == (outfitMap['shoes_id'] as int? ?? 0),
        orElse: () => ClosetItem(
          id: 0,
          name: 'No disponible',
          imagePath: '',
          category: 'Otros',
        ),
      );
      
      final outfitAccessories = accessories
          .where((acc) => acc['outfit_id'] == (outfitMap['id'] as int? ?? 0))
          .map((acc) => allItems.firstWhere(
                (item) => item.id == (acc['item_id'] as int? ?? 0),
                orElse: () => ClosetItem(
                  id: 0,
                  name: 'No disponible',
                  imagePath: '',
                  category: 'Otros',
                ),
              ))
          .toList();
      
      return Outfit(
        id: outfitMap['id'] as int? ?? 0,
        name: outfitMap['name'] as String? ?? 'Outfit sin nombre',
        top: top,
        bottom: bottom,
        shoes: shoes,
        accessories: outfitAccessories.isNotEmpty ? outfitAccessories : null,
        likes: outfitMap['likes'] as int? ?? 0,
        isLiked: (outfitMap['isLiked'] as int?) == 1,
        createdAt: DateTime.tryParse(outfitMap['created_at'] as String? ?? '') ?? DateTime.now(),
      );
    });
  }

  Future<int> deleteOutfit(int id) async {
    final db = await database;
    await db.delete(
      'outfit_accessories',
      where: 'outfit_id = ?',
      whereArgs: [id],
    );
    return await db.delete(
      'outfits',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> toggleOutfitLike(int id) async {
    final db = await database;
    final current = await db.query(
      'outfits',
      columns: ['isLiked', 'likes'],
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    
    if (current.isNotEmpty) {
      final isLiked = (current.first['isLiked'] as int?) == 1;
      final likes = current.first['likes'] as int? ?? 0;
      
      await db.update(
        'outfits',
        {
          'isLiked': isLiked ? 0 : 1,
          'likes': isLiked ? likes - 1 : likes + 1,
        },
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }
}