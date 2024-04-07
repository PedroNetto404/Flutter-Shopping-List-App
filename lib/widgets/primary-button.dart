import 'package:flutter/material.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Icon? icon;
  final String text;

  const PrimaryButton(
      {super.key, required this.onPressed, this.icon, required this.text});

  @override
  Widget build(BuildContext context) => ElevatedButton(
        onPressed: onPressed,
        style: _style(context),
        child: _body(),
      );

  _body() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) icon!,
          const SizedBox(width: 8),
          Text(text)
        ],
      );

  _style(context) => ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.black,
      );
}
