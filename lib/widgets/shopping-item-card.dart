import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/extensions/string-extensions.dart';
import 'package:mobile_shopping_list_app/models/enums/unit-type.dart';
import '../models/shopping-item.dart';
import 'info-with-icon.dart';

class ShoppingItemCard extends StatelessWidget {
  final String listId;
  final ShoppingItem item;
  final VoidCallback onDeletePressed;
  final Function(bool) onMarkPurchaseChange;
  final VoidCallback onEditPressed;

  const ShoppingItemCard(
      {super.key,
      required this.item,
      required this.listId,
      required this.onDeletePressed,
      required this.onMarkPurchaseChange,
      required this.onEditPressed});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          title: Text(item.name.capitalize(),
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, overflow: TextOverflow.fade)),
          leading: Checkbox(
              value: item.purchased,
              onChanged: (value) => onMarkPurchaseChange(value!)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoWithIcon(
                icon: Icons.shopping_bag,
                info: _formatQuantityWithUnit(item.quantity, item.unityType),
              ),
              if (item.category.isNotEmpty)
                InfoWithIcon(
                  icon: Icons.category,
                  info: item.category.capitalize(),
                ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit),
                onPressed: onEditPressed,
              ),
              IconButton(
                  icon: const Icon(Icons.delete), onPressed: onDeletePressed),
            ],
          ),
        ),
      );

  String _formatQuantityWithUnit(double quantity, UnitType unit) =>
      '${quantity.toStringAsFixed(3)} ${unit.toString().split('.').last.toUpperCase()}';
}
