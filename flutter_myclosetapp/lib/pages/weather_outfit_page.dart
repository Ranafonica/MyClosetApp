import 'package:flutter/material.dart';
import '../models/weather_outfit.dart';

class WeatherOutfitsPage extends StatelessWidget {
  final List<WeatherOutfit> outfits;

  const WeatherOutfitsPage({super.key, required this.outfits});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Outfits recomendados')),
      body: ListView.builder(
        itemCount: outfits.length,
        itemBuilder: (context, index) {
          final outfit = outfits[index];
          return Card(
            child: Column(
              children: [
                Image.asset(outfit.imagePath),
                Text(outfit.description),
              ],
            ),
          );
        },
      ),
    );
  }
}