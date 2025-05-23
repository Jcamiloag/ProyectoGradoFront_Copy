import 'package:flutter/material.dart';
import 'package:hola_mundo/models/user.dart';
import 'package:hola_mundo/services/user_service.dart';
import 'package:hola_mundo/views/base_view.dart';
import 'package:hola_mundo/views/profile_edit_view.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  final UserService _userService = UserService();
  User? _user;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    try {
      final user = await _userService.fetchUserProfile();
      setState(() {
        _user = user;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Error al cargar perfil: $e';
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      title: 'Perfil',
      initialIndex: 0,
      length: 1,
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: 140,
                        child: Stack(
                          children: [
                            Align(
                              alignment: const Alignment(0, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                  width: 100,
                                  height: 100,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(50),
                                      child: Image.network(
                                        'https://images.unsplash.com/photo-1633332755192-727a05c4013d?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8dXNlcnxlbnwwfHwwfHw%3D&auto=format&fit=crop&w=900&q=60',
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Align(
                              alignment: const Alignment(1, 0),
                              child: Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 4,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 16, 0, 12),
                        child: Text(
                          '${_user!.firstname} ${_user!.lastname}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 22, 22),
                          ),
                        ),
                      ),
                      Text(
                        _user!.email,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Container(
                                    width: 44,
                                    height: 44,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.people_alt_sharp,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  const Text(
                                    'Activo / Inactivo',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 3,
                              color: Color(0x33000000),
                              offset: Offset(0, -1),
                            )
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Configuración',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildOptionRow(
                                icon: Icons.numbers_sharp,
                                title: 'Número Telefónico',
                                action: _user!.phonenumber.isEmpty
                                    ? 'Añadir'
                                    : _user!.phonenumber,
                              ),
                              _buildOptionRow(
                                icon: Icons.person,
                                title: 'Número de identificación',
                                action: '1006333556', // Cambia si tienes dato real
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileEditView(user: _user!),
                                    ),
                                  );
                                  if (result != null && result is User) {
                                    setState(() {
                                      _user = result;
                                    });
                                  }
                                },
                                child: _buildOptionRow(
                                  icon: Icons.edit_rounded,
                                  title: 'Perfil',
                                  action: 'Editar Perfil',
                                ),
                              ),
                              _buildOptionRow(
                                icon: Icons.notifications_active,
                                title: 'Configuración de notificaciones',
                                showChevron: true,
                              ),
                              _buildOptionRow(
                                icon: Icons.logout_rounded,
                                title: 'Cerrar sesión',
                                action: '¿Salir?',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOptionRow({
    required IconData icon,
    required String title,
    String? action,
    bool showChevron = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 16, 8),
            child: Icon(
              icon,
              color: Colors.grey,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
          ),
          if (action != null)
            Text(
              action,
              style: const TextStyle(
                color: Color(0xFF1A6CAB),
                fontSize: 14,
              ),
            ),
          if (showChevron)
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.grey,
              size: 24,
            ),
        ],
      ),
    );
  }
}
