import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Perfil', // Título de la pantalla
      initialIndex: 0, // Provide the required index
      length: 1, // Provide the required length
      body: const Center(child: Text('Pantalla de perfil')),
      
    );
    
  }
}
