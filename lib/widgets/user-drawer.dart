import 'package:flutter/material.dart';

import '../contants/routes.dart';
import '../services/auth-service.dart';

class UserDrawer extends StatelessWidget {
  final _authService = AuthService();

  UserDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: [
            _drawerHeader(),
            ..._menuItems(context)
                .map((item) => ListTile(
                      leading: item['icon'],
                      title: item['title'],
                      onTap: item['onTap'],
                    ))
                .toList()
          ],
        ),
      );

  _menuItems(context) => [
        {
          'icon': const Icon(Icons.info),
          'title': const Text("Sobre"),
          'onTap': () => Navigator.pushNamed(context, Routes.about),
        },
        {
          'icon': const Icon(Icons.exit_to_app),
          'title': const Text('Sair'),
          'onTap': () => _onSignOutPressed(context),
        }
      ];

  _drawerHeader() => DrawerHeader(
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person),
            ),
            const SizedBox(height: 8),
            Text(_authService.currentUser.email!)
          ],
        ),
      );

  void _onSignOutPressed(BuildContext context) {
    _authService
        .signOut()
        .then((value) => Navigator.pushNamed(context, Routes.home))
        .catchError((_) => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Erro ao sair da aplicação'))));
  }
}
