import 'package:flutter/material.dart';
import '../providers/providers.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ThemeProvider>(
      builder: (BuildContext context, ThemeProvider provider, Widget? child) =>
          Switch(
              activeThumbImage: const AssetImage('assets/images/moon.png'),
              inactiveThumbImage: const AssetImage(
                  'assets/images/sun.png'), //TODO: o sol está com uma borda cinza. Procurar outra imagem
              value: provider.themeMode == ThemeMode.dark,
              onChanged: (_) => provider.toggleTheme()));
}
