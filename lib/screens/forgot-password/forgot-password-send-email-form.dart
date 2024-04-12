import 'package:flutter/material.dart';

import '../../widgets/email-field.dart';

class ForgotPasswordSendEmailForm extends StatelessWidget {
  final TextEditingController emailController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final void Function() onSendEmailPressed;

  ForgotPasswordSendEmailForm(
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
