import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/app-route.dart';

class ForgotPasswordSuccessEmailSentDialog extends StatelessWidget {
  const ForgotPasswordSuccessEmailSentDialog({super.key});

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
