import 'package:go_router/go_router.dart';
import 'package:hola_mundo/views/auth/auth_tabs_page.dart';
import 'package:hola_mundo/views/auth/register_page.dart' as authRegister;

// Vistas generales
import 'package:hola_mundo/views/home_view.dart';
import 'package:hola_mundo/views/provider/change_theme_view.dart';
import 'package:hola_mundo/views/settings_view.dart';
import 'package:hola_mundo/views/profile_view.dart';

import 'package:hola_mundo/views/future/future_view.dart';
import 'package:hola_mundo/views/timer/timer_view.dart';
import 'package:hola_mundo/views/isolate/isolate_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',  // 👈 Cambiado para iniciar en login
  routes: [
    // Home y generales
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileView(),
    ),

    // Otros ejemplos
    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),
    GoRoute(
      path: '/timer',
      name: 'timerView',
      builder: (context, state) => const TimerView(),
    ),
    GoRoute(
      path: '/isolate',
      name: 'isolate',
      builder: (context, state) => const IsolateView(),
    ),

    //!Ruta para autenticacion
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const AuthTabsPage(), // Pantalla login/register
    ),   
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => const authRegister.RegisterPage(),
    ),
    
    //!Ruta para el demo de Provider
    GoRoute(
      path: '/cambiar-tema',
      name: 'cambiar-tema',
      builder: (context, state) => const ChangeThemeView(),
    ),
  ],
);
