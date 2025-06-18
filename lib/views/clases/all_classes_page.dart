import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';
import 'package:hola_mundo/services/clase_service.dart';

class AllClassesPage extends StatefulWidget {
  const AllClassesPage({super.key});

  @override
  State<AllClassesPage> createState() => _AllClassesPageState();
}

class _AllClassesPageState extends State<AllClassesPage> {
  final claseService = ClaseService();
  List<Clase> clases = [];
  bool isLoading = true;
  bool isAdmin = false;

  final List<Color> colores = [
    Colors.pinkAccent,
    Colors.blueAccent,
    Colors.deepPurpleAccent,
    Colors.orangeAccent,
    Colors.greenAccent,
    Colors.cyan,
    Colors.redAccent,
  ];

  @override
  void initState() {
    super.initState();
    cargarUsuarioYClases();
  }

  Future<void> cargarUsuarioYClases() async {
    final prefs = await SharedPreferences.getInstance();
    final role = prefs.getString('role');
    setState(() {
      isAdmin = role == 'ADMIN';
    });
    await cargarClases();
  }

  Future<void> cargarClases() async {
    try {
      final data = await claseService.getClases();
      setState(() {
        clases = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error cargando clases: $e');
      setState(() => isLoading = false);
    }
  }

  void mostrarFormularioClase({Clase? clase}) {
    final nombreController = TextEditingController(text: clase?.nombre ?? '');
    final descripcionController = TextEditingController(text: clase?.descripcion ?? '');
    final categoriaController = TextEditingController(text: clase?.categoria ?? '');

    List<TextEditingController> horarioControllers = (clase?.horarios ?? [])
        .map((h) => TextEditingController(text: h.hora ?? ''))
        .toList();

    if (horarioControllers.isEmpty) {
      horarioControllers.add(TextEditingController());
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(clase == null ? 'Nueva Clase' : 'Editar Clase'),
          content: StatefulBuilder(
            builder: (context, setStateDialog) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(controller: nombreController, decoration: const InputDecoration(labelText: 'Nombre')),
                  TextField(controller: descripcionController, decoration: const InputDecoration(labelText: 'Descripción')),
                  TextField(controller: categoriaController, decoration: const InputDecoration(labelText: 'Categoría')),
                  const SizedBox(height: 10),
                  const Text('Horarios:'),
                  ...horarioControllers.asMap().entries.map((entry) {
                    final index = entry.key;
                    final controller = entry.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(labelText: 'Hora ${index + 1}'),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            setStateDialog(() => horarioControllers.removeAt(index));
                          },
                        ),
                      ],
                    );
                  }).toList(),
                  TextButton.icon(
                    onPressed: () {
                      setStateDialog(() => horarioControllers.add(TextEditingController()));
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar horario'),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final horarios = horarioControllers
                    .where((c) => c.text.trim().isNotEmpty)
                    .map((c) => HorarioClase(hora: c.text.trim()))
                    .toList();

                final nuevaClase = Clase(
                  id: clase?.id,
                  nombre: nombreController.text.trim(),
                  descripcion: descripcionController.text.trim(),
                  categoria: categoriaController.text.trim(),
                  activa: true,
                  horarios: [],
                );

                try {
                  late final Clase claseCreada;

                  if (clase == null) {
                    claseCreada = await claseService.addClase(nuevaClase);
                  } else {
                    await claseService.updateClase(nuevaClase);
                    claseCreada = nuevaClase;
                  }

                  for (var horario in horarios) {
                    await claseService.agregarHorario(claseCreada.id!, horario);
                  }

                  await cargarClases();
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                  Navigator.pop(context);
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  Future<void> eliminarClase(int id) async {
    try {
      await claseService.deleteClase(id);
      await cargarClases();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
    }
  }

  void reservarClase(int claseId, String hora) {
    // Aquí puedes llamar a un método de ClaseService para manejar reservas
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reservaste la clase a las $hora')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Todas las clases',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              itemCount: clases.length,
              itemBuilder: (context, index) {
                final clase = clases[index];
                final color = colores[index % colores.length];
                final nombreClase = clase.nombre ?? 'Clase sin nombre';
                final horarios = clase.horarios ?? [];

                return Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: color.withOpacity(0.3), width: 1),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: color,
                              radius: 30,
                              child: const Icon(Icons.fitness_center, color: Colors.white),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: Text(
                                nombreClase,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            if (isAdmin) ...[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () => mostrarFormularioClase(clase: clase),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  final confirm = await showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text('Eliminar Clase'),
                                      content: const Text('¿Estás seguro de que deseas eliminar esta clase?'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancelar')),
                                        TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Eliminar')),
                                      ],
                                    ),
                                  );
                                  if (confirm == true) eliminarClase(clase.id!);
                                },
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 10),
                        if (horarios.isNotEmpty)
                          Wrap(
                            spacing: 8,
                            children: horarios.map((h) {
                              final hora = h.hora ?? 'Sin hora';
                              return ActionChip(
                                label: Text(hora),
                                onPressed: () {
                                  if (!isAdmin) {
                                    reservarClase(clase.id!, hora);
                                  }
                                },
                              );
                            }).toList(),
                          )
                        else
                          const Text('Sin horarios disponibles'),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () => mostrarFormularioClase(),
              backgroundColor: Colors.redAccent,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
