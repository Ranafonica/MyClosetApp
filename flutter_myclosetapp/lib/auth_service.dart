import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'database_service.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Para utf8.encode

class AuthService {
  final DatabaseService _dbService = DatabaseService();
  static const String _userSessionKey = 'current_user_session';

  String _hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) return false;
    
    final existingUser = await _dbService.getUserByEmail(email);
    if (existingUser != null) return false;
    
    // Hashear la contraseña antes de almacenarla
    final hashedPassword = _hashPassword(password);
    await _dbService.createUser(name, email, hashedPassword);
    return true;
  }

  Future<bool> login(String email, String password) async {
    // Hashear la contraseña para comparación
    final hashedPassword = _hashPassword(password);
    final isValid = await _dbService.validateUser(email, hashedPassword);
    
    if (isValid) {
      final user = await _dbService.getUserByEmail(email);
      if (user != null) {
        await _saveUserSession(user);
      }
    }
    return isValid;
  }

  // Nuevos métodos para manejo de sesión
  Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userSessionKey, jsonEncode(userData));
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);
    
    if (userJson != null) {
      try {
        return jsonDecode(userJson) as Map<String, dynamic>;
      } catch (e) {
        await logout(); // Limpia datos corruptos
        return null;
      }
    }
    return null;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userSessionKey);
  }

  // Método auxiliar para verificar estado de sesión
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null;
  }
}