import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/theme_notifier.dart';
import 'screens/song_list_screen.dart';

void main() {
  runApp(const MyApp());
}

/// Main application widget
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ThemeNotifier _themeNotifier = ThemeNotifier();

  @override
  void dispose() {
    _themeNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeNotifier,
      builder: (context, _) {
        return MaterialApp(
          title: 'Chord Master',
          debugShowCheckedModeBanner: false,
          themeMode: _themeNotifier.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          home: SongListScreen(themeNotifier: _themeNotifier),
        );
      },
    );
  }
}
