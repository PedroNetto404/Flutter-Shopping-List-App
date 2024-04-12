import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-date-sort-button.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-name-search-field.dart';

class ShoppingListFilterSection extends StatelessWidget {
  final String searchText;
  final bool dateAscending;
  final Function(String) onSearchChange;
  final Function() onDateSort;

  const ShoppingListFilterSection(
      {super.key,
      required this.searchText,
      required this.dateAscending,
      required this.onSearchChange,
      required this.onDateSort});

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          child: Row(
            children: [
              ShoppingListNameSearchField(onChanged: onSearchChange),
              const SizedBox(width: 16),
              ShoppingListDateSortButton(
                  dateAscending: dateAscending, onPressed: onDateSort),
            ],
          ),
        ),
      );
}
