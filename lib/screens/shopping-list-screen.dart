import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/providers/shopping-list-provider.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-list-card.dart';
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

  @override
  void initState() {
    super.initState();

    _initFetch();
  }

  void _initFetch() => _fetchFuture = Future.delayed(
      const Duration(seconds: 3),
      () => context
          .read<ShoppingListProvider>()
          .fetchLists()
          .catchError((error) => _showFetchError(context, error)));

  List<ShoppingList> _filter(List<ShoppingList> lists) {
    final filteredLists = _searchText.isEmpty
        ? lists
        : lists
            .where((element) =>
                element.name.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

    filteredLists.sort((a, b) => a.name.compareTo(b.name));

    filteredLists.sort((a, b) => _dateAscending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));

    filteredLists.sort((a, b) => a.completed || b.items.isEmpty ? 1 : -1);

    return filteredLists;
  }

  @override
  Widget build(BuildContext context) => Layout(
      floatingActionButton: FloatingActionButton(
          onPressed: () => _onAddPressed(context),
          child: const Icon(Icons.playlist_add)),
      body: FutureBuilder(
          future: _fetchFuture,
          builder: (context, snapshot) =>
              Selector<ShoppingListProvider, List<ShoppingList>>(
                  selector: (context, provider) => provider.lists,
                  builder: (context, lists, child) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                          child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const Text('Erro ao buscar listas...'),
                          const SizedBox(width: 8),
                          IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => setState(() => _initFetch())),
                        ],
                      ));
                    }

                    if (lists.isEmpty) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.shopping_cart, size: 100),
                            SizedBox(height: 16),
                            Text('Nenhuma lista adicionada ainda...'),
                          ],
                        ),
                      );
                    }

                    final filteredLists = _filter(lists);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          _filterSection(),
                          _infoSection(lists),
                          Expanded(
                            child: ListView.builder(
                              itemCount: filteredLists.length,
                              itemBuilder: (context, index) =>
                                  ShoppingListCard(list: filteredLists[index]),
                            ),
                          ),
                        ],
                      ),
                    );
                  })));

  void _onAddPressed(BuildContext context) => showDialog(
        context: context,
        builder: (context) => ShoppingListDialog.createList(),
      );

  Widget _filterSection() => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
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
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onChanged: (value) =>
                            setState(() => _searchText = value),
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
                      'Total de listas pendentes: ${lists.where((list) => !list.completed || list.items.isEmpty).length}'),
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
