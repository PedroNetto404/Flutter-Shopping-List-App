import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/providers/theme-provider.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context) => Selector<ThemeProvider, ThemeMode>(
        builder: (context, themeMode, child) => Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.background,
            borderRadius: BorderRadius.circular(50),
          ),
          child: IconButton(
            icon: Icon(
                color: themeMode == ThemeMode.light
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.secondary,
                themeMode == ThemeMode.light
                    ? Icons.dark_mode
                    : Icons.light_mode),
            onPressed: () => context.read<ThemeProvider>().toggleTheme(),
          ),
        ),
        selector: (context, provider) => provider.themeMode,
      );
}
