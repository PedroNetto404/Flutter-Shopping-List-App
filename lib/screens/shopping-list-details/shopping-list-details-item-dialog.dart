import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-category-field.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-name-field.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-note-field.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-details/shopping-list-details-quantity-field.dart';
import 'package:provider/provider.dart';
import '../../controllers/shopping-list-controller.dart';
import '../../models/enums/unit-type.dart';
import '../../widgets/unit-type-radios.dart';

class ShoppingListDetailsItemDialog extends StatefulWidget {
  final String _listId;
  final int? _listItemId;

  bool get _isEditing => _listItemId != null;

  const ShoppingListDetailsItemDialog.createItem(
      {super.key, required String listId})
      : _listId = listId,
        _listItemId = null;

  const ShoppingListDetailsItemDialog.updateItem(
      {super.key, required String listId, required int listItemId})
      : _listId = listId,
        _listItemId = listItemId;

  @override
  ShoppingItemDialogState createState() => ShoppingItemDialogState();
}

class ShoppingItemDialogState extends State<ShoppingListDetailsItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '0.000');
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UnitType _selectedUnit = UnitType.un;

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
  Widget build(BuildContext context) => AlertDialog(
        title: Row(
          children: [
            Icon(widget._isEditing ? Icons.edit : Icons.add),
            const SizedBox(width: 8),
            Text(widget._isEditing ? 'Editar item' : 'Adicionar item'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => _onSavedPressed(context),
            child: const Text("Salvar"),
          ),
        ],
        content: SizedBox(
          width: 900,
          height: 400,
          child: SingleChildScrollView(
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    ShoppingListDetailsNameField(controller: _nameController),
                    ShoppingListDetailsCategoryField(
                        controller: _categoryController),
                    ShoppingListDetailsQuantityField(
                        controller: _quantityController),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: UnitTypeRadios(
                          onChanged: (unitType) =>
                              setState(() => _selectedUnit = unitType)),
                    ),
                    ShoppingListDetailsNoteField(controller: _noteController)
                  ],
                )),
          ),
        ),
      );

  void _onSavedPressed(BuildContext context) {
    var controller = context.read<ShoppingListController>();

    if (widget._isEditing) {
      controller.updateShoppingItem(
        listId: widget._listId,
        newName: _nameController.text.trim(),
        newQuantity: double.tryParse(_quantityController.text) ?? 1,
        newUnityType: _selectedUnit,
        newCategory: _categoryController.text.trim(),
        newNote: _noteController.text.trim(),
      );
    } else {
      controller.addItemToShoppingList(
        listId: widget._listId,
        name: _nameController.text.trim(),
        quantity: double.tryParse(_quantityController.text) ?? 1,
        unityType: _selectedUnit,
        category: _categoryController.text.trim(),
        note: _noteController.text.trim(),
      );
    }

    Navigator.pop(context);
  }
}
