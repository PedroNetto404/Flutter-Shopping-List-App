import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-item-actions-trailing.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-item-subtitle.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-toggle-item-purchase-checkbox.dart';
import '../../models/shopping-item.dart';

class ShoppingListDetailsItemCard extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const ShoppingListDetailsItemCard({super.key, required this.item, required this.listId});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(item.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          leading: ShoppingListDetailsToggleItemPurchaseLeading(
              listId: listId, item: item),
          subtitle: ShoppingListDetailsItemSubtitle(item: item),
          trailing: ShoppingListDetailsItemActionsTrailing(
              listId: listId, item: item),
        ),
      );
}
