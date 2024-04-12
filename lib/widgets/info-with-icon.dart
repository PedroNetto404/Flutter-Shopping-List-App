import 'package:flutter/cupertino.dart';

class InfoWithIcon extends StatelessWidget {
  final IconData icon;
  final String info;

  const InfoWithIcon({super.key, required this.icon, required this.info});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Icon(icon, size: 16),
        const SizedBox(width: 4),
        Flexible(
          child: Text(info),
        ),
      ],
    ),
  );
}