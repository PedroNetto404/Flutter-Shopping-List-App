import 'package:flutter/material.dart';

class HomeListfyBanner extends StatelessWidget {
  const HomeListfyBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
      height: 60,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            color: Theme.of(context).colorScheme.background,
            Icons.shopping_cart,
            size: 30,
          ),
          const SizedBox(width: 10),
          Text(
            'Listify',
            style: TextStyle(
                fontSize: 24,
                color: Theme.of(context).colorScheme.background,
                fontWeight: FontWeight.bold),
          ),
        ],
      ));
}
