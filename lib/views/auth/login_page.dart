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

  void login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await AuthService().login(
      emailCtrl.text.trim(),
      passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success']) {
      if (!mounted) return;
      context.go('/');
    } else {
      setState(() {
        errorMessage = result['message'] ?? 'Error al iniciar sesión';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.redAccent;

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

              // Email field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextFormField(
                  controller: emailCtrl,
                  decoration: InputDecoration(
                    hintText: 'Nombre de usuario',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.mail_outline),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu nombre de usuario' : null,
                ),
              ),
              const SizedBox(height: 20),

              // Password field
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: TextFormField(
                  controller: passwordCtrl,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: 'Contraseña',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(obscureText
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () =>
                          setState(() => obscureText = !obscureText),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  validator: (value) =>
                      value!.isEmpty ? 'Ingresa tu contraseña' : null,
                ),
              ),
              const SizedBox(height: 16),

              // Error message
              if (errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                ),

              // Login Button
              GestureDetector(
                onTap: isLoading ? null : login,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                        offset: Offset(0, 4),
                      )
                    ],
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
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

              // Extra
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
                    child: Text(
                      "Crear cuenta",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
