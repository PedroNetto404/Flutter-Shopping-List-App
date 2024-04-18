import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoute {
  static const String home = '/';
  static const String login = '/login';
  static const String forgotPassword = '/forgot-password';
  static const String register = '/register';
  static const String profile = '/profile';
  static const String shoppingList = '/shopping-list';
  static const String about = '/about';
  static const String shoppingListDetails = '/shopping-list-details';
  static const String takePicture = '/take-picture';

  static final Map<String, Widget Function(BuildContext)> _routesMap = {
    home: (context) => const HomeScreen(),
    login: (context) => LoginScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    register: (context) => RegisterScreen(),
    shoppingListDetails: (context) => const ShoppingListDetailsScreen(),
    takePicture: (context) => const TakePictureScreen(),
    shoppingList: (context) => const ShoppingListScreen(),
    about: (context) => const AboutScreen(),
    profile: (context) => const ProfileScreen()
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final builder = _routesMap.entries
        .firstWhere((element) => element.key == settings.name,
            orElse: () => _routesMap.entries.first)
        .value;

    return PageRouteBuilder(
        settings: settings,
        pageBuilder: (context, animation, secondaryAnimation) => builder(context),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: const Duration(milliseconds: 500));
  }
}
