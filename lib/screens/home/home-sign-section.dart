import 'package:flutter/material.dart';

import '../../contants/app-route.dart';

class HomeSignSection extends StatelessWidget {
  const HomeSignSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      ElevatedButton.icon(
        onPressed: () => AppRoute.navigateTo(context, AppRoute.login),
        icon: const Icon(Icons.login),
        label: const Text('Entrar'),
      ),
      const SizedBox(height: 16),
      ElevatedButton.icon(
        onPressed: () => AppRoute.navigateTo(context, AppRoute.register),
        icon: const Icon(Icons.person_add),
        label: const Text('Cadastrar'),
      ),
    ],
  );
}
