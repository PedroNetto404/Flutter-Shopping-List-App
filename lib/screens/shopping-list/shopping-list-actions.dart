import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-modal.dart';
import 'package:provider/provider.dart';
import '../../contants/app-route.dart';
import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-list.dart';
import '../../widgets/delete-confirmation-dialog.dart';

class ShoppingListActions extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListActions({required this.list, super.key});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  ShoppingListModal.updateList(list: list)),
          icon: const Icon(Icons.edit)),
      IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => DeleteConfirmationDialog(
                title: 'Excluir lista de compras',
                content:
                'Tem certeza que deseja excluir a lista de compras "${list.name}"?',
                onConfirm: () => _onConfirmDelete(context),
              ));
        },
      ),
      //Enter in list
      IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () => AppRoute.navigateTo(
              context, AppRoute.shoppingListDetails,
              arguments: list.id)),
    ],
  );

  void _onConfirmDelete(BuildContext context) {
    var controller = context.read<ShoppingListController>();
    controller.removeShoppingList(list.id);
  }
}

