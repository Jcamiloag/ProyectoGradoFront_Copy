import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/models/user.dart';

class UserService {
  final String baseUrl = AppConstants.baseUrl;// Cambia por tu backend

  /// Obtiene el perfil del usuario actualmente autenticado.
  /// Lanza excepción si falla la petición o no existe usuario.
  Future<User> fetchUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.get(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      return User.fromJson(jsonResponse);
    } else {
      throw Exception('Error al obtener perfil: ${response.statusCode}');
    }
  }

  /// Actualiza el perfil del usuario.
  /// Retorna true si la actualización fue exitosa.
  Future<bool> updateUserProfile(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';

    final response = await http.put(
      Uri.parse('$baseUrl/user/me'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(user.toJson()),
    );

    return response.statusCode == 200;
  }
}
