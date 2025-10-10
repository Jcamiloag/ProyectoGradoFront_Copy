import 'package:flutter/material.dart';
import 'package:hola_mundo/services/reserva_service.dart';
import 'package:hola_mundo/models/reserva.dart';

class MisReservasView extends StatefulWidget {
  const MisReservasView({super.key});

  @override
  State<MisReservasView> createState() => _MisReservasViewState();
}

class _MisReservasViewState extends State<MisReservasView> {
  final ReservaService _reservaService = ReservaService();
  late Future<List<Reserva>> _reservasFuture;

  @override
  void initState() {
    super.initState();
    _reservasFuture = _reservaService.getReservasUsuario();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mis Reservas")),
      body: FutureBuilder<List<Reserva>>(
        future: _reservasFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar reservas"));
          }

          final reservas = snapshot.data ?? [];
          if (reservas.isEmpty) {
            return const Center(child: Text("No tienes reservas confirmadas."));
          }

          return ListView.builder(
            itemCount: reservas.length,
            itemBuilder: (context, index) {
              final r = reservas[index];
              return ListTile(
                leading: const Icon(Icons.event_available, color: Colors.green),
                title: Text(r.claseNombre),
                subtitle: Text("${r.fecha} a las ${r.hora}"),
              );
            },
          );
        },
      ),
    );
  }
}
