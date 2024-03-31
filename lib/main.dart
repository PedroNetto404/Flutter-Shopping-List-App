import 'package:flutter/material.dart';
import 'contants/routes.dart';
import 'custom-theme.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/register_screen.dart';
import 'screens/shopping-list-details.dart';
import 'screens/shopping-list-screen.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: HomeScreen(),
        routes: {
          Routes.home: (context) => HomeScreen(),
          Routes.login: (context) => LoginScreen(),
          Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
          Routes.register: (context) => RegisterScreen(),
          Routes.shoppingList: (context) => ShoppingListScreen(),
          Routes.shoppingListDetails: (context) => ShoppingListDetails(),
        },
        theme: CustomTheme.theme);
  }
}
