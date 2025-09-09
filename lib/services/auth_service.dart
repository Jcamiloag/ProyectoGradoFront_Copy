import 'dart:convert';
import 'package:hola_mundo/config.dart' as AppConstants;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
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

        final userObj = User(
          id: data['id'],
          username: data['username'] ?? email,
          firstname: data['firstname'] ?? '',
          lastname: data['lastname'] ?? '',
          email: email,
          phonenumber: data['phonenumber'] ?? '',
          role: data['role'] ?? 'USER',
        );

        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(userObj.toJson()));
        await prefs.setString('username', userObj.username);
        await prefs.setString('role', userObj.role);

        return {'success': true, 'token': data['token']};
      } else {
        return {'success': false, 'message': data['error'] ?? 'Error en login'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
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
        'role': 'USER',
      });

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();

        final userObj = User(
          id: data['id'],
          username: data['username'] ?? username,
          firstname: data['firstname'] ?? name,
          lastname: data['lastname'] ?? last_Name,
          email: email,
          phonenumber: data['phonenumber'] ?? phone,
          role: data['role'] ?? 'USER',
        );

        await prefs.setString('token', data['token']);
        await prefs.setString('user', jsonEncode(userObj.toJson()));
        await prefs.setString('username', userObj.username);
        await prefs.setString('role', userObj.role);

        return {'success': true};
      } else {
        return {
          'success': false,
          'message': 'Error en registro: ${response.statusCode}',
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Error de conexión: $e'};
    }
  }

  Future<User?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userStr = prefs.getString('user');
    if (userStr != null && userStr.isNotEmpty) {
      try {
        return User.fromJson(jsonDecode(userStr));
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    return token?.isNotEmpty == true ? token : null;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');
  }

  Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<bool> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user');
    await prefs.remove('username');
    await prefs.remove('role');
    return true;
  }
}
