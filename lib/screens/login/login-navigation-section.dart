import 'package:flutter/material.dart';
import '../../contants/app-route.dart';
import '../../widgets/link.dart';

class NavigationSection extends StatelessWidget {
  const NavigationSection({super.key});

  @override
  Widget build(BuildContext context) => const Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Link(
              route: AppRoute.forgotPassword,
              label: 'Não possui uma conta? Crie uma agora!'),
          Link(route: AppRoute.forgotPassword, label: 'Esqueceu sua senha?'),
        ],
      );
}
