import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class IsolateView extends StatefulWidget {
  const IsolateView({super.key});

  @override
  State<IsolateView> createState() => _IsolateViewState();
}

class _IsolateViewState extends State<IsolateView> {
  String resultado = "Presiona el botón para ejecutar";

  //!Función que ejecuta la tarea pesada en un Isolate
  Future<void> isolateTask() async {
    final receivePort = ReceivePort(); // Buzón para recibir datos

    // Lanza un nuevo Isolate y le pasa el canal de comunicación principal
    await Isolate.spawn(_simulacionTareaPesada, receivePort.sendPort);

    // Espera a recibir el sendPort del nuevo isolate
    final sendPort = await receivePort.first as SendPort;

    // Crea un canal para recibir la respuesta
    final response = ReceivePort();

    // Envía un mensaje al isolate con los datos y el canal de respuesta
    sendPort.send(["Hola desde el hilo principal", response.sendPort]);

    // Espera la respuesta del isolate
    final result = await response.first as String;

    // Si el widget sigue montado, actualiza la UI y muestra el SnackBar
    if (!mounted) return;
    setState(() {
      resultado = result;
    });

    // Mostrar resultado en un SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Resultado: $result")),
    );
  }

  //!simulacionTareaPesada es una función que simula una tarea pesada en un Isolate
  static void _simulacionTareaPesada(SendPort sendPort) async {
    final port = ReceivePort(); // Buzón interno del isolate
    sendPort.send(port.sendPort); // Se lo enviamos al hilo principal

    // Espera a recibir mensajes
    await for (final message in port) {
      final data = message[0] as String; // Mensaje recibido
      final puertoReceptor = message[1] as SendPort; // Canal para responder

      int counter = 0;
      for (int i = 1; i <= 2000000; i++) { // Ahora suma hasta 2 millones
        counter += i;
        if (kDebugMode) {
          print("Isolate contando: $i");
        }
      }

      puertoReceptor.send(
        "Tarea completada. Suma del 1 al 2M: $counter. - Mensaje recibido: '$data'",
      );
      port.close(); // Cierra el puerto
      Isolate.exit(); // Finaliza el Isolate
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: "Tarea Pesada en Isolate",
      initialIndex: 0,
      length: 1,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(resultado, textAlign: TextAlign.center),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isolateTask,
                child: const Text("Ejecutar tarea en segundo plano"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
