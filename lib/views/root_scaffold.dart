import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/views/custom_drawer.dart';

/// Scaffold principal que gestiona:
/// - Bottom navigation bar
/// - AppBars dinámicos según pestaña
/// - Botones flotantes contextuales
class RootScaffoldWithNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const RootScaffoldWithNavBar({
    super.key,
    required this.navigationShell,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      drawer: const CustomDrawer(),
      body: SafeArea(child: navigationShell),
      bottomNavigationBar: _buildBottomNavBar(context),
      floatingActionButton: _buildFloatingActionButton(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    // Títulos según pestaña activa
    final titles = [
      'Academia Farfala', // Home
      'Reservar Clase',   // Reservations
      'Pagos',            // Payments
      'Mi Perfil',        // Profile
    ];

    final title = titles[navigationShell.currentIndex];

    return AppBar(
      title: Text(title),
      leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu), // Aquí se pone el ícono de las tres rayitas
        onPressed: () => Scaffold.of(context).openDrawer(), // Aquí se abre el Drawer
      ),
    ),

      actions: [
        if (navigationShell.currentIndex == 0)
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/home/settings'),
          ),
        if (navigationShell.currentIndex == 3)
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go('/login'),
          ),
      ],
    );
  }

  BottomNavigationBar _buildBottomNavBar(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: navigationShell.currentIndex,
      onTap: (index) => _onItemTapped(index, context),
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today_outlined),
          activeIcon: Icon(Icons.calendar_today),
          label: 'Reservations',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.credit_card_outlined),
          activeIcon: Icon(Icons.credit_card),
          label: 'Payments',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outlined),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton(BuildContext context) {
    switch (navigationShell.currentIndex) {
      case 1: // Reservations tab
        return FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () => _showAddReservationDialog(context),
        );
      case 2: // Payments tab
        return FloatingActionButton(
          child: const Icon(Icons.payment),
          onPressed: () => _showPaymentSheet(context),
        );
      default:
        return null;
    }
  }

  void _onItemTapped(int index, BuildContext context) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  void _showAddReservationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nueva Reserva'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/reservations/new');
            },
            child: const Text('Continuar'),
          ),
        ],
      ),
    );
  }

  void _showPaymentSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Agregar método de pago'),
            SizedBox(height: 16),
            // Aquí va el formulario
          ],
        ),
      ),
    );
  }
}
