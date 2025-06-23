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
  
  List<Outfit> _outfits = [];
  int _nextOutfitId = 1;

  Future<Outfit> createOutfit(Outfit outfit) async {
    final newOutfit = outfit.copyWith(id: _nextOutfitId++);
    _outfits.add(newOutfit);
    return newOutfit;
  }

  Future<List<Outfit>> readAllOutfits() async {
    return List<Outfit>.from(_outfits);
  }

  Future<int> deleteOutfit(int id) async {
    final initialLength = _outfits.length;
    _outfits.removeWhere((outfit) => outfit.id == id);
    return initialLength - _outfits.length;
  }

  Future<void> toggleOutfitLike(int id) async {
    final index = _outfits.indexWhere((outfit) => outfit.id == id);
    if (index != -1) {
      final outfit = _outfits[index];
      _outfits[index] = outfit.copyWith(
        isLiked: !outfit.isLiked,
        likes: outfit.isLiked ? outfit.likes - 1 : outfit.likes + 1,
      );
    }
  }
}
