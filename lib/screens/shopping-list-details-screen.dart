import 'package:flutter/material.dart';

import '../providers/providers.dart';
import '../widgets/purchase-item-dialog.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';
import '../extensions/extensions.dart';


class ShoppingListDetailsScreen extends StatefulWidget {
  const ShoppingListDetailsScreen({super.key});

  @override
  State<ShoppingListDetailsScreen> createState() =>
      _ShoppingListDetailsScreenState();
}

class _ShoppingListDetailsScreenState extends State<ShoppingListDetailsScreen> {
  String _searchText = '';
  String _selectedCategory = 'Todas';
  bool _showPurchasedItems = false;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Detalhes da Lista')),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            final listId = ModalRoute.of(context)!.settings.arguments as String;
            _onCreateItemPressed(listId);
          },
          child: const Icon(Icons.add_shopping_cart_sharp)),
      body: Consumer<ShoppingListProvider>(builder:
          (BuildContext context, ShoppingListProvider value, Widget? child) {
        final listId = ModalRoute.of(context)!.settings.arguments as String;

        final list = value.getList(listId);
        if (list.isEmpty) {
          return EmptyBanner(
            onTap: () => _onCreateItemPressed(listId),
            message: 'Lista vazia! Adicione um item para começar.',
            icon: Icons.shopping_cart,
          );
        }

        final filteredItems = _getFilteredListItems(list);

        return Padding(
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
                                listId: list.id,
                                item: item,
                                onDeletePressed: () => _onDeletePressed(item),
                                onEditPressed: () => _onEditPressed(item),
                                onBuyPressed: () => _onBuyPressed(item),
                              );
                            })),
                  ],
                ))
              ],
            ));
      }));

  void _onBuyPressed(ShoppingItem item) async {
    await showDialog(
      context: context,
      builder: (_) => PurchaseItemDialog(
        item: item,
        onPurchase: (price, quantity) async {
          final provider = context.read<ShoppingListProvider>();

          try {
            await provider.buyItem(item, price, quantity);
            ScaffoldMessenger.of(context).showSuccessSnackBar(
                'Item "${item.name}" comprado com sucesso!');

            if (provider.getList(item.listId).completed) {
              _showFeedbackIfListCompleted(item.listId);
              setState(() => _showPurchasedItems = true);
            }
          } catch (e) {
            ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
          }
        },
      ),
    );
  }

  Widget _topSection(ShoppingList list) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "🛍️ ${list.name}",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (list.totalPrice != null)
                      Text('Total: ${list.totalPrice!.toCurrency()}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              _filterSection(list),
            ],
          ),
        ),
      );

  Widget _filterSection(ShoppingList list) => Column(
        children: [
          Row(
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
                                child: Text(e),
                              ))
                          .toList(),
                    ),
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Mostrar itens comprados'),
                const SizedBox(width: 4),
                Switch(
                  value: _showPurchasedItems,
                  onChanged: (value) =>
                      setState(() => _showPurchasedItems = value),
                ),
              ],
            ),
          ),
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

  List<String> _getCategories(List<ShoppingItem> items) => [
        'Todas',
        ...items
            .map((e) => e.category)
            .where((category) => category.isNotEmpty)
            .toSet()
      ];

  List<ShoppingItem> _getFilteredListItems(ShoppingList list) {
    var listItems = list.items.where((item) {
      bool pass = true;

      pass = pass && (item.purchased == _showPurchasedItems);
      pass = pass &&
          (_searchText.isNotEmpty
              ? item.name
                  .toLowerCase()
                  .contains(_searchText.trim().toLowerCase())
              : true);
      pass = pass &&
          (_selectedCategory != 'Todas'
              ? item.category == _selectedCategory
              : true);

      return pass;
    }).toList();

    listItems.sort((a, b) => a.name.compareTo(b.name));
    listItems.sort((a, b) => a.purchased ? 1 : -1);

    return listItems;
  }

  void _onCategoryChange(String? value) =>
      setState(() => _selectedCategory = value!);

  void _onSearchChange(String value) => setState(() => _searchText = value);

  void _onDeletePressed(ShoppingItem item) => showDialog(
      context: context,
      builder: (context) => DeleteConfirmationDialog(
          title: const Row(children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Remover Item')
          ]),
          content: Text('Tem certeza que seja remover o item "${item.name}?"'),
          onConfirm: () => _onDeleteConfirmed(item)));

  void _onDeleteConfirmed(ShoppingItem item) async {
    final provider = context.read<ShoppingListProvider>();

    try {
      await provider.removeItemFromShoppingList(item);

      ScaffoldMessenger.of(context)
          .showSuccessSnackBar('Item "${item.name}" removido com sucesso!');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(error);
    }
  }

  void _onCreateItemPressed(String listId) => showDialog(
      context: context,
      builder: (_) => ShoppingItemDialog.createItem(
            listId: listId,
            onSaveAsync: (String name, double quantity, UnitType unitType,
                String category, String note, double? _) async {
              final provider = context.read<ShoppingListProvider>();

              try {
                await provider.addItemToShoppingList(
                    listId: listId,
                    name: name,
                    quantity: quantity,
                    unityType: unitType,
                    category: category,
                    note: note);

                if (!mounted) return;

                ScaffoldMessenger.of(context)
                    .showSuccessSnackBar('Item "$name" adicionado com sucesso!');

                Navigator.of(context).pop();
              } catch (e) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
              }
            },
          ));

  void _onEditPressed(ShoppingItem item) => showDialog(
      context: context,
      builder: (_) => ShoppingItemDialog.updateItem(
          listId: item.listId,
          item: item,
          onSaveAsync: (String name, double quantity, UnitType unitType,
              String category, String note, double? price) async {
            final provider = context.read<ShoppingListProvider>();

            try {
              await provider.updateShoppingItem(
                  listId: item.listId,
                  previousItemName: item.name,
                  newName: name,
                  newQuantity: quantity,
                  newCategory: category,
                  newNote: note,
                  newUnitType: unitType,
                  newPrice: price);

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSuccessSnackBar(
                  'Item "${item.name}" atualizado com sucesso!');
            } catch (e) {
              ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
            }
          }));

  void _showFeedbackIfListCompleted(String listId) {
    final list = context.read<ShoppingListProvider>().getList(listId);

    if (list.completed) {
      ScaffoldMessenger.of(context)
          .showSuccessSnackBar('Lista "${list.name}" finalizada!');
    }
  }
}
