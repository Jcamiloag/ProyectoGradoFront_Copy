import 'package:hola_mundo/models/horario_clase.dart';

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
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      categoria: json['categoria'],
      activa: json['activa'],
      horarios:
          json['horarios'] != null
              ? List<HorarioClase>.from(
                json['horarios'].map((h) => HorarioClase.fromJson(h)),
              )
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'descripcion': descripcion,
      'categoria': categoria,
      'activa': activa,
      'horarios': horarios?.map((h) => h.toJson()).toList(),
    };
  }
}
