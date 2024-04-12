import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';

class Link extends StatelessWidget {
  final AppRoute route;
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
        onPressed: () => AppRoute.navigateTo(context, route),
        child: Text(label),
      );
}
