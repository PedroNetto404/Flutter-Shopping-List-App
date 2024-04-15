import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/extensions/string-extensions.dart';
import 'package:mobile_shopping_list_app/providers/shopping-list-provider.dart';
import 'package:mobile_shopping_list_app/models/shopping-list.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-item-card.dart';
import 'package:provider/provider.dart';
import '../models/enums/unit-type.dart';
import '../models/shopping-item.dart';
import '../widgets/delete-confirmation-dialog.dart';
import '../widgets/list-completed-dialog.dart';
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

  List<ShoppingItem> _getFilteredListItems(ShoppingList list) {
    var listItems = list.items.where((item) {
      bool pass = true;
      if (_searchText.isNotEmpty) {
        pass = pass &&
            item.name.toLowerCase().contains(_searchText.trim().toLowerCase());
      }

      if (_selectedCategory != 'Todas') {
        pass = pass && item.category == _selectedCategory;
      }

      return pass;
    }).toList();

    listItems.sort((a, b) => a.name.compareTo(b.name));
    listItems.sort((a, b) => a.purchased ? 1 : -1);

    return listItems;
  }

  @override
  Widget build(BuildContext context) {
    final listId = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
        appBar: AppBar(title: const Text('Detalhes da Lista')),
        floatingActionButton: FloatingActionButton(
            onPressed: () => _onItemCreateButtonPressed(context, listId),
            child: const Icon(Icons.add_shopping_cart_sharp)),
        body:
            Selector<ShoppingListProvider, (ShoppingList, List<ShoppingItem>)>(
          builder: (BuildContext context,
              (ShoppingList, List<ShoppingItem>) data, Widget? child) {
            final (list, filteredItems) = data;

            return list.items.isEmpty
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
                                    itemBuilder: (context, index) {
                                      final item = filteredItems[index];

                                      return ShoppingItemCard(
                                        listId: listId,
                                        item: item,
                                        onDeletePressed: () => _onDeletePressed(
                                            context, item, listId),
                                        onMarkPurchaseChange: (_) =>
                                            _onTogglePurchasePressed(
                                                context, listId, item),
                                        onEditPressed: () => _onEditPressed(
                                            context, item, listId),
                                      );
                                    })),
                          ],
                        ))
                      ],
                    ),
                  );
          },
          selector: (context, provider) {
            final list = provider.getList(listId);
            final filteredItems = _getFilteredListItems(list);

            return (list, filteredItems);
          },
        ));
  }

  Widget _topSection(ShoppingList list) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16),
                child: Text(
                  "🛍️ ${list.name.capitalize()}",
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _filterSection(list),
              const SizedBox(height: 8),
              if (list.items.isNotEmpty)
                Row(
                  children: [
                    Checkbox(
                        value: list.completed,
                        onChanged: (value) =>
                            _onMarkAllItemsChange(value!, list.id)),
                    const SizedBox(width: 8),
                    GestureDetector(
                        onTap: () =>
                            _onMarkAllItemsChange(!list.completed, list.id),
                        child: Text(
                            'Marcar todos os itens como ${list.completed ? 'pendentes' : 'comprados'}')),
                  ],
                )
            ],
          ),
        ),
      );

  Widget _filterSection(ShoppingList list) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 3,
            child: TextFormField(
              decoration: const InputDecoration(
                hintText: 'Digite o nome do item',
                labelText: 'Nome',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: _onSearchChange,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 1,
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
                            child: Text(e.capitalize()),
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

  List<String> _getCategories(List<ShoppingItem> items) => [
        'Todas',
        ...items
            .map((e) => e.category)
            .where((category) => category.isNotEmpty)
            .toSet()
      ];

  void _onMarkAllItemsChange(bool value, String listId) {
    var provider = context.read<ShoppingListProvider>();

    if (value) {
      provider.completeShoppingList(listId);
      showDialog(
          context: context,
          builder: (context) =>
              ListCompletedDialog(listName: provider.getList(listId).name));
      return;
    }

    provider.resetShoppingList(listId);
  }

  void _onCategoryChange(String? value) =>
      setState(() => _selectedCategory = value!);

  void _onSearchChange(String value) => setState(() => _searchText = value);

  void _onDeletePressed(
          BuildContext context, ShoppingItem item, String listId) =>
      showDialog(
          context: context,
          builder: (context) => DeleteConfirmationDialog(
              title: const Row(children: [
                Icon(Icons.warning, color: Colors.red),
                SizedBox(width: 8),
                Text('Remover Item')
              ]),
              content: Row(
                children: [
                  const Text('Tem certeza que seja remover o item '),
                  Text(item.name.capitalize(),
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.blue)),
                  const Text('?')
                ]
              ),
              onConfirm: () => _onDeleteConfirmed(context, item, listId)));

  void _onDeleteConfirmed(
          BuildContext context, ShoppingItem item, String listId) =>
      context
          .read<ShoppingListProvider>()
          .removeItemFromShoppingList(listId: listId, itemName: item.name)
          .catchError((error) => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('Erro ao remover item: $error'),
                  backgroundColor: Colors.red)));

  void _onItemCreateButtonPressed(BuildContext context, String listId) =>
      showDialog(
          context: context,
          builder: (context) => ShoppingItemDialog.createItem(
                listId: listId,
                onSaveAsync: (String name, double quantity, UnitType unitType,
                        String category, String note) =>
                    context
                        .read<ShoppingListProvider>()
                        .addItemToShoppingList(
                            listId: listId,
                            name: name,
                            quantity: quantity,
                            unityType: unitType,
                            category: category,
                            note: note)
                        .catchError((error) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Erro ao adicionar item: $error'),
                      backgroundColor: Colors.red));
                }),
              ));

  void _onEditPressed(BuildContext context, ShoppingItem item, String listId) =>
      showDialog(
          context: context,
          builder: (context) => ShoppingItemDialog.updateItem(
              listId: listId,
              item: item,
              onSaveAsync: (String name, double quantity, UnitType unitType,
                      String category, String note) =>
                  context
                      .read<ShoppingListProvider>()
                      .updateShoppingItem(
                          listId: listId,
                          previousItemName: item.name,
                          newName: name,
                          newQuantity: quantity,
                          newCategory: category,
                          newNote: note,
                          newUnitType: unitType)
                      .catchError((erro) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Erro ao atualizar item: $erro'),
                        backgroundColor: Colors.red));
                  })));

  void _onTogglePurchasePressed(
      BuildContext context, String listId, ShoppingItem item) {
    var provider = context.read<ShoppingListProvider>();
    provider.toggleItemPurchase(listId, item.name);

    if (provider.getList(listId).completed) {
      showDialog(
          context: context,
          builder: (context) =>
              ListCompletedDialog(listName: provider.getList(listId).name));
    }
  }
}
