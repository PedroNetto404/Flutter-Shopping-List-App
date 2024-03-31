import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/models/enums/unit-type.dart';
import 'package:mobile_shopping_list_app/models/shopping-item.dart';
import '../contants/routes.dart';
import '../models/shopping-list.dart';



class _ShoppingListCard extends StatelessWidget {
  final ShoppingList list;
  final void Function() onDelete;

  const _ShoppingListCard(
      {Key? key, required this.list, required this.onDelete})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Card(
          color: Theme.of(context).colorScheme.primary,
          child: ListTile(
            title: Text(list.name),
            subtitle: Text('${list.items.length} itens'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: onDelete,
            ),
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, Routes.shoppingListDetails,
              arguments: list);
        });
  }
}

class ShoppingListScreen extends StatefulWidget {
  ShoppingListScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ShoppingListScreenState();
  }
}

class _ShoppingListScreenState extends State<ShoppingListScreen> {
  final List<ShoppingList> lists = [
    ShoppingList('Supermercado', items: [
      ShoppingItem('Arroz 5kg', UnityType.un, 2, 'grão'),
      ShoppingItem('Feijão 1kg', UnityType.un, 1, 'grão'),
      ShoppingItem('Macarrão 500g', UnityType.un, 3, 'massa'),
      ShoppingItem('Carne 1kg', UnityType.un, 1, 'proteína'),
      ShoppingItem('Leite 1l', UnityType.un, 2, 'laticínio'),
      ShoppingItem('Ovos 12un', UnityType.un, 1, 'proteína'),
      ShoppingItem('Carne vermelha', UnityType.kg, 1.5, 'proteína'),
    ])
  ];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de compras'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Adicionar lista de compras'),
              content: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Nome da lista',
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      lists.add(ShoppingList(_controller.text));
                    });
                    Navigator.pop(context);
                  },
                  child: const Text('Adicionar'),
                ),
              ],
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Itens',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: lists.length,
                itemBuilder: (context, index) {
                  return _ShoppingListCard(
                      list: lists[index],
                      onDelete: () => {
                            setState(() {
                              lists.removeAt(index);
                            })
                          });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
