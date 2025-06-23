import 'package:flutter/material.dart';
import 'package:icloset/pages/closet_items.dart';
import 'package:share_plus/share_plus.dart'; 

class WorldClosetsPage extends StatefulWidget {
  const WorldClosetsPage({super.key});

  @override
  State<WorldClosetsPage> createState() => _WorldClosetsPageState();
}

class _WorldClosetsPageState extends State<WorldClosetsPage> {
  List<ClosetItem> items = const [
    ClosetItem(name: "Closet #1\nUser: @PabloC5", imagePath: "assets/outfit1.jpg"),
    ClosetItem(name: "Closet #2\nUser: @YZYreff", imagePath: "assets/outfit2.jpg"),
    ClosetItem(name: "Closet #3\nUser: @Ch4mp4gn3PPI", imagePath: "assets/outfit3.jpg"),
    ClosetItem(name: "Closet #4\nUser: @quav0hunch0", imagePath: "assets/outfit4.jpg"),
    ClosetItem(name: "Closet #5\nUser: @CUDIb0ss", imagePath: "assets/outfit5.jpg"),
  ];

  void _toggleLike(int index) {
    setState(() {
      items[index] = items[index].copyWith(
        isLiked: !items[index].isLiked,
        likes: items[index].isLiked ? items[index].likes - 1 : items[index].likes + 1,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('World Closets'),
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  item.isLiked ? Icons.favorite : Icons.favorite_border,
                                  color: item.isLiked ? Colors.red : null,
                                ),
                                onPressed: () => _toggleLike(index),
                              ),
                              Text('${item.likes}'),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.share),
                            onPressed: () {
                              final item = items[index];
                              Share.share(
                                '¡Mira este closet en MyClosetApp!\n\n'
                                '${item.name}\n'
                                'Imagen: ${item.imagePath}\n\n'
                                'Descarga la app para ver más: [Enlace al Play Store]',  // Reemplaza con tu enlace real
                                subject: 'Compartir closet desde MyClosetApp',
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