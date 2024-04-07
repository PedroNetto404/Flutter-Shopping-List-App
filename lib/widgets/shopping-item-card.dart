import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-item-dialog.dart';
import 'package:provider/provider.dart';

import '../controllers/shopping-list-controller.dart';
import '../models/shopping-item.dart';

class ShoppingItemCard extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const ShoppingItemCard({super.key, required this.item, required this.listId});

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
      leading: _buildToggleItemBuyedCheckbox(context),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.shopping_cart, size: 16),
              const SizedBox(width: 4),
              Text(
                  '${item.quantity} ${item.unityType.toString().split('.').last}'),
            ],
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const Icon(Icons.category_outlined, size: 16),
              const SizedBox(width: 4),
              Text(item.category),
            ],
          ),
        ],
      ),
      trailing: _buildActionButtons(context),
    ),
  );

  Widget _buildActionButtons(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ShoppingItemDialog.updateItem(
              listId: listId,
              listItemId: item.id,
            ),
          );
        },
      ),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            var controller = context.read<ShoppingListController>();
            controller.removeItemFromShoppingList(
                listId: listId, itemId: item.id);
          })
    ],
  );

  Widget _buildToggleItemBuyedCheckbox(BuildContext context) => Checkbox(
    value: item.purchased,
    onChanged: (value) => context
        .read<ShoppingListController>()
        .toggleItemPurchase(listId, item.id),
  );
}