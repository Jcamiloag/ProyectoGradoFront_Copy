import 'package:flutter/material.dart';
import 'package:hola_mundo/views/mis_reservas_view.dart';
import 'package:hola_mundo/services/reserva_service.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:hola_mundo/models/clase.dart';
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
  final Set<String> _reservasConfirmadas = {}; // "claseId-fecha-hora"

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
          final fecha = DateFormat('yyyy-MM-dd').parse(horario.fecha);
          final dateOnly = DateTime(fecha.year, fecha.month, fecha.day);
          tempMap.update(
            dateOnly,
            (existing) => [...existing, clase],
            ifAbsent: () => [clase],
          );
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

    final vistos = <int>{};
    return clases.where((c) => vistos.add(c.id ?? -1)).toList();
  }

  Future<void> _mostrarDialogoReserva(
    Clase clase,
    int horarioId,
    String hora,
  ) async {
    final fecha = DateFormat('yyyy-MM-dd').format(_selectedDay!);
    final reservaService = ReservaService();

    return showDialog<void>(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Confirmar Reserva'),
            content: Text('¿Reservar ${clase.nombre} a las $hora?'),
            actions: [
              TextButton(
                child: const Text('Cancelar'),
                onPressed: () async {
                  Navigator.of(context).maybePop();

                  // Feedback de cancelación
                  showDialog(
                    context: context,
                    builder:
                        (_) => AlertDialog(
                          title: const Text("❌ Reserva cancelada"),
                          content: Text(
                            "No reservaste ${clase.nombre} a las $hora.",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              child: const Text("Entendido"),
                            ),
                          ],
                        ),
                  );
                },
              ),
              TextButton(
                child: const Text('Confirmar'),
                onPressed: () async {
                  Navigator.of(context).maybePop();

                  final confirmada = await reservaService.hacerReserva(
                    claseId: clase.id!,
                    horarioId: horarioId, // 👈 Enviamos también el horarioId
                    fecha: fecha,
                    hora: hora,
                  );

                  if (confirmada) {
                    setState(() {
                      _reservasConfirmadas.add("${clase.id}-$fecha-$hora");
                    });

                    // Modal de éxito visible
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder:
                          (_) => AlertDialog(
                            title: const Text("✅ Reserva confirmada"),
                            content: Text(
                              "Has reservado ${clase.nombre} el $fecha a las $hora.",
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  if (Navigator.of(context).canPop()) {
                                    Navigator.of(
                                      context,
                                    ).pop(); // 🔹 Cierra solo el diálogo
                                  }
                                },
                                child: const Text(
                                  "Perfecto",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('❌ Error al realizar la reserva'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario de Reservas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.event_note),
            tooltip: "Ver mis reservas",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MisReservasView()),
              );
            },
          ),
        ],
      ),
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
                    final horarios =
                        clase.horarios!
                            .where(
                              (h) =>
                                  h.fecha ==
                                  DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(_selectedDay!),
                            )
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
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(clase.descripcion),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children:
                                  horarios.map((h) {
                                    final key =
                                        "${clase.id}-${h.fecha}-${h.hora}";
                                    final reservado = _reservasConfirmadas
                                        .contains(key);

                                    return ActionChip(
                                      label:
                                          reservado
                                              ? Text(
                                                "✔ ${h.hora}",
                                                style: const TextStyle(
                                                  color: Colors.green,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                              : Text(h.hora),
                                      onPressed:
                                          reservado ||
                                                  h.id ==
                                                      null // 👈 seguridad extra
                                              ? null
                                              : () => _mostrarDialogoReserva(
                                                clase,
                                                h.id!, // 👈 ahora seguro no crashea
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
