import 'package:flutter/material.dart';
import 'package:icloset/pages/closet_items.dart';

class TrendingPage extends StatefulWidget {
  final List<ClosetItem> items;

  const TrendingPage({super.key, required this.items});

  @override
  State<TrendingPage> createState() => _TrendingPageState();
}

class _TrendingPageState extends State<TrendingPage> {
  late List<ClosetItem> sortedItems;

  @override
  void initState() {
    super.initState();
    sortedItems = List.from(widget.items)..sort((a, b) => b.likes.compareTo(a.likes));
  }

  void _toggleLike(int index) {
    setState(() {
      sortedItems[index] = sortedItems[index].copyWith(
        isLiked: !sortedItems[index].isLiked,
        likes: sortedItems[index].isLiked ? sortedItems[index].likes - 1 : sortedItems[index].likes + 1,
      );
      sortedItems.sort((a, b) => b.likes.compareTo(a.likes));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tendencias'),
        elevation: 4,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: sortedItems.length,
        itemBuilder: (context, index) {
          final item = sortedItems[index];
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
                      const SizedBox(height: 8),
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
                            onPressed: () {},
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