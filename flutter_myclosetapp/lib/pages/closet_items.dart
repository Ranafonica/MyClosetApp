class ClosetItem {
  final int id;
  final String name;
  final String imagePath;
  final int likes;
  final bool isLiked;
  final String category; // Nueva propiedad añadida

  const ClosetItem({
    required this.id,
    required this.name,
    required this.imagePath,
    this.likes = 0,
    this.isLiked = false,
    this.category = 'Otros', // Valor por defecto para mantener compatibilidad
  });

  ClosetItem copyWith({
    int? id,
    String? name,
    String? imagePath,
    int? likes,
    bool? isLiked,
    String? category, // Nuevo parámetro en copyWith
  }) {
    return ClosetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      category: category ?? this.category, // Manteniendo el valor actual si no se proporciona
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

  const Outfit({
    required this.id,
    required this.name,
    required this.top,
    required this.bottom,
    required this.shoes,
    this.accessories,
    required this.createdAt,
  });
}