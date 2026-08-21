class Asistencia {
  final int id;
  final int reservaId;
  final String nombreUsuario;
  final String nombreClase;
  final String categoria;
  final String hora;
  final String fecha;
  final String estadoReserva;
  final String estadoAsistencia;

  Asistencia({
    required this.id,
    required this.reservaId,
    required this.nombreUsuario,
    required this.nombreClase,
    required this.categoria,
    required this.hora,
    required this.fecha,
    required this.estadoReserva,
    required this.estadoAsistencia,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json["id"] ?? 0,
      reservaId: json["reservaId"] ?? 0,
      nombreUsuario: json["nombreUsuario"] ?? "",
      nombreClase: json["nombreClase"] ?? "",
      categoria: json["categoria"] ?? "",
      hora: json["hora"] ?? "",
      fecha: json["fecha"] ?? "",
      estadoReserva: json["estadoReserva"] ?? "",
      estadoAsistencia: json["estadoAsistencia"] ?? "",
    );
  }
}