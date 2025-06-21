import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'theme/theme.dart';
import 'theme/util.dart';
import 'pages/preferences_service.dart';

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
        final brightness = isDarkMode ? Brightness.dark : Brightness.light;
        final textTheme = createTextTheme(context, "Nova Slim", "Bungee");
        final theme = MaterialTheme(textTheme);

        return MaterialApp(
          title: 'iCloset',
          debugShowCheckedModeBanner: false,
          theme: isDarkMode ? theme.dark() : theme.light(),
          home: const SplashScreen(),
        );
      },
    );
  }

  // Método para actualizar el tema desde otras pantallas
 void updateTheme(bool isDarkMode) {
    _isDarkMode.value = isDarkMode;
  }
}