import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:hola_mundo/models/asistencia.dart';

class AsistenciaService {

  final String baseUrl =
      "http://localhost:8080/asistencias";



  // ===============================
  // OBTENER INSCRITOS DE UN HORARIO
  // ===============================

  Future<List<Asistencia>> obtenerAsistenciasHorario(
      int horarioId,
  ) async {

    final response = await http.get(

      Uri.parse(
        "$baseUrl/horario/$horarioId",
      ),

    );



    if (response.statusCode == 200) {

      final List<dynamic> data =
          jsonDecode(response.body);

      return data
          .map(
            (e) => Asistencia.fromJson(e),
          )
          .toList();

    }



    throw Exception(
      "Error obteniendo asistencias",
    );

  }



  // ===============================
  // ACTUALIZAR ESTADO
  // ===============================

  Future<void> actualizarEstado(
      int asistenciaId,
      String estado,
  ) async {

    final response = await http.put(

      Uri.parse(
        "$baseUrl/$asistenciaId/estado",
      ),

      headers: {

        "Content-Type":
            "application/json",

      },

      body: jsonEncode({

        "estado": estado,

      }),

    );



    if (response.statusCode != 200) {

      throw Exception(
        "Error actualizando asistencia",
      );

    }

  }

}