import 'package:flutter/material.dart';
import 'package:hola_mundo/views/auth/login_page.dart';
import 'package:hola_mundo/views/auth/register_page.dart';

class AuthTabsPage extends StatelessWidget {
  const AuthTabsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWideScreen = screenWidth > 600;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            // Nueva decoración superior con formas más suaves
            Positioned(
              top: -30,
              left: -60,
              child: Transform.rotate(
                angle: 0.5,
                child: Container(
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.red.shade100,
                  ),
                ),
              ),
            ),
            Positioned(
              top: -20,
              right: -40,
              child: Transform.rotate(
                angle: -0.3,
                child: Container(
                  width: 220,
                  height: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(60),
                    color: Colors.red.shade200,
                  ),
                ),
              ),
            ),

            // Contenido principal centrado
            Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Academia Farfala',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Bienvenida de vuelta',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 30),
                      Container(
                        width: isWideScreen ? 500 : double.infinity,
                        constraints: const BoxConstraints(
                          maxWidth: 500,
                          minHeight: 450,
                          maxHeight: 600,
                        ),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(40),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Column(
                          children: [
                            TabBar(
                              labelColor: Colors.red,
                              unselectedLabelColor: Colors.grey,
                              indicatorColor: Colors.red,
                              tabs: [
                                Tab(text: 'Ingresar'),
                                Tab(text: 'Crear cuenta'),
                              ],
                            ),
                            Expanded(
                              child: TabBarView(
                                children: [
                                  LoginPage(isTabMode: true),
                                  RegisterPage(isTabMode: true),
                                ],
                              ),
                            ),
                          ],
                        ),
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
}
