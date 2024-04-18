import 'package:flutter/material.dart';
import '../widgets/layout.dart';
import '../widgets/widgets.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Layout(
          body: SingleChildScrollView(
              child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _appSection(),
              const SizedBox(height: 20),
              _developerSection(),
              const SizedBox(height: 20),
              _developerPicture(context),
            ],
          ),
        ),
      )));

  Widget _appSection() => Column(
        children: [
          _sectionHeader(Icons.info, 'Sobre o aplicativo:'),
          const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
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
              ))
        ],
      );

  Widget _developerSection() => Column(
        children: [
          _sectionHeader(Icons.developer_mode, 'Desenvolvido por:'),
          const Padding(
              padding: EdgeInsets.only(left: 10),
              child: Column(
                children: [
                  InfoWithIcon(
                      icon: Icons.person, info: 'Pedro Netto de Sousa Lima.'),
                  InfoWithIcon(
                      icon: Icons.email, info: 'pedro.lima47@fatec.sp.gov.br'),
                  InfoWithIcon(
                      icon: Icons.school,
                      info: 'Graduando em ADS na FATEC-RP.'),
                ],
              ))
        ],
      );

  Widget _developerPicture(context) => Container(
      width: 300,
      height: 300,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(shape: BoxShape.circle),
      child: Image.asset('assets/images/dev.jpg', fit: BoxFit.contain));

  Widget _sectionHeader(IconData icon, String text) => Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              Text(text,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      overflow: TextOverflow.ellipsis)),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );
}
