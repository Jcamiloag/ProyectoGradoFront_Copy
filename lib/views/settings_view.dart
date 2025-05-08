import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Configuración', // Título de la pantalla
      initialIndex: 0, // Set the initial index
      length: 1, // Set the length
      body: const Center(child: Text('Pantalla de configuración')),
    );
  }
}
