import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-card.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-filter-section.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-modal.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-user-drawer.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-lists-info-section.dart';
import 'package:mobile_shopping_list_app/widgets/conditional-loading.dart';
import 'package:provider/provider.dart';
import '../../models/shopping-list.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _searchText = '';
  bool _dateAscending = true;
  late Future<void> _fetchingListsFuture;

  @override
  void initState() {
    super.initState();
    var controller = context.read<ShoppingListController>();
    _fetchingListsFuture = controller.fetchLists();
  }

  List<ShoppingList> _filter(ShoppingListController controller) {
    var filteredLists = _searchText.isEmpty
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
  Widget build(BuildContext context) => FutureBuilder(
      future: _fetchingListsFuture,
      builder: (context, snapshot) => Scaffold(
            appBar: AppBar(
                title: const Text('🛒 Listas de Compras'), centerTitle: true),
            drawer: ShoppingListUserDrawer(),
            floatingActionButton: FloatingActionButton(
              onPressed: () => showDialog(
                  context: context,
                  builder: (context) => ShoppingListModal.createList()),
              child: const Icon(Icons.add),
            ),
            body: ConditionalLoading(
                predicate: () =>
                    snapshot.connectionState == ConnectionState.waiting,
                childBuilder: (_) => Consumer<ShoppingListController>(
                      builder: (context, controller, child) {
                        var filteredLists = _filter(controller);

                        if (filteredLists.isEmpty) {
                          return const Center(
                              child: Text('Nenhuma lista encontrada'));
                        }

                        return Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            children: [
                              const SizedBox(height: 16),
                              ShoppingListFilterSection(
                                searchText: _searchText,
                                dateAscending: _dateAscending,
                                onSearchChange: (value) =>
                                    setState(() => _searchText = value),
                                onDateSort: () => setState(
                                    () => _dateAscending = !_dateAscending),
                              ),
                              ShoppingListsInfoSection(lists: controller.lists),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: filteredLists.length,
                                  itemBuilder: (context, index) =>
                                      ShoppingListCard(
                                          list: filteredLists[index]),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )),
          ));
}
