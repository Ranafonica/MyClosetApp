class ClosetItem {
  final String name;
  final String imagePath;
  final int likes;
  final bool isLiked;

  const ClosetItem({
    required this.name,
    required this.imagePath,
    this.likes = 0,
    this.isLiked = false,
  });

  ClosetItem copyWith({
    String? name,
    String? imagePath,
    int? likes,
    bool? isLiked,
  }) {
    return ClosetItem(
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