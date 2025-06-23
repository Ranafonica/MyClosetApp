import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'weather_service.dart';

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  String? _weatherOutfitImage;
  bool _isLoadingWeather = false;
  String _weatherMessage = 'Toque para obtener recomendación';
  bool _locationDenied = false;

  Future<void> _checkLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        _weatherMessage = 'GPS desactivado. Active la ubicación';
        _locationDenied = true;
      });
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _weatherMessage = 'Permiso de ubicación denegado';
          _locationDenied = true;
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        _weatherMessage = 'Permiso permanentemente denegado. Cambie la configuración';
        _locationDenied = true;
      });
      return;
    }

    // Si tenemos permisos, obtenemos el clima
    await _getWeatherOutfit();
  }

  Future<void> _getWeatherOutfit() async {
    if (_isLoadingWeather) return;
    
    setState(() {
      _isLoadingWeather = true;
      _weatherMessage = 'Obteniendo ubicación...';
    });

    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
      
      final weather = await WeatherService.getWeather(
        position.latitude,
        position.longitude,
      );
      
      final temp = weather['main']['temp'] as double;
      final isCold = temp < 18.0;

      setState(() {
        _weatherOutfitImage = isCold ? 'assets/outfit1.jpg' : 'assets/outfit2.jpg';
        _weatherMessage = isCold ? 'Outfit para clima frío' : 'Outfit para clima cálido';
        _locationDenied = false;
      });
    } catch (e) {
      setState(() {
        _weatherMessage = 'Error: ${e.toString().replaceAll('Exception: ', '')}';
        _locationDenied = true;
      });
    } finally {
      setState(() {
        _isLoadingWeather = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainBanner(context),
            
            // Sección de Outfit por clima
            const SizedBox(height: 24),
            Text(
              'Recomendación del día',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: _locationDenied ? _checkLocationPermission : _getWeatherOutfit,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.grey[200],
                  image: _weatherOutfitImage != null
                      ? DecorationImage(
                          image: AssetImage(_weatherOutfitImage!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: _isLoadingWeather
                    ? const Center(child: CircularProgressIndicator())
                    : _weatherOutfitImage == null
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                _weatherMessage,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: _locationDenied ? Colors.red : Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        : Stack(
                            children: [
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      colors: [
                                        Colors.black.withOpacity(0.7),
                                        Colors.transparent,
                                      ],
                                    ),
                                  ),
                                  child: Text(
                                    _weatherMessage,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
              ),
            ),
            
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
              itemCount: 3,
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

  // [Mantener igual _buildActionCard y _buildQuickActions]
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