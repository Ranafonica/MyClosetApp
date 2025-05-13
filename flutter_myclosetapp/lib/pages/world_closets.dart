import 'package:flutter/material.dart';
import 'package:flutter_myclosetapp/pages/closet_items.dart';

class WorldClosetsPage extends StatelessWidget {
  const WorldClosetsPage({super.key});

  final List<ClosetItem> items = const [
    ClosetItem(name: "Closet #1\nUser: @PabloC5", imagePath: "assets/outfit1.jpg"),
    ClosetItem(name: "Closet #2\nUser: @YZYreff", imagePath: "assets/outfit2.jpg"),
    ClosetItem(name: "Closet #3\nUser: @Ch4mp4gn3PPI", imagePath: "assets/outfit3.jpg"),
    ClosetItem(name: "Closet #4\nUser: @quav0hunch0", imagePath: "assets/outfit4.jpg"),
    ClosetItem(name: "Closet #5\nUser: @CUDIb0ss", imagePath: "assets/outfit5.jpg"),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 16),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: [
              Image.asset(
                item.imagePath,
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 30),
            ],
          ),
        );
      },
    );
  }
}
