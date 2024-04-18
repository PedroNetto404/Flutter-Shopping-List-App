import 'package:flutter/material.dart';

import '../providers/providers.dart';
import '../constants/constants.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider provider, Widget? child) =>
          Switch(
              activeThumbImage: const AssetImage('assets/images/moon.png'),
              inactiveThumbImage: const AssetImage('assets/images/sun.png'),
              value: provider.currentTheme == CustomTheme.darkTheme ? true : false,
              onChanged: (_) => provider.toggleTheme()));
}
