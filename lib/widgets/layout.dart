import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/screens/listify-progress-screen.dart';

import '../constants/constants.dart';
import '../extensions/extensions.dart';
import '../providers/providers.dart';
import 'widgets.dart';

class Layout extends StatelessWidget {
  final Widget body;
  final Widget? floatingActionButton;

  final _routeMap = {
    AppRoute.about: 0,
    AppRoute.shoppingList: 1,
    AppRoute.profile: 2
  };

  Layout({super.key, required this.body, this.floatingActionButton});

  @override
  Widget build(BuildContext context) => Consumer<AuthProvider>(
          builder: (BuildContext context, AuthProvider value, Widget? child) {
        if (!value.isAuthenticated) {
          return const ListifyProgressScreen(
              nextScreenRoute: AppRoute.home, miliseconds: 3000);
        }

        return Scaffold(
            appBar: _appBar(context),
            body: body,
            bottomNavigationBar: _bottomNavigationBar(context),
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: FloatingActionButtonLocation.miniEndFloat);
      });

  AppBar _appBar(BuildContext context) => AppBar(
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
              onPressed: () async {
                try {
                  final provider = context.read<AuthProvider>();
                  await provider.signOut();

                  if (!context.mounted) return;

                  Navigator.of(context).pushNamedWithLoading(AppRoute.home, canPopAll: true); 
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
                }
              }),
          const SizedBox(width: 8),
        ],
      );

  Widget _bottomNavigationBar(BuildContext context) => BottomNavigationBar(
          currentIndex: _getCurrentIndex(context),
          onTap: (index) {
            if (index == _getCurrentIndex(context)) return;

            final newRoute = _routeMap.keys.firstWhere(
                (key) => _routeMap[key] == index,
                orElse: () => AppRoute.shoppingList);

            Navigator.of(context).pushNamed(newRoute);
          },
          selectedIconTheme: IconThemeData(
              size: 40, color: Theme.of(context).colorScheme.primary),
          unselectedIconTheme: IconThemeData(
              size: 24, color: Theme.of(context).colorScheme.secondary),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.circleInfo), label: 'Sobre'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.listCheck), label: 'Listas'),
            BottomNavigationBarItem(
                icon: Icon(FontAwesomeIcons.person), label: 'Perfil'),
          ]);

  int _getCurrentIndex(BuildContext context) =>
      _routeMap[ModalRoute.of(context)!.settings.name]!;
}
