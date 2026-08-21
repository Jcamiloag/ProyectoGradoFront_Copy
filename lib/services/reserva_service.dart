import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:hola_mundo/models/reserva.dart';


class ReservaService {


  final String baseUrl =
      "http://localhost:8080/reservas";



  // ===============================
  // CREAR RESERVA
  // ===============================

  Future<Reserva> crearReserva(
      int userId,
      int horarioId,
  ) async {


    final response = await http.post(

      Uri.parse(baseUrl),

      headers: {

        "Content-Type": "application/json",

      },


      body: jsonEncode({

        "userId": userId,

        "horarioId": horarioId,

      }),


    );



    print("STATUS RESERVA: ${response.statusCode}");
    print("BODY RESERVA: ${response.body}");



    if(response.statusCode == 200 ||
       response.statusCode == 201){


      return Reserva.fromJson(
          jsonDecode(response.body)
      );


    }



    throw Exception(
        response.body
    );


  }





  // ===============================
  // OBTENER RESERVAS USUARIO
  // ===============================

  Future<List<Reserva>> obtenerReservasUsuario(
      int userId
  ) async {



    final response = await http.get(

        Uri.parse(
            "$baseUrl/usuario/$userId"
        )

    );



    if(response.statusCode == 200){


      List data = jsonDecode(response.body);



      return data
          .map(
              (e)=> Reserva.fromJson(e)
      )
          .toList();



    }



    throw Exception(
        "Error cargando reservas"
    );


  }





  // ===============================
  // CANCELAR RESERVA
  // ===============================

  Future<Reserva> cancelarReserva(
      int reservaId
  ) async {


    final response = await http.put(

        Uri.parse(
            "$baseUrl/$reservaId/cancelar"
        )

    );



    if(response.statusCode == 200){


      return Reserva.fromJson(
          jsonDecode(response.body)
      );


    }



    throw Exception(
        "Error cancelando reserva"
    );


  }


}