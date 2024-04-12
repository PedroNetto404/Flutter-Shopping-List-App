import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-item.dart';

class ShoppingListDetailsToggleItemPurchaseLeading extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const ShoppingListDetailsToggleItemPurchaseLeading(
      {super.key, required this.listId, required this.item});

  @override
  Widget build(BuildContext context) => Checkbox(
        value: item.purchased,
        onChanged: (value) => context
            .read<ShoppingListController>()
            .toggleItemPurchase(listId, item.id),
      );
}
