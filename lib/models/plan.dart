import 'package:hola_mundo/models/plan_catalogo.dart';


class Plan {

  final int id;

  final int userId;

  final PlanCatalogo? planCatalogo;

  final int cantidadClases;

  final int clasesRestantes;

  final double valor;

  final DateTime? fechaInicio;

  final DateTime? fechaFinalizacion;

  final String estado;



  Plan({

    required this.id,

    required this.userId,

    required this.planCatalogo,

    required this.cantidadClases,

    required this.clasesRestantes,

    required this.valor,

    required this.fechaInicio,

    required this.fechaFinalizacion,

    required this.estado,

  });





  factory Plan.fromJson(Map<String, dynamic> json) {

    return Plan(

      id: json['id'] ?? 0,


      userId:

          json['user'] != null
              ? json['user']['id'] ?? 0
              : json['userId'] ?? 0,



      planCatalogo:

          json['planCatalogo'] != null

              ? PlanCatalogo.fromJson(
                  json['planCatalogo']
                )

              : null,



      cantidadClases:

          json['cantidadClases'] ?? 0,



      clasesRestantes:

          json['clasesRestantes'] ?? 0,



      valor:

          json['valor'] != null

              ? (json['valor'] as num).toDouble()

              : 0.0,



      fechaInicio:

          json['fechaInicio'] != null

              ? DateTime.parse(
                  json['fechaInicio']
                )

              : null,



      fechaFinalizacion:

          json['fechaFinalizacion'] != null

              ? DateTime.parse(
                  json['fechaFinalizacion']
                )

              : null,



      estado:

          json['estado'] ?? "",

    );

  }





  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "userId": userId,

      "planCatalogo":
          planCatalogo?.toJson(),

      "cantidadClases":
          cantidadClases,

      "clasesRestantes":
          clasesRestantes,

      "valor":
          valor,

      "fechaInicio":
          fechaInicio?.toIso8601String(),

      "fechaFinalizacion":
          fechaFinalizacion?.toIso8601String(),

      "estado":
          estado,

    };

  }

}