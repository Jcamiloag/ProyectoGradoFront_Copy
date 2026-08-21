import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:hola_mundo/constants/api_constants.dart';
import 'package:hola_mundo/models/plan.dart';
import 'package:hola_mundo/models/plan_catalogo.dart';



class PlanService {


  final String baseUrl =
      AppConstants.baseUrl;



  final Duration timeout =
      const Duration(seconds: 10);





  // ==========================
  // PLANES DEL USUARIO
  // ==========================


  Future<List<Plan>> obtenerPlanesUsuario(
      int userId,
      ) async {


    final response = await http.get(


      Uri.parse(
        '$baseUrl/plans/user/$userId',
      ),


      headers:{
        'Content-Type':'application/json',
      },


    ).timeout(timeout);



    if(response.statusCode == 200){


      final List data =
      jsonDecode(response.body);



      return data
          .map(
            (json)=>Plan.fromJson(json),
      )
          .toList();


    }


    throw Exception(
      "Error cargando planes",
    );


  }









  // ==========================
  // ASIGNAR PLAN
  // ==========================


  Future<bool> asignarPlan(
      int userId,
      int planCatalogoId,
      ) async {



    final response = await http.post(



      Uri.parse(
        '$baseUrl/plans/asignar',
      ),



      headers:{
        'Content-Type':'application/json',
      },



      body:jsonEncode({


        "userId":
        userId,


        "planCatalogoId":
        planCatalogoId,


      }),



    ).timeout(timeout);




    return response.statusCode == 200 ||
        response.statusCode == 201;


  }









  // ==========================
  // OBTENER CATÁLOGO
  // ==========================


  Future<List<PlanCatalogo>> obtenerPlanesCatalogo() async {



    final response = await http.get(



      Uri.parse(
        '$baseUrl/plan-catalogo',
      ),



      headers:{
        'Content-Type':'application/json',
      },



    ).timeout(timeout);





    if(response.statusCode == 200){



      final List data =
      jsonDecode(response.body);




      return data
          .map(
              (json)=>PlanCatalogo.fromJson(json)
      )
          .toList();



    }



    throw Exception(
      "Error cargando catálogo",
    );



  }









  // ==========================
  // CREAR PLAN CATÁLOGO
  // ==========================


  Future<bool> crearPlanCatalogo(
      PlanCatalogo plan,
      ) async {



    final response = await http.post(



      Uri.parse(
        '$baseUrl/plan-catalogo',
      ),



      headers:{
        'Content-Type':'application/json',
      },



      body:jsonEncode(

          plan.toJson()

      ),



    ).timeout(timeout);




    return response.statusCode == 200 ||
        response.statusCode == 201;


  }









  // ==========================
  // ACTUALIZAR PLAN CATÁLOGO
  // ==========================


  Future<bool> actualizarPlanCatalogo(
      PlanCatalogo plan,
      ) async {



    final response = await http.put(



      Uri.parse(
        '$baseUrl/plan-catalogo/${plan.id}',
      ),



      headers:{
        'Content-Type':'application/json',
      },



      body:jsonEncode(

          plan.toJson()

      ),



    ).timeout(timeout);




    return response.statusCode == 200;


  }









  // ==========================
  // CAMBIAR ESTADO CATÁLOGO
  // ==========================


  Future<bool> cambiarEstadoCatalogo(
      int id,
      ) async {



    final response = await http.patch(



      Uri.parse(
        '$baseUrl/plan-catalogo/$id/estado',
      ),



      headers:{
        'Content-Type':'application/json',
      },



    ).timeout(timeout);



    return response.statusCode == 200;



  }









  // ==========================
  // ELIMINAR PLAN CATÁLOGO
  // ==========================


  Future<bool> eliminarPlanCatalogo(
      int id,
      ) async {



    final response = await http.delete(



      Uri.parse(
        '$baseUrl/plan-catalogo/$id',
      ),



      headers:{
        'Content-Type':'application/json',
      },



    ).timeout(timeout);




    return response.statusCode == 200 ||
        response.statusCode == 204;



  }









  // ==========================
  // ACTUALIZAR ESTADO PLAN USUARIO
  // ==========================


  Future<bool> actualizarEstadoPlan(

      int planId,

      String estado,

      ) async {



    final response = await http.put(



      Uri.parse(
        '$baseUrl/plans/$planId',
      ),



      headers:{
        'Content-Type':'application/json',
      },



      body:jsonEncode({


        "estado":
        estado,


      }),



    ).timeout(timeout);




    return response.statusCode == 200;



  }









  // ==========================
  // ELIMINAR PLAN ASIGNADO
  // ==========================


  Future<bool> eliminarPlanAsignado(
      int planId,
      ) async {



    final response = await http.delete(



      Uri.parse(
        '$baseUrl/plans/$planId',
      ),



      headers:{
        'Content-Type':'application/json',
      },



    ).timeout(timeout);




    return response.statusCode == 200 ||
        response.statusCode == 204;



  }



}