import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/views/auth/auth_tabs_page.dart';
import 'package:hola_mundo/views/auth/register_page.dart' as authRegister;
import 'package:hola_mundo/views/home_view.dart';
import 'package:hola_mundo/views/profile_view.dart';
import 'package:hola_mundo/views/reservations/calendar_view.dart';
import 'package:hola_mundo/views/payments/payments_view.dart';
import 'package:hola_mundo/views/root_scaffold.dart';
import 'package:hola_mundo/views/settings_view.dart';
import 'package:hola_mundo/views/future/future_view.dart';
import 'package:hola_mundo/views/timer/timer_view.dart';
import 'package:hola_mundo/views/isolate/isolate_view.dart';
import 'package:hola_mundo/views/provider/change_theme_view.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Error 404: Page not found at ${state.uri.path}'),
    ),
  ),
  redirect: (context, state) {
    if (state.uri.path == '/') {
      return '/home';
    }
    return null;
  },
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          RootScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        // Home Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: HomeView()),
              routes: [
                GoRoute(
                  path: 'settings',
                  builder: (context, state) => const SettingsView(),
                ),
              ],
            ),
          ],
        ),

        // Reservations Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reservations',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: CalendarView()),
            ),
          ],
        ),

        // Payments Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/payments',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: PaymentsView()),
            ),
          ],
        ),

        // Profile Branch
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) =>
                  const NoTransitionPage(child: ProfileView()),
              routes: [
                GoRoute(
                  path: 'future',
                  builder: (context, state) => const FutureView(),
                ),
                GoRoute(
                  path: 'timer',
                  builder: (context, state) => const TimerView(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),

    // Authentication Routes
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthTabsPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const authRegister.RegisterPage(),
    ),

    // Feature Routes
    GoRoute(
      path: '/isolate',
      builder: (context, state) => const IsolateView(),
    ),
    GoRoute(
      path: '/cambiar-tema',
      name: 'cambiar-tema', //Añadir esta línea
      builder: (context, state) => const ChangeThemeView(),
    ),
  ],
);