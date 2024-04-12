import 'package:flutter/material.dart';

class HomeWelcomeSection extends StatelessWidget {
  const HomeWelcomeSection({super.key});

  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text(
          'Bem-vindo a',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Listify!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const Text(
          '🧠 Nunca mais esqueça de comprar algo no supermercado! 🛒',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ]);
}
