import 'package:flutter/material.dart';

final ThemeData softBlueTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF2196F3),
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(0xFFF5F9FC), // Background putih kebiruan
  // App Bar Theme
  appBarTheme: const AppBarTheme(
    centerTitle: false,
    elevation: 0,
    color: Colors.transparent,
    iconTheme: IconThemeData(color: Color(0xFF2196F3)),
    titleTextStyle: TextStyle(
      color: Color(0xFF2C3E50),
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),

  // Card Theme
  cardTheme: CardTheme(
    elevation: 2,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    color: Colors.white,
    shadowColor: Colors.black.withValues(alpha: 0.1),
  ),

  // Floating Action Button Theme
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color(0xFF2196F3),
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    extendedTextStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 16,
    ),
  ),

  // Input Decoration Theme
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.grey[50],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE0E0E0)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF2196F3), width: 2),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    labelStyle: TextStyle(color: Colors.grey[700]),
  ),

  // Checkbox Theme
  checkboxTheme: CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
      if (states.contains(WidgetState.selected)) {
        return const Color(0xFF2196F3);
      }
      return Colors.transparent;
    }),
  ),

  // Navigation Bar Theme
  navigationBarTheme: NavigationBarThemeData(
    backgroundColor: Colors.white,
    elevation: 3,
    indicatorColor: const Color(0xFF2196F3).withValues(alpha: 0.15),
    labelTextStyle: WidgetStateProperty.all(
      const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
    ),
    iconTheme: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return const IconThemeData(color: Color(0xFF2196F3));
      }
      return const IconThemeData(color: Colors.grey);
    }),
  ),

  // Text Theme
  textTheme: const TextTheme(
    headlineLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    headlineMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Color(0xFF2C3E50),
    ),
    bodyLarge: TextStyle(fontSize: 16, color: Color(0xFF2C3E50)),
    bodyMedium: TextStyle(fontSize: 14, color: Color(0xFF2C3E50)),
    bodySmall: TextStyle(fontSize: 12, color: Color(0xFF2C3E50)),
  ),

  // Elevated Button Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFF2196F3),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
    ),
  ),

  // Divider Theme
  dividerTheme: DividerThemeData(
    space: 16,
    thickness: 1,
    color: Colors.grey[200],
  ),

  // Snackbar Theme
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color(0xFF323232),
    contentTextStyle: const TextStyle(color: Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    behavior: SnackBarBehavior.floating,
  ),

  // List Tile Theme
  listTileTheme: const ListTileThemeData(
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    minLeadingWidth: 0,
    minVerticalPadding: 16,
  ),
);
