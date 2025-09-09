import 'package:go_router/go_router.dart';
import 'package:hola_mundo/services/auth_service.dart';

// Layout principal con BottomNav + Drawer
import 'package:hola_mundo/views/root_scaffold.dart';

// Vistas
import 'package:hola_mundo/views/home_view.dart';
import 'package:hola_mundo/views/reservations/calendar_view.dart'; // 👈 tu calendario
import 'package:hola_mundo/views/profile_view.dart';
import 'package:hola_mundo/views/settings_view.dart';

// Autenticación
import 'package:hola_mundo/views/auth/auth_tabs_page.dart';
import 'package:hola_mundo/views/auth/register_page.dart' as authRegister;

final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) async {
    final auth = AuthService();
    final token = await auth.getToken();

    final goingToLogin = state.matchedLocation == '/login';
    final goingToRegister = state.matchedLocation == '/register';

    // 🔹 Si no hay token y no va a login/register -> login
    if (token == null && !goingToLogin && !goingToRegister) {
      return '/login';
    }

    // 🔹 Si ya hay token e intenta ir a login -> mándalo a home
    if (token != null && goingToLogin) {
      return '/home';
    }

    return null; // no redirigir
  },
  routes: [
    /// 🔹 Navegación principal con BottomNav + Drawer
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return RootScaffoldWithNavBar(navigationShell: navigationShell);
      },
      branches: [
        // 🏠 Home
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeView(),
            ),
          ],
        ),

        // 📅 Reservas (calendario)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/reservas',
              name: 'reservas',
              builder: (context, state) => const CalendarView(),
            ),
          ],
        ),

        // 💳 Pagos (comentado si aún no está implementado)
        /*
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/pagos',
              name: 'pagos',
              builder: (context, state) => const PaymentsView(),
            ),
          ],
        ),
        */

        // 👤 Perfil
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/perfil',
              name: 'perfil',
              builder: (context, state) => const ProfileView(),
            ),
          ],
        ),
      ],
    ),

    /// 🔹 Rutas fuera del BottomNav
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsView(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const AuthTabsPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) => authRegister.RegisterPage(isTabMode: false),
    ),
  ],
);
