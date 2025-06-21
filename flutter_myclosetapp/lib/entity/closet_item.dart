class ClosetItem {
  final int? id;
  final String name;
  final String imagePath;
  final String category;

  ClosetItem({
    this.id,
    required this.name,
    required this.imagePath,
    required this.category,
  });

  ClosetItem copyWith({int? id, String? name, String? imagePath, String? category}) {
    return ClosetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      category: category ?? this.category,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'category': category,
    };
  }

  factory ClosetItem.fromMap(Map<String, dynamic> map) {
    return ClosetItem(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      category: map['category'],
    );
  }
}
