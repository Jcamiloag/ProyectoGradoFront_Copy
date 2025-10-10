import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';
import 'package:hola_mundo/config.dart';

class ClaseService {
  final String claseUrl = '$baseUrl/api/clases';

  Future<List<Clase>> getClases() async {
    final response = await http.get(Uri.parse(claseUrl));
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Clase.fromJson(json)).toList();
    } else {
      throw Exception('Error al obtener las clases');
    }
  }

  Future<Clase> addClase(Clase clase) async {
    // Mandamos la clase sin horarios
    final claseSinHorarios = Clase(
      nombre: clase.nombre,
      descripcion: clase.descripcion,
      categoria: clase.categoria,
      activa: clase.activa,
    );

    final response = await http.post(
      Uri.parse(claseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(claseSinHorarios.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final createdClase = Clase.fromJson(jsonDecode(response.body));

      // Luego agregamos los horarios por separado
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
      Uri.parse("$claseUrl/${clase.id}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(clase.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error al actualizar la clase");
    }
  }

  Future<void> deleteClase(int id) async {
    final response = await http.delete(Uri.parse("$claseUrl/$id"));

    if (response.statusCode != 200 && response.statusCode != 204) {
      throw Exception("Error al eliminar la clase");
    }
  }

  Future<HorarioClase> agregarHorario(int claseId, HorarioClase horario) async {
    // ✅ Aseguramos el formato correcto de fecha y hora
    final fechaFormateada = horario.fecha;
    String horaFormateada;

    // Si la hora viene como DateTime o TimeOfDay, la convertimos
    if (horario.hora is DateTime) {
      final hora = horario.hora as DateTime;
      horaFormateada =
          "${hora.hour.toString().padLeft(2, '0')}:${hora.minute.toString().padLeft(2, '0')}";
    } else if (horario.hora is String) {
      // Ya viene en formato string "HH:mm"
      horaFormateada = horario.hora;
    } else {
      // En caso de que sea nulo o tipo no esperado
      throw Exception("Formato de hora inválido");
    }

    // 🔹 Armamos el JSON manualmente con formato correcto
    final horarioJson = {
      "fecha": fechaFormateada,
      "hora": horaFormateada,
      "capacidad": horario.capacidad,
    };

    print("📤 Enviando horario → $horarioJson");

    final response = await http.post(
      Uri.parse('$claseUrl/$claseId/horarios'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(horarioJson),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final jsonBody = jsonDecode(response.body);
      print("✅ Horario creado correctamente: $jsonBody");
      return HorarioClase.fromJson(jsonBody);
    } else {
      print(
        "❌ Error al agregar horario: ${response.statusCode} -> ${response.body}",
      );
      throw Exception(
        'Error al agregar horario: ${response.statusCode} -> ${response.body}',
      );
    }
  }
}
