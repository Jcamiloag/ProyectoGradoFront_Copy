/*import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:hola_mundo/models/establecimiento.dart';

class EstablecimientoService {
  static const String baseUrl = 'http://10.0.2.2:8080';
  static const String baseUrlImg = 'http://10.0.2.2:8080/images';

  Future<List<Establecimiento>> getEstablecimientos() async {
    try {
      print('Obteniendo lista de establecimientos...'); // Log para debug

      final response = await http.get(
        Uri.parse('$baseUrl/establecimientos'),
        headers: {
          'Content-Type': 'application/json',
          // Añade el token si es necesario
          // 'Authorization': 'Bearer $token',
        },
      );

      print(
        'Get Establecimientos - Status: ${response.statusCode}',
      ); // Log para debug
      print('Get Establecimientos - Body: ${response.body}'); // Log para debug

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Establecimiento.fromJson(json)).toList();
      } else {
        throw Exception(
          'Error al cargar establecimientos: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('Error en getEstablecimientos: $e'); // Log para debug
      throw Exception('Error al cargar establecimientos: $e');
    }
  }

  Future<bool> deleteEstablecimiento(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('${baseUrl}establecimientos/$id'),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al eliminar establecimiento: $e');
    }
  }

  Future<bool> createEstablecimiento(
    Establecimiento est, {
    File? logoFile,
  }) async {
    //Implement the logic to create an Establecimiento
    //For example, send a request to an API or save it locally
    try {
      final uri = Uri.parse('${baseUrl}establecimientos');
      // Codificar imagen como base64 si existe
      String? base64Image;
      if (logoFile != null) {
        final imageBytes = await logoFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }
      final body = jsonEncode(est.toJson(logoBase64: base64Image));
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      return response.statusCode == 201;
    } catch (e) {
      throw Exception('Error al crear establecimiento: $e');
    }
  }

  //!updateEstablecimiento
  /// Actualiza un establecimiento en la API.
  /// Recibe un objeto Establecimiento y un archivo de imagen opcional.
  /// Devuelve true si la actualización fue exitosa, false en caso contrario.
  Future<bool> updateEstablecimiento(
    Establecimiento est, {
    File? logoFile,
  }) async {
    try {
      final uri = Uri.parse('${baseUrl}establecimiento-update/${est.id}');

      // Codificar imagen como base64 si existe
      // se codifica la imagen a base64 porque la API lo requiere
      // base 64 se usa para convertir datos binarios a texto
      // y se puede enviar como un string en JSON
      String? base64Image;
      if (logoFile != null) {
        final imageBytes = await logoFile.readAsBytes();
        base64Image = base64Encode(imageBytes);
      }

      final body = jsonEncode(est.toJson(logoBase64: base64Image));

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error al actualizar establecimiento: $e');
    }
  }
}
*/