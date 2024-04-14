import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shopping-list-provider.dart';
import '../models/shopping-list.dart';

class ShoppingListDialog extends StatelessWidget {
  final ShoppingList? _list;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ShoppingListDialog.createList({super.key}) : _list = null;

  ShoppingListDialog.updateList({
    super.key,
    required ShoppingList list,
  }) : _list = list {
    _nameController.text = list.name;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(_list == null ? Icons.add_box_sharp : Icons.edit_note_sharp),
            const SizedBox(width: 8),
            Text(_list == null ? 'Nova Lista' : 'Editar Lista'),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar')),
          ElevatedButton(
              onPressed: () => onSavedPressed(context),
              child: const Text("Salvar")),
        ],
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Form(
            key: _formKey,
            child: TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome da lista',
                hintText: 'Ex: Compras de terça',
                prefixIcon: Icon(Icons.list),
              ),
              validator: (value) {
                if (value!.isEmpty) return 'Nome da lista não pode ser vazio';
                return null;
              },
              onFieldSubmitted: (_) => onSavedPressed(context),
            ),
          ),
        ),
      );

  void onSavedPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final listName = _nameController.text.trim();

    final controller = context.read<ShoppingListProvider>();

    final future = _list == null
        ? controller.addShoppingList(listName)
        : controller.updateShoppingListName(_list.id, listName);

    future
        .then((value) => Navigator.pop(context))
        .catchError((error) => _onSaveError(context, error));
  }

  void _onSaveError(BuildContext context, Object error) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar lista: $error'),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
}
