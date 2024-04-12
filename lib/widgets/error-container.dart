import 'package:flutter/material.dart';

class ErrorContainer extends StatelessWidget {
  final String message;

  const ErrorContainer({super.key, required this.message});

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            message,
            style: const TextStyle(color: Colors.red),
          ),
        ),
      );
}
