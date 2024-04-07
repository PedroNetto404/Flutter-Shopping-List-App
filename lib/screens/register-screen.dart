import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';
import 'package:mobile_shopping_list_app/widgets/password-field.dart';
import '../services/auth-service.dart';
import '../contants/routes.dart';
import '../widgets/link.dart';
import '../widgets/primary-button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crie sua conta'),
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Cadastre suas credenciais',
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
                  PasswordField(
                      controller: _passwordConfirmationController,
                      customLabel: 'Confirme a senha'),
                  _errorMessageWidget(),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Link(
                      label: 'Já tem uma conta? Faça login',
                      route: Routes.login,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    onPressed: _onRegisterPressed,
                    text: 'Cadastrar',
                    icon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onRegisterPressed() async {
    if (_formKey.currentState!.validate()) {
      final email = _emailController.text;
      final password = _passwordController.text;
      final passwordConfirmation = _passwordConfirmationController.text;

      if (password != passwordConfirmation) {
        setState(() {
          _errorMessage = 'As senhas não conferem';
        });
        return;
      }

      try {
        await AuthService()
            .create(email: email, password: password)
            .then((value) => Navigator.pushNamed(context, Routes.shoppingList));
      } on FirebaseAuthException catch (e) {
        setState(() {
          _errorMessage = e.message;
        });
      }
    }
  }

  Widget _errorMessageWidget() {
    if (_errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        _errorMessage!,
        style: const TextStyle(color: Colors.red),
      ),
    );
  }
}
