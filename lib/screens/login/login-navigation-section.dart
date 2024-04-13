import 'package:flutter/material.dart';
import '../../contants/app-route.dart';
import '../../widgets/link.dart';

class NavigationSection extends StatelessWidget {
  const NavigationSection({super.key});

  @override
  Widget build(BuildContext context) => const Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            Link(
                route: AppRoute.register,
                label: 'Não possui uma conta? Crie uma agora!'),
            Link(route: AppRoute.forgotPassword, label: 'Esqueceu sua senha?'),
          ],
        ),
      );
}
