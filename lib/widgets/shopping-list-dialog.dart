import 'package:flutter/material.dart';

import '../models/models.dart';

class ShoppingListDialog extends StatelessWidget {
  final ShoppingList? _list;
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Function(String name) onSaveAsync;
  final String? Function(String? name) nameValidator;

  ShoppingListDialog.createList(
      {super.key, required this.onSaveAsync, required this.nameValidator})
      : _list = null;

  ShoppingListDialog.updateList({
    super.key,
    required ShoppingList list,
    required this.onSaveAsync,
    required this.nameValidator,
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
          OutlinedButton(
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
                errorMaxLines: 3,
                prefixIcon: Icon(Icons.list),
              ),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              
              validator: nameValidator,
              onFieldSubmitted: (_) => onSavedPressed(context),
            ),
          ),
        ),
      );

  void onSavedPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final listName = _nameController.text.trim();

    onSaveAsync(listName);
  }
}
