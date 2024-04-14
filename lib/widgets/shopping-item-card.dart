import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import '../providers/shopping-list-provider.dart';
import '../models/shopping-item.dart';
import 'delete-confirmation-dialog.dart';
import 'info-with-icon.dart';
import 'shopping-item-dialog.dart';

class ShoppingItemCard extends StatelessWidget {
  final String listId;
  final ShoppingItem item;

  const ShoppingItemCard({super.key, required this.item, required this.listId});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(item.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          leading: Checkbox(
              value: item.purchased,
              onChanged: (_) => _onTogglePurchasePressed(context)),
          subtitle: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: InfoWithIcon(
                  icon: Icons.shopping_bag,
                  info:
                      '${item.quantity.toStringAsFixed(3)} ${item.unityType.toString().split('.').last.toUpperCase()}',
                ),
              ),
              if (item.category.isNotEmpty)
                Expanded(
                  child: InfoWithIcon(
                    icon: Icons.category,
                    info: item.category,
                  ),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () => _onEditPressed(context),
              ),
              IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _onDeletePressed(context)),
            ],
          ),
        ),
      );

  void _onDeletePressed(BuildContext context) => showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
            title: 'Remover item',
            content: 'Tem certeza que seja remover o item "${item.name}"?',
            onConfirm: () => _onDeleteConfirmed(context),
          ));

  void _onDeleteConfirmed(BuildContext context) {
    var controller = context.read<ShoppingListProvider>();
    controller.removeItemFromShoppingList(listId: listId, itemName: item.name);
  }

  void _onEditPressed(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) =>
          ShoppingItemDialog.updateItem(listId: listId, itemName: item.name),
    );
  }

  void _onTogglePurchasePressed(BuildContext context) {
    var provider = context.read<ShoppingListProvider>();
    provider.toggleItemPurchase(listId, item.name);

    if(provider.getList(listId).completed){
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.check, color: Colors.green),
              SizedBox(width: 8),
              Text('Lista concluída'),
            ],
          ),
          content: const Text('Todos os itens foram marcados como comprados.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
