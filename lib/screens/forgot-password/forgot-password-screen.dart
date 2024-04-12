import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/forgot-password/forgot-password-send-email-form.dart';
import 'package:mobile_shopping_list_app/screens/forgot-password/forgot-password-success-email-sent-dialog.dart';

import '../../services/auth-service.dart';

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
            child: ForgotPasswordSendEmailForm(
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
      builder: (context) => const ForgotPasswordSuccessEmailSentDialog());
}
