import 'package:flutter/material.dart';
import 'package:hola_mundo/views/base_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'ACADEMIA FARFALA',
      initialIndex: 1,
      length: 2,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Imagen principal simulada con colores pastel y texto responsivo
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                double fontSize = constraints.maxWidth > 600 ? 24 : 16;

                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 230, 180, 180), // pastel rosado
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: Text(
                        'Somos una escuela especializada en pole dance y pole sport, pioneros en Tuluá, con más de 10 años de experiencia.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.bold,
                          color: const Color.fromARGB(255, 243, 243, 243),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 16),

          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                FilterButton(label: 'Populares', color: Colors.amber),
                FilterButton(label: 'Baile', color: Colors.redAccent),
                FilterButton(label: 'Pole', color: Colors.lightBlue),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Lista de clases
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: const [
                ClassCard(
                  title: 'Estiramiento',
                  description: 'Clase para mejorar tu flexibilidad',
                  color: Color(0xFFD1F2EB),
                ),
                SizedBox(height: 12),
                ClassCard(
                  title: 'Baile',
                  description: 'Movimiento libre con ritmo',
                  color: Color(0xFFF9E79F),
                ),
                SizedBox(height: 12),
                ClassCard(
                  title: 'Baile en silla',
                  description: 'Clases sensuales con silla',
                  color: Color(0xFFFADBD8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final Color color;

  const FilterButton({super.key, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class ClassCard extends StatelessWidget {
  final String title;
  final String description;
  final Color color;

  const ClassCard({
    super.key,
    required this.title,
    required this.description,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(2, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 90,
            height: double.infinity,
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(description, style: TextStyle(color: Colors.grey[600])),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

