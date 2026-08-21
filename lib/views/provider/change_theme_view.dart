import 'package:flutter/material.dart';
import 'package:hola_mundo/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class ChangeThemeView extends StatelessWidget {
  const ChangeThemeView({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Apariencia",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            "Personaliza la experiencia de la aplicación.",
            style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(.7),
              fontSize: 15,
            ),
          ),

          const SizedBox(height: 24),

          //================== TEMA ==================

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.dark_mode_rounded),
                    title: Text(
                      "Tema",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      "Selecciona el modo de visualización.",
                    ),
                  ),
                  const Divider(height: 1),

                  RadioListTile<ThemeMode>(
                    title: const Text("Usar configuración del sistema"),
                    secondary: const Icon(Icons.phone_android),
                    value: ThemeMode.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),

                  RadioListTile<ThemeMode>(
                    title: const Text("Modo claro"),
                    secondary: const Icon(Icons.light_mode),
                    value: ThemeMode.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),

                  RadioListTile<ThemeMode>(
                    title: const Text("Modo oscuro"),
                    secondary: const Icon(Icons.dark_mode),
                    value: ThemeMode.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      if (value != null) {
                        themeProvider.setThemeMode(value);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          //================== TEXTO ==================

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.text_fields),
                      SizedBox(width: 10),
                      Text(
                        "Tamaño del texto",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Ajusta el tamaño de la letra para toda la aplicación.",
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withOpacity(.7),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    children: [
                      const Text(
                        "A",
                        style: TextStyle(fontSize: 14),
                      ),
                      Expanded(
                        child: Slider(
                          value: themeProvider.textScale,
                          min: .9,
                          max: 1.3,
                          divisions: 4,
                          label:
                              "${(themeProvider.textScale * 100).round()}%",
                          onChanged: (value) {
                            themeProvider.setTextScale(value);
                          },
                        ),
                      ),
                      const Text(
                        "A",
                        style: TextStyle(fontSize: 22),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withOpacity(.35),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Text(
                      "Así se verá el texto en toda la aplicación.",
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          //================== INFORMACIÓN ==================

          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            child: const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text(
                "Información",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "Versión 1.0.0",
              ),
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }
}