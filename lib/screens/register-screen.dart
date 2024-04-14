import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';
import 'package:mobile_shopping_list_app/widgets/error-container.dart';
import 'package:mobile_shopping_list_app/widgets/password-field.dart';
import '../services/auth-service.dart';
import '../contants/app-route.dart';
import '../widgets/link.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _nameController = TextEditingController();
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
                      customHint: 'Digite a senha novamente'),
                  if (_errorMessage != null)
                    ErrorContainer(message: _errorMessage!),
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
                      onPressed: _onRegisterPressed,
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
  }

  void _onRegisterPressed() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text;
    final password = _passwordController.text;
    final passwordConfirmation = _passwordConfirmationController.text;
    final name = _nameController.text;

    if (password != passwordConfirmation) {
      setState(() => _errorMessage = 'As senhas não conferem');
      return;
    }

    AuthService()
        .create(email: email, password: password, name: name)
        .then((value) => AppRoute.navigateTo(context, AppRoute.shoppingList))
        .catchError(
            (error) => setState(() => _errorMessage = error.toString()));
  }

  Widget _registerNameField() => TextFormField(
      controller: _nameController,
      decoration: const InputDecoration(
        prefixIcon: Icon(Icons.person),
        labelText: 'Nome',
        hintText: 'Digite seu nome',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor, digite seu nome';
        }
        return null;
      },
      textInputAction: TextInputAction.next);
}
