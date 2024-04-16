import 'package:flutter/material.dart';

import '../screens/screens.dart';

class AppRoute {
  final String value;

  const AppRoute._(this.value);

  static const home = AppRoute._('/home');
  static const login = AppRoute._('/login');
  static const forgotPassword = AppRoute._('/forgot-password');
  static const register = AppRoute._('/register');
  static const shoppingList = AppRoute._('/shopping-list');
  static const shoppingListDetails = AppRoute._('/shopping-list-details');
  static const about = AppRoute._('/about');
  static const takePicture = AppRoute._('/take-picture');
  static const profile = AppRoute._('/profile');

  static final Map<String, Widget Function(BuildContext)> routesMap = {
    home.value: (context) => const HomeScreen(),
    login.value: (context) => LoginScreen(),
    forgotPassword.value: (context) => const ForgotPasswordScreen(),
    register.value: (context) => RegisterScreen(),
    shoppingList.value: (context) => const ShoppingListScreen(),
    shoppingListDetails.value: (context) => const ShoppingListDetailsScreen(),
    about.value: (context) => const AboutScreen(),
    profile.value: (context) => const ProfileScreen(),
    takePicture.value: (context) => const TakePictureScreen()
  };

  static Future<void> navigateTo(BuildContext context, AppRoute route,
          {Object? arguments}) =>
      Navigator.pushNamed(context, route.value, arguments: arguments);

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) =>
      PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 800),
          pageBuilder: (context, animation, secondaryAnimation) =>
              routesMap[settings.name]?.call(context) ?? const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) =>
              FadeTransition(
                  opacity: animation.drive(Tween(begin: 0.0, end: 1.0)
                      .chain(CurveTween(curve: Curves.ease))),
                  child: child),
          settings: settings);

  static void navigateWithLoading(BuildContext context, AppRoute route) => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => ListifyProgressScreen(
            nextScreenRoute: route, miliseconds: 3000)));
}
