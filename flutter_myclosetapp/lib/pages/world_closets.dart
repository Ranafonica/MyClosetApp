import 'package:flutter/material.dart';
import 'package:flutter_myclosetapp/pages/closet_items.dart';

class WorldClosetsPage extends StatelessWidget {
  WorldClosetsPage({super.key});

  final List<ClosetItem> items = const [
    ClosetItem(name: "Sombrero", imagePath: "assets/sombrero.png"),
    ClosetItem(name: "Bufanda", imagePath: "assets/bufanda.png"),
    ClosetItem(name: "Botas", imagePath: "assets/botas.png"),
    ClosetItem(name: "Camisa", imagePath: "assets/camisa.png"),
    ClosetItem(name: "Lentes", imagePath: "assets/lentes.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('World Closets')),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              leading: Image.asset(items[index].imagePath, width: 50),
              title: Text(items[index].name),
            ),
          );
        },
      ),
    );
  }
}
