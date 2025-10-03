class ClosetItem {
  final String? id; // Cambiado a String para Firebase
  final String name;
  final String imagePath;
  final String category;
  final int likes;
  final bool isLiked;

  const ClosetItem({
    this.id,
    required this.name,
    required this.imagePath,
    required this.category,
    this.likes = 0,
    this.isLiked = false,
  });

  ClosetItem copyWith({
    String? id,
    String? name,
    String? imagePath,
    String? category,
    int? likes,
    bool? isLiked,
  }) {
    return ClosetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category,
      'likes': likes,
      'isLiked': isLiked,
    };
  }

  factory ClosetItem.fromMap(Map<String, dynamic> map) {
    return ClosetItem(
      id: map['id'] as String?,
      name: map['name'] as String,
      imagePath: map['imagePath'] as String,
      category: map['category'] as String,
      likes: (map['likes'] ?? 0) as int,
      isLiked: (map['isLiked'] ?? false) as bool,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ClosetItem &&
        other.id == id &&
        other.name == name &&
        other.imagePath == imagePath &&
        other.category == category;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, imagePath, category);
  }
}

class ClosetGroup {
  final String groupName;
  final List<ClosetItem> items;

  const ClosetGroup({required this.groupName, required this.items});
}

class Outfit {
  final String? id; // Cambiado a String para Firebase
  final String name;
  final ClosetItem top;
  final ClosetItem bottom;
  final ClosetItem shoes;
  final List<ClosetItem>? accessories;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;

  const Outfit({
    this.id,
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
    String? id,
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

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Outfit &&
        other.id == id &&
        other.name == name &&
        other.top == top &&
        other.bottom == bottom &&
        other.shoes == shoes;
  }

  @override
  int get hashCode {
    return Object.hash(id, name, top, bottom, shoes);
  }
}