import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';
import 'package:mobile_shopping_list_app/widgets/conditional-loading.dart';
import 'package:mobile_shopping_list_app/widgets/theme-selector.dart';

import '../contants/app-route.dart';

class Layout extends StatefulWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const Layout({super.key, required this.body, this.floatingActionButton});

  @override
  State<Layout> createState() => _LayoutState();
}

class _LayoutState extends State<Layout> {
  Timer? _navigationTimer;

  @override
  void dispose() {
    _navigationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: AuthService().userChanges,
      builder: (context, snapshot) => ConditionalLoadingIndicator(
          predicate: () => snapshot.connectionState == ConnectionState.waiting,
          childBuilder: (context) {
            if (!snapshot.hasData) {
              _startNavigationTimer(context);
              return const Scaffold(
                  body: Center(child: CircularProgressIndicator()));
            }

            return Scaffold(
                appBar: _appBar(context, snapshot),
                body: widget.body,
                floatingActionButton: widget.floatingActionButton,
                bottomNavigationBar: _bottomNavigationBar(context));
          }));

  PreferredSizeWidget _appBar(BuildContext context, AsyncSnapshot snapshot) =>
      AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 8),
            Text('Listify',
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary))
          ],
        ),
        actions: [
          const ThemeSelector(),
          if (snapshot.hasData)
            IconButton(
                icon: const Icon(Icons.exit_to_app),
                onPressed: () => AuthService().signOut()),
          const SizedBox(width: 8),
        ],
      );

  Widget _bottomNavigationBar(BuildContext context) => BottomNavigationBar(
        currentIndex: _getCurrentIndex(context),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.info), label: 'Sobre', tooltip: 'Sobre o app'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Listas',
              tooltip: 'Minhas lista de compras'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Perfil',
              tooltip: 'Meu perfil'),
        ],
        onTap: (index) {
          final currentRoute = ModalRoute.of(context)!.settings.name;

          if (index == 0 && currentRoute != AppRoute.about.value) {
            Navigator.pushReplacementNamed(context, AppRoute.about.value);
            return;
          }

          if (index == 1 && currentRoute != AppRoute.shoppingList.value) {
            Navigator.pushReplacementNamed(context, AppRoute.shoppingList.value);
            return;
          }

          if (index == 2 && currentRoute != AppRoute.profile.value) {
            Navigator.pushReplacementNamed(context, AppRoute.profile.value);
          }
        },
      );

  int _getCurrentIndex(BuildContext context) {
    final currentRoute = ModalRoute.of(context)!.settings.name;

    if (currentRoute == AppRoute.about.value) return 0;
    if (currentRoute == AppRoute.shoppingList.value) return 1;

    return 2;
  }

  void _startNavigationTimer(BuildContext context) {
    if (_navigationTimer == null || !_navigationTimer!.isActive) {
      _navigationTimer = Timer(const Duration(seconds: 2),
          () => AppRoute.navigateTo(context, AppRoute.home));
    }
  }
}
