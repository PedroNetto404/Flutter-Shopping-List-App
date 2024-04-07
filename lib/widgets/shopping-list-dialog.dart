import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/shopping-list-controller.dart';
import '../models/shopping-list.dart';

class ShoppingListDialog extends StatelessWidget {
  final ShoppingList? _list;
  final _controller = TextEditingController();

  ShoppingListDialog.createList({super.key}) : _list = null;

  ShoppingListDialog.updateList({
    super.key,
    required ShoppingList list,
  }) : _list = list {
    _controller.text = list.name;
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Theme.of(context).colorScheme.secondary,
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_list == null
                  ? 'Adicionar lista de compras'
                  : 'Editar lista', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nome da lista',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  _buildSaveButton(context),
                ],
              ),
            ],
          ),
        ),
      );

  Widget _buildSaveButton(BuildContext context) => ElevatedButton(
        onPressed: () => onSavedPressed(context),
        child: const Text("Salvar"),
      );

  void onSavedPressed(BuildContext context) {
    var controller = context.read<ShoppingListController>();

    if (_list == null) {
      controller.addShoppingList(_controller.text);
    } else {
      controller.updateShoppingListName(
          listId: _list.id, name: _controller.text);
    }

    Navigator.pop(context);
  }
}
