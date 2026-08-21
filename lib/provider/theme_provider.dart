import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  // Color institucional de la aplicación (rojo)
  final Color _color = const Color(0xFFD32F2F);

  ThemeMode _themeMode = ThemeMode.system;
  double _textScale = 1.0;

  Color get color => _color;
  ThemeMode get themeMode => _themeMode;
  double get textScale => _textScale;

  ThemeProvider() {
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Cargar modo de tema
    final modoGuardado = prefs.getString('themeMode');
    if (modoGuardado != null) {
      switch (modoGuardado) {
        case 'light':
          _themeMode = ThemeMode.light;
          break;
        case 'dark':
          _themeMode = ThemeMode.dark;
          break;
        default:
          _themeMode = ThemeMode.system;
      }
    }

    // Cargar tamaño del texto
    _textScale = prefs.getDouble('textScale') ?? 1.0;

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    String modeString;
    switch (mode) {
      case ThemeMode.light:
        modeString = 'light';
        break;
      case ThemeMode.dark:
        modeString = 'dark';
        break;
      case ThemeMode.system:
      default:
        modeString = 'system';
    }

    await prefs.setString('themeMode', modeString);
  }

  Future<void> setTextScale(double scale) async {
    _textScale = scale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textScale', scale);
  }

  /// Restablece el tamaño del texto al valor por defecto.
  Future<void> resetTextScale() async {
    _textScale = 1.0;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('textScale', 1.0);
  }
}