import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;
  final String customLabel;
  final String customHint;
  final void Function()? onSubmitted;
  final String? Function(String?)? additionalValidator;

  const PasswordField(
      {super.key,
      required this.controller,
      this.customLabel = 'Senha',
      this.customHint = 'Digite sua senha',
      this.onSubmitted,
      this.additionalValidator});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) => TextFormField(
        controller: widget.controller,
        decoration: InputDecoration(
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
              onPressed: _toggleObscure,
              icon:
                  Icon(_isObscured ? Icons.visibility : Icons.visibility_off)),
          hintText: widget.customHint,
          labelText: widget.customLabel,
        ),
        keyboardType: TextInputType.visiblePassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        obscureText: _isObscured,
        validator: _validatePassword,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      );

  void _toggleObscure() => setState(() => _isObscured = !_isObscured);

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira uma senha.';
    }

    if (value.length < 6) {
      return 'A senha deve ter no mínimo 6 caracteres.';
    }

    return widget.additionalValidator?.call(value);
  }
}
