import 'package:flutter/material.dart';
import 'location_service.dart';
import 'weather_service.dart';
import 'weather_outfit_page.dart';
import 'package:icloset/models/weather_outfit.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainBanner(context),
            const SizedBox(height: 24),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                'Explorar',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: 4, // Ahora son 4 cards
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.85,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
              ),
              itemBuilder: (context, index) {
                final cards = [
                  _buildActionCard(
                    context: context,
                    imagePath: 'assets/home_closet.png',
                    title: 'Mi Closet',
                    subtitle: 'Ver tus prendas',
                    onTap: () => Navigator.pushNamed(context, '/my-closet'),
                  ),
                  _buildActionCard(
                    context: context,
                    imagePath: 'assets/home_world.jpg',
                    title: 'Closets del Mundo',
                    subtitle: 'Inspírate',
                    onTap: () => Navigator.pushNamed(context, '/world-closets'),
                  ),
                  _buildActionCard(
                    context: context,
                    imagePath: 'assets/home_outfit.jpg',
                    title: 'Crear Outfit',
                    subtitle: 'Combina prendas',
                    onTap: () => Navigator.pushNamed(context, '/create-outfit'),
                  ),
                  _buildActionCard(
                    context: context,
                    imagePath: 'assets/weather_icon.jpg',
                    title: 'Outfits por clima',
                    subtitle: 'Recomendaciones según tu ubicación',
                    onTap: () async {
                      final scaffold = ScaffoldMessenger.of(context);
                      scaffold.showSnackBar(
                        const SnackBar(content: Text('Obteniendo datos climáticos...')),
                      );
                      try {
                        final position = await LocationService.getCurrentLocation();
                        final weather = await WeatherService.getWeather(
                          position.latitude,
                          position.longitude,
                        );
                        final weatherCondition = weather['weather'][0]['main'].toString();
                        final outfits = WeatherOutfit.getOutfitsForWeather(weatherCondition);
                        
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => WeatherOutfitsPage(outfits: outfits),
                          ),
                        );

                        scaffold.hideCurrentSnackBar();
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Error: ${e.toString()}')),
                        );
                      }
                    },
                  ),
                ];
                return cards[index];
              },
            ),
            
            const SizedBox(height: 24),
            
            _buildQuickActions(context),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMainBanner(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/featured'),
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: const DecorationImage(
            image: AssetImage('assets/home_banner.jpeg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Colors.black.withOpacity(0.7),
                Colors.transparent,
              ],
            ),
          ),
          padding: const EdgeInsets.all(16),
          alignment: Alignment.bottomLeft,
          child: Text(
            'Nueva colección primavera',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String imagePath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Acciones rápidas',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildQuickAction(
                icon: Icons.camera_alt,
                label: 'Añadir prenda',
                onTap: () => Navigator.pushNamed(context, '/add-item'),
              ),
              _buildQuickAction(
                icon: Icons.star,
                label: 'Favoritos',
                onTap: () => Navigator.pushNamed(context, '/favorites'),
              ),
              _buildQuickAction(
                icon: Icons.shopping_bag,
                label: 'Tienda',
                onTap: () => Navigator.pushNamed(context, '/store'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18),
              const SizedBox(width: 8),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}