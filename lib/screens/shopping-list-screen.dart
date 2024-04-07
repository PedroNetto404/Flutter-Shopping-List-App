import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:mobile_shopping_list_app/widgets/shopping-list-dialog.dart';
import 'package:provider/provider.dart';
import '../contants/routes.dart';
import '../models/shopping-list.dart';
import '../widgets/shopping-list-card.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _searchText = '';
  bool _dateAscending = true;

  @override
  void initState() {
    super.initState();
    var controller = context.read<ShoppingListController>();
    controller.fetchLists();
  }

  @override
  Widget build(BuildContext context) {
    var controller = context.watch<ShoppingListController>();

    if (controller.fetchingData) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    var filteredLists = filter(controller);

    return Scaffold(
      appBar: AppBar(title: const Text('Listas de compras'), centerTitle: true),
      drawer: _buildDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => ShoppingListDialog.createList(),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: filteredLists.isEmpty
            ? const Center(child: Text('Nenhuma lista encontrada'))
            : Column(
                children: [
                  _buildListsInfoSection(context),
                  const SizedBox(height: 16),
                  _buildFilterSection(),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredLists.length,
                      itemBuilder: (context, index) =>
                          ShoppingListCard(list: filteredLists[index]),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Drawer _buildDrawer() {
    var authService = AuthService();
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 40,
                  child: Icon(Icons.person),
                ),
                const SizedBox(height: 8),
                Text(authService.currentUser.email!)
              ],
            ),
          ),
          ListTile(
              leading: const Icon(Icons.info),
              title: const Text("Sobre"),
              onTap: () => Navigator.pushNamed(context, Routes.about)),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Sair'),
            onTap: () {
              authService.signOut();
              Navigator.pushNamed(context, Routes.home);
              //Logout
            },
          )
        ],
      ),
    );
  }

  Widget _buildFilterSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            _buildSearchField(),
            const SizedBox(width: 16),
            _buildDateSortButton()
          ],
        ),
      );

  Widget _buildListsInfoSection(BuildContext context) {
    var lists = context.read<ShoppingListController>().lists;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
              'Total de listas pendentes: ${lists.where((element) => !element.completed).length}'),
          Text('Total de listas: ${lists.length}')
        ],
      ),
    );
  }

  Widget _buildSearchField() => Expanded(
        child: TextField(
          onChanged: (value) => setState(() => _searchText = value),
          decoration:
              const InputDecoration(labelText: 'Pesquise pelo nome da lista'),
        ),
      );

  Widget _buildDateSortButton() => Expanded(
      flex: 0,
      child: IconButton(
          onPressed: () => setState(() => _dateAscending = !_dateAscending),
          icon: Row(
            children: [
              const Icon(Icons.calendar_today),
              Icon(_dateAscending ? Icons.arrow_downward : Icons.arrow_upward),
            ],
          )));

  List<ShoppingList> filter(ShoppingListController controller) {
    var filteredLists = _searchText.isEmpty
        ? controller.lists
        : controller.lists
            .where((element) =>
                element.name.toLowerCase().contains(_searchText.toLowerCase()))
            .toList();

    filteredLists.sort((a, b) => _dateAscending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));

    filteredLists.sort((a, b) => a.completed ? 1 : -1);

    return filteredLists;
  }
}
