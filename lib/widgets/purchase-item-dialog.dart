import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/extensions/extensions.dart';
import 'package:mobile_shopping_list_app/models/models.dart';
import 'package:mobile_shopping_list_app/widgets/number-field.dart';

class PurchaseItemDialog extends StatefulWidget {
  final ShoppingItem item;
  final void Function(double quantity, double price) onPurchase;

  const PurchaseItemDialog({super.key, required this.item, required this.onPurchase});

  @override
  State<PurchaseItemDialog> createState() => _PurchaseItemDialogState();
}

class _PurchaseItemDialogState extends State<PurchaseItemDialog> {
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController(text: '1');

  late double? itemTotalPrice;

  @override
  void initState() {
    super.initState();
    itemTotalPrice = widget.item.totalPrice;
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(FontAwesomeIcons.cartShopping, color: Colors.yellow),
                const SizedBox(width: 8),
                Text('Comprar ${widget.item.name}',
                    style:
                        const TextStyle(overflow: TextOverflow.ellipsis)),
              ],
            ),
            if(itemTotalPrice != null)
              Text(itemTotalPrice!.toCurrency(),
                  style: const TextStyle(fontSize: 16, overflow: TextOverflow.ellipsis)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            NumberField(
                controller: _quantityController,
                precision: 3,
                label: 'Quantidade',
                hint: 'Altere a quantidade desejada',
                initialValue: widget.item.quantity),
            const SizedBox(height: 8),
            NumberField(
                controller: _priceController,
                initialValue: widget.item.price ?? 1,
                precision: 2,
                label: 'Valor',
                numberSymbol: 'R\$ ',
                hint: 'Digite o valor do item'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          OutlinedButton(
            onPressed: () {
              final quantity = double.tryParse(_quantityController.text);
              final price = double.tryParse(_priceController.text);

              widget.onPurchase(quantity ?? 1, price ?? 1);

              Navigator.pop(context);
            },
            child: const Text('Comprar'),
          ),
        ],
      );
}
