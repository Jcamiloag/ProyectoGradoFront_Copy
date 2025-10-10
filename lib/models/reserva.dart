class Reserva {
  final int id;
  final int claseId;
  final String claseNombre;
  final String fecha;
  final String hora;

  Reserva({
    required this.id,
    required this.claseId,
    required this.claseNombre,
    required this.fecha,
    required this.hora,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'] ?? 0,
      claseId: json['claseId'] ?? 0,
      claseNombre: json['claseNombre'] ?? 'Clase sin nombre',
      fecha: json['fecha'] ?? '',
      hora: json['hora'] ?? '',
    );
  }
}
