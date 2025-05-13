import 'package:flutter/material.dart';
import 'package:flutter_myclosetapp/pages/closet_items.dart';

class MyClosetPage extends StatefulWidget {
  const MyClosetPage({super.key});

  @override
  State<MyClosetPage> createState() => _MyClosetPageState();
}

class _MyClosetPageState extends State<MyClosetPage> {
  final List<ClosetItem> items = const [
    ClosetItem(name: "Chaqueta", imagePath: "assets/chaqueta.png"),
    ClosetItem(name: "Zapatos", imagePath: "assets/zapatos.png"),
    ClosetItem(name: "Pantalón", imagePath: "assets/pantalon.png"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Closet')),
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
