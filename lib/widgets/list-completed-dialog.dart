import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/extensions/string-extensions.dart';

class ListCompletedDialog extends StatelessWidget {
  final String listName;

  const ListCompletedDialog({super.key, required this.listName});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green),
            SizedBox(width: 8),
            Text('Lista concluída')
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text('A lista'),
                Text(' "${listName.capitalize()}"',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                const Text(' foi concluída com sucesso!')
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomRight,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            )
          ],
        ),
      );
}
