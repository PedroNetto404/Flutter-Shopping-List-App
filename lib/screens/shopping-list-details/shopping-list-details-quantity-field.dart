import 'package:flutter/material.dart';

class ShoppingListDetailsQuantityField extends StatelessWidget {
  final TextEditingController controller;

  const ShoppingListDetailsQuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(8.0),
    child: TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      validator: _validateQuantity,
      decoration: InputDecoration(
          labelText: 'Quantidade',
          hintText: 'Digite a quantidade do item',
          prefixIcon: const Icon(Icons.format_list_numbered),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _circleButton(Icons.remove, Colors.red, _onDecrement),
              _circleButton(Icons.add, Colors.green, _onIncrement),
            ],
          )),
    ),
  );

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Quantidade é obrigatória';
    if (double.tryParse(value) == null) return 'Quantidade inválida';
    return null;
  }

  void _onIncrement() {
    var value = (double.tryParse(controller.text) ?? 0) + 1;
    controller.text = value.toStringAsFixed(3);
  }

  void _onDecrement() {
    var value = (double.tryParse(controller.text) ?? 0) - 1;
    if (value == 0) return;

    controller.text = value.toStringAsFixed(3);
  }

  Widget _circleButton(IconData icon, Color color, void Function() onPressed) =>
      IconButton(
          icon: Icon(icon),
          onPressed: onPressed,
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(color),
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ));
}
