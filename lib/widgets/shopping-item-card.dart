import 'package:flutter/material.dart';

import 'widgets.dart'; 
import '../models/models.dart';
import '../extensions/extensions.dart';

class ShoppingItemCard extends StatelessWidget {
  final String listId;
  final ShoppingItem item;
  final VoidCallback onDeletePressed;
  final VoidCallback onEditPressed;
  final VoidCallback onBuyPressed;

  const ShoppingItemCard(
      {super.key,
      required this.item,
      required this.listId,
      required this.onDeletePressed,
      required this.onEditPressed,
      required this.onBuyPressed});

  @override
  Widget build(BuildContext context) => Card(
        child: ListTile(
          onTap: onEditPressed,
          title: Text(item.name,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  overflow: TextOverflow.fade)),
          leading: PurchasedItemButton(
            purchased: item.purchased,
            onPressed: onBuyPressed,
          ),
          subtitle: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: InfoWithIcon(
                      icon: Icons.shopping_bag,
                      info: _formatQuantityWithUnit(
                          item.quantity, item.unityType),
                    ),
                  ),
                  if (item.price != null)
                    Expanded(
                      child: InfoWithIcon(
                        icon: Icons.monetization_on,
                        info: 'R\$ ${item.price!.toStringAsFixed(2)}',
                      ),
                    )
                ],
              ),
              if (item.category.isNotEmpty)
                InfoWithIcon(
                  icon: Icons.category,
                  info: item.category.capitalize(),
                )
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
