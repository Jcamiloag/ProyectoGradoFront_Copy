import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/models/reserva.dart';
import 'package:hola_mundo/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReservaService {
  final String reservaUrl = '$baseUrl/api/reservas';

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// 🔹 Crear reserva (POST /api/reservas)
  Future<bool> hacerReserva({
    required int claseId,
    required int horarioId, // 👈 agregar este parámetro
    required String fecha,
    required String hora,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse(reservaUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "claseId": claseId,
        "horarioId": horarioId, // 👈 enviar también al backend
        "fecha": fecha,
        "hora": hora,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true;
    } else {
      print("❌ Error reserva: ${response.statusCode} → ${response.body}");
      return false;
    }
  }

  /// 🔹 Obtener reservas del usuario autenticado (GET /api/reservas/usuario)
  Future<List<Reserva>> getReservasUsuario() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$reservaUrl/usuario'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Reserva.fromJson(json)).toList();
    } else {
      print("❌ Error al obtener reservas: ${response.body}");
      throw Exception("Error al obtener reservas del usuario");
    }
  }

  /// 🔹 Cancelar reserva (DELETE /api/reservas/{id})
  Future<bool> cancelarReserva(int reservaId) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$reservaUrl/$reservaId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print("❌ Error al cancelar reserva: ${response.body}");
      return false;
    }
  }
}
