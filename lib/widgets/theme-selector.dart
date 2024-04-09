import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context)  => Consumer<ShoppingListController>(
    builder: (context, themeController, child) => Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.circular(50),
      ),
      child: IconButton(
        icon: Icon(
            color: themeController.currentTheme == ThemeMode.light
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary,
            themeController.currentTheme == ThemeMode.light
            ? Icons.dark_mode
            : Icons.light_mode),
        onPressed: () => themeController.toggleTheme(),
      ),
    ),
  );
}
