import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-info-section.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-item-card.dart';

import '../../models/shopping-item.dart';
import '../../models/shopping-list.dart';

class ShoppingListDetailsBottomSection extends StatelessWidget {
  final ShoppingList list;
  final List<ShoppingItem> filteredItems;

  const ShoppingListDetailsBottomSection({
    required this.list,
    required this.filteredItems,
    super.key,
  });

  @override
  Widget build(BuildContext context) => Expanded(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ShoppingListDetailsInfoSection(list: list),
          Expanded(
            child: ListView.builder(
              itemCount: filteredItems.length,
              itemBuilder: (context, index) => ShoppingListDetailsItemCard(
                  listId: list.id, item: filteredItems[index]),
            ),
          ),
        ],
      ));
}
