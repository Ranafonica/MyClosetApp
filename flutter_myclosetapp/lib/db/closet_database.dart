import 'package:icloset/pages/closet_items.dart'; // Cambiado a pages

class ClosetDatabase {
  static final ClosetDatabase instance = ClosetDatabase._init();
  List<ClosetItem> _items = [];
  int _nextId = 1;

  ClosetDatabase._init();

  Future<ClosetItem> create(ClosetItem item) async {
    final newItem = item.copyWith(id: _nextId++);
    _items.add(newItem);
    return newItem;
  }

  Future<List<ClosetItem>> readAllItems() async {
    return List<ClosetItem>.from(_items);
  }

  Future<int> delete(int id) async {
    final initialLength = _items.length;
    _items.removeWhere((item) => item.id == id);
    return initialLength - _items.length;
  }
}