import 'package:flutter/material.dart';

import '../../models/shopping-list.dart';

class ShoppingListDetailsInfoSection extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListDetailsInfoSection({super.key, required this.list});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Itens pendentes: ${list.items.where((e) => !e.purchased).length}'),
                  const SizedBox(width: 16),
                  Text(
                      'Itens comprados: ${list.items.where((element) => element.purchased).length}'),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );
}
