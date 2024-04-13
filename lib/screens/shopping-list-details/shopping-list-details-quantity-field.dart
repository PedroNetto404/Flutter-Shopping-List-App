import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/circle-button.dart';

class ShoppingListDetailsQuantityField extends StatelessWidget {
  final TextEditingController controller;

  const ShoppingListDetailsQuantityField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          keyboardType: TextInputType.number,
          onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
          validator: _validateQuantity,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              labelText: 'Quantidade',
              hintText: 'Digite a quantidade do item',
              prefixIcon: const Icon(Icons.format_list_numbered),
              suffixIcon: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleButton(
                        icon: const Icon(Icons.remove),
                        color: Colors.red,
                        onPressed: _onDecrement),
                    CircleButton(
                        icon: const Icon(Icons.add),
                        color: Colors.green,
                        onPressed: _onIncrement),
                  ],
                ),
              )),
        ),
      );

  String? _validateQuantity(String? value) {
    if (value == null || value.isEmpty) return 'Quantidade é obrigatória';

    final quantity = double.tryParse(value);
    if (quantity == null) return 'Quantidade inválida';

    if (quantity <= 0) return 'Quantidade deve ser maior que zero';

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
}
