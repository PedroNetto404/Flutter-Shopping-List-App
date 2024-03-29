import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/routes.dart';
import 'package:mobile_shopping_list_app/screens/forgot_password_screen.dart';
import 'package:mobile_shopping_list_app/screens/home_screen.dart';
import 'package:mobile_shopping_list_app/screens/login_screen.dart';
import 'package:mobile_shopping_list_app/screens/register_screen.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
      routes: {
        Routes.shoppingList: (context) => HomeScreen(),
        Routes.login: (context) => LoginScreen(),
        Routes.forgotPassword: (context) => ForgotPasswordScreen(),
        Routes.register: (context) => RegisterScreen(),
      }, 
    );
  }
}
