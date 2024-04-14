import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping-list-provider.dart';
import '../models/enums/unit-type.dart';
import 'circle-button.dart';
import 'unit-type-radios.dart';

class ShoppingItemDialog extends StatefulWidget {
  final String _listId;
  final String? _itemName;

  bool get _isEditing => _itemName != null;

  const ShoppingItemDialog.createItem({super.key, required String listId})
      : _listId = listId,
        _itemName = null;

  const ShoppingItemDialog.updateItem(
      {super.key, required String listId, required String itemName})
      : _listId = listId,
        _itemName = itemName;

  @override
  ShoppingItemDialogState createState() => ShoppingItemDialogState();
}

class ShoppingItemDialogState extends State<ShoppingItemDialog> {
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1.000');
  final _categoryController = TextEditingController();
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UnitType _selectedUnit = UnitType.un;

  @override
  void initState() {
    super.initState();

    if (widget._isEditing) {
      var item = context
          .read<ShoppingListProvider>()
          .lists
          .firstWhere((element) => element.id == widget._listId)
          .items
          .firstWhere((element) => element.name == widget._itemName);

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
                autovalidateMode: AutovalidateMode.onUserInteraction,
                key: _formKey,
                child: Column(
                  children: [
                    _nameField(),
                    _categoryField(),
                    _quantityField(),
                    _unitType(),
                    _noteField(),
                  ],
                )),
          ),
        ),
      );

  void _onSavedPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    var controller = context.read<ShoppingListProvider>();

    final future = widget._isEditing ? 
      controller.updateShoppingItem(
        listId: widget._listId,
        previousItemName: widget._itemName!,
        newName: _nameController.text.trim(),
        newQuantity: double.tryParse(_quantityController.text) ?? 1,
        newUnityType: _selectedUnit,
        newCategory: _categoryController.text.trim(),
        newNote: _noteController.text.trim(),
      ) : 
      controller.addItemToShoppingList(
        listId: widget._listId,
        name: _nameController.text.trim(),
        quantity: double.tryParse(_quantityController.text) ?? 1,
        unityType: _selectedUnit,
        category: _categoryController.text.trim(),
        note: _noteController.text.trim(),
      );

    future.then((value) => Navigator.pop(context)).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao salvar item: $error'),
        backgroundColor: Colors.red,
      ));
    });
  }

  Widget _nameField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _nameController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Nome',
          hintText: 'Digite o nome do item',
          prefixIcon: Icon(Icons.shopping_cart),
        ),
        validator: (value) => value == null || value.isEmpty
            ? 'Nome do item é obrigatório'
            : null,
      ),
    );
  }

  Widget _categoryField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _categoryController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        decoration: const InputDecoration(
          labelText: 'Categoria',
          hintText: 'Digite a categoria do item',
          prefixIcon: Icon(Icons.category),
        ),
      ),
    );
  }

  Widget _quantityField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        controller: _quantityController,
        keyboardType: TextInputType.number,
        onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
        validator: (value) {
          if (value == null || value.isEmpty) return 'Quantidade é obrigatória';

          final quantity = double.tryParse(value);
          if (quantity == null) return 'Quantidade inválida';

          if (quantity <= 0) return 'Quantidade deve ser maior que zero';

          return null;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
            labelText: 'Quantidade',
            hintText: 'Digite a quantidade do item',
            prefixIcon: const Icon(Icons.format_list_numbered),
            suffixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleButton(
                      icon: const Icon(Icons.remove),
                      color: Colors.red,
                      onPressed: () => _onDecrement()),
                  const SizedBox(width: 8),
                  CircleButton(
                      icon: const Icon(Icons.add),
                      color: Colors.green,
                      onPressed: () => _onIncrement()),
                ],
              ),
            )),
      ),
    );
  }

  void _onIncrement() {
    var value = (double.tryParse(_quantityController.text) ?? 0) + 1;
    _quantityController.text = value.toStringAsFixed(3);
  }

  void _onDecrement() {
    var value = (double.tryParse(_quantityController.text) ?? 0) - 1;
    if (value == 0) return;

    _quantityController.text = value.toStringAsFixed(3);
  }

  Widget _unitType() => Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: UnitTypeRadios(
            onChanged: (unitType) => setState(() => _selectedUnit = unitType)),
      );

  Widget _noteField() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          onFieldSubmitted: (_) {
            FocusScope.of(context).unfocus();
            _onSavedPressed(context);
          },
          controller: _noteController,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            labelText: 'Observação',
            hintText: 'Digite uma observação sobre o item',
            prefixIcon: Icon(Icons.edit_note_sharp),
          ),
          maxLines: 3,
        ),
      );
}
