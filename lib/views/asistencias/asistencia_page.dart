import 'package:flutter/material.dart';

import 'package:hola_mundo/models/asistencia.dart';
import 'package:hola_mundo/services/asistencia_service.dart';

class AsistenciaPage extends StatefulWidget {
  final int horarioId;

  const AsistenciaPage({
    super.key,
    required this.horarioId,
  });

  @override
  State<AsistenciaPage> createState() =>
      _AsistenciaPageState();
}

class _AsistenciaPageState
    extends State<AsistenciaPage> {

  final AsistenciaService service =
      AsistenciaService();

  List<Asistencia> asistencias = [];

  bool cargando = true;

  @override
  void initState() {
    super.initState();
    cargarAsistencias();
  }

  Future<void> cargarAsistencias() async {

    try {

      final data =
          await service.obtenerAsistenciasHorario(
        widget.horarioId,
      );

      if (!mounted) return;

      setState(() {

        asistencias = data;

        cargando = false;

      });

    } catch (e) {

      if (!mounted) return;

      setState(() {

        cargando = false;

      });

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(

          content: Text(
            e.toString(),
          ),

        ),

      );

    }

  }

  Future<void> cambiarEstado(
    int id,
    String estado,
  ) async {

    final confirmar =
        await showDialog<bool>(

      context: context,

      builder: (_) {

        return AlertDialog(

          shape: RoundedRectangleBorder(

            borderRadius:
                BorderRadius.circular(20),

          ),

          title: const Text(
            "Confirmar",
          ),

          content: Text(

            estado == "ASISTIO"

                ? "¿Marcar este estudiante como ASISTIÓ?"

                : "¿Marcar este estudiante como NO ASISTIÓ?",

          ),

          actions: [

            TextButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  false,
                );

              },

              child: const Text(
                "Cancelar",
              ),

            ),

            ElevatedButton(

              onPressed: () {

                Navigator.pop(
                  context,
                  true,
                );

              },

              child: const Text(
                "Aceptar",
              ),

            ),

          ],

        );

      },

    );

    if (confirmar != true) return;

    await service.actualizarEstado(
      id,
      estado,
    );

    await cargarAsistencias();

  }

  @override
  Widget build(BuildContext context) {

    final inscritos =
        asistencias.length;

    final asistieron =
        asistencias
            .where(
              (e) =>
                  e.estadoAsistencia ==
                  "ASISTIO",
            )
            .length;

    final faltaron =
        asistencias
            .where(
              (e) =>
                  e.estadoAsistencia ==
                  "NO_ASISTIO",
            )
            .length;

    return Scaffold(

      appBar: AppBar(

        title:
            const Text("Asistencias"),

        backgroundColor:
            Colors.red,

      ),
            body: cargando

          ? const Center(
              child: CircularProgressIndicator(),
            )

          : Column(

              children: [

                // ===========================
                // RESUMEN
                // ===========================

                Padding(

                  padding: const EdgeInsets.all(16),

                  child: Row(

                    children: [

                      Expanded(

                        child: _resumenCard(

                          "Inscritos",

                          inscritos.toString(),

                          Icons.people,

                          Colors.indigo,

                        ),

                      ),

                      const SizedBox(width: 10),

                      Expanded(

                        child: _resumenCard(

                          "Asistieron",

                          asistieron.toString(),

                          Icons.check_circle,

                          Colors.green,

                        ),

                      ),

                      const SizedBox(width: 10),

                      Expanded(

                        child: _resumenCard(

                          "Faltaron",

                          faltaron.toString(),

                          Icons.cancel,

                          Colors.red,

                        ),

                      ),

                    ],

                  ),

                ),

                Expanded(

                  child: asistencias.isEmpty

                      ? const Center(

                          child: Text(

                            "No hay inscritos.",

                            style: TextStyle(

                              fontSize: 18,

                            ),

                          ),

                        )

                      : ListView.builder(

                          padding: const EdgeInsets.symmetric(

                            horizontal: 16,

                          ),

                          itemCount: asistencias.length,

                          itemBuilder: (context, index) {

                            final a = asistencias[index];

                            return Card(

                              margin: const EdgeInsets.only(

                                bottom: 16,

                              ),

                              elevation: 3,

                              shape: RoundedRectangleBorder(

                                borderRadius:

                                    BorderRadius.circular(20),

                              ),

                              child: Padding(

                                padding:

                                    const EdgeInsets.all(18),

                                child: Column(

                                  crossAxisAlignment:

                                      CrossAxisAlignment.start,

                                  children: [

                                    Row(

                                      children: [

                                        CircleAvatar(

                                          backgroundColor:

                                              Colors.red.shade50,

                                          child: const Icon(

                                            Icons.person,

                                            color: Colors.red,

                                          ),

                                        ),

                                        const SizedBox(width: 12),

                                        Expanded(

                                          child: Text(

                                            a.nombreUsuario,

                                            style:

                                                const TextStyle(

                                              fontSize: 18,

                                              fontWeight:

                                                  FontWeight.bold,

                                            ),

                                          ),

                                        ),

                                        _estadoChip(a),

                                      ],

                                    ),

                                    const SizedBox(height: 18),

                                    Row(

                                      children: [

                                        const Icon(

                                          Icons.sports_gymnastics,

                                          size: 18,

                                          color: Colors.red,

                                        ),

                                        const SizedBox(width: 8),

                                        Text(a.nombreClase),

                                      ],

                                    ),

                                    const SizedBox(height: 8),

                                    Row(

                                      children: [

                                        const Icon(

                                          Icons.calendar_month,

                                          size: 18,

                                          color: Colors.red,

                                        ),

                                        const SizedBox(width: 8),

                                        Text(a.fecha),

                                      ],

                                    ),

                                    const SizedBox(height: 8),

                                    Row(

                                      children: [

                                        const Icon(

                                          Icons.schedule,

                                          size: 18,

                                          color: Colors.red,

                                        ),

                                        const SizedBox(width: 8),

                                        Text(a.hora),

                                      ],

                                    ),

                                    const SizedBox(height: 18),
                                                                        if (a.estadoReserva ==
                                        "CANCELADA")

                                      Container(

                                        width: double.infinity,

                                        padding:
                                            const EdgeInsets.all(14),

                                        decoration: BoxDecoration(

                                          color:
                                              Colors.grey.shade200,

                                          borderRadius:
                                              BorderRadius.circular(14),

                                        ),

                                        child: const Row(

                                          children: [

                                            Icon(

                                              Icons.cancel,

                                              color: Colors.grey,

                                            ),

                                            SizedBox(width: 10),

                                            Text(

                                              "Reserva cancelada",

                                              style: TextStyle(

                                                fontWeight:
                                                    FontWeight.bold,

                                                color: Colors.grey,

                                              ),

                                            ),

                                          ],

                                        ),

                                      )

                                    else

                                      Row(

                                        children: [

                                          Expanded(

                                            child:
                                                ElevatedButton.icon(

                                              onPressed: () {

                                                cambiarEstado(

                                                  a.id,

                                                  "ASISTIO",

                                                );

                                              },

                                              style:
                                                  ElevatedButton.styleFrom(

                                                backgroundColor:

                                                    Colors.green,

                                                foregroundColor:

                                                    Colors.white,

                                                padding:
                                                    const EdgeInsets.symmetric(

                                                  vertical: 14,

                                                ),

                                                shape:
                                                    RoundedRectangleBorder(

                                                  borderRadius:
                                                      BorderRadius.circular(14),

                                                ),

                                              ),

                                              icon: const Icon(

                                                Icons.check,

                                              ),

                                              label: const Text(

                                                "ASISTIÓ",

                                              ),

                                            ),

                                          ),

                                          const SizedBox(width: 12),

                                          Expanded(

                                            child:
                                                ElevatedButton.icon(

                                              onPressed: () {

                                                cambiarEstado(

                                                  a.id,

                                                  "NO_ASISTIO",

                                                );

                                              },

                                              style:
                                                  ElevatedButton.styleFrom(

                                                backgroundColor:

                                                    Colors.red,

                                                foregroundColor:

                                                    Colors.white,

                                                padding:
                                                    const EdgeInsets.symmetric(

                                                  vertical: 14,

                                                ),

                                                shape:
                                                    RoundedRectangleBorder(

                                                  borderRadius:
                                                      BorderRadius.circular(14),

                                                ),

                                              ),

                                              icon: const Icon(

                                                Icons.close,

                                              ),

                                              label: const Text(

                                                "NO ASISTIÓ",

                                              ),

                                            ),

                                          ),

                                        ],

                                      ),

                                  ],

                                ),

                              ),

                            );

                          },

                        ),

                ),

              ],

            ),

    );

  }
    // ===========================================
  // CHIP DEL ESTADO
  // ===========================================

  Widget _estadoChip(Asistencia a) {

    Color color;
    IconData icono;
    String texto;

    if (a.estadoReserva == "CANCELADA") {

      color = Colors.grey;
      icono = Icons.cancel;
      texto = "CANCELADA";

    } else {

      switch (a.estadoAsistencia) {

        case "ASISTIO":

          color = Colors.green;
          icono = Icons.check_circle;
          texto = "ASISTIÓ";
          break;

        case "NO_ASISTIO":

          color = Colors.red;
          icono = Icons.cancel;
          texto = "NO ASISTIÓ";
          break;

        default:

          color = Colors.orange;
          icono = Icons.schedule;
          texto = "PENDIENTE";

      }

    }

    return Container(

      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),

      decoration: BoxDecoration(

        color: color.withOpacity(.15),

        borderRadius: BorderRadius.circular(30),

      ),

      child: Row(

        mainAxisSize: MainAxisSize.min,

        children: [

          Icon(
            icono,
            color: color,
            size: 18,
          ),

          const SizedBox(width: 6),

          Text(

            texto,

            style: TextStyle(

              color: color,

              fontWeight: FontWeight.bold,

            ),

          ),

        ],

      ),

    );

  }

  // ===========================================
  // TARJETA RESUMEN
  // ===========================================

  Widget _resumenCard(

    String titulo,

    String cantidad,

    IconData icono,

    Color color,

  ) {

    return Container(

      padding: const EdgeInsets.symmetric(
        vertical: 18,
      ),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius: BorderRadius.circular(18),

        boxShadow: [

          BoxShadow(

            color: Colors.black.withOpacity(.06),

            blurRadius: 10,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        children: [

          Icon(
            icono,
            color: color,
            size: 30,
          ),

          const SizedBox(height: 8),

          Text(

            cantidad,

            style: TextStyle(

              fontSize: 26,

              fontWeight: FontWeight.bold,

              color: color,

            ),

          ),

          const SizedBox(height: 4),

          Text(

            titulo,

            style: const TextStyle(

              fontWeight: FontWeight.w600,

            ),

          ),

        ],

      ),

    );

  }

}