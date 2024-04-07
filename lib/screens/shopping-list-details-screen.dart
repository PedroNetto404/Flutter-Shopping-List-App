import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/models/shopping-item.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:mobile_shopping_list_app/models/shopping-list.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-item-card.dart';
import 'package:provider/provider.dart';
import '../widgets/shopping-item-dialog.dart';

class ShoppingListDetailsScreen extends StatefulWidget {
  const ShoppingListDetailsScreen({super.key});

  @override
  State<ShoppingListDetailsScreen> createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  final _searchController = TextEditingController();
  String _searchText = '';
  String _selectedCategory = '';

  @override
  Widget build(BuildContext context) {
    var listId = ModalRoute.of(context)!.settings.arguments as String;
    var provider = context.watch<ShoppingListController>();

    var list = provider.lists.firstWhere((element) => element.id == listId);

    var listItems = list.items.where((element) {
      bool pass = true;
      if (_searchText.isNotEmpty) {
        pass = pass &&
            element.name.toLowerCase().substring(0, _searchText.length) ==
                _searchText.toLowerCase();
      }

      if (_selectedCategory.isNotEmpty && _selectedCategory != 'Todos') {
        pass = pass && element.category == _selectedCategory;
      }

      return pass;
    }).toList();

    listItems.sort((a, b) => a.purchased ? 1 : -1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes da Lista'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => ShoppingItemDialog.createItem(listId: listId),
        ),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                list.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            _buildListSectionInfo(list),
            const SizedBox(height: 16),
            _buildSearchArea(list),
            const SizedBox(height: 16),
            _buildMarkAllItems(list),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: listItems.length,
                itemBuilder: (context, index) =>
                    ShoppingItemCard(item: listItems[index], listId: list.id),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMarkAllItems(ShoppingList list) => Row(
        children: [
          Checkbox(
              value: list.completed,
              onChanged: (value) {
                var provider = context.read<ShoppingListController>();
                value!
                    ? provider.completeShoppingList(list.id)
                    : provider.resetShoppingList(list.id);
              }),
          const SizedBox(width: 8),
          Text(
              'Marcar todos os itens como ${list.completed ? 'pendentes' : 'comprados'}'),
        ],
      );

  Widget _buildListSectionInfo(ShoppingList list) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
                'Itens pendentes: ${list.items.where((e) => !e.purchased).length}'),
            const SizedBox(width: 16),
            Text(
                'Itens comprados: ${list.items.length - list.items.where((element) => element.purchased).length}'),
          ],
        ),
      );

  Widget _buildSearchArea(ShoppingList list) {
    var categories = ['Todos', ...list.items.map((e) => e.category).toSet()];

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 1,
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(labelText: 'Nome'),
                onChanged: (value) => setState(() => _searchText = value),
              )),
          const SizedBox(width: 16),
          Expanded(
              flex: 1,
              child: Column(
                children: [
                  const Text('Categoria:', textAlign: TextAlign.center, style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: _selectedCategory.isEmpty
                        ? categories.first
                        : _selectedCategory,
                    items: categories
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _selectedCategory = value!),
                  ),
                ],
              )),
        ],
      ),
    );
  }
}
