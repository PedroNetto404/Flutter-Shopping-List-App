import 'package:flutter/material.dart';
import '../contants/routes.dart';
import '../services/auth-service.dart';

class UserDrawer extends StatelessWidget {
  final _authService = AuthService();

  late final List<Map<String, dynamic>> _menuItems = [
    {
      'icon': Icons.info,
      'title': 'Sobre',
      'onTap': (context) => Navigator.pushNamed(context, Routes.about),
    },
    {
      'icon': Icons.exit_to_app,
      'title': 'Sair',
      'onTap': (context) => _onSignOutPressed(context),
    }
  ];

  UserDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          children: [
            _DrawerHeader(authService: _authService),
            ..._menuItems.map((item) => _MenuItem(item))
          ],
        ),
      );

  void _onSignOutPressed(BuildContext context) => _authService
        .signOut()
        .then((value) => Navigator.pushNamed(context, Routes.home))
        .catchError((error) => _showSnackBarError(context));

  _showSnackBarError(BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao sair da aplicação')));
}

class _MenuItem extends StatelessWidget {
  final Map<String, dynamic> _item;

  const _MenuItem(item, {super.key}) : _item = item;

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(top: 8),
        child: ListTile(
          leading: Icon(_item['icon']),
          title: Text(_item['title']),
          onTap: () => _item['onTap'](context),
        ),
      );
}

class _DrawerHeader extends StatelessWidget {
  final AuthService _authService;

  const _DrawerHeader({super.key, required AuthService authService})
      : _authService = authService;

  @override
  Widget build(BuildContext context) => DrawerHeader(
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
}
