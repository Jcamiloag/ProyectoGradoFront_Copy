import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/constants/api_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/models/user.dart';

class UserService {

  final String baseUrl = AppConstants.baseUrl;

  /// Obtiene el perfil del usuario actualmente autenticado.
  Future<User> fetchUserProfile() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token') ?? '';

    final response = await http.get(

      Uri.parse('$baseUrl/user/me'),

      headers: {

        'Authorization': 'Bearer $token',

        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final jsonResponse =
          json.decode(response.body);

      return User.fromJson(jsonResponse);

    } else {

      throw Exception(
        'Error al obtener perfil: ${response.statusCode}',
      );
    }
  }

  /// Actualiza perfil del usuario autenticado
  Future<bool> updateUserProfile(
      User user) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token') ?? '';

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

  /// Obtener todos los usuarios
  Future<List<User>> fetchAllUsers() async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token') ?? '';

    final response = await http.get(

      Uri.parse('$baseUrl/users'),

      headers: {

        'Authorization': 'Bearer $token',

        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {

      final List<dynamic> jsonResponse =
          json.decode(response.body);

      return jsonResponse

          .map(
            (user) => User.fromJson(user),
          )

          .toList();

    } else {

      throw Exception(
        'Error al obtener usuarios: ${response.statusCode}',
      );
    }
  }

  /// EDITAR usuario (ADMIN)
  Future<bool> updateUser(
      User user) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token') ?? '';

    final response = await http.put(

      Uri.parse(
        '$baseUrl/users/${user.id}',
      ),

      headers: {

        'Authorization': 'Bearer $token',

        'Content-Type': 'application/json',
      },

      body: jsonEncode(
        user.toJson(),
      ),
    );

    return response.statusCode == 200;
  }

  /// ELIMINAR usuario (ADMIN)
  Future<bool> deleteUser(
      int id) async {

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString('token') ?? '';

    final response = await http.delete(

      Uri.parse(
        '$baseUrl/users/$id',
      ),

      headers: {

        'Authorization': 'Bearer $token',

        'Content-Type': 'application/json',
      },
    );

    return response.statusCode == 200 ||

        response.statusCode == 204;
  }
}