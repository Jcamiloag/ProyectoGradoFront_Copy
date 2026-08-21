import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hola_mundo/models/user.dart';

import 'package:hola_mundo/views/auth/auth_tabs_page.dart';
import 'package:hola_mundo/views/auth/register_page.dart'
    as authRegister;

import 'package:hola_mundo/views/home_view.dart';
import 'package:hola_mundo/views/profile_view.dart';
import 'package:hola_mundo/views/settings_view.dart';
import 'package:hola_mundo/views/provider/change_theme_view.dart';

import 'package:hola_mundo/views/future/future_view.dart';
import 'package:hola_mundo/views/evaluacion/evaluacion_view.dart';

import 'package:hola_mundo/views/planes/student_plan_page.dart';
import 'package:hola_mundo/views/planes/plan_catalogo_page.dart';

import 'package:hola_mundo/views/asistencias/historial_clases_page.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',

  routes: [

    // ==========================
    // LOGIN
    // ==========================

    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const AuthTabsPage(),
    ),

    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) =>
          const authRegister.RegisterPage(),
    ),

    // ==========================
    // HOME
    // ==========================

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

    // ==========================
    // OTRAS VISTAS
    // ==========================

    GoRoute(
      path: '/future',
      name: 'future',
      builder: (context, state) => const FutureView(),
    ),

    GoRoute(
      path: '/evaluacion',
      name: 'evaluacion',
      builder: (context, state) {
        final usuario = state.extra as User;

        return EvaluacionView(
          usuario: usuario,
        );
      },
    ),

    GoRoute(
      path: '/planes',
      name: 'planes',
      builder: (context, state) {
        final usuario = state.extra as User;

        return StudentPlanPage(
          usuario: usuario,
        );
      },
    ),

    // ==========================
    // CONFIGURACIÓN
    // ==========================

    GoRoute(
      path: '/cambiar-tema',
      name: 'cambiar-tema',
      builder: (context, state) =>
          const ChangeThemeView(),
    ),

    GoRoute(
      path: '/catalogo-planes',
      name: 'catalogo-planes',
      builder: (context, state) {
        return PlanCatalogoPage();
      },
    ),

    GoRoute(
      path: '/historial-clases',
      name: 'historial-clases',
      builder: (context, state) =>
          const HistorialClasesPage(),
    ),
  ],
);