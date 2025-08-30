import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/config.dart'; 

class ReservaService {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<bool> hacerReserva({
    required int claseId,
    required String fecha,
    required String hora,
  }) async {
    final token = await _getToken();

    if (token == null || JwtDecoder.isExpired(token)) {
      print('⚠️ Token ausente o expirado');
      return false;
    }

    final url = Uri.parse('$baseUrl/reservas');

    final body = {
      'claseId': claseId,
      'fecha': fecha,
      'hora': hora,
    };

    print('📤 Enviando reserva: $body');
    print('🔑 Token usado: $token');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );

    print('🔁 Código de respuesta: ${response.statusCode}');
    print('📨 Respuesta: ${response.body}');

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
