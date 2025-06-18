import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/constants/api_constants.dart';
import 'package:hola_mundo/models/user.dart';

class AuthService {
  final String baseUrl = AppConstants.baseUrl;

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        
        if (data['username'] != null) {
          await prefs.setString('username', data['username']);
        }

        if (data['role'] != null) {
          await prefs.setString('role', data['role']); // <-- GUARDAMOS EL ROL
        }

        return {'success': true, 'token': data['token']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Error en login',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  Future<Map<String, dynamic>> register({
    required String name,
    required String last_Name,
    required String username,
    required String phone,
    required String email,
    required String password,
  }) async {
    try {
      final body = jsonEncode({
        'username': username,
        'password': password,
        'firstname': name,
        'lastname': last_Name,
        'email': email,
        'phonenumber': phone,
        'role': 'USER', // Este campo lo ignora el backend si ya lo asigna por correo
      });

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        
        if (data['username'] != null) {
          await prefs.setString('username', data['username']);
        }

        if (data['role'] != null) {
          await prefs.setString('role', data['role']); // <-- GUARDAMOS EL ROL
        }

        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Error en registro: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e',
      };
    }
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role'); // <-- para saber si es ADMIN o USER
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null) {
      return User.fromJson(jsonDecode(userStr));
    }
    return null;
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('username');
    await prefs.remove('role'); // <-- eliminamos el rol al cerrar sesión
    return true;
  }
}
