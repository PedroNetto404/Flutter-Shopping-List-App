import 'package:flutter/material.dart';

class PurchasedItemButton extends StatelessWidget {
  
  final bool purchased;
  final VoidCallback onPressed;

  const PurchasedItemButton({super.key, required this.purchased, required this.onPressed});

  @override
  Widget build(BuildContext context) => purchased
    ? const Icon(Icons.check_circle, color: Colors.green)
    : IconButton(
      icon: const Icon(Icons.shopping_cart, color: Colors.yellow),
      onPressed: onPressed,
    );
}