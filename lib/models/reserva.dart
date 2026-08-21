class Reserva {

  final int id;

  final int userId;

  final int planId;

  final String nombreClase;

  final String categoria;

  final String hora;

  final String? fecha;

  final String fechaReserva;

  final String estado;


  Reserva({

    required this.id,

    required this.userId,

    required this.planId,

    required this.nombreClase,

    required this.categoria,

    required this.hora,

    this.fecha,

    required this.fechaReserva,

    required this.estado,

  });



  factory Reserva.fromJson(Map<String, dynamic> json) {

    return Reserva(

      id: json['id'] ?? 0,

      userId: json['userId'] ?? 0,

      planId: json['planId'] ?? 0,


      nombreClase:
          json['nombreClase'] ?? "",


      categoria:
          json['categoria'] ?? "",


      hora:
          json['hora'] ?? "",


      fecha:
          json['fecha'],


      fechaReserva:
          json['fechaReserva'] ?? "",


      estado:
          json['estado'] ?? "",

    );

  }

}