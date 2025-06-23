class WeatherOutfit {
  final String weatherCondition;
  final String imagePath;
  final String description;

  WeatherOutfit({
    required this.weatherCondition,
    required this.imagePath,
    required this.description,
  });

  // Ejemplo de datos estáticos (puedes cargarlos desde Firebase o JSON más adelante)
  static final Map<String, List<WeatherOutfit>> _outfitRecommendations = {
    'clear': [
      WeatherOutfit(
        weatherCondition: 'soleado',
        imagePath: 'assets/outfits/sunny_outfit1.jpg',
        description: 'Usa lentes de sol y ropa ligera',
      ),
    ],
    'rain': [
      WeatherOutfit(
        weatherCondition: 'lluvioso',
        imagePath: 'assets/outfits/rainy_outfit1.jpg',
        description: 'Lleva paraguas y chaqueta impermeable',
      ),
    ],
    // Añade más condiciones (clouds, snow, etc.)
  };

  static List<WeatherOutfit> getOutfitsForWeather(String weatherCondition) {
    return _outfitRecommendations[weatherCondition.toLowerCase()] ?? [
      WeatherOutfit(
        weatherCondition: 'genérico',
        imagePath: 'assets/outfits/default_outfit.jpg',
        description: 'Recomendación general para clima desconocido',
      ),
    ];
  }
}