import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/models/shopping-item.dart';

import '../models/enums/unit-type.dart';

class ShoppingItemCard extends StatefulWidget {
  final ShoppingItem item;
  final void Function() onDelete;

  const ShoppingItemCard({super.key, required this.item, required this.onDelete});

  @override
  State<ShoppingItemCard> createState() => _ShoppingItemCardState();
}

class _ShoppingItemCardState extends State<ShoppingItemCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          color: widget.item.buyed
              ? Theme.of(context).colorScheme.secondary.withOpacity(0.5)
              : null,
          child: ListTile(
              title: Text(widget.item.name),
              enabled: !widget.item.buyed,
              leading: Checkbox(
                value: widget.item.buyed,
                onChanged: (value) {
                  setState(() {
                    widget.item.buyed = value!;
                  });
                },
              ),
              subtitle: Text(
                  '${widget.item.quantity} ${widget.item.unityType.toString().split('.').last}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: widget.onDelete,
                  ),
                  IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                ],
              )),
        ),
        onTap: () {
          setState(() {
            widget.item.buyed = !widget.item.buyed;
          });
        });
  }
}
