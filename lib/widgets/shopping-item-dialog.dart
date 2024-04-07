import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/shopping-list-controller.dart';
import '../models/enums/unit-type.dart';

class ShoppingItemDialog extends StatefulWidget {
  final String _listId;
  final int? _listItemId;

  bool get _isEditing => _listItemId != null;

  const ShoppingItemDialog.createItem({super.key, required String listId})
      : _listId = listId,
        _listItemId = null;

  const ShoppingItemDialog.updateItem(
      {super.key, required String listId, required int listItemId})
      : _listId = listId,
        _listItemId = listItemId;

  @override
  ShoppingItemDialogState createState() => ShoppingItemDialogState();
}

class ShoppingItemDialogState extends State<ShoppingItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  UnityType _selectedUnit = UnityType.un;

  @override
  void initState() {
    super.initState();

    if (widget._isEditing) {
      var item = context
          .read<ShoppingListController>()
          .lists
          .firstWhere((element) => element.id == widget._listId)
          .items
          .firstWhere((element) => element.id == widget._listItemId);

      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _categoryController.text = item.category;
      _selectedUnit = item.unityType;
      _noteController.text = item.note;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                    widget._isEditing ? 'Editar item' : 'Adicionar item',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                _buildTextField('Nome', _nameController),
                _buildTextField('Categoria', _categoryController),
                _buildTextField('Anotação', _noteController, maxLines: 4),
                Row(
                  children: [
                    Expanded(
                        child:
                            _buildTextField('Quantidade', _quantityController)),
                    _buildDropDown(),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancelar'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          widget._isEditing ? _onEditItem() : _onAddItem();
                        },
                        child: const Text('Salvar'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onEditItem() {
    var controller = context.read<ShoppingListController>();

    controller.updateShoppingItem(
        listId: widget._listId,
        newName: _nameController.text.trim(),
        newQuantity: double.parse(_quantityController.text.trim()),
        newUnityType: _selectedUnit,
        newCategory: _categoryController.text.trim(),
        newNote: _noteController.text.trim());
    Navigator.pop(context);
  }

  void _onAddItem() => context
      .read<ShoppingListController>()
      .addItemToShoppingList(
          listId: widget._listId,
          name: _nameController.text.trim(),
          quantity: double.parse(_quantityController.text.trim()),
          unityType: _selectedUnit,
          category: _categoryController.text.trim(),
          note: _noteController.text.trim())
      .then((_) => Navigator.pop(context));

  Widget _buildTextField(String labelText, TextEditingController controller,
      {int? maxLines}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: labelText,
        ),
      ),
    );
  }

  Widget _buildDropDown() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          const Text('Unidade: '),
          DropdownButton<UnityType>(
            value: _selectedUnit,
            items: UnityType.values
                .map((unit) => DropdownMenuItem(
                      value: unit,
                      child: Text(unit.toString().split('.').last),
                    ))
                .toList(),
            onChanged: (value) {
              setState(() {
                _selectedUnit = value!;
              });
            },
          ),
        ],
      ),
    );
  }
}
