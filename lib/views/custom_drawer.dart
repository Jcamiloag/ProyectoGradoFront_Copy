import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/services/auth_service.dart';
import 'package:hola_mundo/models/user.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  
  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  User? user;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _loadUser);
  }

  Future<void> _loadUser() async {
    final u = await AuthService().getUser();
    if (!mounted) return;
    setState(() {
      user = u ??
          User(
            id: 0,
            username: '',
            firstname: '',
            lastname: '',
            email: '',
            phonenumber: '',
            role: 'USER',
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, 
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.red),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.username.isNotEmpty == true ? user!.username : 'Usuario',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? 'email@ejemplo.com',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              context.go('/');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              context.push('/settings');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              context.replace('/profile');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Paso de Parámetros'),
            onTap: () {
              context.go('/paso_parametros');
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Lista de Estudiantes'),
            onTap: () => context.goNamed('future'),
          ),
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            onTap: () => context.goNamed('timerView'),
          ),
          ListTile(
            leading: const Icon(Icons.memory),
            title: const Text('Isolate'),
            onTap: () => context.goNamed('isolate'),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Establecimientos'),
            onTap: () => context.push('/establecimientos'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Iniciar sesión'),
            onTap: () {
              context.goNamed('login');
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Cerrar sesión'),
            onTap: () async {
              final token = await AuthService().getToken();
              if (token != null) {
                await AuthService().logout();
                if (!context.mounted) return;
                context.go('/login');
              } else {
                if (!context.mounted) return;
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No hay sesión activa.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.color_lens),
            title: const Text('Cambiar tema'),
            onTap: () {
              context.pushNamed('cambiar-tema');
            },
          ),
        ],
      ),
    );
  }
}
