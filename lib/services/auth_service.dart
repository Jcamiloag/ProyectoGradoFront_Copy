import 'dart:convert';
import 'package:hola_mundo/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  final String baseUrl = 'http://192.168.0.2:8080'; // Actualiza según corresponda

  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'password': password,
        }),
      );

      print('Register - Response status: ${response.statusCode}');
      print('Register - Response body: ${response.body}');

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
      if (data['user'] != null) {
          await prefs.setString('user', jsonEncode(data['user']));
        }
        return {'success': true, 'token': data['token']};
      } else {
        return {
          'success': false,
          'message': data['error'] ?? 'Error en login'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error de conexión: $e'
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
      print('Iniciando registro...'); // Log inicial
      print('Datos a enviar: username: $username, name: $name, lastname: $last_Name, email: $email, phone: $phone'); // Log de datos

      final body = jsonEncode({
        'username': username,
        'password': password,
        'firstname': name,
        'lastname': last_Name,
        'email': email,
        'phonenumber': phone,
        'role': 'USER'
      });

      print('Body del request: $body'); // Log del body

      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      print('Register - Response status: ${response.statusCode}');
      print('Register - Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', data['token']);
        return {'success': true};
      } else {
        print('Error en registro - Status code: ${response.statusCode}');
        print('Error en registro - Body: ${response.body}');
        return {
          'success': false,
          'message': 'Error en registro: ${response.statusCode}'
        };
      }
    } catch (e) {
      print('Error de conexión: $e'); // Log del error
      return {
        'success': false,
        'message': 'Error de conexión: $e'
      };
    }
    
    
}

  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error obteniendo token: $e');
      return null;
    }
  }

  Future<User?> getUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userStr = prefs.getString('user');
      if (userStr != null) {
        return User.fromJson(jsonDecode(userStr));
      }
      return null;
    } catch (e) {
      print('Error obteniendo usuario: $e');
      return null;
    }
  }

  Future<bool> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user');
      return true;
    } catch (e) {
      print('Error en logout: $e');
      return false;
    }
  }
 
}
  

