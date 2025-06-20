import 'package:flutter/material.dart';
import 'pages/splash_screen.dart';
import 'theme/theme.dart';
import 'theme/util.dart';

// 📦 para borrar la base de datos
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'closet.db');
  await deleteDatabase(path); // 👈 BORRA LA ANTIGUA BD
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = View.of(context).platformDispatcher.platformBrightness;
    final textTheme = createTextTheme(context, "Nova Slim", "Bungee");
    final theme = MaterialTheme(textTheme);

    return MaterialApp(
      title: 'iCloset',
      debugShowCheckedModeBanner: false,
      theme: brightness == Brightness.dark ? theme.dark() : theme.light(),
      home: const SplashScreen(),
    );
  }
}
