import 'package:flutter/material.dart';
import 'package:hola_mundo/services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _initialized = false;
  bool _loggedIn = false;

  bool get initialized => _initialized;
  bool get loggedIn => _loggedIn;

  Future<void> loadSession() async {
    final token = await AuthService().getToken();

    _loggedIn = token != null && token.isNotEmpty;
    _initialized = true;

    notifyListeners();
  }

  void login() {
    _loggedIn = true;
    notifyListeners();
  }

  void logout() {
    _loggedIn = false;
    notifyListeners();
  }
}