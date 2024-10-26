import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/scheduler.dart';

class UiProvider extends ChangeNotifier {
  bool _isDark = false;
  bool get isDark => _isDark;

  late SharedPreferences storage;

  // Custom dark theme
  final darkTheme = ThemeData(
    primaryColor: Colors.black,
    brightness: Brightness.dark,
    primaryColorDark: Colors.black,
    colorScheme: const ColorScheme.dark(
      primary: Colors.blue, // Accent color
      secondary: Colors.blue, // Accent for FAB and others
      brightness: Brightness.dark, // Ensure brightness matches
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.white),
      headlineMedium: TextStyle(color: Colors.white),
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.black,
      hintStyle: TextStyle(color: Colors.white),
      labelStyle: TextStyle(color: Colors.white),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.white),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue, // Blue FAB color
    ),
  );

// Custom light theme
  final lightTheme = ThemeData(
    primaryColor: Colors.white,
    brightness: Brightness.light,
    primaryColorDark: Colors.white,
    colorScheme: const ColorScheme.light(
      primary: Colors.blue, // Accent color
      secondary: Colors.blue, // Accent for FAB and others
      brightness: Brightness.light, // Ensure brightness matches
    ),
    textTheme: const TextTheme(
      titleLarge: TextStyle(color: Colors.black),
      headlineMedium: TextStyle(color: Colors.black),
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      hintStyle: TextStyle(color: Colors.black),
      labelStyle: TextStyle(color: Colors.black),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Colors.blue, // Blue FAB color
    ),
  );

  // Init method of provider
  Future<void> init() async {
    storage = await SharedPreferences.getInstance();
    _isDark = storage.getBool("isDark") ?? false;

    // Use SchedulerBinding to detect system brightness setting
    final brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    _isDark = brightness == Brightness.dark;

    notifyListeners();
  }

  //Dark mode toggle action
  void changeTheme() {
    _isDark = !_isDark;
    storage.setBool("isDark", _isDark);
    notifyListeners();
  }
}
