import 'package:flutter/material.dart';

class ShoppingListDetailsSearchArea extends StatelessWidget {
  final Function(String) onSearchChange;
  final Function(String?) onCategoryChange;
  final List<String> categories;
  final String currentCategory;

  const ShoppingListDetailsSearchArea({
    super.key,
    required this.onSearchChange,
    required this.onCategoryChange,
    required this.categories,
    required this.currentCategory,
  });

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    mainAxisSize: MainAxisSize.max,
    children: [
      _nameSearch(context),
      _categorySearch(context),
    ],
  );

  Widget _nameSearch(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width * 0.6,
    child: TextFormField(
      decoration: const InputDecoration(
        hintText: 'Digite o nome do item',
        labelText: 'Nome',
        prefixIcon: Icon(Icons.search),
      ),
      onChanged: onSearchChange,
    ),
  );

  Widget _categorySearch(BuildContext context) => SizedBox(
    width: MediaQuery.of(context).size.width * 0.3,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Categoria'),
        DropdownButton<String>(
          value: currentCategory,
          isExpanded: true,
          onChanged: onCategoryChange,
          items: categories
              .map((e) => DropdownMenuItem<String>(
            value: e,
            child: Text(e),
          ))
              .toList(),
        ),
      ],
    ),
  );
}


