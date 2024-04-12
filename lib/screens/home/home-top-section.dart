import 'package:flutter/cupertino.dart';

import '../../widgets/theme-selector.dart';
import 'home-listfy-banner.dart';

class HomeTopSection extends StatelessWidget {
  const HomeTopSection({super.key});

  @override
  Widget build(BuildContext context) => Container(
    decoration: const BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/images/shopping-list-note.jpg'),
        fit: BoxFit.cover,
      ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Align(
          alignment: Alignment.topRight,
          child: Container(
              margin: const EdgeInsets.only(top: 40, right: 20),
              child: const ThemeSelector()),
        ),
        const Align(
            alignment: Alignment.bottomCenter, child: HomeListfyBanner()),
      ],
    ),
  );
}
