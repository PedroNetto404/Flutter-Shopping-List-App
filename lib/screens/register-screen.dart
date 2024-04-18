import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../providers/providers.dart';
import '../constants/constants.dart';
import '../widgets/widgets.dart';
import '../extensions/extensions.dart';

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
                    _registerButtons(context),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget _registerButtons(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _onRegisterPressed(context),
              icon: const Icon(Icons.person),
              label: const Text('Cadastrar'),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                  onPressed: () => _onRegisterWithGoogleProvider(context),
                  icon: const Icon(FontAwesomeIcons.google),
                  label: const Text('Cadastrar com Google'))),
        ]),
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

  void _onRegisterPressed(BuildContext context) =>
      _onRegister(context, (provider) async {
        if (!_formKey.currentState!.validate()) return;

        final name = _nameController.text.trim();
        final email = _emailController.text.trim();
        final password = _passwordController.text.trim();

        await provider.create(email, password, name);
      });

  void _onRegisterWithGoogleProvider(BuildContext context) => _onRegister(
      context, (provider) async => await provider.signInWithGoogle());

  void _onRegister(BuildContext context,
      Future<void> Function(AuthProvider) registerMethod) async {
    final provider = context.read<AuthProvider>();

    try {
      await registerMethod(provider);

      if (!context.mounted) return;

      Navigator.of(context).pushNamedWithLoading(AppRoute.shoppingList); 
    } catch (e) {
      ScaffoldMessenger.of(context).showUnexpectedErrorSnackBar(e);
    }
  }
}