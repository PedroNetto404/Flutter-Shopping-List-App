import 'package:flutter/material.dart';

class ListifyLogo extends StatelessWidget {
  const ListifyLogo({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      height: MediaQuery.of(context).size.width * 0.3,
      child: Expanded(
          child:
              Image.asset('assets/images/listify-logo.png', fit: BoxFit.fill)));
}
