import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/api_constants.dart';

class EvaluacionService {

  final String baseUrl = AppConstants.baseUrl;

  Future<bool> guardarEvaluacion(
      Map<String, dynamic> evaluacion) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? '';

    final response = await http.post(

      Uri.parse('$baseUrl/evaluaciones'),

      headers: {

        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },

      body: jsonEncode(evaluacion),

    );

    return response.statusCode == 200;
  }

  Future<Map<String, dynamic>?> obtenerEvaluacionUsuario(
      int userId) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? '';

    final response = await http.get(

      Uri.parse('$baseUrl/evaluaciones/usuario/$userId'),

      headers: {

        'Authorization': 'Bearer $token',

      },

    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);

      if (data is List && data.isNotEmpty) {

        return data.first;

      }

    }

    return null;
  }

  Future<bool> actualizarEvaluacion(
      int id,
      Map<String, dynamic> evaluacion) async {

    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString('token') ?? '';

    final response = await http.put(

      Uri.parse('$baseUrl/evaluaciones/$id'),

      headers: {

        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',

      },

      body: jsonEncode(evaluacion),

    );

    return response.statusCode == 200;
  }
}