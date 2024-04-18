import 'package:flutter/material.dart';

import '../constants/constants.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _theme = CustomTheme.darkTheme;

  ThemeData get currentTheme => _theme;

  void toggleTheme() {
    _theme = _theme == CustomTheme.darkTheme
        ? CustomTheme.lightTheme
        : CustomTheme.darkTheme;
    notifyListeners();
  }
}


