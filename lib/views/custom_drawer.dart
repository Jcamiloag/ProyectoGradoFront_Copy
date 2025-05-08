import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/services/auth_service.dart';
import 'package:hola_mundo/models/user.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});
  
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  //?  Variable para almacenar el usuario actual
  User? user;
  //

  @override
  void initState() {
    super.initState();
    //* Carga el usuario al iniciar el estado
    //* Se utiliza Future.delayed para asegurarse de que la carga del usuario se realice después de que el widget se haya construido completamente.
    Future.delayed(Duration.zero, () {
      _loadUser();
    });
  }

  Future<void> _loadUser() async {
    //** Obtiene el usuario actual utilizando el servicio de autenticación
    //** y actualiza el estado del widget con la información del usuario.
    final u = await AuthService().getUser();
    setState(() {
      user = u;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, 
        children: [
          DrawerHeader( 
            decoration: BoxDecoration(
              color: Colors.red, // Color primario de la aplicación
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.name ?? 'Usuario desconocido',
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              //context.go('/'); // Navega a la ruta principal
              //Reemplaza la ruta actual en la pila de navegación.
              //No permite volver atrás automáticamente, ya que no agrega la nueva ruta a la pila.
              //Útil para navegación sin historial, como en barra de navegación o cambiar de pestañas.
              context.go('/'); // Navega a la ruta principal
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Configuración'),
            onTap: () {
              //context.push(String route)
              //Añade la nueva ruta a la pila de navegación.
              //Permite volver atrás con context.pop().
              //Ideal para flujos donde el usuario puede regresar, como navegar a una pantalla de detalles.
              context.push(
                '/settings',
              ); // Navega a la pantalla de configuración
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            onTap: () {
              //context.replace(String route)
              //Similar a go(), pero en este caso reemplaza la ruta actual sin eliminar el historial anterior.
              //Útil si quieres evitar que el usuario regrese a la pantalla anterior
              //pero manteniendo la posibilidad de navegar hacia otras rutas en la pila
              context.replace('/profile'); // Navega a la pantalla de perfil
              Navigator.pop(context); // Cierra el drawer
            },
          ),
          //!PASO DE PARAMETROS
          ListTile(
            leading: const Icon(Icons.input),
            title: const Text('Paso de Parámetros'),
            onTap: () {
              context.go('/paso_parametros');
            },
          ),
         
          //!Future
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Lista de Estudiantes'),
            onTap: () => context.goNamed('future'),
          ),
          //!TIMER
          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text('Timer'),
            onTap: () {
              context.goNamed('timerView');
            },
          ), 
           //!ISOLATE
          ListTile(
            leading: const Icon(Icons.memory),
            title: const Text('Isolate'),
            onTap: () {
              //Navega a la ruta con nombre 'isolate'
              context.goNamed('isolate');
            },
          ),
          
           ListTile(
            leading: Icon(Icons.business),
            title: Text('Establecimientos'),
            onTap: () {
              // Navegación con GoRouter
              context.push('/establecimientos');
            },
          ),
          //! ruta para logout y login
          ListTile(
            leading: const Icon(Icons.login),
            title: const Text('Iniciar sesión'),
            onTap: () {
              context.goNamed('login');
              Navigator.pop(context); // Cierra el Drawer
            },
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Cerrar sesión'),
            onTap: () async {
              final token = await AuthService().getToken();

              if (token != null) {
                await AuthService().logout();

                if (!context.mounted) {
                  return;
                }
                context.go('/login');
              } else {
                if (!context.mounted) return;
                Navigator.pop(context); // Cierra el drawer
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No hay sesión activa.')),
                );
              }
            },
          ),  
          //! ruta para cambiar el tema
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
