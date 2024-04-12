import 'package:flutter/material.dart';

class RegisterNameField extends StatelessWidget {
  final TextEditingController controller;

  const RegisterNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) => TextFormField(
      controller: controller,
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
