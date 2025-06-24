import 'package:flutter/material.dart';
import 'package:icloset/pages/my_closet.dart';
import 'package:icloset/pages/world_closets.dart';
import 'package:icloset/pages/home_content.dart';
import 'package:icloset/pages/preferences_page.dart';
import 'package:icloset/pages/create_outfit_page.dart'; // Nueva importación

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomeContent(),
    MyClosetPage(),
    WorldClosetsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context); // Cierra el drawer si está abierto
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitle(_selectedIndex)),
      ),
      body: _pages[_selectedIndex],
      drawer: _buildDrawer(),
    );
  }

  String _getTitle(int index) {
    switch (index) {
      case 0: return 'Inicio';
      case 1: return 'Mi Closet';
      case 2: return 'Closets del Mundo';
      default: return widget.title;
    }
  }

  // En home.dart, modificar el método _buildDrawer
  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/image.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            child: Text('User @Ph4rrell'),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () => _onItemTapped(0),
          ),
          ListTile(
            leading: const Icon(Icons.home_repair_service),
            title: const Text('Mi Closet'),
            onTap: () => _onItemTapped(1),
          ),
          ListTile(
            leading: const Icon(Icons.public),
            title: const Text('Closets del Mundo'),
            onTap: () => _onItemTapped(2),
          ),
          ListTile(
            leading: const Icon(Icons.account_circle),
            title: const Text('Mi Cuenta'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/account');
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Preferencias'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const PreferencesPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}