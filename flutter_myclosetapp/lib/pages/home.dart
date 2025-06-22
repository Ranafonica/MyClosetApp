import 'package:flutter/material.dart';
import 'package:icloset/pages/my_closet.dart';
import 'package:icloset/pages/world_closets.dart';
import 'package:icloset/pages/home_content.dart';
import 'package:icloset/pages/trending_page.dart';
import 'package:icloset/pages/preferences_page.dart';
import 'package:icloset/pages/closet_items.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const appTitle = 'MyClosetApp';

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: appTitle,
      home: MyHomePage(title: appTitle),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;
  final List<ClosetItem> _sharedItems = const [
    ClosetItem(name: "Closet #1\nUser: @PabloC5", imagePath: "assets/outfit1.jpg"),
    ClosetItem(name: "Closet #2\nUser: @YZYreff", imagePath: "assets/outfit2.jpg"),
    ClosetItem(name: "Closet #3\nUser: @Ch4mp4gn3PPI", imagePath: "assets/outfit3.jpg"),
    ClosetItem(name: "Closet #4\nUser: @quav0hunch0", imagePath: "assets/outfit4.jpg"),
    ClosetItem(name: "Closet #5\nUser: @CUDIb0ss", imagePath: "assets/outfit5.jpg"),
  ];

  static List<String> get _pageTitles => <String>[
    'Home Page',
    'My Closet',
    'World Wide Closets',
    'Tendencias',
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          const HomeContent(),
          const MyClosetPage(),
          WorldClosetsPage(key: ValueKey(_sharedItems)),
          TrendingPage(items: _sharedItems, key: ValueKey(_sharedItems)),
        ],
      ),
      drawer: Drawer(
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
              title: const Text('Home'),
              selected: _selectedIndex == 0,
              onTap: () => _onItemTapped(0),
            ),
            ListTile(
              title: const Text('My Closet'),
              selected: _selectedIndex == 1,
              onTap: () => _onItemTapped(1),
            ),
            ListTile(
              title: const Text('World Closets'),
              selected: _selectedIndex == 2,
              onTap: () => _onItemTapped(2),
            ),
            ListTile(
              title: const Text('Tendencias'),
              selected: _selectedIndex == 3,
              onTap: () => _onItemTapped(3),
            ),
            ListTile(
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
      ),
    );
  }
}