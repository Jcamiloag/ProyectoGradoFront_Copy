import 'package:flutter/material.dart';
import 'package:hola_mundo/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeView extends StatelessWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentColor = themeProvider.color;

    final List<Color> availableColors = [
      const Color.fromARGB(255, 20, 83, 165), // Azul por defecto
      Colors.red,
      Colors.green,
      Colors.purple,
      Colors.orange,
      Colors.teal,
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Cambiar tema')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Modo de tema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButton<ThemeMode>(
              value: themeProvider.themeMode,
              onChanged: (ThemeMode? newMode) {
                if (newMode != null) {
                  themeProvider.setThemeMode(newMode);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text('Usar modo del sistema'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text('Modo claro'),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text('Modo oscuro'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('Color del tema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                children: availableColors.map((color) {
                  return GestureDetector(
                    onTap: () {
                      themeProvider.setColor(color);
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: color,
                        border: Border.all(
                          color: currentColor == color ? Colors.black : Colors.transparent,
                          width: 4,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
