import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-mark-all-items-button.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-search-area.dart';

import '../../models/shopping-list.dart';

class ShoppingListDetailsTopSection extends StatelessWidget {
  final ShoppingList list;
  final Function(String) onSearchChange;
  final Function(String?) onCategoryChange;
  final String selectedCategory;
  final List<String> categories;

  const ShoppingListDetailsTopSection(
      {super.key,
      required this.list,
      required this.onSearchChange,
      required this.onCategoryChange,
      required this.categories,
      required this.selectedCategory});

  @override
  Widget build(BuildContext context) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _listTopSectionTitle(list),
            const SizedBox(height: 16),
            ShoppingListDetailsSearchArea(
              onSearchChange: onSearchChange,
              onCategoryChange: onCategoryChange,
              categories: categories,
              currentCategory: selectedCategory,
            ),
            const SizedBox(height: 8),
            if (list.items.isNotEmpty)
              ShoppingListDetailsMarkAllItemsButton(list: list),
          ],
        ),
      );

  Widget _listTopSectionTitle(ShoppingList list) => Padding(
        padding: const EdgeInsets.only(top: 16, left: 16),
        child: Text(
          "🛍️ ${list.name}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
