import 'package:flutter/material.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset(
            'assets/home1.png',
            width: 600,
            height: 300,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: _ImageWithText(
                    imagePath: 'assets/home3.png',
                    label: 'Mi Clóset',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ImageWithText(
                    imagePath: 'assets/home2.jpg',
                    label: 'Clósets del Mundo',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageWithText extends StatelessWidget {
  final String imagePath;
  final String label;

  const _ImageWithText({required this.imagePath, required this.label, super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1, // hace que sea cuadrada
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
