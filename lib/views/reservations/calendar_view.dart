import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hola_mundo/models/clase.dart';
import 'package:hola_mundo/models/horario_clase.dart';
import 'package:hola_mundo/services/clase_service.dart';

class CalendarView extends StatefulWidget {
  const CalendarView({super.key});

  @override
  State<CalendarView> createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  final ClaseService _claseService = ClaseService();
  late Future<List<Clase>> _clasesFuture;
  List<Clase> _todasLasClases = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Clase>> _clasesPorDia = {};

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('es_ES', null);
    _selectedDay = _focusedDay;
    _cargarClases();
  }

  Future<void> _cargarClases() async {
    _clasesFuture = _claseService.getClases();
    final clases = await _clasesFuture;
    _organizarClasesPorDia(clases);
    setState(() {
      _todasLasClases = clases;
    });
  }

  void _organizarClasesPorDia(List<Clase> clases) {
    final tempMap = <DateTime, List<Clase>>{};

    for (var clase in clases) {
      if (clase.horarios != null) {
        for (var horario in clase.horarios!) {
          if (horario.fecha != null) {
            final fecha = DateFormat('yyyy-MM-dd').parse(horario.fecha!);
            final dateOnly = DateTime(fecha.year, fecha.month, fecha.day);
            tempMap.update(
              dateOnly,
              (existing) => [...existing, clase],
              ifAbsent: () => [clase],
            );
          }
        }
      }
    }

    setState(() {
      _clasesPorDia = tempMap;
    });
  }

  List<Clase> _getClasesDelDia(DateTime? day) {
    if (day == null) return [];
    final dateOnly = DateTime(day.year, day.month, day.day);
    final clases = _clasesPorDia[dateOnly] ?? [];

    // Eliminar duplicados por ID
    final vistos = <int>{};
    return clases.where((c) => vistos.add(c.id ?? -1)).toList();
  }

  Future<void> _mostrarDialogoReserva(Clase clase, String hora) async {
  return showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text('Confirmar Reserva'),
      content: Text('¿Reservar ${clase.nombre} a las $hora?'),
      actions: [
        TextButton(
          child: const Text('Cancelar'),
          onPressed: () => Navigator.of(context).maybePop(), // ← Corrección
        ),
        TextButton(
          child: const Text('Confirmar'),
          onPressed: () async {
            Navigator.of(context).maybePop(); // ← Corrección

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Reserva confirmada para ${clase.nombre} a las $hora'),
              ),
            );

            await _cargarClases(); // Refresca la vista
          },
        ),
      ],
    ),
  );
}


  void _mostrarFormularioDeReserva(DateTime selectedDate) {
    final clasesDelDia = _getClasesDelDia(selectedDate);

    if (clasesDelDia.isEmpty) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Sin clases disponibles'),
          content: const Text('No hay clases programadas para este día.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    Clase? claseSeleccionada;
    String? horaSeleccionada;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            final clasesUnicas = {
              for (var c in clasesDelDia) c.id!: c
            }.values.toList(); // Únicas por ID

            return AlertDialog(
              title: const Text('Reservar clase'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButton<Clase>(
                    value: claseSeleccionada,
                    isExpanded: true,
                    hint: const Text('Selecciona una clase'),
                    items: clasesUnicas.map((clase) {
                      return DropdownMenuItem<Clase>(
                        value: clase,
                        child: Text(clase.nombre),
                      );
                    }).toList(),
                    onChanged: (nuevaClase) {
                      setStateDialog(() {
                        claseSeleccionada = nuevaClase;
                        horaSeleccionada = null;
                      });
                    },
                  ),
                  if (claseSeleccionada != null)
                    DropdownButton<String>(
                      value: horaSeleccionada,
                      isExpanded: true,
                      hint: const Text('Selecciona un horario'),
                      items: claseSeleccionada!.horarios!
                          .where((h) =>
                              h.fecha ==
                              DateFormat('yyyy-MM-dd')
                                  .format(selectedDate))
                          .map((horario) {
                        return DropdownMenuItem<String>(
                          value: horario.hora,
                          child: Text(horario.hora),
                        );
                      }).toList(),
                      onChanged: (nuevaHora) {
                        setStateDialog(() {
                          horaSeleccionada = nuevaHora;
                        });
                      },
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: (claseSeleccionada != null &&
                          horaSeleccionada != null)
                      ? () async {
                          Navigator.of(context).pop();
                          await _mostrarDialogoReserva(
                            claseSeleccionada!,
                            horaSeleccionada!,
                          );
                        }
                      : null,
                  child: const Text('Reservar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddReservationDialog(DateTime selectedDate) {
  final clasesDelDia = _getClasesDelDia(selectedDate).toSet().toList(); // ← Evita duplicados

  if (clasesDelDia.isEmpty) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Sin clases disponibles'),
        content: const Text('No hay clases programadas para este día.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).maybePop(), // ← Seguro
            child: const Text('OK'),
          ),
        ],
      ),
    );
    return;
  }

  showDialog(
    context: context,
    builder: (context) {
      Clase? claseSeleccionada;
      String? horaSeleccionada;

      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Reservar clase'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButton<Clase>(
                  value: claseSeleccionada,
                  hint: const Text('Selecciona una clase'),
                  isExpanded: true,
                  items: clasesDelDia.map((clase) {
                    return DropdownMenuItem<Clase>(
                      value: clase,
                      child: Text(clase.nombre),
                    );
                  }).toList(),
                  onChanged: (nuevaClase) {
                    setState(() {
                      claseSeleccionada = nuevaClase;
                      horaSeleccionada = null;
                    });
                  },
                ),
                if (claseSeleccionada != null)
                  DropdownButton<String>(
                    value: horaSeleccionada,
                    hint: const Text('Selecciona horario'),
                    isExpanded: true,
                    items: claseSeleccionada!.horarios!
                        .where((h) =>
                            h.fecha ==
                            DateFormat('yyyy-MM-dd').format(selectedDate))
                        .map((horario) => DropdownMenuItem<String>(
                              value: horario.hora,
                              child: Text(horario.hora),
                            ))
                        .toList(),
                    onChanged: (nuevaHora) {
                      setState(() {
                        horaSeleccionada = nuevaHora;
                      });
                    },
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).maybePop(), // ← Aquí también
                child: const Text('Cancelar'),
              ),
              ElevatedButton(
                onPressed: claseSeleccionada != null && horaSeleccionada != null
                    ? () async {
                        Navigator.of(context).maybePop(); // ← Aquí también

                        await _mostrarDialogoReserva(
                          claseSeleccionada!,
                          horaSeleccionada!,
                        );

                        final nuevasClases = await _claseService.getClases();
                        _organizarClasesPorDia(nuevasClases);
                      }
                    : null,
                child: const Text('Reservar'),
              ),
            ],
          );
        },
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendario de Reservas')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime.now().add(const Duration(days: 365)),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
              _mostrarFormularioDeReserva(selectedDay);
            },
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => _getClasesDelDia(day).isNotEmpty ? [day] : [],
          ),
          const SizedBox(height: 12),
          if (_selectedDay != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clases para el ${DateFormat('EEEE d MMMM', 'es_ES').format(_selectedDay!)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Clase>>(
              future: _clasesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Error al cargar clases'));
                }

                final clasesDelDia = _getClasesDelDia(_selectedDay);
                if (clasesDelDia.isEmpty) {
                  return const Center(child: Text('No hay clases este día'));
                }

                return ListView.builder(
                  itemCount: clasesDelDia.length,
                  itemBuilder: (context, index) {
                    final clase = clasesDelDia[index];
                    final horarios = clase.horarios!
                        .where((h) =>
                            h.fecha ==
                            DateFormat('yyyy-MM-dd')
                                .format(_selectedDay!))
                        .toList();

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clase.nombre,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            const SizedBox(height: 4),
                            Text(clase.descripcion),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: horarios.map((h) {
                                return ActionChip(
                                  label: Text(h.hora),
                                  onPressed: () => _mostrarDialogoReserva(
                                    clase,
                                    h.hora,
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
