import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'theme/theme.dart';
import 'theme/util.dart';
import 'pages/preferences_service.dart';
import 'pages/home.dart';
import 'pages/my_closet.dart';
import 'pages/world_closets.dart';
import 'pages/add_closet_items.dart';
import 'pages/weather_outfit_page.dart';
import 'pages/create_outfit_page.dart';
import 'pages/outfits_page.dart';
import 'login_page.dart';
import 'register_page.dart';
import 'account_page.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesService();
  await prefs.init();
  final isDarkMode = prefs.darkMode;
  
  runApp(MyApp(initialDarkMode: isDarkMode));
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;
  
  const MyApp({super.key, required this.initialDarkMode});

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late ValueNotifier<bool> _isDarkMode;

  @override
  void initState() {
    super.initState();
    _isDarkMode = ValueNotifier(widget.initialDarkMode);
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isDarkMode,
      builder: (context, isDarkMode, child) {
        final textTheme = createTextTheme(context, "Nova Slim", "Bungee");
        final theme = MaterialTheme(textTheme);

        return MaterialApp(
          title: 'iCloset',
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? theme.dark() : theme.light(),
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginPage(),
            '/register': (context) => const RegisterPage(),
            '/home': (context) => const MyHomePage(title: 'MyClosetApp'),
            '/my-closet': (context) => const MyClosetPage(),
            '/world-closets': (context) => const WorldClosetsPage(),
            '/add-item': (context) => const AddClosetItemPage(),
            '/create-outfit': (context) => const CreateOutfitPage(),
            '/my-outfits': (context) => const OutfitsPage(),
            '/account': (context) => const AccountPage(), // Nueva ruta
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/weather-outfits') {
              final args = settings.arguments as Map<String, dynamic>? ?? {};
              return MaterialPageRoute(
                builder: (context) => WeatherOutfitsPage(
                  outfits: args['outfits'] ?? [],
                ),
              );
            }
            return null;
          },
        );
      },
    );
  }

  void updateTheme(bool isDarkMode) {
    _isDarkMode.value = isDarkMode;
  }
}