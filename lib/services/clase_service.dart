import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';

class ClaseService {
  final String baseUrl = 'http://localhost:8080/api/clases'; // Cambia por tu IP real si es necesario

  Future<List<Clase>> getClases() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Clase.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las clases');
    }
  }

  Future<Clase> addClase(Clase clase) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clase.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final createdClase = Clase.fromJson(jsonDecode(response.body));

      if (createdClase.id != null && clase.horarios != null) {
        for (final horario in clase.horarios!) {
          await agregarHorario(createdClase.id!, horario);
        }
      }

      return createdClase;
    } else {
      throw Exception("Error al crear la clase");
    }
  }

  Future<void> updateClase(Clase clase) async {
    final response = await http.put(
      Uri.parse("$baseUrl/${clase.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clase.toJson()),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al actualizar la clase");
    }
  }

  Future<void> deleteClase(int id) async {
    final response = await http.delete(Uri.parse("$baseUrl/$id"));

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar la clase");
    }
  }

  Future<void> agregarHorario(int claseId, HorarioClase horario) async {
    final response = await http.post(
      Uri.parse('$baseUrl/$claseId/horarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(horario.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception("Error al agregar horario");
    }
  }
}
