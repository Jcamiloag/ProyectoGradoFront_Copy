import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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

    try {
      final result = await AuthService().register(
        username: usernameCtrl.text.trim(),
        name: nameCtrl.text.trim(),
        last_Name: lastNameCtrl.text.trim(),
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
        phone: phoneCtrl.text.trim(),
      );

      setState(() => isLoading = false);

      if (result['success']) {
        if (!mounted) return;
        await Future.delayed(const Duration(milliseconds: 500));
        if (!mounted) return;
        context.go('/');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registro exitoso')),
        );
      } else {
        setState(() {
          errorMessage = result['message'] ?? 'Error al registrarse';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error inesperado: $e';
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
              const Text(
                "Hola!",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                "Únete a Farfala y comienza tu transformación",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 32),

              _buildTextField(
                controller: nameCtrl,
                icon: Icons.person_outline,
                hint: "Nombre",
                validator: (v) =>
                    v!.isEmpty ? "Por favor ingresa tu nombre" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: lastNameCtrl,
                icon: Icons.person_outline,
                hint: "Apellido",
                validator: (v) =>
                    v!.isEmpty ? "Por favor ingresa tu apellido" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: usernameCtrl,
                icon: Icons.account_circle_outlined,
                hint: "Nombre de usuario",
                validator: (v) =>
                    v!.isEmpty ? "Por favor ingresa tu nombre de Usuario" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: phoneCtrl,
                icon: Icons.phone_outlined,
                hint: "Teléfono",
                inputType: TextInputType.phone,
                validator: (v) =>
                    v!.isEmpty ? "Por favor ingresa tu número telefonico" : null,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: emailCtrl,
                icon: Icons.mail_outline,
                hint: "Email",
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Por favor ingresa tu Email";
                  }
                  final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                  if (!emailRegex.hasMatch(v)) {
                    return "Ingresa un correo electrónico válido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: passwordCtrl,
                icon: Icons.lock_outline,
                hint: "Contraseña",
                obscure: obscureText,
                suffixIcon: IconButton(
                  icon: Icon(obscureText
                      ? Icons.visibility_off
                      : Icons.visibility),
                  onPressed: () =>
                      setState(() => obscureText = !obscureText),
                ),
                validator: (v) => v!.length < 6
                    ? "La contraseña debe tener al menos 6 caracteres"
                    : null,
              ),
              const SizedBox(height: 24),

              if (errorMessage != null)
                Text(errorMessage!,
                    style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),

              // Register button
              GestureDetector(
                onTap: isLoading ? null : register,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    gradient: const LinearGradient(
                      colors: [Colors.redAccent, Colors.red],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withOpacity(0.4),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      )
                    ],
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "REGISTRARSE",
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
                  const Text("¿Ya tienes una cuenta? "),
                  GestureDetector(
                    onTap: () {
                      if (!widget.isTabMode) {
                        context.go('/login');
                      } else {
                        DefaultTabController.of(context).animateTo(0);
                      }
                    },
                    child: Text(
                      "Iniciar sesión",
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

  Widget _buildTextField({
    required TextEditingController controller,
    required IconData icon,
    required String hint,
    String? Function(String?)? validator,
    TextInputType inputType = TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, 2),
          )
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        obscureText: obscure,
        validator: validator,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          suffixIcon: suffixIcon,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }
}
