import 'dart:convert';

import 'package:hola_mundo/constants/api_constants.dart';
import 'package:hola_mundo/models/plan_catalogo.dart';
import 'package:http/http.dart' as http;

import 'auth_service.dart';

class PlanCatalogoService {

  final String baseUrl = AppConstants.baseUrl;
  final AuthService authService = AuthService();

  Future<List<PlanCatalogo>> obtenerPlanes() async {

    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/plan-catalogo"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {

      final List datos = jsonDecode(response.body);

      return datos
          .map((e) => PlanCatalogo.fromJson(e))
          .toList();
    }

    throw Exception("Error al cargar planes");
  }

  Future<List<PlanCatalogo>> obtenerPlanesActivos() async {

    final token = await authService.getToken();

    final response = await http.get(
      Uri.parse("$baseUrl/plan-catalogo/activos"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {

      final List datos = jsonDecode(response.body);

      return datos
          .map((e) => PlanCatalogo.fromJson(e))
          .toList();
    }

    throw Exception("Error al cargar planes");
  }
}