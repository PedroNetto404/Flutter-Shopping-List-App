import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/widgets/layout.dart';
import '../widgets/info-with-icon.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) => Layout(
          body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
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
        ),
      ));

  Widget _appSection() => Column(
        children: [
          _sectionHeader(Icons.info, 'Sobre o aplicativo:'),
          const Padding(
              padding: EdgeInsets.only(left: 20),
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
              padding: EdgeInsets.only(left: 20),
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

  Widget _sectionHeader(IconData icon, String text) => Column(
        children: [
          Row(
            children: [
              Icon(icon, size: 24),
              const SizedBox(width: 8),
              // _ClippedText(
              //     text: text, fontSize: 28, fontWeight: FontWeight.bold),
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
