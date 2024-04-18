import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/extensions/extensions.dart';
import 'package:provider/provider.dart';

import '../constants/app-route.dart';
import '../providers/auth-provider.dart';
import '../widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Login'),
          centerTitle: true,
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoute.home))),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Entre com suas credenciais',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 30),
                  EmailField(controller: _emailController),
                  const SizedBox(height: 16),
                  PasswordField(
                      controller: _passwordController,
                      onSubmitted: () => _onSignInPressed(context)),
                  const SizedBox(height: 16),
                  _navigationSection(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                        onPressed: () => _onSignInPressed(context),
                        label: const Text('Entrar'),
                        icon: const Icon(Icons.login)),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: _googleSignInButton(context),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context) =>
      ElevatedButton.icon(
          onPressed: () => _onGoogleSignInPressed(context),
          icon: const Icon(FontAwesomeIcons.google),
          label: const Text('Entrar com Google'));

  Widget _navigationSection() =>
      const Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Link(
                route: AppRoute.register,
                label: 'Não possui uma conta? Crie uma agora!'),
            Link(route: AppRoute.forgotPassword, label: 'Esqueceu sua senha?'),
          ],
        ),
      );

  void _onGoogleSignInPressed(BuildContext context) async {
    final provider = context.read<AuthProvider>();

    try {
      await provider.signInWithGoogle();

      if (!context.mounted) return;
      Navigator.of(context).pushNamedWithLoading(AppRoute.shoppingList);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }


  void _onSignInPressed(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final provider = context.read<AuthProvider>();


      final email = _emailController.text;
      final password = _passwordController.text;

      await provider.signIn(email, password);

      if (!context.mounted) return;

      Navigator.of(context).pushNamedWithLoading(AppRoute.shoppingList);
    } catch (e) {
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }
}
