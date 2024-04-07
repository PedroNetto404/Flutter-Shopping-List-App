import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String customLabel;

  const PasswordField({super.key, required this.controller, this.customLabel = 'Senha'});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: _decorate(),
        keyboardType: TextInputType.visiblePassword,
        obscureText: _isObscured,
        validator: _validatePassword,
      );

  _decorate() => InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: _suffix(),
        labelText: widget.customLabel,
        border: const OutlineInputBorder(),
      );

  _suffix() => IconButton(
      onPressed: _toggleObscure,
      icon: Icon(_isObscured ? Icons.visibility : Icons.visibility_off));

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha.';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }

    return null;
  }
}
