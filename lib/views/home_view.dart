import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';
import 'package:hola_mundo/services/auth_service.dart'; // Asegúrate de tener el import correcto para AuthService

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Número de pestañas
      child: BaseView(
        title: 'ACADEMIA FARFALA',
        initialIndex: 1,
        length: 2,
        body: Column(
          children: [
            // Texto arriba del TabBar
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Somos una escuela especializada en pole dance y pole sport, pioneros en Tulua, con más de 10 años de experiencia',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // FutureBuilder que muestra el token
            FutureBuilder<String?>(
              future: AuthService().getToken(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }

                if (snapshot.hasError) {
                  return const Text('Error al cargar token');
                }

                final token = snapshot.data;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Text(
                    'Token: ${token ?? "No hay token"}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              },
            ),

            // TabBar
            const TabBar(
              tabs: <Widget>[
                Tab(icon: Icon(Icons.social_distance_outlined)),
                Tab(icon: Icon(Icons.handshake)),
              ],
            ),

            // Contenido de las pestañas
            Expanded(
              child: TabBarView(
                children: <Widget>[
                  // Pestaña clases 
                  GridViewBuilder(items: [
                    "Pole Sport", "Sexy Pole", "Baile en silla", "Twerk", "Baile Urbano", "Bachata y salsa", "Funcional"
                  ]),

                  // Segunda pestaña de saludo 
                  Image.asset(
                    'assets/images/imagen_1.jpg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// *Clase GridViewBuilder con nombres personalizados*
class GridViewBuilder extends StatelessWidget {
  final List<String> items;

  const GridViewBuilder({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // 1 columna
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 3.0,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 232, 223, 184),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                items[index],
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ),
          );
        },
      ),
    );
  }
}
