import 'package:flutter/material.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:hola_mundo/services/evaluacion_service.dart';

class EvaluacionView extends StatefulWidget {
  final User usuario;

  const EvaluacionView({
    super.key,
    required this.usuario,
  });

  @override
  State<EvaluacionView> createState() => _EvaluacionViewState();
}

class _EvaluacionViewState extends State<EvaluacionView> {
  final EvaluacionService evaluacionService = EvaluacionService();

  // Controllers
  final edadController = TextEditingController();
  final estaturaController = TextEditingController();
  final pesoController = TextEditingController();

  final descripcionLesionController = TextEditingController();
  final objetivoController = TextEditingController();
  final observacionesController = TextEditingController();

  // Valores evaluación
  int experienciaPole = 0;
  int experienciaDeportiva = 0;
  int flexibilidad = 0;
  int fuerza = 0;

  bool tieneLesiones = false;

  int? evaluacionId;

  bool cargando = true;
  bool modoEdicion = false;

  @override
  void initState() {
    super.initState();
    cargarEvaluacion();
  }

  Future<void> cargarEvaluacion() async {
    final evaluacion = await evaluacionService.obtenerEvaluacionUsuario(
      widget.usuario.id,
    );

    if (evaluacion != null) {
      evaluacionId = evaluacion["id"];

      edadController.text = evaluacion["edad"].toString();

      estaturaController.text =
          evaluacion["estatura"].toString();

      pesoController.text =
          evaluacion["peso"].toString();

      experienciaPole =
          evaluacion["experienciaPole"] ?? 0;

      experienciaDeportiva =
          evaluacion["experienciaDeportiva"] ?? 0;

      flexibilidad =
          evaluacion["flexibilidad"] ?? 0;

      fuerza =
          evaluacion["fuerza"] ?? 0;

      tieneLesiones =
          evaluacion["lesiones"] ?? false;

      descripcionLesionController.text =
          evaluacion["descripcionLesion"] ?? "";

      objetivoController.text =
          evaluacion["objetivo"] ?? "";

      observacionesController.text =
          evaluacion["observaciones"] ?? "";

      modoEdicion = true;
    }

    setState(() {
      cargando = false;
    });
  }

  @override
  void dispose() {
    edadController.dispose();
    estaturaController.dispose();
    pesoController.dispose();

    descripcionLesionController.dispose();
    objetivoController.dispose();
    observacionesController.dispose();

    super.dispose();
  }

