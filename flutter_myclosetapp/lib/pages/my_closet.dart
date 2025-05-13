import 'package:flutter/material.dart';
import 'package:flutter_myclosetapp/pages/closet_items.dart';

class MyClosetPage extends StatelessWidget {
  const MyClosetPage({super.key});

  final List<ClosetGroup> closetGroups = const [
    ClosetGroup(
      groupName: "Parte Superior",
      items: [
        ClosetItem(name: "Chaqueta", imagePath: "assets/chaqueta.png"),
        ClosetItem(name: "Camisa", imagePath: "assets/camisa.png"),
      ],
    ),
    ClosetGroup(
      groupName: "Parte Inferior",
      items: [
        ClosetItem(name: "Pantalón", imagePath: "assets/pantalon.png"),
        ClosetItem(name: "Botas", imagePath: "assets/botas.png"),
        ClosetItem(name: "Zapatillas", imagePath: "assets/zapatos.png"),
      ],
    ),
    ClosetGroup(
      groupName: "Accesorios",
      items: [
        ClosetItem(name: "Gorro", imagePath: "assets/sombrero.png"),
        ClosetItem(name: "Lentes", imagePath: "assets/lentes.png"),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: closetGroups.length,
      itemBuilder: (context, groupIndex) {
        final group = closetGroups[groupIndex];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                group.groupName,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: group.items.length,
              itemBuilder: (context, itemIndex) {
                final item = group.items[itemIndex];
                return Card(
                  child: ListTile(
                    leading: Image.asset(item.imagePath, width: 50),
                    title: Text(item.name),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
