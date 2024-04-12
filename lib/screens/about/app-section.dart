import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/about/section-header.dart';
import '../../widgets/info-with-icon.dart';

class AppSection extends StatelessWidget {
  const AppSection({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      SectionHeader(icon: Icons.info, text: 'Sobre o aplicativo:'),
      InfoWithIcon(
        icon: Icons.shopping_cart,
        info:
        'Este aplicativo foi desenvolvido para ajudar você a organizar suas compras.',
      ),
      InfoWithIcon(
        icon: Icons.check,
        info:
        'Adicione itens à sua lista de compras e marque-os como comprados quando os adquirir.',
      ),
    ],
  );
}