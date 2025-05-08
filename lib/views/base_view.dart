import 'package:flutter/material.dart';
import 'custom_drawer.dart'; // Importa el Drawer personalizado
import 'package:go_router/go_router.dart'; // Para navegación

class BaseView extends StatelessWidget {
  final String title;
  final Widget body;
  final int initialIndex;
  final int length;
  final Widget? floatingActionButton;

  const BaseView({
    super.key,
    required this.title,
    required this.body,
    required this.initialIndex,
    required this.length,
    this.floatingActionButton,
  });

  void _onTap(int index, BuildContext context) {
    if (index == initialIndex) return;

    switch (index) {
      case 0:
        context.go('/establecimientos');
        break;
      case 1:
        context.go('/dogs');
        break;
      case 2:
        context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), backgroundColor: Colors.red),
      drawer: const CustomDrawer(),
      body: body,
      floatingActionButton: floatingActionButton,
    );
  }
}
