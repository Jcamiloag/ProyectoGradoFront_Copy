import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hola_mundo/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hola_mundo/routes/app_router.dart';

import 'themes/app_theme.dart'; // Importa el tema

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //! Importante para que funcione el dotenv, inicializa el widget

  //! Carga el archivo .env en la raíz del proyecto
  await dotenv.load(fileName: ".env");

  //! Ejecuta la app con Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final themeColor = themeProvider.color;
    final themeMode = themeProvider.themeMode;

    return MaterialApp.router(
      title: 'Flutter - UCEVA',
      theme: AppTheme.lightTheme(themeColor),
      darkTheme: AppTheme.darkTheme(themeColor), 
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
