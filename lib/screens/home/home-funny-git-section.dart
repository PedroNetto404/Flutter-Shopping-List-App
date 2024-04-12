import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeFunnyGifSection extends StatelessWidget {
  const HomeFunnyGifSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      border: Border.all(
          color: Theme.of(context).colorScheme.primary, width: 6),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Image.asset('assets/images/lost_in_supermarket.gif',
        height: 150, width: double.infinity, fit: BoxFit.fitWidth),
  );
}


