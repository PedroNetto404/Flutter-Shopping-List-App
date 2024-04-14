import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';
import '../services/auth-service.dart';
import '../widgets/theme-selector.dart';

class HomeScreen extends StatelessWidget {
  final _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
      body: Column(
        children: [
          Expanded(flex: 3, child: _TopSection()),
          Expanded(flex: 6, child: _BottomSection()),
        ],
      ),
    );
}


class _TopSection extends StatelessWidget {
  const _TopSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
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
        const Align(
            alignment: Alignment.bottomCenter, child: _ListfyBanner()),
      ],
    ),
  );
}

class _BottomSection extends StatelessWidget {
  const _BottomSection({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _FunnyGifSection(),
            SizedBox(height: 16),
            _WelcomeSection(),
            SizedBox(height: 16),
            _SignSection(),
          ],
        )),
  );
}
class _ListfyBanner extends StatelessWidget {
  const _ListfyBanner({super.key});

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

class _FunnyGifSection extends StatelessWidget {
  const _FunnyGifSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          border: Border.all(
              color: Theme.of(context).colorScheme.primary, width: 6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset('assets/images/lost_in_supermarket.gif',
            height: 150,
            width: double.infinity,
            fit: BoxFit.fitWidth),
      );
}


class _SignSection extends StatelessWidget {
  const _SignSection({super.key});

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

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) =>
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
          style: TextStyle(
            fontSize: 16
          ),
        ),
      ]);
}
