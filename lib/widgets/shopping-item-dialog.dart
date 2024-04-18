import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_shopping_list_app/extensions/extensions.dart';

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class ShoppingItemDialog extends StatefulWidget {
  final String listId;
  final ShoppingItem? item;
  final Future<void> Function(String name, double quantity, UnitType unitType,
      String category, String note, double? price) onSaveAsync;

  bool get _isEditing => item != null;

  const ShoppingItemDialog.createItem(
      {super.key, required this.listId, required this.onSaveAsync})
      : item = null;

  const ShoppingItemDialog.updateItem(
      {super.key,
      required this.listId,
      required this.item,
      required this.onSaveAsync});

  @override
  ShoppingItemDialogState createState() => ShoppingItemDialogState();
}

class ShoppingItemDialogState extends State<ShoppingItemDialog> {
  final _priceController = TextEditingController(text: '1');
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController(text: '1.000');
  final _noteController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  UnitType _selectedUnit = UnitType.un;
  String _selectedCategory = '';
  double? currentItemPrice = 0;
  double currentItemQuantity = 0;

  double? get itemTotalPrice =>
      currentItemPrice == null ? null : currentItemPrice! * currentItemQuantity;

  @override
  void initState() {
    super.initState();

    if (!widget._isEditing) return;

    final item = widget.item!;

    _nameController.text = item.name;
    _selectedCategory = item.category;
    _selectedUnit = item.unityType;
    _noteController.text = item.note ?? '';

    currentItemPrice = item.price;
    currentItemQuantity = item.quantity;

    _priceController.text = item.price?.toString() ?? '';
    _priceController.addListener(_onNumberChanged);

    _quantityController.text = item.quantity.toString();
    _quantityController.addListener(_onNumberChanged);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: _title(),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: _onSavedPressed,
            child: const Text("Salvar"),
          ),
        ],
        content: SingleChildScrollView(
          child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.9, child: _body()),
        ),
      );

  Widget _body() => Form(
        key: _formKey,
        child: Column(
          children: [
            _nameField(),
            _categoryField(),
            _unitType(),
            NumberField(
                controller: _quantityController,
                precision: 3,
                label: 'Quantidade',
                hint: 'Digite a quantidade do item',
                initialValue: currentItemQuantity),
            if (widget._isEditing && currentItemPrice != null)
              NumberField(
                  controller: _priceController,
                  precision: 2,
                  label: 'Preço',
                  hint: 'Digite o preço do item',
                  numberSymbol: 'R\$ ',
                  initialValue: currentItemPrice),
            _noteField()
          ],
        ),
      );

  Widget _title() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Icon(widget._isEditing ? Icons.edit : Icons.add),
            const SizedBox(width: 8),
            Text(widget._isEditing ? 'Editar item' : 'Adicionar item')
          ]),
          if (itemTotalPrice != null && widget._isEditing)
            Text(' - Total: ${itemTotalPrice!.toCurrency()}',
                style: const TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                    overflow: TextOverflow.ellipsis))
        ],
      );

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
              optionsViewBuilder: _buildCategoryOptions,
              initialValue: TextEditingValue(text: _selectedCategory),
              optionsBuilder: (textEditingValue) {
                if (textEditingValue.text.isEmpty) return categories;

                return categories
                    .where((element) =>
                        element.toLowerCase().contains(textEditingValue.text))
                    .toList();
              },
              onSelected: (String value) =>
                  setState(() => _selectedCategory = value),
              fieldViewBuilder: _buildCategoryFormField),
      selector: (context, provider) => provider.lists
          .firstWhere((element) => element.id == widget.listId)
          .items
          .map((e) => e.category)
          .toSet()
          .toList());

  Widget _buildCategoryOptions(BuildContext ontext, Function(String) onSelected,
          Iterable<String> options) =>
      Align(
        alignment: Alignment.topLeft,
        child: Material(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.68,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  title: Text(option),
                  onTap: () => onSelected(option),
                );
              },
            ),
          ),
        ),
      );

  Widget _buildCategoryFormField(
          context, controller, focusNode, onFieldSubmitted) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: controller,
          onChanged: (value) => setState(() => _selectedCategory = value),
          focusNode: focusNode,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Categoria',
            hintText: 'Digite a categoria do item',
            prefixIcon: Icon(Icons.category),
          ),
        ),
      );

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
            _onSavedPressed();
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

  void _onSavedPressed() async {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final quantity = double.tryParse(_quantityController.text) ?? 0;
    final category = _selectedCategory;
    final note = _noteController.text.trim();
    final price = double.tryParse(_priceController.text);

    await widget.onSaveAsync(
        name, quantity, _selectedUnit, category, note, price);

    if (!mounted) return;
  }

  void _onNumberChanged() => setState(() {
        currentItemPrice = double.tryParse(_priceController.text);
        currentItemQuantity = double.tryParse(_quantityController.text) ?? 0;
      });
}
