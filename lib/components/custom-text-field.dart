import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final bool obscureText;
  final String labelText;
  final TextEditingController textEditingController;

  const CustomTextField({
    required this.obscureText,
    required this.labelText,
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(padding: EdgeInsets.all(16), child: TextField(
      controller: textEditingController,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        labelStyle: TextStyle(color: Colors.white),
      ),
      obscureText: obscureText,
    ));
  }
}