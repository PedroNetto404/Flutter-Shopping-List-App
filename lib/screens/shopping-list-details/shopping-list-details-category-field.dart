import 'package:flutter/material.dart';

class ShoppingListDetailsCategoryField extends StatelessWidget {
  final TextEditingController controller;

  const ShoppingListDetailsCategoryField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Categoria',
            hintText: 'Digite a categoria do item',
            prefixIcon: Icon(Icons.category),
          ),
        ),
      );
}
