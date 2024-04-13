import 'package:flutter/material.dart';

class DeveloperPicture extends StatelessWidget {
  const DeveloperPicture({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(200),
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).colorScheme.primary,
          blurRadius: 10,
          spreadRadius: 5,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(200),
      child: Image.asset(
        'assets/images/dev.jpg',
        fit: BoxFit.cover,
      ),
    ),
  );
}