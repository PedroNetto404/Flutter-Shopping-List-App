import 'package:flutter/material.dart';

class CustomTheme {
  static const InputDecorationTheme _inputDecorationTheme =
      InputDecorationTheme(
    labelStyle: TextStyle(color: Colors.white),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(206, 83, 83, 1)),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Color.fromRGBO(87, 87, 87, 0.498)),
    ),
  );

  static final ElevatedButtonThemeData _elevatedButtonTheme =
      ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
    backgroundColor: const Color.fromRGBO(206, 83, 83, 1),
    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
    textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
  ));

  static ThemeData get theme {
    return ThemeData(
        iconTheme: const IconThemeData(color: Colors.white),
        colorScheme: const ColorScheme.dark(
          background: Color.fromRGBO(50, 50, 50, 1),
          primary: Color.fromRGBO(206, 83, 83, 1),
          secondary: Color.fromRGBO(87, 87, 87, 0.498),
        ),
        elevatedButtonTheme: _elevatedButtonTheme,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromRGBO(206, 83, 83, 1),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        inputDecorationTheme: _inputDecorationTheme);
  }
}
