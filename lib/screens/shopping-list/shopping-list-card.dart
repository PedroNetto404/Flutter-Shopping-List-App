import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-actions.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-info-subtitle.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-card-leading.dart';
import '../../contants/app-route.dart';
import '../../models/shopping-list.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListCard({required this.list, super.key});

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          onTap: () => _onCardTap(context),
          title: Text(list.name,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          leading: ShoppingListCardLeading(list: list),
          subtitle: ShoppingListInfoSubtitle(list: list),
          trailing: ShoppingListActions(list: list)));

  void _onCardTap(BuildContext context) =>
      AppRoute.navigateTo(context, AppRoute.shoppingListDetails,
          arguments: list.id);
}
