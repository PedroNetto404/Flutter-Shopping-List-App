import 'package:flutter/material.dart';

import '../../models/shopping-list.dart';

class ShoppingListsInfoSection extends StatelessWidget {
  final List<ShoppingList> lists;

  const ShoppingListsInfoSection({super.key, required this.lists});

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
                      'Total de listas pendentes: ${lists.where((element) => !element.completed).length}'),
                  Text('Total de listas: ${lists.length}')
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );
}
