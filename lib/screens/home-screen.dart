import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/constants/app-route.dart';

import '../widgets/theme-selector.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: false,
    child: Scaffold(
        body: Column(
          children: [
            Expanded(flex: 1, child: _topSection(context)),
            Expanded(flex: 2, child: _bottomSection(context)),
          ],
        ),
      ));

  Widget _topSection(BuildContext context) => Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/shopping-list-note.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: Container(
                  margin: const EdgeInsets.only(top: 40, right: 20),
                  child: const ThemeSelector()),
            ),
            _listifyBanner(context)
          ],
        ),
      );

  Widget _bottomSection(BuildContext context) => Center(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _funnyGifSection(context),
                const SizedBox(height: 16),
                _welcomeSection(context),
                const SizedBox(height: 16),
                _signSection(context),
              ],
            )),
      );

  Widget _funnyGifSection(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset('assets/images/lost_in_supermarket.gif',
            height: 150, width: double.infinity, fit: BoxFit.fitWidth),
      );

  Widget _signSection(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton.icon(
            onPressed: () => AppRoute.navigateTo(context, AppRoute.login),
            icon: const Icon(Icons.login),
            label: const Text('Entrar'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => AppRoute.navigateTo(context, AppRoute.register),
            icon: const Icon(Icons.person_add),
            label: const Text('Cadastrar'),
          ),
        ],
      );

  Widget _welcomeSection(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          children: [
            const Text(
              'Bem-vindo a',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Listify!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
        const Text(
          '🧠🛒 Nunca mais esqueça de comprar algo no supermercado!',
          style: TextStyle(fontSize: 16),
        ),
      ]);

  Widget _listifyBanner(context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), topLeft: Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart,
                color: Theme.of(context).colorScheme.onPrimary),
            const SizedBox(width: 8),
            Text(
              'Listify',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      );
}
