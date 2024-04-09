import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode currentTheme = ThemeMode.system;

  void toggleTheme() {
    currentTheme =
        currentTheme == ThemeMode.light
            ? ThemeMode.dark
            : ThemeMode.light;
    notifyListeners();
  }
}
