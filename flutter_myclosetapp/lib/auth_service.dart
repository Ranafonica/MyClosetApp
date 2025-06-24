import 'database_service.dart';

class AuthService {
  final DatabaseService _dbService = DatabaseService();

  Future<bool> register(String name, String email, String password, String confirmPassword) async {
    if (password != confirmPassword) return false;
    
    final existingUser = await _dbService.getUserByEmail(email);
    if (existingUser != null) return false;
    
    await _dbService.createUser(name, email, password);
    return true;
  }

  Future<bool> login(String email, String password) async {
    return await _dbService.validateUser(email, password);
  }
}