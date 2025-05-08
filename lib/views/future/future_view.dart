import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class FutureView extends StatefulWidget {
  const FutureView({super.key});

  @override
  State<FutureView> createState() => _FutureViewState();
}

class _FutureViewState extends State<FutureView> {
  List<String> _nombres = []; //forma para declarar una lista.

  @override
  // !inicializa el estado
  // *llama a la funcion obtenerDatos() para cargar los datos al iniciar
  void initState() {
    super.initState();
    obtenerDatos(); // carga al iniciar
  }

  // !Funcion que simula una carga de datos
  //*espera 5 segundos antes de cargar los datos, esto simula una carga de datos.
  Future<List<String>> cargarNombres() async {
    //future.delayed() simula una carga de datos
    await Future.delayed(const Duration(seconds: 5));
    return [
      'Juan',
      'Pedro',
      'Luis',
      'Ana',
      'Maria',
      'Jose',
      'Carlos',
      'Sofia',
      'Laura',
      'Fernando',
      'Ricardo',
      'Diana',
      'Elena',
      'Miguel',
      'Rosa',
      'Luz',
      'Carmen',
      'Pablo',
      'Jorge',
      'Roberto',
    ];
  }

  // !Funcion que obtiene los datos
  // *carga los datos y los asigna a la lista _nombres
  Future<void> obtenerDatos() async {
    final datos = await cargarNombres();

    //!mounted es una propiedad de State que indica si el widget está montado en el árbol de widgets
    //mounted es true si el widget está montado en el árbol de widgets
    //mounted es false si el widget no está montado en el árbol de widgets
    if (!mounted) return;
    setState(() {
      _nombres = datos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Lista de Estudiantes',
      initialIndex: 0, // Indice de la ruta actual
      length: _nombres.length, // Longitud de la lista
      body:
          //*si la lista esta vacia muestra un CircularProgressIndicator
          _nombres.isEmpty 
              ? const Center(child: CircularProgressIndicator()) // Muestra un indicador de carga
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ListView.builder(
                    itemCount: _nombres.length, // Cantidad de elementos
                    itemBuilder: (context, index) {  // Crea un elemento de la lista
                      return Card(
                        color: const Color.fromARGB(255, 232, 223, 184),
                        child: ListTile(
                          title: Text(_nombres[index]),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
