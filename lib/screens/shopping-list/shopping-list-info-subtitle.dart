import 'package:flutter/material.dart';
import '../../models/shopping-list.dart';
import '../../widgets/info-with-icon.dart';

class ShoppingListInfoSubtitle extends StatelessWidget {
  final ShoppingList list;

  const ShoppingListInfoSubtitle({required this.list, super.key});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoWithIcon(
            icon: Icons.calendar_today,
            info:
                '${list.createdAt.day.toString().padLeft(2, '0')}/${list.createdAt.month.toString().padLeft(2, '0')}/${list.createdAt.year}',
          ),
          InfoWithIcon(
            icon: Icons.shopping_cart,
            info: list.items.isEmpty
                ? 'Vazia'
                : list.completed
                    ? 'Concluída'
                    : '${list.items.where((element) => !element.purchased).length} / ${list.items.length}',
          ),
        ],
      );
}
