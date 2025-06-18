
class HorarioClase {
  String hora;
  String? fecha;

  HorarioClase({required this.hora, this.fecha});

  factory HorarioClase.fromJson(Map<String, dynamic> json) {
    return HorarioClase(
      hora: json['hora'],
      fecha: json['fecha'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'hora': hora,
      'fecha': fecha,
    };
  }
}
