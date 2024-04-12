import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/shopping-list/shopping-list-screen.dart';
import '../../services/auth-service.dart';
import 'home-bottom-section.dart';
import 'home-top-section.dart';

class HomeScreen extends StatelessWidget {
  final _authService = AuthService();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => _authService.currentUser != null
      ? const ShoppingListScreen()
      : const Scaffold(
          body: Column(
            children: [
              Expanded(flex: 4, child: HomeTopSection()),
              Expanded(flex: 6, child: HomeBottomSection()),
            ],
          ),
        );
}
