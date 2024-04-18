import 'package:flutter/material.dart';

class EmptyBanner extends StatelessWidget {
  final VoidCallback onTap;
  final String message;
  final IconData icon;

  const EmptyBanner({super.key, required this.onTap, required this.message, required this.icon});

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Icon(icon, size: 64),
              const SizedBox(height: 16),
              Text(message,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.bold))
            ]),
          ),
        ),
      );
}
