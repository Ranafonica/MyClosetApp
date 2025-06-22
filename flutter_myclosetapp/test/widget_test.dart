//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:icloset/main.dart';
import 'package:icloset/pages/splash_screen.dart';

void main() {
  testWidgets('Test de SplashScreen', (WidgetTester tester) async {
    // Construye MyApp con initialDarkMode false (valor por defecto en PreferencesService)
    await tester.pumpWidget(const MyApp(initialDarkMode: false));

    // Verifica que SplashScreen esté presente
    expect(find.byType(SplashScreen), findsOneWidget);

    // Opcional: Simula el retraso y navegación a Home
    await tester.pump(const Duration(seconds: 3));
    // Nota: Si SplashScreen navega a Home, necesitarás mockear Navigator
  });
}