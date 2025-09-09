import 'package:flutter/material.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:hola_mundo/services/user_service.dart';

class ProfileEditView extends StatefulWidget {
  final User user;

  const ProfileEditView({super.key, required this.user});

  @override
  State<ProfileEditView> createState() => _ProfileEditViewState();
}

class _ProfileEditViewState extends State<ProfileEditView> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: '${widget.user.firstname} ${widget.user.lastname}'.trim());
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phonenumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      List<String> names = _nameController.text.trim().split(' ');
      String firstName = names.isNotEmpty ? names[0] : '';
      String lastName = names.length > 1 ? names.sublist(1).join(' ') : '';

      User updatedUser = User(
        id: widget.user.id,
        username: widget.user.username,
        firstname: firstName,
        lastname: lastName,
        email: _emailController.text.trim(),
        phonenumber: _phoneController.text.trim(),
        role: widget.user.role,
      );

      bool success = await _userService.updateUserProfile(updatedUser);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cambios guardados correctamente')),
        );
        Navigator.pop(context, updatedUser); // Devuelve el usuario actualizado
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al guardar los cambios')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Nombre completo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Correo'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Número telefónico'),
                validator: (value) => value == null || value.isEmpty ? 'Campo requerido' : null,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveChanges,
                child: const Text('Guardar cambios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}