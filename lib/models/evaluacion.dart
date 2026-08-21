class Evaluacion {
  final int? id;
  final int userId;

  final int edad;
  final double estatura;
  final double peso;

  final int experienciaPole;
  final int experienciaDeportiva;

  final int flexibilidad;
  final int fuerza;

  final bool lesiones;
  final String descripcionLesion;

  final String objetivo;
  final String observaciones;

  final String fechaEvaluacion;

  Evaluacion({
    this.id,
    required this.userId,
    required this.edad,
    required this.estatura,
    required this.peso,
    required this.experienciaPole,
    required this.experienciaDeportiva,
    required this.flexibilidad,
    required this.fuerza,
    required this.lesiones,
    required this.descripcionLesion,
    required this.objetivo,
    required this.observaciones,
    required this.fechaEvaluacion,
  });

  factory Evaluacion.fromJson(Map<String, dynamic> json) {
    return Evaluacion(
      id: json['id'],
      userId: json['user_id'] ?? json['userId'],
      edad: json['edad'],
      estatura: (json['estatura'] as num).toDouble(),
      peso: (json['peso'] as num).toDouble(),
      experienciaPole: json['experiencia_pole'] ?? json['experienciaPole'],
      experienciaDeportiva:
          json['experiencia_deportiva'] ?? json['experienciaDeportiva'],
      flexibilidad: json['flexibilidad'],
      fuerza: json['fuerza'],
      lesiones: json['lesiones'],
      descripcionLesion:
          json['descripcion_lesion'] ?? json['descripcionLesion'] ?? '',
      objetivo: json['objetivo'] ?? '',
      observaciones: json['observaciones'] ?? '',
      fechaEvaluacion:
          json['fecha_evaluacion'] ?? json['fechaEvaluacion'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "userId": userId,
      "edad": edad,
      "estatura": estatura,
      "peso": peso,
      "experienciaPole": experienciaPole,
      "experienciaDeportiva": experienciaDeportiva,
      "flexibilidad": flexibilidad,
      "fuerza": fuerza,
      "lesiones": lesiones,
      "descripcionLesion": descripcionLesion,
      "objetivo": objetivo,
      "observaciones": observaciones,
      "fechaEvaluacion": fechaEvaluacion,
    };
  }
}