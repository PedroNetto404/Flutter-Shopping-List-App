import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => TextFormField(
        enableSuggestions: true,
        controller: controller,
        decoration: const InputDecoration(
            prefixIcon: Icon(Icons.email),
            labelText: 'E-mail',
            hintText: 'Digite seu e-mail'
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        keyboardType: TextInputType.emailAddress,
        validator: _validateEmail,
        textInputAction: TextInputAction.next,
      );

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira um e-mail';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return "E-mail inválido, verifique e tente novamente";
    }

    return null;
  }
}
