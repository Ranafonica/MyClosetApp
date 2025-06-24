class ClosetItem {
  final int id;
  final String name;
  final String imagePath;
  final int likes;
  final bool isLiked;
  final String category;

  const ClosetItem({
    required this.id,
    required this.name,
    required this.imagePath,
    this.likes = 0,
    this.isLiked = false,
    this.category = 'Otros',
  });

  ClosetItem copyWith({
    int? id,
    String? name,
    String? imagePath,
    int? likes,
    bool? isLiked,
    String? category,
  }) {
    return ClosetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      category: category ?? this.category,
    );
  }
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category,
      'likes': likes,
      'isLiked': isLiked ? 1 : 0,
    };
  }

  factory ClosetItem.fromMap(Map<String, dynamic> map) {
    return ClosetItem(
      id: map['id'] as int,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      category: map['category'] as String,
      likes: map['likes'] as int,
      isLiked: map['isLiked'] == 1,
    );
  }
}

class ClosetGroup {
  final String groupName;
  final List<ClosetItem> items;

  const ClosetGroup({required this.groupName, required this.items});
}

class Outfit {
  final int id;
  final String name;
  final ClosetItem top;
  final ClosetItem bottom;
  final ClosetItem shoes;
  final List<ClosetItem>? accessories;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;

  const Outfit({
    required this.id,
    required this.name,
    required this.top,
    required this.bottom,
    required this.shoes,
    this.accessories,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
  });

  Outfit copyWith({
    int? id,
    String? name,
    ClosetItem? top,
    ClosetItem? bottom,
    ClosetItem? shoes,
    List<ClosetItem>? accessories,
    DateTime? createdAt,
    int? likes,
    bool? isLiked,
  }) {
    return Outfit(
      id: id ?? this.id,
      name: name ?? this.name,
      top: top ?? this.top,
      bottom: bottom ?? this.bottom,
      shoes: shoes ?? this.shoes,
      accessories: accessories ?? this.accessories,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}