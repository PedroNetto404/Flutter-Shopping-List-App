import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/controllers/theme-controller.dart';
import 'package:provider/provider.dart';

class ThemeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
        Consumer<ThemeController>(builder: (BuildContext context, ThemeController value, Widget? child) {
          return PopupMenuButton<ThemeMode>(
            onSelected: (ThemeMode mode) {
              value.currentTheme = mode;
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: ThemeMode.system,
                child: Text('System Theme'),
              ),
              const PopupMenuItem(
                value: ThemeMode.light,
                child: Text('Light Theme'),
              ),
              const PopupMenuItem(
                value: ThemeMode.dark,
                child: Text('Dark Theme'),
              ),
            ],
          );
        },);
}