class ClosetItem {
  final int id;
  final String name;
  final String imagePath;
  final int likes;
  final bool isLiked;

  const ClosetItem({
    required this.id,
    required this.name,
    required this.imagePath,
    this.likes = 0,
    this.isLiked = false,
  });

  ClosetItem copyWith({
    int? id,
    String? name,
    String? imagePath,
    int? likes,
    bool? isLiked,
  }) {
    return ClosetItem(
      id: id ?? this.id,
      name: name ?? this.name,
      imagePath: imagePath ?? this.imagePath,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }
}

class ClosetGroup {
  final String groupName;
  final List<ClosetItem> items;

  const ClosetGroup({required this.groupName, required this.items});
}