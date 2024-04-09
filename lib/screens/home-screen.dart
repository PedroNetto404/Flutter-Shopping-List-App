import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/routes.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list-screen.dart';
import 'package:mobile_shopping_list_app/widgets/full-screen-progress-indicator.dart';
import 'package:mobile_shopping_list_app/widgets/primary-button.dart';
import '../services/auth-service.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder(
      stream: AuthService().authStateChanges, builder: _streamBuilder);

  Widget _streamBuilder(BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const FullScreenProgressIndicator();
    }

    if (snapshot.hasData) return const ShoppingListScreen();

    return Scaffold(
      body: Column(
        children: [
          Expanded(flex: 4, child: _HomeTopSection()),
          Expanded(flex: 6, child: _HomeBottomSection()),
        ],
      ),
    );
  }
}

class _HomeTopSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Image.asset(
            'assets/images/shopping-list-note.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
          ),
          const Positioned(bottom: 0, left: 0, right: 0, child: _ListfyBanner())
        ],
      );
}

class _ListfyBanner extends StatelessWidget {
  const _ListfyBanner({super.key});

  @override
  Widget build(BuildContext context) => Container(
      height: 60, decoration: _boxDecoration(context), child: _content());

  _content() => const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart,
            size: 30,
          ),
          SizedBox(width: 10),
          Text(
            'Listify',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );

  _boxDecoration(context) => BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      );
}

class _HomeBottomSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Center(
        child: Container(
            alignment: Alignment.center,
            width: double.infinity,
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

class _FunnyGifSection extends StatelessWidget {
  const _FunnyGifSection({super.key});

  @override
  Widget build(BuildContext context) =>
      Container(
        decoration: BoxDecoration(
          //borda arrredondada
          border: Border.all(color: Theme.of(context).colorScheme.primary, width: 6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Image.asset('assets/images/lost_in_supermarket.gif',
            height: 150, width: double.infinity, fit: BoxFit.fitWidth),
      );
}

class _WelcomeSection extends StatelessWidget {
  const _WelcomeSection({super.key});

  @override
  Widget build(BuildContext context) =>
      const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          'Bem-vindo a',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          'Listify!',
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'Nunca mais esqueça de comprar algo no supermercado!',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ]);
}

class _SignSection extends StatelessWidget {
  const _SignSection({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          PrimaryButton(
              onPressed: () => Navigator.pushNamed(context, Routes.login),
              text: 'Entrar',
              icon: const Icon(Icons.login)),
          const SizedBox(height: 16),
          PrimaryButton(
              onPressed: () => Navigator.pushNamed(context, Routes.register),
              text: 'Registrar',
              icon: const Icon(Icons.person_add)),
        ],
      );
}
