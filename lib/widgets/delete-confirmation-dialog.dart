import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final Widget title;
  final Widget content;
  final void Function() onConfirm;

  const DeleteConfirmationDialog(
      {super.key,
      required this.title,
      required this.content,
      required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title,
      content: content,
      actions: [
        OutlinedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: () {
            onConfirm();
            Navigator.pop(context);
          },
          child: const Text('Excluir'),
        ),
      ],
    );
  }
}
