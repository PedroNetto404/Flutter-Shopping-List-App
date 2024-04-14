import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/home-screen.dart';
import 'package:mobile_shopping_list_app/widgets/theme-selector.dart';
import 'package:provider/provider.dart';
import '../constants/app-route.dart';
import '../providers/auth-provider.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  const Layout({super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    if (!authProvider.isAuthenticated) return const HomeScreen();

    return Scaffold(
        appBar: _appBar(context),
        body: body,
        floatingActionButton: floatingActionButton,
        bottomNavigationBar: _bottomNavigationBar(context));
  }

  PreferredSizeWidget _appBar(BuildContext context) => AppBar(
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
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () {
                final authProvider = context.read<AuthProvider>();
                authProvider.signOut();
              }),
          const SizedBox(width: 8),
        ],
      );

  Widget _bottomNavigationBar(BuildContext context) => BottomNavigationBar(
        selectedFontSize: 16,
        selectedIconTheme: const IconThemeData(size: 40),
        unselectedFontSize: 12,
        unselectedIconTheme: const IconThemeData(size: 24),
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
            Navigator.pushReplacementNamed(
                context, AppRoute.shoppingList.value);
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
}
