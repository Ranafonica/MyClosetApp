import 'package:flutter/material.dart';
import 'package:icloset/pages/preferences_service.dart';
import 'package:icloset/main.dart';

class PreferencesPage extends StatefulWidget {
  const PreferencesPage({super.key});

  @override
  State<PreferencesPage> createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  final PreferencesService _prefs = PreferencesService();
  bool _darkMode = false;
  bool _notificationsEnabled = true;
  String _sortOrder = 'category';
  final List<String> _sortOptions = ['category', 'name', 'date'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    await _prefs.init();
    setState(() {
      _darkMode = _prefs.darkMode;
      _notificationsEnabled = _prefs.notificationsEnabled;
      _sortOrder = _prefs.sortOrder;
    });
  }

  void _updateAppTheme(bool isDarkMode) {
    final myAppState = context.findAncestorStateOfType<MyAppState>();
    myAppState?.updateTheme(isDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preferencias'),
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetPreferences,
            tooltip: 'Reiniciar preferencias',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Tema oscuro - Ahora actualiza la app en tiempo real
          SwitchListTile(
            title: const Text('Tema oscuro'),
            value: _darkMode,
            onChanged: (value) async {
              await _prefs.setDarkMode(value);
              setState(() => _darkMode = value);
              _updateAppTheme(value); // Notifica el cambio a MyApp
            },
          ),
          const Divider(),

          // Notificaciones (sin cambios)
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: _notificationsEnabled,
            onChanged: (value) async {
              await _prefs.setNotificationsEnabled(value);
              setState(() => _notificationsEnabled = value);
            },
          ),
          const Divider(),

          // Ordenación de prendas (sin cambios)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: const Text(
              'Ordenar prendas por:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          ..._sortOptions.map((option) {
            return RadioListTile<String>(
              title: Text(
                option == 'category' ? 'Categoría' : 
                option == 'name' ? 'Nombre' : 'Fecha',
              ),
              value: option,
              groupValue: _sortOrder,
              onChanged: (value) async {
                if (value != null) {
                  await _prefs.setSortOrder(value);
                  setState(() => _sortOrder = value);
                }
              },
            );
          }).toList(),
        ],
      ),
    );
  }

  Future<void> _resetPreferences() async {
    await _prefs.resetPreferences();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preferencias reiniciadas')),
      );
      _loadPreferences();
      // También resetea el tema a claro
      _updateAppTheme(false); 
    }
  }
}