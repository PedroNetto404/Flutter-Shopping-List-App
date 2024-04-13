import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-list.dart';

class ShoppingListDetailsMarkAllItemsButton extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListDetailsMarkAllItemsButton({super.key, required this.list});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Checkbox(
              value: list.completed,
              onChanged: (value) {
                var provider = context.read<ShoppingListProvider>();
                value!
                    ? provider.completeShoppingList(list.id)
                    : provider.resetShoppingList(list.id);
              }),
          const SizedBox(width: 8),
          Text(
              'Marcar todos os itens como ${list.completed ? 'pendentes' : 'comprados'}'),
        ],
      );
}
