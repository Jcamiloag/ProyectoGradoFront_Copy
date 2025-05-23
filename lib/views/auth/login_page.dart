import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
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
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text("Iniciar sesión",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 8),
              const Text(
                "Comencemos completando el formulario a continuación.",
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: emailCtrl,
                style: const TextStyle(color: Colors.black), // Texto campo
                decoration: InputDecoration(
                  hintText: 'Nombre de usuario',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu nombre de usuario' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: passwordCtrl,
                style: const TextStyle(color: Colors.black), // Texto campo
                obscureText: obscureText,
                decoration: InputDecoration(
                  hintText: 'Contraseña',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  suffixIcon: IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: () =>
                        setState(() => obscureText = !obscureText),
                  ),
                ),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu contraseña' : null,
                    
              ),
              const SizedBox(height: 24),
              if (errorMessage != null)
                Text(errorMessage!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: isLoading ? null : login,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Ingresar",
                        style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),
              const Text("Or sign up with"),
              const SizedBox(height: 12),
              SignInButton(Buttons.google, onPressed: () {}),
              const SizedBox(height: 8),
              SignInButton(Buttons.apple, onPressed: () {}),
            ],
          ),
        ),
      ),
    );
  }
}
