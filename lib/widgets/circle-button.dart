import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final Icon icon;
  final Color color;
  final VoidCallback onPressed;

  const CircleButton({
    required this.icon,
    required this.color,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) => IconButton(
      icon: icon,
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
        padding: MaterialStateProperty.all(EdgeInsets.zero),
      ));

}