import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl = dotenv.env['URL_API']!;

  //! login se encarga de autenticar al usuario
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('${baseUrl}login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(data['user']));
      } catch (e) {
        debugPrint('Error al guardar token en SharedPreferences: $e');
      }

      return {'success': true, 'user': User.fromJson(data['user'])};
    } else {
      final data = jsonDecode(response.body);
      return {'success': false, 'message': data['message'] ?? 'Error en login'};
    }
  }

  //! register se encarga de registrar al usuario
  Future<Map<String, dynamic>> register({
    required String name,
    required String lastName,
    required String username,
    required String phone,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('${baseUrl}users'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'last_name': lastName,
        'username': username,
        'phone': phone,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 201) {
      return {'success': true};
    } else {
      final data = jsonDecode(response.body);
      return {
        'success': false,
        'message': data['message'] ?? 'Error en registro',
        'errors': data['errors'],
      };
    }
  }

  //! getUser se encarga de obtener el usuario
  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) {
        return User.fromJson(jsonDecode(userStr));
      }
    } catch (e) {
      debugPrint('Error al obtener SharedPreferences: $e');
    }
    return null;
  }

  //! getToken se encarga de obtener el token
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      debugPrint('Error al obtener token: $e');
      return null;
    }
  }

  //! isLoggedIn se encarga de verificar si el usuario está logueado
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
    } catch (e) {
      debugPrint('Logout error: $e');
    }
  }
}
