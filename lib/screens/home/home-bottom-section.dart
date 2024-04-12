import 'package:flutter/cupertino.dart';
import 'package:mobile_shopping_list_app/screens/home/home-sign-section.dart';
import 'package:mobile_shopping_list_app/screens/home/home-welcome-section.dart';

import 'home-funny-git-section.dart';

class HomeBottomSection extends StatelessWidget {
  const HomeBottomSection({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(30),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            HomeFunnyGifSection(),
            SizedBox(height: 16),
            HomeWelcomeSection(),
            SizedBox(height: 16),
            HomeSignSection(),
          ],
        )),
  );
}