import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:hola_mundo/services/auth_service.dart';
import 'package:hola_mundo/views/asistencias/historial_clases_page.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {

  String? username;
  String? role;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      Duration.zero,
      _loadUser,
    );
  }

  Future<void> _loadUser() async {

    final u =
        await AuthService().getUsername();

    final r =
        await AuthService().getRole();

    if (!mounted) return;

    setState(() {

      username = u;

      role = r;

    });

  }

  @override
  Widget build(BuildContext context) {

    final isAdmin =
        role?.trim().toUpperCase() == "ADMIN";

    return Drawer(

      child: SafeArea(

        child: Column(

          children: [

            // ==========================
            // HEADER
            // ==========================

            Container(

              width: double.infinity,

              padding: const EdgeInsets.fromLTRB(
                24,
                34,
                24,
                26,
              ),

              decoration: const BoxDecoration(

                gradient: LinearGradient(

                  colors: [

                    Color(0xFFD32F2F),

                    Color(0xFFB71C1C),

                  ],

                  begin: Alignment.topLeft,

                  end: Alignment.bottomRight,

                ),

              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  const Icon(

                    Icons.account_circle_rounded,

                    size: 56,

                    color: Colors.white,

                  ),

                  const SizedBox(height: 18),

                  Text(

                    "¡Hola, ${username ?? "Usuario"}!",

                    style: const TextStyle(

                      color: Colors.white,

                      fontSize: 23,

                      fontWeight: FontWeight.bold,

                    ),

                  ),

                  const SizedBox(height: 6),

                  Text(

                    isAdmin
                        ? "Administrador"
                        : "Bienvenido nuevamente",

                    style: const TextStyle(

                      color: Colors.white70,

                      fontSize: 15,

                    ),

                  ),

                  const SizedBox(height: 16),

                  if (role != null)

                    Container(

                      padding:
                          const EdgeInsets.symmetric(

                        horizontal: 14,

                        vertical: 6,

                      ),

                      decoration: BoxDecoration(

                        color:
                            Colors.white.withOpacity(.15),

                        borderRadius:
                            BorderRadius.circular(25),

                      ),

                      child: Text(

                        role!.toUpperCase(),

                        style: const TextStyle(

                          color: Colors.white,

                          fontWeight: FontWeight.w600,

                          letterSpacing: 1,

                        ),

                      ),

                    ),

                ],

              ),

            ),

            Expanded(

              child: ListView(

                padding: const EdgeInsets.symmetric(

                  horizontal: 14,

                  vertical: 16,

                ),

                children: [

                  _sectionTitle("GENERAL"),

                  _drawerItem(

                    context,

                    icon: Icons.home_rounded,

                    title: "Inicio",

                    onTap: () {

                      Navigator.pop(context);

                      context.go("/");

                    },

                  ),

                  _drawerItem(

                    context,

                    icon: Icons.person_outline_rounded,

                    title: "Perfil",

                    onTap: () {

                      Navigator.pop(context);

                      context.go("/profile");

                    },

                  ),

                  _drawerItem(

                    context,

                    icon: Icons.settings_outlined,

                    title: "Configuración",

                    onTap: () {

                      Navigator.pop(context);

                      context.go("/settings");

                    },

                  ),

                  const SizedBox(height: 22),

                  _sectionTitle("SISTEMA"),

                  _drawerItem(

                    context,

                    icon: Icons.palette_outlined,

                    title: "Apariencia",

                    onTap: () {

                      Navigator.pop(context);

                      context.pushNamed(
                        "cambiar-tema",
                      );

                    },

                  ),

                  if (isAdmin)

                    _drawerItem(

                      context,

                      icon: Icons.groups_outlined,

                      title: "Lista de estudiantes",

                      onTap: () {

                        Navigator.pop(context);

                        context.goNamed(
                          "future",
                        );

                      },

                    ),

                  if (isAdmin)

                    _drawerItem(

                      context,

                      icon:
                          Icons.card_membership_rounded,

                      title:
                          "Catálogo de planes",

                      onTap: () {

                        Navigator.pop(context);

                        context.goNamed(
                          "catalogo-planes",
                        );

                      },

                    ),

                  if (isAdmin)

                    _drawerItem(

                      context,

                      icon:
                          Icons.fact_check_rounded,

                      title:
                          "Historial de clases",

                      onTap: () {

                        Navigator.pop(context);

                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (_) => const HistorialClasesPage(),
                          ),
                        );
                      },

                    ),
                                    ],

              ),

            ),

            // ==========================
            // BOTÓN CERRAR SESIÓN
            // ==========================

            Padding(

              padding: const EdgeInsets.all(16),

              child: InkWell(

                borderRadius:
                    BorderRadius.circular(18),

                onTap: () async {

                  final token =
                      await AuthService()
                          .getToken();

                  if (token != null) {

                    await AuthService()
                        .logout();

                    if (!context.mounted) {
                      return;
                    }

                    context.go("/login");

                  } else {

                    if (!context.mounted) {
                      return;
                    }

                    Navigator.pop(context);

                    ScaffoldMessenger.of(context)
                        .showSnackBar(

                      const SnackBar(

                        content: Text(
                          "No hay sesión activa.",
                        ),

                      ),

                    );

                  }

                },

                child: Container(

                  padding:
                      const EdgeInsets.symmetric(

                    horizontal: 18,

                    vertical: 16,

                  ),

                  decoration: BoxDecoration(

                    color: Colors.red.shade50,

                    borderRadius:
                        BorderRadius.circular(18),

                    border: Border.all(

                      color:
                          Colors.red.shade100,

                    ),

                  ),

                  child: Row(

                    children: [

                      Icon(

                        Icons.logout_rounded,

                        color:
                            Colors.red.shade700,

                      ),

                      const SizedBox(width: 14),

                      Text(

                        "Cerrar sesión",

                        style: TextStyle(

                          color:
                              Colors.red.shade700,

                          fontWeight:
                              FontWeight.bold,

                          fontSize: 15,

                        ),

                      ),

                      const Spacer(),

                      Icon(

                        Icons.arrow_forward_ios_rounded,

                        size: 16,

                        color:
                            Colors.red.shade700,

                      ),

                    ],

                  ),

                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

  // ==========================
  // TÍTULO DE SECCIÓN
  // ==========================

  Widget _sectionTitle(
    String title,
  ) {

    return Padding(

      padding: const EdgeInsets.only(

        left: 12,

        bottom: 8,

      ),

      child: Text(

        title,

        style: TextStyle(

          color: Colors.grey.shade600,

          fontSize: 12,

          fontWeight: FontWeight.bold,

          letterSpacing: 1.2,

        ),

      ),

    );

  }

  // ==========================
  // ITEM DEL DRAWER
  // ==========================

  Widget _drawerItem(

    BuildContext context, {

    required IconData icon,

    required String title,

    required VoidCallback onTap,

  }) {

    return Padding(

      padding:
          const EdgeInsets.only(bottom: 6),

      child: ListTile(

        shape: RoundedRectangleBorder(

          borderRadius:
              BorderRadius.circular(16),

        ),

        leading: Icon(

          icon,

          color: const Color(0xFFD32F2F),

        ),

        trailing: const Icon(

          Icons.chevron_right_rounded,

          size: 20,

        ),

        title: Text(

          title,

          style: const TextStyle(

            fontWeight: FontWeight.w600,

          ),

        ),

        onTap: onTap,

      ),

    );

  }

}