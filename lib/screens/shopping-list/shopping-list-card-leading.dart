import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';
import 'package:provider/provider.dart';
import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-list.dart';

class ShoppingListCardLeading extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCardLeading({required this.list, super.key});

  @override
  Widget build(BuildContext context) => list.items.isNotEmpty
      ? Checkbox(
          value: list.completed,
          onChanged: (value) => _onCheckboxTap(context),
        )
      : IconButton(
          onPressed: () => _onAddItemTap(context), icon: const Icon(Icons.add));

  void _onCheckboxTap(BuildContext context) {
    var provider = context.read<ShoppingListController>();
    if (list.completed) {
      provider.resetShoppingList(list.id);
    } else {
      provider.completeShoppingList(list.id);
    }
  }

  void _onAddItemTap(BuildContext context) =>
      AppRoute.navigateTo(context, AppRoute.shoppingListDetails,
          arguments: list.id);
}
