import 'package:flutter/material.dart';

class ShoppingListDetailsNameField extends StatelessWidget {
  final TextEditingController controller;

  const ShoppingListDetailsNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Nome',
            hintText: 'Digite o nome do item',
            prefixIcon: Icon(Icons.shopping_cart),
          ),
          validator: _validateName,
        ),
      );

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) return 'Nome do item é obrigatório';
    return null;
  }
}
