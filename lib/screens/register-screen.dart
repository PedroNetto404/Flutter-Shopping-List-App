import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';
import 'package:mobile_shopping_list_app/widgets/password-field.dart';
import 'package:provider/provider.dart';
import '../providers/auth-provider.dart';
import '../constants/app-route.dart';
import '../widgets/link.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Crie sua conta'),
            centerTitle: true,
            leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context))),
        body: Form(
          key: _formKey,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      ' Cadastre suas credenciais',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 30),
                    _registerNameField(),
                    const SizedBox(height: 16),
                    EmailField(controller: _emailController),
                    const SizedBox(height: 16),
                    PasswordField(controller: _passwordController),
                    const SizedBox(height: 16),
                    PasswordField(
                        controller: _passwordConfirmationController,
                        customLabel: 'Confirmação de senha',
                        customHint: 'Digite a senha novamente',
                        additionalValidator: (value) {
                          if (value != _passwordController.text) {
                            return 'As senhas não conferem';
                          }
                          return null;
                        }),
                    const SizedBox(height: 16),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Link(
                        label: 'Já tem uma conta? Faça login',
                        route: AppRoute.login,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _onRegisterPressed(context),
                        icon: const Icon(Icons.person),
                        label: const Text('Cadastrar'),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _registerNameField() => TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Nome',
        hintText: 'Digite seu nome',
      ),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite seu nome';
        }
        return null;
      },
      textInputAction: TextInputAction.next);

  void _onRegisterPressed(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;

    context
        .read<AuthProvider>()
        .create(email, password, name)
        .then((value) => AppRoute.navigateTo(context, AppRoute.shoppingList))
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar a conta: $error'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    });
  }
}
