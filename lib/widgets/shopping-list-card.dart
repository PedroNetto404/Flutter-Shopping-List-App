import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';
import '../extensions/extensions.dart';

class ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;
  final VoidCallback onTap;
  final VoidCallback onDownloadPressed;
  final VoidCallback onCopyPressed;

  const ShoppingListCard(
      {required this.list,
      super.key,
      required this.onDeletePressed,
      required this.onEditPressed,
      required this.onTap,
      required this.onDownloadPressed,
      required this.onCopyPressed});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Card(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [_title(), _body(context), _bottonActions()],
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _rigthActions(),
                  ))
            ],
          ),
        )),
      );

  Widget _title() => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Expanded(
            child: Text(list.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    overflow: TextOverflow.ellipsis)),
          ),
        ),
      );

  Widget _body(context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Column(children: [
              InfoWithIcon(
                icon: Icons.calendar_today,
                info: list.createdAt.toSouthAmericaFormat(),
              ),
              InfoWithIcon(
                icon: Icons.shopping_bag,
                info: _formatItensCout(list),
              ),
              if (list.totalPrice != null)
                InfoWithIcon(
                  icon: Icons.monetization_on,
                  info: 'R\$ ${list.totalPrice!.toCurrency()}',
                )
            ]),
          )
        ],
      );

  Widget _bottonActions() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(onPressed: onEditPressed, icon: const Icon(Icons.edit)),
          IconButton(icon: const Icon(Icons.delete), onPressed: onDeletePressed)
        ],
      );

  Widget _rigthActions() =>
      Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: IconButton(
              onPressed: onCopyPressed,
              icon: const Icon(FontAwesomeIcons.copy)),
        ),
        list.items.isNotEmpty
            ? PurchasedItemButton(purchased: list.completed, onPressed: onTap)
            : IconButton(
                onPressed: onTap,
                icon: const Icon(FontAwesomeIcons.circleArrowRight)),
        IconButton(
          icon: const Icon(Icons.file_download),
          onPressed: onDownloadPressed,
        )
      ]);

  String _formatItensCout(ShoppingList list) => list.items.isEmpty
      ? 'Vazia'
      : list.completed
          ? 'Concluída'
          : '${list.items.where((element) => !element.purchased).length} / ${list.items.length}';
}
