import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/providers/shopping-list-provider.dart';
import 'package:mobile_shopping_list_app/models/shopping-list.dart';
import 'package:mobile_shopping_list_app/widgets/layout.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-item-card.dart';
import 'package:provider/provider.dart';
import '../models/shopping-item.dart';
import '../widgets/shopping-item-dialog.dart';

class ShoppingListDetailsScreen extends StatefulWidget {
  const ShoppingListDetailsScreen({super.key});

  @override
  State<ShoppingListDetailsScreen> createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  String _searchText = '';
  String _selectedCategory = 'Todas';

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

  @override
  Widget build(BuildContext context) =>
      Consumer<ShoppingListProvider>(builder: (context, provider, child) {
        final listId = ModalRoute.of(context)!.settings.arguments as String;
        final list = provider.getList(listId);
        final filteredItems = filterList(list);

        return Scaffold(
            appBar: AppBar(title: const Text('Detalhes da Lista')),
            floatingActionButton: FloatingActionButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (context) =>
                        ShoppingItemDialog.createItem(listId: listId)),
                child: const Icon(Icons.add_shopping_cart_sharp)),
            body: list.items.isEmpty
                ? _emptyListMessage()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        _topSection(list),
                        const SizedBox(height: 8),
                        Expanded(
                            child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            _infoSection(list),
                            Expanded(
                              child: ListView.builder(
                                itemCount: filteredItems.length,
                                itemBuilder: (context, index) =>
                                    ShoppingItemCard(
                                        listId: list.id,
                                        item: filteredItems[index]),
                              ),
                            ),
                          ],
                        ))
                      ],
                    ),
                  ));
      });

  Widget _topSection(ShoppingList list) => Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 16, left: 16),
              child: Text(
                "🛍️ ${list.name}",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            _searchSection(list),
            const SizedBox(height: 8),
            if (list.items.isNotEmpty)
              Row(
                children: [
                  Checkbox(
                      value: list.completed,
                      onChanged: (value) =>
                          _onMarkAllItemsChange(value!, list.id)),
                  const SizedBox(width: 8),
                  Text(
                      'Marcar todos os itens como ${list.completed ? 'pendentes' : 'comprados'}'),
                ],
              )
          ],
        ),
      );

  void _onMarkAllItemsChange(bool value, String listId) {
    var provider = context.read<ShoppingListProvider>();

    value
        ? provider.completeShoppingList(listId)
        : provider.resetShoppingList(listId);
  }

  Widget _searchSection(ShoppingList list) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Digite o nome do item',
                labelText: 'Nome',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChange,
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Categoria'),
                DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  onChanged: _onCategoryChange,
                  items: _getCategories(list.items)
                      .map((e) => DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                ),
              ],
            ),
          )
        ],
      );

  Widget _infoSection(ShoppingList list) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                      'Itens pendentes: ${list.items.where((e) => !e.purchased).length}'),
                  const SizedBox(width: 16),
                  Text(
                      'Itens comprados: ${list.items.where((element) => element.purchased).length}'),
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );

  Widget _emptyListMessage() => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart, size: 100),
            SizedBox(height: 16),
            Text('Lista vazia...'),
          ],
        ),
      );

  List<String> _getCategories(List<ShoppingItem> items) =>
      ['Todas', ...items.map((e) => e.category).toSet()];

  void _onCategoryChange(String? value) =>
      setState(() => _selectedCategory = value!);

  void _onSearchChange(String value) => setState(() => _searchText = value);
}
