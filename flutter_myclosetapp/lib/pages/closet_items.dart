class ClosetItem {
  final String name;
  final String imagePath;

  const ClosetItem({required this.name, required this.imagePath});
}

class ClosetGroup {
  final String groupName;
  final List<ClosetItem> items;

  const ClosetGroup({required this.groupName, required this.items});
}