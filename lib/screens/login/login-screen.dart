import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/services/auth-service.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';
import 'package:mobile_shopping_list_app/widgets/password-field.dart';
import '../../contants/app-route.dart';
import 'login-navigation-section.dart';

class LoginScreen extends StatelessWidget {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  LoginScreen({super.key});

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
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30),
                EmailField(controller: _emailController),
                const SizedBox(height: 16),
                PasswordField(controller: _passwordController),
                const SizedBox(height: 16),
                const NavigationSection(),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      onPressed: () => _onSignInPressed(context),
                      label: const Text('Entrar'),
                      icon: const Icon(Icons.login)),
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
      final email = _emailController.text;
      final password = _passwordController.text;

      AuthService()
          .signIn(email: email, password: password)
          .then((value) => AppRoute.navigateTo(context, AppRoute.home))
          .catchError((_) => _showSnackBarError(context));
    }
  }

  _showSnackBarError(context) => ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Erro ao fazer login. Verifique suas credenciais e tente novamente.'),
        ),
      );
}
