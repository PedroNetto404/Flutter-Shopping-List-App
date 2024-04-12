import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ShoppingListDateSortButton extends StatelessWidget {
  final bool dateAscending;
  final Function() onPressed;

  const ShoppingListDateSortButton(
      {super.key, required this.dateAscending, required this.onPressed});

  @override
  Widget build(BuildContext context) => IconButton(
      onPressed: onPressed,
      icon: Row(
        children: [
          const Icon(Icons.calendar_today),
          Icon(dateAscending ? Icons.arrow_downward : Icons.arrow_upward),
        ],
      ));
}
