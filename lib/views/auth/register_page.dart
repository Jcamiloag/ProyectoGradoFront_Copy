import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sign_in_button/sign_in_button.dart';
import 'package:hola_mundo/services/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final bool isTabMode;

  const RegisterPage({super.key, this.isTabMode = false});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final lastNameCtrl = TextEditingController();
  final usernameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool isLoading = false;
  bool obscureText = true;
  String? errorMessage;

  void register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    final result = await AuthService().register(
      name: nameCtrl.text.trim(),
      lastName: lastNameCtrl.text.trim(),
      username: usernameCtrl.text.trim(),
      phone: phoneCtrl.text.trim(),
      email: emailCtrl.text.trim(),
      password: passwordCtrl.text.trim(),
    );

    setState(() => isLoading = false);

    if (result['success']) {
      if (!mounted) return;
      context.go('/establecimientos');
    } else {
      setState(() {
        errorMessage = result['message'] ?? 'Error al registrarse';
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
              const Text("Crear cuenta",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text("Completa el formulario para registrarte."),
              const SizedBox(height: 24),

              TextFormField(
                controller: nameCtrl,
                decoration: _inputDecoration("Nombres"),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu nombre' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: lastNameCtrl,
                decoration: _inputDecoration("Apellidos"),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tus apellidos' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: usernameCtrl,
                decoration: _inputDecoration("Nombre de usuario"),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa un nombre de usuario' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: _inputDecoration("Teléfono"),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu número de teléfono' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: emailCtrl,
                decoration: _inputDecoration("Email"),
                validator: (value) =>
                    value!.isEmpty ? 'Ingresa tu correo' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: passwordCtrl,
                obscureText: obscureText,
                decoration: _inputDecoration("Contraseña").copyWith(
                  suffixIcon: IconButton(
                    icon: Icon(obscureText
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () =>
                        setState(() => obscureText = !obscureText),
                  ),
                ),
                validator: (value) => value!.length < 6
                    ? 'La contraseña debe tener al menos 6 caracteres'
                    : null,
              ),
              const SizedBox(height: 24),

              if (errorMessage != null)
                Text(errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 8),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                onPressed: isLoading ? null : register,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Registrarse",
                        style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(height: 24),

              const Text("O regístrate con"),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20),
    );
  }
}
