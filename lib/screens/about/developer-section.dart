import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/about/section-header.dart';

import '../../widgets/info-with-icon.dart';

class DeveloperSection extends StatelessWidget {
  const DeveloperSection({super.key});

  @override
  Widget build(BuildContext context) => const Column(
    children: [
      SectionHeader(icon: Icons.developer_mode, text: 'Desenvolvido por:'),
      InfoWithIcon(icon: Icons.person, info: 'Pedro Netto de Sousa Lima.'),
      InfoWithIcon(icon: Icons.email, info: 'pedro.lima47@fatec.sp.gov.br'),
      InfoWithIcon(
          icon: Icons.school, info: 'Graduando em ADS na FATEC-RP.'),
    ],
  );
}