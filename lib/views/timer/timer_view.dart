import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class TimerView extends StatefulWidget {
  const TimerView({super.key});

  @override
  State<TimerView> createState() => _TimerViewState();
}

class _TimerViewState extends State<TimerView> {
  late Timer _timer;
  int _contador = 0;
  int _indiceSeleccionado = 0; // Índice seleccionado en el BottomNavigationBar
  bool _estaCorriendo = false; // Indica si el temporizador está corriendo

  @override
  void initState() {
    super.initState();
  }

  void _iniciarTemporizador() { // Inicia el temporizador
    if (_estaCorriendo) return; // Si ya está corriendo, no hace nada
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) { // Cada segundo
      setState(() { // Actualiza el estado
        _contador++; // Incrementa el contador
      });
    });
    _estaCorriendo = true; // Indica que el temporizador está corriendo
  }

  void _pausarTemporizador() { // Pausa el temporizador
    _timer.cancel(); // Cancela el temporizador
    _estaCorriendo = false; // Indica que el temporizador no está corriendo
  }

  void _reiniciarTemporizador() { // Reinicia el temporizador
    _pausarTemporizador(); // Pausa el temporizador
    setState(() { // Actualiza el estado
      _contador = 0; // Reinicia el contador
    });
    _iniciarTemporizador(); // Inicia el temporizador
  }

  @override
  void dispose() { // Cancela el temporizador al cerrar la vista
    _pausarTemporizador(); // Pausa el temporizador
    super.dispose(); // Llama al método dispose de la clase padre
  }

  void _itemSeleccionado(int index) { // Cambia la página seleccionada
    setState(() { // Actualiza el estado
      _indiceSeleccionado = index; // Cambia el índice seleccionado
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> paginas = [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Segundos: $_contador',
            style: const TextStyle(fontSize: 28),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 223, 184),
                ),
                onPressed: _iniciarTemporizador,
                child: const Text('Iniciar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 223, 184),
                ),
                onPressed: _pausarTemporizador,
                child: const Text('Pausar'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 232, 223, 184),
                ),
                onPressed: _reiniciarTemporizador,
                child: const Text('Reiniciar'),
              ),
            ],
          ),
        ],
      ),
      const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text(
          'Este ejemplo usa Timer.periodic para aumentar el contador automáticamente cada segundo.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    ];

    return BaseView(
      title: 'Contador',
      initialIndex: _indiceSeleccionado,
      length: paginas.length,
      body: Column(
        children: [
          Expanded(child: paginas[_indiceSeleccionado]),
          BottomNavigationBar(
            currentIndex: _indiceSeleccionado,
            onTap: _itemSeleccionado,
            selectedItemColor: Colors.blueAccent,
            unselectedItemColor: Colors.grey,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.timer),
                label: 'Contador',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.info_outline),
                label: 'Descripción',
              ),
            ],
          ),
        ],
      ),
    );
  }
}
