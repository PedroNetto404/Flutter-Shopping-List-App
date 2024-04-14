import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/shopping-list-provider.dart';
import '../models/enums/unit-type.dart';
import 'circle-button.dart';
import 'unit-type-radios.dart';

class ShoppingItemDialog extends StatefulWidget {
  final String listId;
  final String? itemName;

  bool get _isEditing => itemName != null;

  const ShoppingItemDialog.createItem({super.key, required this.listId})
      : itemName = null;

  const ShoppingItemDialog.updateItem(
      {super.key, required this.listId, required String this.itemName});

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
          .firstWhere((element) => element.id == widget.listId)
          .items
          .firstWhere((element) => element.name == widget.itemName);

      _nameController.text = item.name;
      _quantityController.text = item.quantity.toString();
      _categoryController.text = item.category;
      _selectedUnit = item.unityType;
      _noteController.text = item.note ?? '';
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

    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 1;
    final category = _categoryController.text.trim();
    final note = _noteController.text.trim();

    final future = widget._isEditing
        ? controller.updateShoppingItem(
            listId: widget.listId,
            previousItemName: widget.itemName!,
            newName: name,
            newQuantity: quantity,
            newUnityType: _selectedUnit,
            newCategory: category,
            newNote: note)
        : controller.addItemToShoppingList(
            listId: widget.listId,
            name: name,
            quantity: quantity,
            unityType: _selectedUnit,
            category: category,
            note: note);

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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) => value == null || value.isEmpty
            ? 'Nome do item é obrigatório'
            : null,
      ),
    );
  }

  Widget _categoryField() => Selector<ShoppingListProvider, List<String>>(
      builder: (BuildContext context, List<String> categories, Widget? child) =>
          Autocomplete(
              initialValue: TextEditingValue(text: _categoryController.text),
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return categories;

                return categories
                    .where((element) =>
                        element.toLowerCase().contains(textEditingValue.text))
                    .toList();
              },
              onSelected: (String value) => _categoryController.text = value,
              fieldViewBuilder: (context, controller, focusNode,
                      onFieldSubmitted) =>
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: controller,
                      onChanged: (value) => _categoryController.text = value,
                      focusNode: focusNode,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        hintText: 'Digite a categoria do item',
                        prefixIcon: Icon(Icons.category),
                      ),
                    ),
                  )),
      selector: (context, provider) => provider.lists
          .firstWhere((element) => element.id == widget.listId)
          .items
          .map((e) => e.category)
          .toSet()
          .toList());

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
        autovalidateMode: AutovalidateMode.onUserInteraction,
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
            initialValue: _selectedUnit,
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
