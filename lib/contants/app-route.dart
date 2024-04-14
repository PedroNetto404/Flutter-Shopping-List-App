//define a constant values for routes
import 'package:flutter/material.dart';
import '../screens/about-screen.dart';
import '../screens/forgot-password-screen.dart';
import '../screens/home-screen.dart';
import '../screens/login-screen.dart';
import '../screens/profile-screen.dart';
import '../screens/register-screen.dart';
import '../screens/shopping-list-details-screen.dart';
import '../screens/shopping-list-screen.dart';
import '../screens/take-picture-screen.dart';

class AppRoute {
  final String value;

  const AppRoute._(this.value);

  static const home = AppRoute._('/home');
  static const login = AppRoute._('/login');
  static const forgotPassword = AppRoute._('/forgot-password');
  static const register = AppRoute._('/register');
  static const shoppingList = AppRoute._('/shopping-list');
  static const shoppingListDetails = AppRoute._('/shopping-list-detail');
  static const about = AppRoute._('/about');
  static const takePicture = AppRoute._('/take-picture');
  static const profile = AppRoute._('/profile');

  static Map<String, Widget Function(BuildContext)> get routesMap => {
        home.value: (context) => HomeScreen(),
        login.value: (context) => LoginScreen(),
        forgotPassword.value: (context) => const ForgotPasswordScreen(),
        register.value: (context) => const RegisterScreen(),
        shoppingList.value: (context) => const ShoppingListScreen(),
        shoppingListDetails.value: (context) =>
            const ShoppingListDetailsScreen(),
        about.value: (context) => const AboutScreen(),
        takePicture.value: (context) => const TakePictureScreen(),
        profile.value: (context) => const ProfileScreen(),
      };

  static Future<void> navigateTo(BuildContext context, AppRoute route,
          {Object? arguments}) =>
      Navigator.pushNamed(context, route.value, arguments: arguments);
}
