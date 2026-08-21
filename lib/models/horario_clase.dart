class HorarioClase {

  int? id;

  String? fecha;

  String? hora;

  int? cupos;

  int? cuposDisponibles;


  HorarioClase({

    this.id,

    this.fecha,

    this.hora,

    this.cupos,

    this.cuposDisponibles,

  });



  factory HorarioClase.fromJson(Map<String, dynamic> json) {

    return HorarioClase(

      id: json['id'],

      fecha: json['fecha'],

      hora: json['hora'],

      cupos: json['cupos'],

      cuposDisponibles: json['cuposDisponibles'],

    );

  }



  Map<String, dynamic> toJson() {

    return {

      "id": id,

      "fecha": fecha,

      "hora": hora,

      "cupos": cupos,

      "cuposDisponibles": cuposDisponibles,

    };

  }

}