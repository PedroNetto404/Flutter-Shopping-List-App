import 'package:flutter/cupertino.dart';

import 'clipped-text.dart';

class SectionHeader extends StatelessWidget {
  final IconData icon;
  final String text;

  const SectionHeader({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              ClippedText(
                  text: text, fontSize: 28, fontWeight: FontWeight.bold),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
}
