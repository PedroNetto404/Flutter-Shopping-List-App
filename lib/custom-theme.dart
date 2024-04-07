import 'package:flutter/material.dart';

class CustomTheme {
  static const InputDecorationTheme _inputDecorationTheme = InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.orange), // Laranja
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(255, 255, 255, 1.0)), // Branco com 50% de opacidade
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.orange, // Laranja
      foregroundColor: Colors.black,
      textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

  static ThemeData get theme {
    return ThemeData(
      iconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.dark(
        background: Colors.black12,
        primary: Colors.orange, // Laranja
        secondary: Colors.orange.withOpacity(0.5), // Laranja com 50% de opacidade
      ),
      elevatedButtonTheme: _elevatedButtonTheme,
      appBarTheme: AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      listTileTheme: ListTileThemeData(
        textColor: Colors.white,
        tileColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      inputDecorationTheme: _inputDecorationTheme,
    );
  }
}
