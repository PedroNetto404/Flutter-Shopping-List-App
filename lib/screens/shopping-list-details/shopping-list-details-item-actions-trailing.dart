
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-item.dart';
import '../../widgets/delete-confirmation-dialog.dart';
import 'shopping-list-details-item-dialog.dart';

class ShoppingListDetailsItemActionsTrailing extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const ShoppingListDetailsItemActionsTrailing(
      {super.key, required this.listId, required this.item});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: const Icon(Icons.edit),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ShoppingListDetailsItemDialog.updateItem(
              listId: listId,
              listItemId: item.id,
            ),
          );
        },
      ),
      IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () => _onDeletePressed(context)),
    ],
  );

  void _onDeletePressed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
        title: 'Remover item',
        content: 'Deseja remover o item ${item.name}?',
        onConfirm: () => _onDeleteConfirmed(context),
      ));

  void _onDeleteConfirmed(BuildContext context) {
    var controller = context.read<ShoppingListController>();
    controller.removeItemFromShoppingList(listId: listId, itemId: item.id);
  }
}


