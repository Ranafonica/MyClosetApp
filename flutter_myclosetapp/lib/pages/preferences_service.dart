import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  
  PreferencesService._internal();
  
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // 1. Configuración de Tema
  bool get darkMode => _prefs.getBool('darkMode') ?? false;
  Future<void> setDarkMode(bool value) async {
    await _prefs.setBool('darkMode', value);
  }

  // 2. Ordenación de prendas
  String get sortOrder => _prefs.getString('sortOrder') ?? 'category';
  Future<void> setSortOrder(String value) async {
    await _prefs.setString('sortOrder', value);
  }

  // 3. Notificaciones
  bool get notificationsEnabled => _prefs.getBool('notifications') ?? true;
  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool('notifications', value);
  }

  // 4. Reiniciar preferencias (para desarrollo)
  Future<void> resetPreferences() async {
    await _prefs.clear();
  }
}