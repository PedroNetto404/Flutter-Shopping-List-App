import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-list-dialog.dart';
import 'package:provider/provider.dart';
import '../contants/routes.dart';
import '../controllers/shopping-list-controller.dart';
import '../models/shopping-list.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCard({required this.list, super.key});

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          onTap: () {
            Navigator.pushNamed(context, Routes.shoppingListDetails,
                arguments: list.id);
          },
          title: Text(list.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          leading: _buildLeadingCheckbox(context),
          subtitle: _buildListInfoSubtitle(context),
          trailing: _buildActionButtons(context)));

  Widget _buildActionButtons(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) =>
                      ShoppingListDialog.updateList(list: list)),
              icon: const Icon(Icons.edit)),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              showDialog(
                  context: context, builder: _buildDeleteConfirmationDialog);
            },
          ),
          //Enter in list
          IconButton(
            icon: const Icon(Icons.arrow_forward),
            onPressed: () {
              Navigator.pushNamed(context, Routes.shoppingListDetails,
                  arguments: list.id);
            },
          ),
        ],
      );

  Widget _buildLeadingCheckbox(BuildContext context) => Checkbox(
        value: list.completed,
        onChanged: (value) {
          var provider = context.read<ShoppingListController>();
          if (value!) {
            provider.completeShoppingList(list.id);
          } else {
            provider.resetShoppingList(list.id);
          }
        },
      );

  Widget _buildListInfoSubtitle(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 16),
              const SizedBox(width: 4),
              Text(
                  '${list.createdAt.day.toString().padLeft(2, '0')}/${list.createdAt.month.toString().padLeft(2, '0')}/${list.createdAt.year}'),
            ],
          ),
          Row(
            children: [
              const Icon(Icons.shopping_cart, size: 16),
              const SizedBox(width: 4),
              list.completed
                  ? const Text('Concluída')
                  : Text(
                      '${list.items.where((element) => !element.purchased).length} / ${list.items.length}'),
            ],
          )
        ],
      );

  Widget _buildDeleteConfirmationDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Excluir lista de compras'),
      content: Text(
          'Tem certeza que deseja excluir a lista de compras "${list.name}"?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: () {
            var controller = context.read<ShoppingListController>();
            controller.removeShoppingList(list.id);
            Navigator.pop(context);
          },
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
