import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/shopping-list-controller.dart';
import '../../models/shopping-list.dart';

class ShoppingListModal extends StatelessWidget {
  final ShoppingList? _list;
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ShoppingListModal.createList({super.key}) : _list = null;

  ShoppingListModal.updateList({
    super.key,
    required ShoppingList list,
  }) : _list = list {
    _controller.text = list.name;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Row(
      children: [
        Icon(_list == null ? Icons.add_box_sharp : Icons.edit_note_sharp),
        const SizedBox(width: 8),
        Text(_list == null ? 'Adicionar lista de compras' : 'Editar lista'),
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
          controller: _controller,
          decoration: const InputDecoration(
            labelText: 'Nome da lista',
            hintText: 'Ex: Compras de Janeiro',
            prefixIcon: Icon(Icons.list),
          ),
          validator: (value) {
            if (value!.isEmpty) return 'Nome da lista não pode ser vazio';
            return null;
          },
        ),
      ),
    ),
  );

  void onSavedPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    var controller = context.read<ShoppingListController>();

    if (_list == null) {
      controller.addShoppingList(_controller.text.trim());
    } else {
      controller.updateShoppingListName(
          listId: _list.id, name: _controller.text.trim());
    }

    Navigator.pop(context);
  }
}