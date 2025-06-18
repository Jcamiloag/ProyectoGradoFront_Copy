import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Clase>> _clasesPorDia = {};

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _clasesFuture = _claseService.getClases();
    _clasesFuture.then((clases) {
      _organizarClasesPorDia(clases);
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
    return _clasesPorDia[dateOnly] ?? [];
  }

  Future<void> _mostrarDialogoReserva(Clase clase, String hora) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Reserva'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('¿Reservar ${clase.nombre} a las $hora?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmar'),
              onPressed: () async {
                try {
                  // Aquí deberías llamar a tu servicio para guardar la reserva
                  // await _reservaService.crearReserva(clase.id, _selectedDay, hora);
                  
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Reserva confirmada para $hora')),
                  );
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error al reservar: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
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
              setState(() {
                _calendarFormat = format;
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            eventLoader: (day) => _getClasesDelDia(day).isNotEmpty ? [day] : [],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: FutureBuilder<List<Clase>>(
              future: _clasesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error al cargar clases'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No hay clases disponibles'));
                }

                final clasesDelDia = _getClasesDelDia(_selectedDay);
                
                if (clasesDelDia.isEmpty) {
                  return Center(child: Text('No hay clases este día'));
                }

                return ListView.builder(
                  itemCount: clasesDelDia.length,
                  itemBuilder: (context, index) {
                    final clase = clasesDelDia[index];
                    final horarios = clase.horarios ?? [];
                    
                    return Card(
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              clase.nombre,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(clase.descripcion),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              children: horarios.map((horario) {
                                return ActionChip(
                                  label: Text(horario.hora ?? ''),
                                  onPressed: () => _mostrarDialogoReserva(clase, horario.hora ?? ''),
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
