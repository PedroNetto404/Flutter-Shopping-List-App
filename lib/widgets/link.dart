import 'package:flutter/material.dart';

class Link extends StatelessWidget {
  final String route;
  final String label;

  const Link({super.key, required this.route, required this.label});

  @override
  Widget build(BuildContext context) => TextButton(
      style: TextButton.styleFrom(
        alignment: Alignment.centerLeft,
        textStyle: const TextStyle(
          fontSize: 16,
        ),
        padding: const EdgeInsets.all(0),
      ),
      onPressed: () => Navigator.pushNamed(context, route),
      child: Text(label));
}
