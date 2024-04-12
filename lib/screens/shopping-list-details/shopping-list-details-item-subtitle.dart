import 'package:flutter/material.dart';
import '../../models/shopping-item.dart';
import '../../widgets/info-with-icon.dart';

class ShoppingListDetailsItemSubtitle extends StatelessWidget {
  final ShoppingItem item;

  const ShoppingListDetailsItemSubtitle({super.key, required this.item});

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InfoWithIcon(
            icon: Icons.shopping_bag,
            info:
                '${item.quantity} ${item.unityType.toString().split('.').last.toUpperCase()}',
          ),
          InfoWithIcon(
            icon: Icons.category,
            info: item.category,
          ),
        ],
      );
}