  Future<void> guardarEvaluacion() async {
    if (edadController.text.isEmpty ||
        estaturaController.text.isEmpty ||
        pesoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Completa los datos básicos',
          ),
        ),
      );

      return;
    }

    final evaluacion = {
      "user": {
        "id": widget.usuario.id,
      },
      "edad": int.parse(
        edadController.text,
      ),
      "estatura": double.parse(
        estaturaController.text,
      ),
      "peso": double.parse(
        pesoController.text,
      ),
      "experienciaPole": experienciaPole,
      "experienciaDeportiva": experienciaDeportiva,
      "flexibilidad": flexibilidad,
      "fuerza": fuerza,
      "lesiones": tieneLesiones,
      "descripcionLesion":
          descripcionLesionController.text,
      "objetivo": objetivoController.text,
      "observaciones":
          observacionesController.text,
      "fechaEvaluacion": DateTime.now()
          .toIso8601String()
          .substring(0, 10),
    };

    bool resultado = false;

    if (modoEdicion) {
      resultado =
          await evaluacionService.actualizarEvaluacion(
        evaluacionId!,
        evaluacion,
      );
    } else {
      resultado =
          await evaluacionService.guardarEvaluacion(
        evaluacion,
      );
    }

    if (resultado) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            modoEdicion
                ? 'Evaluación actualizada correctamente'
                : 'Evaluación guardada correctamente',
          ),
        ),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            modoEdicion
                ? 'Error al actualizar evaluación'
                : 'Error al guardar evaluación',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),

      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.red.shade700,
        foregroundColor: Colors.white,
        title: Text(
          modoEdicion
              ? 'Actualizar evaluación'
              : 'Evaluación inicial',
        ),
      ),

      body: cargando
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(18),
              child: Column(
                children: [

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        children: [

                          CircleAvatar(
                            radius: 34,
                            backgroundColor:
                                Colors.red.shade100,
                            child: Icon(
                              Icons.person,
                              size: 38,
                              color:
                                  Colors.red.shade700,
                            ),
                          ),

                          const SizedBox(height: 15),

                          Text(
                            widget.usuario.name,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            widget.usuario.email,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            widget.usuario.phonenumber,
                            style: TextStyle(
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                                    Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Información física",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.red.shade700,
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller:
                                edadController,
                            keyboardType:
                                TextInputType.number,
                            decoration:
                                InputDecoration(
                              labelText: "Edad",
                              prefixIcon:
                                  const Icon(
                                      Icons.cake),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                estaturaController,
                            keyboardType:
                                const TextInputType
                                    .numberWithOptions(
                                        decimal:
                                            true),
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Estatura (m)",
                              prefixIcon:
                                  const Icon(
                                      Icons.height),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                pesoController,
                            keyboardType:
                                const TextInputType
                                    .numberWithOptions(
                                        decimal:
                                            true),
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Peso (kg)",
                              prefixIcon:
                                  const Icon(
                                      Icons.monitor_weight),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Experiencia",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.red.shade700,
                            ),
                          ),

                          const SizedBox(height: 20),

                          DropdownButtonFormField<int>(
                            value:
                                experienciaPole,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Experiencia en Pole",
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                            items: const [

                              DropdownMenuItem(
                                value: 0,
                                child: Text(
                                    "Sin experiencia"),
                              ),

                              DropdownMenuItem(
                                value: 1,
                                child: Text(
                                    "Básica"),
                              ),

                              DropdownMenuItem(
                                value: 2,
                                child: Text(
                                    "Intermedia"),
                              ),

                              DropdownMenuItem(
                                value: 3,
                                child: Text(
                                    "Avanzada"),
                              ),
                            ],
                            onChanged: (value) {

                              setState(() {

                                experienciaPole =
                                    value ?? 0;

                              });

                            },
                          ),

                          const SizedBox(height: 18),

                          DropdownButtonFormField<int>(
                            value:
                                experienciaDeportiva,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Experiencia deportiva",
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                            items: const [

                              DropdownMenuItem(
                                value: 0,
                                child:
                                    Text("No"),
                              ),

                              DropdownMenuItem(
                                value: 1,
                                child:
                                    Text("Sí"),
                              ),

                            ],
                            onChanged: (value) {

                              setState(() {

                                experienciaDeportiva =
                                    value ?? 0;

                              });

                            },
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),
                                    Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Estado de salud",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.red.shade700,
                            ),
                          ),

                          const SizedBox(height: 15),

                          SwitchListTile(
                            contentPadding:
                                EdgeInsets.zero,
                            title: const Text(
                              "¿Presenta lesiones?",
                            ),
                            subtitle: const Text(
                              "Indique si el estudiante tiene alguna lesión o condición física.",
                            ),
                            activeColor:
                                Colors.red.shade700,
                            value: tieneLesiones,
                            onChanged: (value) {
                              setState(() {
                                tieneLesiones =
                                    value;
                              });
                            },
                          ),

                          if (tieneLesiones) ...[

                            const SizedBox(height: 15),

                            TextField(
                              controller:
                                  descripcionLesionController,
                              maxLines: 3,
                              decoration:
                                  InputDecoration(
                                labelText:
                                    "Descripción de la lesión",
                                alignLabelWithHint:
                                    true,
                                prefixIcon:
                                    const Icon(
                                  Icons.healing,
                                ),
                                border:
                                    OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.circular(
                                          14),
                                ),
                              ),
                            ),

                          ],
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(18),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [

                          Text(
                            "Objetivos",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.bold,
                              color:
                                  Colors.red.shade700,
                            ),
                          ),

                          const SizedBox(height: 18),

                          TextField(
                            controller:
                                objetivoController,
                            maxLines: 3,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Objetivo del estudiante",
                              alignLabelWithHint:
                                  true,
                              prefixIcon:
                                  const Icon(
                                      Icons.flag),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          TextField(
                            controller:
                                observacionesController,
                            maxLines: 5,
                            decoration:
                                InputDecoration(
                              labelText:
                                  "Observaciones",
                              alignLabelWithHint:
                                  true,
                              prefixIcon:
                                  const Icon(
                                      Icons.notes),
                              border:
                                  OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.circular(
                                        14),
                              ),
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      icon: Icon(
                        modoEdicion
                            ? Icons.edit
                            : Icons.save,
                      ),
                      label: Text(
                        modoEdicion
                            ? "Actualizar evaluación"
                            : "Guardar evaluación",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            Colors.red.shade700,
                        foregroundColor:
                            Colors.white,
                        elevation: 3,
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(
                                  14),
                        ),
                      ),
                      onPressed:
                          guardarEvaluacion,
                    ),
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
    );
  }
}