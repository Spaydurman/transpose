import 'package:flutter/material.dart';

/// Application theme configuration
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  /// Primary color seed for the app
  static const Color _primarySeed = Color(0xFF6366F1);

  /// Light theme surface colors
  static const Color _lightSurface = Color(0xFFFAFAFA);
  static const Color _lightSurfaceVariant = Color(0xFFE5E7EB);

  /// Dark theme surface colors
  static const Color _darkSurface = Color(0xFF1A1A1A);
  static const Color _darkSurfaceVariant = Color(0xFF2D2D2D);

  /// Light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: _primarySeed,
            brightness: Brightness.light,
          ).copyWith(
            surface: _lightSurface,
            surfaceContainerHighest: _lightSurfaceVariant,
          ),
      cardTheme: CardThemeData(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }

  /// Dark theme configuration
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme:
          ColorScheme.fromSeed(
            seedColor: _primarySeed,
            brightness: Brightness.dark,
          ).copyWith(
            surface: _darkSurface,
            surfaceContainerHighest: _darkSurfaceVariant,
          ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
    );
  }
}
