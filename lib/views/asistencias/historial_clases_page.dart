import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';
import 'package:hola_mundo/services/clase_service.dart';
import 'package:hola_mundo/views/asistencias/asistencia_page.dart';


class HistorialClasesPage extends StatefulWidget {
  const HistorialClasesPage({super.key});

  @override
  State<HistorialClasesPage> createState() =>
      _HistorialClasesPageState();
}

class _HistorialClasesPageState
    extends State<HistorialClasesPage> {

  final ClaseService claseService = ClaseService();

  final TextEditingController buscadorController =
      TextEditingController();

  List<Clase> clases = [];

  bool cargando = true;

  DateTime? fechaFiltro;

  String busqueda = "";

  @override
  void initState() {
    super.initState();
    cargarClases();
  }

  Future<void> cargarClases() async {

    final data = await claseService.getClases();

    if (!mounted) return;

    setState(() {

      clases = data;

      cargando = false;

    });

  }

  Future<void> seleccionarFecha() async {

    final fecha = await showDatePicker(

      context: context,

      initialDate:
          fechaFiltro ?? DateTime.now(),

      firstDate: DateTime(2025),

      lastDate: DateTime(2035),

    );

    if (fecha != null) {

      setState(() {

        fechaFiltro = fecha;

      });

    }

  }

  bool pasaFiltro(
      Clase clase,
      HorarioClase horario,
      ) {

    final texto =
        busqueda.trim().toLowerCase();

    final coincideTexto =

        texto.isEmpty ||

        (clase.nombre ?? "")
            .toLowerCase()
            .contains(texto) ||

        (clase.categoria ?? "")
            .toLowerCase()
            .contains(texto) ||

        (horario.fecha ?? "")
            .toLowerCase()
            .contains(texto) ||

        (horario.hora ?? "")
            .toLowerCase()
            .contains(texto);

    if (!coincideTexto) {

      return false;

    }

    if (fechaFiltro == null) {

      return true;

    }

    final fecha =
        DateFormat("yyyy-MM-dd")
            .format(fechaFiltro!);

    return horario.fecha == fecha;

  }

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> horarios = [];

    for (final clase in clases) {

      for (final horario
          in (clase.horarios ?? [])) {

        if (pasaFiltro(
          clase,
          horario,
        )) {

          horarios.add({

            "clase": clase,

            "horario": horario,

          });

        }

      }

    }

    horarios.sort((a, b) {

      final HorarioClase h1 =
          a["horario"];

      final HorarioClase h2 =
          b["horario"];

      return (h2.fecha ?? "")
          .compareTo(h1.fecha ?? "");

    });

    return Scaffold(

     appBar: AppBar(

  leading: IconButton(

  icon: const Icon(Icons.arrow_back),

  onPressed: () {

    Navigator.pop(context);

  },

),

  title: const Text(
    "Historial de clases",
  ),

  backgroundColor: Colors.red,

),

      body: cargando

          ? const Center(

        child:
        CircularProgressIndicator(),

      )

          : RefreshIndicator(

        onRefresh:
        cargarClases,

        child:
        ListView(

          padding:
          const EdgeInsets.all(18),

          children: [

            TextField(

              controller:
              buscadorController,

              decoration:

              InputDecoration(

                hintText:
                "Buscar por clase, categoría, fecha o hora",

                prefixIcon:
                const Icon(
                  Icons.search,
                ),

                suffixIcon:

                fechaFiltro == null

                    ? IconButton(

                  icon:
                  const Icon(
                    Icons.calendar_month,
                  ),

                  onPressed:
                  seleccionarFecha,

                )

                    : IconButton(

                  icon:
                  const Icon(
                    Icons.clear,
                  ),

                  onPressed: () {

                    setState(() {

                      fechaFiltro =
                      null;

                    });

                  },

                ),

                border:

                OutlineInputBorder(

                  borderRadius:
                  BorderRadius.circular(
                    18,
                  ),

                ),

              ),

              onChanged: (value) {

                setState(() {

                  busqueda =
                      value;

                });

              },

            ),

            const SizedBox(height: 20),
                        if (horarios.isEmpty)

              Container(

                margin: const EdgeInsets.only(top: 40),

                padding: const EdgeInsets.all(30),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius: BorderRadius.circular(24),

                  boxShadow: [

                    BoxShadow(

                      color: Colors.black.withOpacity(.05),

                      blurRadius: 12,

                    )

                  ],

                ),

                child: Column(

                  children: [

                    Icon(

                      Icons.event_busy,

                      color: Colors.grey.shade400,

                      size: 70,

                    ),

                    const SizedBox(height: 15),

                    const Text(

                      "No se encontraron clases.",

                      style: TextStyle(

                        fontSize: 18,

                        fontWeight: FontWeight.bold,

                      ),

                    ),

                    const SizedBox(height: 8),

                    const Text(

                      "Prueba buscando por otra fecha o por el nombre de la clase.",

                      textAlign: TextAlign.center,

                    ),

                  ],

                ),

              )

            else

              ...horarios.map((item) {

                final Clase clase = item["clase"];

                final HorarioClase h = item["horario"];

                final inscritos =
                    (h.cupos ?? 0) -
                    (h.cuposDisponibles ?? 0);

                final porcentaje =
                    (h.cupos == null || h.cupos == 0)
                        ? 0.0
                        : inscritos / h.cupos!;

                return Container(

                  margin:
                      const EdgeInsets.only(bottom: 18),

                  decoration: BoxDecoration(

                    color: Colors.white,

                    borderRadius:
                        BorderRadius.circular(24),

                    boxShadow: [

                      BoxShadow(

                        color:
                            Colors.black.withOpacity(.06),

                        blurRadius: 12,

                        offset: const Offset(0, 4),

                      ),

                    ],

                  ),

                  child: Padding(

                    padding:
                        const EdgeInsets.all(20),

                    child: Column(

                      crossAxisAlignment:
                          CrossAxisAlignment.start,

                      children: [

                        Row(

                          children: [

                            Container(

                              padding:
                                  const EdgeInsets.all(12),

                              decoration:
                                  BoxDecoration(

                                color:
                                    Colors.red.shade50,

                                borderRadius:
                                    BorderRadius.circular(16),

                              ),

                              child: const Icon(

                                Icons.sports_gymnastics,

                                color: Colors.red,

                                size: 30,

                              ),

                            ),

                            const SizedBox(width: 15),

                            Expanded(

                              child: Column(

                                crossAxisAlignment:
                                    CrossAxisAlignment.start,

                                children: [

                                  Text(

                                    clase.nombre ?? "",

                                    style:
                                        const TextStyle(

                                      fontSize: 20,

                                      fontWeight:
                                          FontWeight.bold,

                                    ),

                                  ),

                                  const SizedBox(height: 4),

                                  Text(

                                    clase.categoria ?? "",

                                    style: TextStyle(

                                      color:
                                          Colors.grey.shade700,

                                    ),

                                  ),

                                ],

                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 20),

                        Row(

                          children: [

                            const Icon(

                              Icons.calendar_month,

                              size: 18,

                              color: Colors.red,

                            ),

                            const SizedBox(width: 8),

                            Text(h.fecha ?? ""),

                          ],

                        ),

                        const SizedBox(height: 10),

                        Row(

                          children: [

                            const Icon(

                              Icons.schedule,

                              size: 18,

                              color: Colors.red,

                            ),

                            const SizedBox(width: 8),

                            Text(h.hora ?? ""),

                          ],

                        ),

                        const SizedBox(height: 16),

                        Row(

                          children: [

                            const Icon(

                              Icons.people,

                              color: Colors.indigo,

                            ),

                            const SizedBox(width: 10),

                            Expanded(

                              child: ClipRRect(

                                borderRadius:
                                    BorderRadius.circular(20),

                                child:
                                    LinearProgressIndicator(

                                  value: porcentaje,

                                  minHeight: 10,

                                  backgroundColor:
                                      Colors.grey.shade300,

                                  color: Colors.red,

                                ),

                              ),

                            ),

                            const SizedBox(width: 12),

                            Text(

                              "$inscritos/${h.cupos ?? 0}",

                              style:
                                  const TextStyle(

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                          ],

                        ),

                        const SizedBox(height: 20),
                                                SizedBox(

                          width: double.infinity,

                          child: ElevatedButton.icon(

                            style: ElevatedButton.styleFrom(

                              backgroundColor:
                                  Colors.indigo,

                              foregroundColor:
                                  Colors.white,

                              padding:
                                  const EdgeInsets.symmetric(
                                vertical: 14,
                              ),

                              elevation: 0,

                              shape:
                                  RoundedRectangleBorder(

                                borderRadius:
                                    BorderRadius.circular(16),

                              ),

                            ),

                            onPressed: h.id == null
                                ? null
                                : () async {

                                    await Navigator.push(

                                      context,

                                      MaterialPageRoute(

                                        builder: (_) =>
                                            AsistenciaPage(

                                          horarioId: h.id!,

                                        ),

                                      ),

                                    );

                                    // Al volver de asistencia,
                                    // actualizamos la información.
                                    await cargarClases();

                                  },

                            icon: const Icon(
                              Icons.fact_check_rounded,
                            ),

                            label: const Text(

                              "Administrar asistencia",

                              style: TextStyle(

                                fontSize: 15,

                                fontWeight:
                                    FontWeight.bold,

                              ),

                            ),

                          ),

                        ),

                      ],

                    ),

                  ),

                );

              }),

          ],

        ),

      ),

    );

  }


  @override
  void dispose() {

    buscadorController.dispose();

    super.dispose();

  }

}