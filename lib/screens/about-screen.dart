import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sobre'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _appSection(),
                const SizedBox(height: 40),
                _developerSection(),
                const SizedBox(height: 40),
                _developerImage(context),
              ],
            ),
          ),
        ),
      );

  Widget _appSection() => Column(
        children: [
          _sectionHeader(
            const Icon(Icons.info),
            'Sobre o aplicativo:',
          ),
          _infoWithIcon(
            Icons.shopping_cart,
            'Este aplicativo foi desenvolvido para ajudar você a organizar suas compras.',
          ),
          _infoWithIcon(
            Icons.check,
            'Adicione itens à sua lista de compras e marque-os como comprados quando os adquirir.',
          ),
        ],
      );

  Widget _developerSection() => Column(
        children: [
          _sectionHeader(const Icon(Icons.developer_mode), 'Desenvolvido por:'),
          _infoWithIcon(Icons.person, 'Pedro Netto de Sousa Lima.'),
          _infoWithIcon(Icons.email, 'pedro.lima47@fatec.sp.gov.br'),
          _infoWithIcon(Icons.school, 'Graduando em ADS na FATEC-RP.'),
        ],
      );

  Widget _developerImage(context) => Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(200),
      boxShadow: [

        BoxShadow(
          color: Colors.black.withOpacity(0.1),
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
        width: MediaQuery.of(context).size.width * 0.1,
        height: MediaQuery.of(context).size.height * 0.4,
        fit: BoxFit.cover,
      ),
    ),
  );

  Widget _infoWithIcon(IconData icon, String text) => Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              _buildText(text: text),
            ],
          ),
          const SizedBox(height: 8),
        ],
      );

  Widget _sectionHeader(Icon icon, String text) => Column(
        children: [
          Row(
            children: [
              icon,
              const SizedBox(width: 8),
              _buildText(
                text: text,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      );

  Widget _buildText({
    required String text,
    double? fontSize,
    FontWeight? fontWeight,
    TextAlign? textAlign,
  }) =>
      Expanded(
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize ?? 16,
            fontWeight: fontWeight,
          ),
          textAlign: textAlign,
          overflow: TextOverflow.clip,
          maxLines: null,
        ),
      );
}
