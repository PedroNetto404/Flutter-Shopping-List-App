import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';
import 'package:mobile_shopping_list_app/widgets/password-field.dart';
import 'package:mobile_shopping_list_app/widgets/primary-button.dart';
import 'package:mobile_shopping_list_app/widgets/link.dart';

import '../contants/routes.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login'), centerTitle: true),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Entre com suas credenciais',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                EmailField(controller: _emailController),
                const SizedBox(height: 16),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 16),
                _navigationSection(context),
                const SizedBox(height: 16),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PrimaryButton(
                        onPressed: () => _onSignInPressed(context),
                        text: 'Entrar',
                        icon: const Icon(Icons.login)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSignInPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      // Adicionado validação do formulário
      final email = _emailController.text;
      final password = _passwordController.text;

      AuthService()
          .signIn(email: email, password: password)
          .then((value) => Navigator.pushNamed(context, Routes.shoppingList))
          .catchError((_) => {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                        'Erro ao fazer login. Verifique suas credenciais e tente novamente.',
                        style: TextStyle(color: Colors.white)),
                    backgroundColor: Colors.red,
                  ),
                )
              });
    }
  }

  Widget _navigationSection(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Link(
              route: Routes.register,
              label: 'Não possui uma conta? Crie uma agora!'),
          Link(route: Routes.forgotPassword, label: 'Esqueceu sua senha?'),
        ],
      );
}
