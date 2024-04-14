import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/providers/shopping-list-provider.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-list-card.dart';
import 'package:mobile_shopping_list_app/widgets/conditional-loading.dart';
import 'package:mobile_shopping_list_app/widgets/layout.dart';
import 'package:provider/provider.dart';
import '../models/shopping-list.dart';
import '../widgets/shopping-list-dialog.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _searchText = '';
  bool _dateAscending = true;
  Future<void>? _fetchFuture;

  List<ShoppingList> _filter(ShoppingListProvider controller) {
    final filteredLists = _searchText.isEmpty
        ? controller.lists
        : controller.lists
            .where((element) =>
                element.name.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

    filteredLists.sort((a, b) => a.completed ? 1 : -1);

    filteredLists.sort((a, b) => _dateAscending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));

    return filteredLists;
  }

  @override
  Widget build(BuildContext context) => Layout(
      floatingActionButton: FloatingActionButton(
          onPressed: () => _onAddPressed(context),
          child: const Icon(Icons.playlist_add)),
      body:
          Consumer<ShoppingListProvider>(builder: (context, controller, child) {
        _fetchFuture = _fetchFuture ??
            controller
                .fetchLists()
                .catchError((error) => _showFetchError(context, error));

        return FutureBuilder(
            future: _fetchFuture,
            builder: (context, snapshot) => ConditionalLoadingIndicator(
                predicate: () =>
                    snapshot.connectionState == ConnectionState.waiting,
                childBuilder: (context) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _filterSection(),
                          _infoSection(controller.lists),
                          Expanded(
                            child: ListView.builder(
                              itemCount: _filter(controller).length,
                              itemBuilder: (context, index) {
                                final list = _filter(controller)[index];
                                return ShoppingListCard(list: list);
                              },
                            ),
                          ),
                        ],
                      ),
                    )));
      }));

  void _onAddPressed(BuildContext context) => showDialog(
        context: context,
        builder: (context) => ShoppingListDialog.createList(),
      );

  Widget _filterSection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text('📝 Minhas Listas',
                    style:
                        TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
              ),
              const Divider(),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (value) => setState(() => _searchText = value),
                      decoration: const InputDecoration(
                          hintText: 'Digite o nome da lista',
                          labelText: 'Buscar lista',
                          prefixIcon: Icon(Icons.search)),
                    ),
                  ),
                  const SizedBox(width: 16),
                  IconButton(
                      onPressed: () =>
                          setState(() => _dateAscending = !_dateAscending),
                      icon: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          Icon(_dateAscending
                              ? Icons.arrow_downward
                              : Icons.arrow_upward),
                        ],
                      ))
                ],
              ),
            ],
          ),
        ),
      );

  Widget _infoSection(List<ShoppingList> lists) => Padding(
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
                      'Total de listas pendentes: ${lists.where((element) => !element.completed).length}'),
                  Text('Total de listas: ${lists.length}')
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      );

  void _showFetchError(BuildContext context, Object error) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao buscar listas: $error'),
          backgroundColor: Theme.of(context).colorScheme.error));
}
