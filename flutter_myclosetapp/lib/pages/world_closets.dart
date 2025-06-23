import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:icloset/pages/closet_items.dart';
import 'package:share_plus/share_plus.dart';

class WorldClosetsPage extends StatefulWidget {
  const WorldClosetsPage({super.key});

  @override
  State<WorldClosetsPage> createState() => _WorldClosetsPageState();
}

class _WorldClosetsPageState extends State<WorldClosetsPage> {
  List<ClosetItem> items = [
    ClosetItem(
      id: 1,
      name: "Closet #1\nUser: @PabloC5",
      imagePath: "assets/outfit1.jpg",
      likes: 42,
      isLiked: false,
    ),
    ClosetItem(
      id: 2,
      name: "Closet #2\nUser: @YZYreff",
      imagePath: "assets/outfit2.jpg",
      likes: 28,
      isLiked: false,
    ),
    ClosetItem(
      id: 3,
      name: "Closet #3\nUser: @Ch4mp4gn3PPI",
      imagePath: "assets/outfit3.jpg",
      likes: 35,
      isLiked: false,
    ),
    ClosetItem(
      id: 4,
      name: "Closet #4\nUser: @quav0hunch0",
      imagePath: "assets/outfit4.jpg",
      likes: 19,
      isLiked: false,
    ),
    ClosetItem(
      id: 5,
      name: "Closet #5\nUser: @CUDIb0ss",
      imagePath: "assets/outfit5.jpg",
      likes: 56,
      isLiked: false,
    ),
  ];

  bool _showOnlyLiked = false;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    _loadLikes();
  }

  Future<void> _loadLikes() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var i = 0; i < items.length; i++) {
        final isLiked = _prefs.getBool('liked_${items[i].id}') ?? false;
        items[i] = items[i].copyWith(isLiked: isLiked);
      }
    });
  }

  Future<void> _saveLike(int id, bool isLiked) async {
    await _prefs.setBool('liked_$id', isLiked);
  }

  void _toggleLike(int index) {
    setState(() {
      final newLikeStatus = !items[index].isLiked;
      items[index] = items[index].copyWith(
        isLiked: newLikeStatus,
        likes: newLikeStatus 
            ? items[index].likes + 1 
            : items[index].likes - 1,
      );
      
      // Guardar el estado del like
      _saveLike(items[index].id!, newLikeStatus);
      
      // Ordenar por likes (mayor a menor)
      items.sort((a, b) => b.likes.compareTo(a.likes));
    });
  }

  void _toggleShowOnlyLiked() {
    setState(() {
      _showOnlyLiked = !_showOnlyLiked;
    });
  }

  List<ClosetItem> get _filteredItems {
    return _showOnlyLiked 
        ? items.where((item) => item.isLiked).toList()
        : items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Closets del Mundo'),
        elevation: 4,
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyLiked ? Icons.favorite : Icons.favorite_border,
              color: _showOnlyLiked ? Colors.red : null,
            ),
            onPressed: _toggleShowOnlyLiked,
            tooltip: _showOnlyLiked 
                ? 'Mostrar todos los outfits' 
                : 'Mostrar solo mis likes',
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredItems.length,
        itemBuilder: (context, index) {
          final item = _filteredItems[index];
          return Card(
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                  child: Image.asset(
                    item.imagePath,
                    height: 250,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Text(
                        item.name.split('\n')[0],
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        item.name.split('\n')[1],
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.favorite, color: Colors.red, size: 16),
                          const SizedBox(width: 4),
                          Text('${item.likes} likes'),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              item.isLiked ? Icons.favorite : Icons.favorite_border,
                              color: item.isLiked ? Colors.red : null,
                            ),
                            onPressed: () => _toggleLike(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              Share.share(
                                '¡Mira este outfit en MyClosetApp!\n\n'
                                '${item.name}\n'
                                'Likes: ${item.likes}\n\n'
                                'Descarga la app para ver más: [Enlace al Play Store]',
                                subject: 'Outfit compartido desde MyClosetApp',
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}