import 'package:flutter/material.dart';

final ThemeData sageGreenTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFFB2C8B2), // Warna hijau sage (soft green)
    brightness: Brightness.light,
  ),
  scaffoldBackgroundColor: const Color(
    0xFFF8F9F4,
  ), // Background putih kehijauan
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFB2C8B2),
    foregroundColor: Colors.white,
    elevation: 0,
  ),
  textTheme: const TextTheme(bodyMedium: TextStyle(color: Color(0xFF3D4A3D))),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFB2C8B2), // Hijau sage
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    ),
  ),
  useMaterial3: true,
);
