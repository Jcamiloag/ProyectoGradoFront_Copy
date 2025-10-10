import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

class HorarioClase {
  int? id;
  String hora;
  String fecha;
  int capacidad;
  int? claseId; // ✅ agregado, porque el backend lo devuelve

  HorarioClase({
    this.id,
    required this.hora,
    required this.fecha,
    required this.capacidad,
    this.claseId,
  });

  /// ✅ Conversión desde JSON con manejo de nulos
  factory HorarioClase.fromJson(Map<String, dynamic> json) {
    print("📌 Recibí horario desde backend: $json");

    return HorarioClase(
      id: json['id'],
      hora: (json['hora'] ?? "00:00").toString(),
      fecha: (json['fecha'] ?? "").toString(),
      capacidad: json['capacidad'] is int
          ? json['capacidad']
          : int.tryParse(json['capacidad']?.toString() ?? "0") ?? 0,
      claseId: json['claseId'],
    );
  }

  /// ✅ Conversión a JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'hora': _formatearHora(hora),
      'fecha': fecha,
      'capacidad': capacidad,
      if (claseId != null) 'claseId': claseId,
    };
  }

  /// ✅ Asegura que la hora siempre tenga formato HH:mm:ss
  String _formatearHora(String horaOriginal) {
    try {
      if (horaOriginal.contains(":")) {
        // ejemplo: "14:30"
        final parsed = DateFormat.Hm().parse(horaOriginal);
        return DateFormat.Hms().format(parsed);
      }
      return horaOriginal;
    } catch (e) {
      print("⚠️ Error formateando hora: $e");
      return "00:00:00";
    }
  }

  /// ✅ Método para formatear hora desde TimeOfDay
  static String formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt);
  }
}
