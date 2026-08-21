class PlanCatalogo {
  final int id;
  final String categoria;
  final String nombre;
  final int? cantidadClases;
  final double valor;
  final int? duracion;
  final bool activo;

  const PlanCatalogo({
    required this.id,
    required this.categoria,
    required this.nombre,
    this.cantidadClases,
    required this.valor,
    this.duracion,
    required this.activo,
  });

  factory PlanCatalogo.fromJson(Map<String, dynamic> json) {
    return PlanCatalogo(
      id: json["id"] ?? 0,

      categoria:
          json["categoria"] ?? "",

      nombre:
          json["nombre"] ?? "",

      cantidadClases:
          json["cantidadClases"],

      valor:
          (json["valor"] ?? 0).toDouble(),

      duracion:
          json["duracion"],

      activo:
          json["activo"] ?? true,
    );
  }


  Map<String, dynamic> toJson() {
    return {

      "id": id,

      "categoria": categoria,

      "nombre": nombre,

      "cantidadClases":
          cantidadClases,

      "valor":
          valor,

      "duracion":
          duracion,

      "activo":
          activo,

    };
  }
}