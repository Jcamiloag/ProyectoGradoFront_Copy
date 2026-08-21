import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hola_mundo/provider/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:hola_mundo/routes/app_router.dart';

import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carga el archivo .env
  await dotenv.load(fileName: ".env");

  // ==========================
  // PRUEBA DE SESIÓN
  // ==========================
  final prefs = await SharedPreferences.getInstance();

  print("================================");
  print("TOKEN: ${prefs.getString('token')}");
  print("USER ID: ${prefs.getInt('userId')}");
  print("USERNAME: ${prefs.getString('username')}");
  print("ROLE: ${prefs.getString('role')}");
  print("================================");

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

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(
        textScaler: TextScaler.linear(themeProvider.textScale),
      ),
      child: MaterialApp.router(
        title: 'Flutter - UCEVA',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(themeProvider.color),
        darkTheme: AppTheme.darkTheme(themeProvider.color),
        themeMode: themeProvider.themeMode,
        routerConfig: appRouter,
      ),
    );
  }
}