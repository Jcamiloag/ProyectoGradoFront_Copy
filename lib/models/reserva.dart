class Reserva {
  final int? id;
  final int claseId;
  final String fecha;
  final String hora;

  Reserva({
    this.id,
    required this.claseId,
    required this.fecha,
    required this.hora,
  });

  factory Reserva.fromJson(Map<String, dynamic> json) {
    return Reserva(
      id: json['id'],
      claseId: json['clase']['id'], // el backend devuelve la clase completa
      fecha: json['fecha'],
      hora: json['hora'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "claseId": claseId,
      "fecha": fecha,
      "hora": hora,
    };
  }
}
