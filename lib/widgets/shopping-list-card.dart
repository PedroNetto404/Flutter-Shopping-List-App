import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import '../extensions/extensions.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onCheckPressed;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onTap;

  const ShoppingListCard(
      {required this.list,
      super.key,
      required this.onDeletePressed,
      required this.onCheckPressed,
      required this.onEditPressed,
      required this.onTap});

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          onTap: () => onTap(),
          title: Text(list.name.capitalize(),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.fade)),
          leading: list.items.isNotEmpty
              ? Checkbox(
                  value: list.completed,
                  onChanged: (value) => onCheckPressed(),
                )
              : CircleButton(
                  icon: Icon(Icons.add,
                      color: Theme.of(context).colorScheme.background),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: onTap),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoWithIcon(
                icon: Icons.calendar_today,
                info: _formatDate(list.createdAt),
              ),
              InfoWithIcon(
                icon: Icons.shopping_cart,
                info: _formatItensCout(list),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                  onPressed: onEditPressed, icon: const Icon(Icons.edit)),
              IconButton(
                  icon: const Icon(Icons.delete), onPressed: onDeletePressed),
              //Enter in list
              IconButton(
                  icon: const Icon(Icons.arrow_forward), onPressed: onTap),
            ],
          )));

  String _formatItensCout(ShoppingList list) => list.items.isEmpty
      ? 'Vazia'
      : list.completed
          ? 'Concluída'
          : '${list.items.where((element) => !element.purchased).length} / ${list.items.length}';

  String _formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
}
