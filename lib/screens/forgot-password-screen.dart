import 'package:flutter/material.dart';

import '../contants/app-route.dart';
import '../services/auth-service.dart';
import '../widgets/email-field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Esqueci minha senha'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: _SendEmailForm(
                emailController: _emailController,
                onSendEmailPressed: () => _onSendEmailPressed(context)),
          ),
        ),
      );

  void _onSendEmailPressed(BuildContext context) => AuthService()
      .sendPasswordResetEmail(email: _emailController.text)
      .then((value) => _showSuccessDialog(context))
      .catchError((_) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                const Text('Erro ao enviar email de redefinição de senha.'),
            backgroundColor: Theme.of(context).colorScheme.error,
          )));

  void _showSuccessDialog(BuildContext context) => showDialog(
      context: context,
      builder: (context) => const _SuccessEmailSentDialog());
}

class _SendEmailForm extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final void Function() onSendEmailPressed;

  _SendEmailForm(
      {super.key,
      required this.emailController,
      required this.onSendEmailPressed});

  @override
  Widget build(BuildContext context) => Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Entre com seu e-mail para redefinir a senha',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                EmailField(controller: emailController),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton(
                onPressed: onSendEmailPressed,
                child: const Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email),
                    SizedBox(width: 8),
                    Text('Enviar link de redefinição de senha'),
                  ],
                ))
          ],
        ),
      );
}

class _SuccessEmailSentDialog extends StatelessWidget {
  const _SuccessEmailSentDialog({super.key});

  @override
  Widget build(BuildContext context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.check, color: Colors.green),
            SizedBox(width: 10),
            Text('Email enviado!'),
          ],
        ),
        content: const Text(
          'Verifique sua caixa de entrada e siga as instruções para recuperar sua senha.',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              AppRoute.navigateTo(context, AppRoute.login);
            },
            child: const Text('OK'),
          ),
        ],
      );
}
