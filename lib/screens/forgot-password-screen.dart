import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/email-field.dart';

import '../services/auth-service.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isEmailSent = false;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Esqueci minha senha'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: _isEmailSent ? _emailSentMessage() : _sendEmailForm(),
        ),
      ),
    );
  }

  Column _sendEmailForm() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Entre com seu e-mail para redefinir a senha',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 16),
              EmailField(controller: _emailController),
            ],
          ),
          const SizedBox(height: 30),
          _errorMessageBox(),
          ElevatedButton(
              onPressed: _onSendEmailPressed,
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
      );

  _errorMessageBox() => _errorMessage != null
      ? Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red),
          ),
        )
      : const SizedBox();

  void _onSendEmailPressed() {
    final email = _emailController.text;

    if (email.isEmpty) {
      setState(() {
        _errorMessage = 'Preencha o campo de e-mail';
      });
      return;
    }

    AuthService()
        .sendPasswordResetEmail(email: _emailController.text)
        .then((value) => setState(() {
              _isEmailSent = true;
            }))
        .catchError((error) => setState(() {
              _errorMessage = error.toString();
            }));
  }

  _emailSentMessage() => const Padding(
        //top padding
        padding: EdgeInsets.only(top: 80),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check, color: Colors.green, size: 25),
                SizedBox(width: 8),
                Text('Email enviado com sucesso.',
                    style:
                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
              ],
            ),
            SizedBox(height: 16),
            Text(
                'Verifique sua caixa de entrada e acesse o link para redefinir sua senha.',
                style: TextStyle(fontSize: 20))
          ],
        ),
      );
}
