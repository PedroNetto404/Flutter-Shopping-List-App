import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/components/shopping-item-card.dart';
import 'package:mobile_shopping_list_app/models/shopping-item.dart';

import '../models/shopping-list.dart';

class ShoppingListDetails extends StatefulWidget {
  const ShoppingListDetails({super.key});

  @override
  State<ShoppingListDetails> createState() => _ShoppingListDetailsState();
}

class _ShoppingListDetailsState extends State<ShoppingListDetails> {
  late List<ShoppingItem> items;

  @override
  Widget build(BuildContext context) {
    var shoppingList = ModalRoute.of(context)!.settings.arguments as ShoppingList;
    items = shoppingList.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Detalhes da lista de compras'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Exibe modal para editar o nome da lista ou adicionar um item a lista
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text('Lista: ${shoppingList.name}', style: Theme.of(context).textTheme.headline6),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return ShoppingItemCard(item: items[index], onDelete: () {});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}