import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:mobile_shopping_list_app/models/shopping-list.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-bottom-section.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-top-section.dart';
import 'package:provider/provider.dart';
import '../../models/shopping-item.dart';
import 'shopping-list-details-item-dialog.dart';

class ShoppingListDetailsScreen extends StatefulWidget {
  const ShoppingListDetailsScreen({super.key});

  @override
  State<ShoppingListDetailsScreen> createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  String _searchText = '';
  String _selectedCategory = 'Todas';

  @override
  Widget build(BuildContext context) =>
      Consumer<ShoppingListProvider>(builder: (context, provider, child) {
        final listId = ModalRoute.of(context)!.settings.arguments as String;
        final list = provider.getList(listId);
        final filteredItems = filterList(list);

        return Scaffold(
          appBar: AppBar(
            title: const Text('📑 Detalhes da Lista'),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) =>
                  ShoppingListDetailsItemDialog.createItem(listId: list.id),
            ),
            child: const Icon(Icons.add),
          ),
          body: list.items.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, size: 100),
                      SizedBox(height: 16),
                      Text('Lista vazia...'),
                    ],
                  ),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ShoppingListDetailsTopSection(
                          list: list,
                          onSearchChange: _onSearchChange,
                          onCategoryChange: _onCategoryChange,
                          categories: _getCategories(list.items),
                          selectedCategory: _selectedCategory),
                      const SizedBox(height: 8),
                      ShoppingListDetailsBottomSection(
                          list: list, filteredItems: filteredItems),
                    ],
                  ),
                ),
        );
      });

  List<ShoppingItem> filterList(ShoppingList list) {
    var listItems = list.items.where((element) {
      bool pass = true;
      if (_searchText.isNotEmpty) {
        pass = pass &&
            element.name.toLowerCase().substring(0, _searchText.length) ==
                _searchText.toLowerCase();
      }

      if (_selectedCategory != 'Todas') {
        pass = pass && element.category == _selectedCategory;
      }

      return pass;
    }).toList();

    listItems.sort((a, b) => a.purchased ? 1 : -1);

    return listItems;
  }

  List<String> _getCategories(List<ShoppingItem> items) =>
      ['Todas', ...items.map((e) => e.category).toSet()];

  void _onCategoryChange(String? value) =>
      setState(() => _selectedCategory = value!);

  void _onSearchChange(String value) => setState(() => _searchText = value);
}
