import 'package:flutter/material.dart';

class ShoppingListNameSearchField extends StatelessWidget {
  final Function(String) onChanged;

  const ShoppingListNameSearchField({super.key, required this.onChanged});

  @override
  Widget build(BuildContext context) => Expanded(
    child: TextField(
          onChanged: onChanged,
          decoration: const InputDecoration(
              labelText: 'Buscar lista', prefixIcon: Icon(Icons.search)),
        ),
  );
}
