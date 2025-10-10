import 'package:hola_mundo/models/horario_clase.dart';
import 'package:intl/intl.dart';

String normalizarHora(String horaOriginal) {
  try {
    final parsed = DateFormat.jm().parse(horaOriginal); // "4:44 AM" -> DateTime
    return DateFormat("HH:mm:ss").format(parsed); // -> "04:44:00"
  } catch (e) {
    return horaOriginal; // fallback si ya viene bien
  }
}

class Clase {
  int? id;
  String nombre;
  String descripcion;
  String categoria;
  bool activa;
  List<HorarioClase>? horarios;

  Clase({
    this.id,
    required this.nombre,
    required this.descripcion,
    required this.categoria,
    this.activa = true,
    this.horarios,
  });

  factory Clase.fromJson(Map<String, dynamic> json) {
    return Clase(
      id: json['id'],
      nombre: json['nombre']?.toString() ?? "",
      descripcion: json['descripcion']?.toString() ?? "",
      categoria: json['categoria']?.toString() ?? "",
      activa: json['activa'] == null
          ? true
          : (json['activa'] is bool
              ? json['activa']
              : json['activa'].toString().toLowerCase() == "true"),
      horarios: json['horarios'] != null
          ? List<HorarioClase>.from(
              (json['horarios'] as List).map(
                (h) => HorarioClase.fromJson(h),
              ),
            )
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'activa': activa,
      'horarios': horarios?.map((h) => h.toJson()).toList(),
    };
  }
}
