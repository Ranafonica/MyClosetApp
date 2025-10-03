import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _userSessionKey = 'current_user_session';

  // Registro con email y contraseña
  Future<User?> register(String name, String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Guardar información adicional del usuario en Firestore
      if (result.user != null) {
        await _saveUserData(result.user!.uid, name, email);
        await _saveUserSession({
          'uid': result.user!.uid,
          'name': name,
          'email': email,
        });
      }
      
      return result.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login con email y contraseña
  Future<User?> login(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      if (result.user != null) {
        final userData = await _getUserData(result.user!.uid);
        await _saveUserSession({
          'uid': result.user!.uid,
          'name': userData['name'] ?? result.user!.displayName ?? 'Usuario',
          'email': result.user!.email ?? email,
        });
      }
      
      return result.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Login con Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = 
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      
      if (result.user != null) {
        await _saveUserData(
          result.user!.uid, 
          result.user!.displayName ?? 'Usuario', 
          result.user!.email ?? ''
        );
        await _saveUserSession({
          'uid': result.user!.uid,
          'name': result.user!.displayName ?? 'Usuario',
          'email': result.user!.email ?? '',
        });
      }
      
      return result.user;
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Cerrar sesión
  Future<void> logout() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_userSessionKey);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }

  // Obtener usuario actual
  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userSessionKey);
    
    if (userJson != null) {
      try {
        return Map<String, dynamic>.from(jsonDecode(userJson));
      } catch (e) {
        await logout();
        return null;
      }
    }
    
    // Si no hay sesión guardada, verificar Firebase Auth
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      final userData = await _getUserData(currentUser.uid);
      final userSession = {
        'uid': currentUser.uid,
        'name': userData['name'] ?? currentUser.displayName ?? 'Usuario',
        'email': currentUser.email ?? '',
      };
      await _saveUserSession(userSession);
      return userSession;
    }
    
    return null;
  }

  // Obtener UID del usuario actual
  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final user = await getCurrentUser();
    return user != null && _auth.currentUser != null;
  }

  // Métodos auxiliares privados
  Future<void> _saveUserData(String uid, String name, String email) async {
    await _firestore.collection('users').doc(uid).set({
      'name': name,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLogin': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<Map<String, dynamic>> _getUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data() ?? {};
  }

  Future<void> _saveUserSession(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userSessionKey, jsonEncode(userData));
  }

  String _handleAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          return 'El correo electrónico ya está en uso.';
        case 'invalid-email':
          return 'El correo electrónico no es válido.';
        case 'operation-not-allowed':
          return 'Operación no permitida.';
        case 'weak-password':
          return 'La contraseña es demasiado débil.';
        case 'user-disabled':
          return 'La cuenta ha sido deshabilitada.';
        case 'user-not-found':
          return 'No se encontró una cuenta con este correo.';
        case 'wrong-password':
          return 'La contraseña es incorrecta.';
        default:
          return 'Error de autenticación: ${error.message}';
      }
    }
    return 'Error inesperado: $error';
  }

  // Recuperar contraseña
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw _handleAuthError(e);
    }
  }
}