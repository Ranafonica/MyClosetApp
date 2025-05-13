import 'package:flutter/material.dart';
import 'package:flutter_myclosetapp/pages/closet_items.dart';

class WorldClosetsPage extends StatelessWidget {
  const WorldClosetsPage({super.key,  required this.title});

  final List<ClosetItem> items = const [
    ClosetItem(name: "Anthony.S Closet", imagePath: "assets/outfit1.jpg"),
    ClosetItem(name: "Marcus.B Closet", imagePath: "assets/outfit2.jpg"),
    ClosetItem(name: "Jeremy.C Closet", imagePath: "assets/outfit3.jpg"),
    ClosetItem(name: "Leon Closet", imagePath: "assets/outfit4.jpg"),
    ClosetItem(name: "James.B Closet", imagePath: "assets/outfit5.jpg"),
  ];

  final String title;
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
