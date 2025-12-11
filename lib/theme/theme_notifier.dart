import 'package:flutter/material.dart';

/// Manages the app's theme mode (light/dark)
class ThemeNotifier extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.dark;

  /// Current theme mode
  ThemeMode get themeMode => _themeMode;

  /// Check if current theme is dark mode
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// Toggle between light and dark mode
  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  /// Set specific theme mode
  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      notifyListeners();
    }
  }
}
