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

  static const Map<AppRoute, (int, String, String, IconData)> bottomBarMap = {
    AppRoute.about: (0, 'Sobre', 'Sobre o app', Icons.info),
    AppRoute.shoppingList: (
      1,
      'Listas',
      'Minhas lista de compras',
      Icons.shopping_cart
    ),
    AppRoute.profile: (2, 'Perfil', 'Meu perfil', Icons.account_circle)
  };

  @override
  Widget build(BuildContext context) =>
      Consumer<AuthProvider>(builder: (context, provider, child) {
        if (!provider.isAuthenticated) return const HomeScreen();

        return Scaffold(
            appBar: _appBar(context, provider),
            body: body,
            floatingActionButton: floatingActionButton,
            bottomNavigationBar: _bottomNavigationBar(context));
      });

  PreferredSizeWidget _appBar(BuildContext context, AuthProvider provider) =>
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
          IconButton(
              icon: const Icon(Icons.exit_to_app),
              onPressed: () => _onSignOutPressed(context, provider)),
          const SizedBox(width: 8),
        ],
      );

  Widget _bottomNavigationBar(BuildContext context) => BottomNavigationBar(
        selectedFontSize: 16,
        unselectedFontSize: 12,
        currentIndex: _getCurrentIndex(context),
        items: bottomBarMap.entries.map((entry) {
          final (_, label, tooltip, icon) = entry.value;
          return BottomNavigationBarItem(
              label: label, tooltip: tooltip, icon: Icon(icon));
        }).toList(),
        onTap: (index) => _onBottonIconTap(index, context),
      );

  void _onBottonIconTap(int index, BuildContext context) {
    final appRoute = bottomBarMap.entries
        .firstWhere((entry) => entry.value.$1 == index)
        .key;

    if (appRoute.value == ModalRoute.of(context)!.settings.name) return;

    AppRoute.navigateTo(context, appRoute);
  }

  int _getCurrentIndex(BuildContext context) => bottomBarMap.entries
        .firstWhere(
            (entry) => entry.key.value == ModalRoute.of(context)!.settings.name)
        .value
        .$1;

  void _onSignOutPressed(BuildContext context, AuthProvider provider) =>
      provider
          .signOut()
          .then((_) => AppRoute.navigateTo(context, AppRoute.home))
          .catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'Não foi possível sair da sua conta. Tente novamente mais tarde.'),
            backgroundColor: Colors.redAccent));
      });
}
