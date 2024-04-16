import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_shopping_list_app/widgets/listfy-logo.dart';
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
      appBar: AppBar(title: const Text('Login'), centerTitle: true,
       leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => AppRoute.navigateTo(context, AppRoute.home))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 30),
              child: ListifyLogo(),
            ),
            Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _googleSignInButton(BuildContext context) => ElevatedButton.icon(
      onPressed: () => _onGoogleSignInPressed(context),
      icon: const Icon(FontAwesomeIcons.google),
      label: const Text('Entrar com Google'));

  Widget _navigationSection() => const Align(
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

  void _onGoogleSignInPressed(BuildContext context) {
    context.read<AuthProvider>().signInWithGoogle().then((_) {
      AppRoute.navigateWithLoading(context, AppRoute.shoppingList);
    }).catchError((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              'Erro ao fazer login com Google. Tente novamente mais tarde.'),
        ),
      );
    });
  }

  void _onSignInPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;

      context
          .read<AuthProvider>()
          .signIn(email, password)
          .then((_) => AppRoute.navigateWithLoading(context, AppRoute.shoppingList))
          .catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text(
                'Erro ao fazer login. Verifique suas credenciais e tente novamente.'),
          ),
        );
      });
    }
  }
}
