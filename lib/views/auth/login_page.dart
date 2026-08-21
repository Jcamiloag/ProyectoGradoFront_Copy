import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hola_mundo/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  final bool isTabMode;

  const LoginPage({super.key, this.isTabMode = false});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;
  String? errorMessage;

  Future<void> login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await AuthService().login(
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });

    if (result['success']) {

      print("================================");
      print("LOGIN EXITOSO");
      print("ANTES DE GO: ${GoRouterState.of(context).uri}");

      context.go('/');

      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          print("DESPUÉS DE GO: ${GoRouterState.of(context).uri}");
          print("================================");
        }
      });

    } else {
      setState(() {
        errorMessage = result['message'] ?? 'Error al iniciar sesión';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Colors.redAccent;

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              const Text(
                "Ingresa para continuar tu camino con Farfala",
                style: TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 32),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: emailCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.mail_outline),
                    contentPadding: EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Ingresa tu Email'
                          : null,
                ),
              ),

              const SizedBox(height: 20),

              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextFormField(
                  controller: passwordCtrl,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        obscureText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () {
                        setState(() {
                          obscureText = !obscureText;
                        });
                      },
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty
                          ? 'Ingresa tu contraseña'
                          : null,
                ),
              ),

              const SizedBox(height: 16),

              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),

              GestureDetector(
                onTap: isLoading ? null : login,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.redAccent,
                        Colors.red,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                      : const Text(
                          "INICIAR SESIÓN",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("¿No tienes una cuenta? "),
                  GestureDetector(
                    onTap: () {
                      if (!widget.isTabMode) {
                        context.go('/register');
                      } else {
                        DefaultTabController.of(context).animateTo(1);
                      }
                    },
                    child: const Text(
                      "Crear cuenta",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}