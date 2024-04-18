import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/services/export-service.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../models/models.dart';
import '../providers/providers.dart';
import '../widgets/layout.dart';
import '../widgets/widgets.dart';
import '../extensions/extensions.dart';
import '../constants/constants.dart';

class ShoppingListScreen extends StatefulWidget {
  const ShoppingListScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ShoppingListScreenState();
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  String _searchText = '';
  bool _dateAscending = true;
  bool _showCompleted = false;

  late Future<void> _fetchFuture;
  late ShoppingListProvider _provider;

  @override
  void initState() {
    super.initState();

    _provider = context.read<ShoppingListProvider>();
    _fetchFuture = _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      await _provider.fetchLists();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }

  List<ShoppingList> _getFilteredLists(List<ShoppingList> lists) {
    final filteredLists = lists.where((element) {
      bool pass = true;

      if (_searchText.isNotEmpty) {
        pass = element.name.containsIgnoreCase(_searchText);
      }

      if (_showCompleted) {
        pass = pass && element.completed;
      }

      return pass;
    }).toList();

    filteredLists.sort((a, b) => a.name.compareTo(b.name));

    filteredLists.sort((a, b) => _dateAscending
        ? a.createdAt.compareTo(b.createdAt)
        : b.createdAt.compareTo(a.createdAt));

    filteredLists.sort((a, b) => a.completed || b.items.isEmpty ? 1 : -1);

    return filteredLists;
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        child: Layout(
          body: FutureBuilder(
              future: _fetchFuture,
              builder: (context, snapshot) => Consumer<ShoppingListProvider>(
                      builder: (context, provider, child) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                          child: Row(
                        children: [
                          const Icon(Icons.error, color: Colors.red),
                          const Text('Erro ao buscar listas...'),
                          const SizedBox(width: 8),
                          IconButton(
                              icon: const Icon(Icons.refresh),
                              onPressed: () => setState(() => _fetchData())),
                        ],
                      ));
                    }

                    final lists = provider.lists;

                    if (lists.isEmpty) {
                      return EmptyBanner(
                          onTap: _onAddPressed,
                          message:
                              'Nenhuma lista adicionada...\nToque aqui para iniciar!',
                          icon: FontAwesomeIcons.rectangleList);
                    }

                    final filteredLists = _getFilteredLists(lists);

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          _filterSection(context),
                          _infoSection(lists),
                          Expanded(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _getGridColumnsCount(context),
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                              itemCount: filteredLists.length,
                              itemBuilder: (context, index) {
                                final list = filteredLists[index];
                                return ShoppingListCard(
                                    list: filteredLists[index],
                                    onDownloadPressed: () =>
                                        _onDownloadPressed(list),
                                    onDeletePressed: () =>
                                        _onDeletePressed(list),
                                    onEditPressed: () => _onEditPressed(list),
                                    onTap: () => Navigator.pushNamed(
                                        context, AppRoute.shoppingListDetails,
                                        arguments: list.id),
                                    onCopyPressed: () => _onCopyPressed(list));
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  })),
        ),
      );

  Widget _filterSection(context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('📝 Minhas Listas',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.bold)),
                    IconButton(
                        onPressed: _onAddPressed,
                        icon: Icon(FontAwesomeIcons.circlePlus,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary)),
                  ],
                ),
              ),
              const Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Row(
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
                            onPressed: () => setState(
                                () => _dateAscending = !_dateAscending),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('Listas concluídas'),
                        const SizedBox(width: 8),
                        Switch(
                            value: _showCompleted,
                            onChanged: (value) =>
                                setState(() => _showCompleted = value)),
                      ],
                    )
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

  void _onAddPressed() => showDialog(
      context: context,
      builder: (_) {
        final provider = context.read<ShoppingListProvider>();
        final authProvider = context.read<AuthProvider>();

        return ShoppingListDialog.createList(
          onSaveAsync: (String name) async {
            try {
              await provider.addShoppingList(
                  name, authProvider.currentUser!.uid);
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                  .showSuccessSnackBar('Lista "$name" adicionada!');
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
            }
          },
          nameValidator: (String? name) {
            final listWithSameName = provider.lists
                .where((element) => element.name.containsIgnoreCase(name!))
                .firstOrNull;

            return listWithSameName != null
                ? 'Já existe uma lista com o nome $name'
                : _validateListName(name);
          },
        );
      });

  void _onEditPressed(ShoppingList list) => showDialog(
      context: context,
      builder: (_) => ShoppingListDialog.updateList(
          list: list,
          onSaveAsync: (String name) async {
            try {
              await _provider.updateShoppingListName(list.id, name);
              if (!mounted) return;

              ScaffoldMessenger.of(context)
                  .showSuccessSnackBar('Lista atualizada!');
            } catch (e) {
              if (!mounted) return;

              ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
            }
          },
          nameValidator: _validateListName));

  String? _validateListName(String? name) =>
      name == null || name.isEmpty ? 'Nome da lista não pode ser vazio' : null;

  void _onDeletePressed(ShoppingList list) => showDialog(
      context: context,
      builder: (_) => DeleteConfirmationDialog(
          title: const Row(children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('Remover Lista')
          ]),
          content: Text('Deseja remover a lista "${list.name}"?',
              style: const TextStyle(overflow: TextOverflow.clip)),
          onConfirm: () => _onConfirmDelete(list)));

  void _onConfirmDelete(ShoppingList list) async {
    try {
      await _provider.removeShoppingList(list.id);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSuccessSnackBar('Lista removida!');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }

  void _onDownloadPressed(ShoppingList list) async {
    try {
      if(list.isEmpty) {
        ScaffoldMessenger.of(context).showWarningSnackBar('Lista vazia... Adicione itens para exportar!');
        return;
      }

      final exportService = ExportService();

      final filePath = await exportService.exportListInPDF(list);

      if (!mounted) return;

      if(!kIsWeb) {
        final storagePermissionStatus = await Permission.storage.status;
        if (!storagePermissionStatus.isGranted) {
          await Permission.storage.request();
        }
      }

      await OpenFile.open(filePath);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }

  _onCopyPressed(ShoppingList list) async {
    if (list.items.isEmpty) {
      ScaffoldMessenger.of(context).showWarningSnackBar('Lista vazia... Adicione itens para copiar!');
      return;
    }

    await Clipboard.setData(ClipboardData(text: list.toString()));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSuccessSnackBar('Lista copiada!');
  }

  int _getGridColumnsCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width ~/ 200;
  }
}
