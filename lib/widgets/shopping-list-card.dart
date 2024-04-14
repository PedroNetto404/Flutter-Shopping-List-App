import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app-route.dart';
import '../providers/shopping-list-provider.dart';
import '../models/shopping-list.dart';
import 'circle-button.dart';
import 'delete-confirmation-dialog.dart';
import 'info-with-icon.dart';
import 'shopping-list-dialog.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCard({required this.list, super.key});

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          onTap: () => _goToShoppingListDetails(context),
          title: Text(list.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          leading: list.items.isNotEmpty
              ? Checkbox(
                  value: list.completed,
                  onChanged: (value) => _onCheckboxTap(context),
                )
              : CircleButton(
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.background),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () => _goToShoppingListDetails(context)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoWithIcon(
                icon: Icons.calendar_today,
                info:
                    '${list.createdAt.day.toString().padLeft(2, '0')}/${list.createdAt.month.toString().padLeft(2, '0')}/${list.createdAt.year}',
              ),
              InfoWithIcon(
                icon: Icons.shopping_cart,
                info: list.items.isEmpty
                    ? 'Vazia'
                    : list.completed
                        ? 'Concluída'
                        : '${list.items.where((element) => !element.purchased).length} / ${list.items.length}',
              ),
            ],
          ),
          trailing: Row(
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
                      context: context,
                      builder: (context) => DeleteConfirmationDialog(
                            title: 'Excluir Lista',
                            content:
                                'Tem certeza que deseja excluir a lista de compras "${list.name}"?',
                            onConfirm: () => _onConfirmDelete(context),
                          ));
                },
              ),
              //Enter in list
              IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () => _goToShoppingListDetails(context)),
            ],
          )));

  void _onCheckboxTap(BuildContext context) {
    var provider = context.read<ShoppingListProvider>();

    if (list.completed) {
      provider.resetShoppingList(list.id);
    } else {
      provider.completeShoppingList(list.id);
    }
  }

  void _onConfirmDelete(BuildContext context) =>
      context.read<ShoppingListProvider>().removeShoppingList(list.id);

  void _goToShoppingListDetails(BuildContext context) =>
      AppRoute.navigateTo(context, AppRoute.shoppingListDetails, arguments: list.id);
}
