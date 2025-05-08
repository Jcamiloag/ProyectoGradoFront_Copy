import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  Color _color = const Color.fromARGB(255, 20, 83, 165);
  ThemeMode _themeMode = ThemeMode.system;

  Color get color => _color;
  ThemeMode get themeMode => _themeMode;

  ThemeProvider() {
    _loadPreferences(); // Carga tanto color como modo de tema
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    // Carga color
    final colorGuardado = prefs.getString('color');
    if (colorGuardado != null) {
      _color = Color(int.parse(colorGuardado));
    }

    // Carga modo de tema
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

    notifyListeners();
  }

  Future<void> setColor(Color newColor) async {
    _color = newColor;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('color', newColor.value.toString());
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
}


