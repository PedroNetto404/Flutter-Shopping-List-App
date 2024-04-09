import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/custom-theme.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:mobile_shopping_list_app/screens/about-screen.dart';
import 'package:provider/provider.dart';
import 'contants/routes.dart';
import 'firebase_options.dart';
import 'screens/home-screen.dart';
import 'screens/login-screen.dart';
import 'screens/forgot-password-screen.dart';
import 'screens/register-screen.dart';
import 'screens/shopping-list-details-screen.dart';
import 'screens/shopping-list-screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
      create: (context) => ShoppingListController(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ShoppingListController>(
        builder: (context, shoppingListController, child) => MaterialApp(
          debugShowCheckedModeBanner: false,
          debugShowMaterialGrid: false,
          initialRoute: Routes.home,
          routes: {
            Routes.home: (context) => const HomeScreen(),
            Routes.login: (context) => LoginScreen(),
            Routes.forgotPassword: (context) => const ForgotPasswordScreen(),
            Routes.register: (context) => const RegisterScreen(),
            Routes.shoppingList: (context) => const ShoppingListScreen(),
            Routes.shoppingListDetails: (context) =>
                const ShoppingListDetailsScreen(),
            Routes.about: (context) => const AboutScreen(),
          },
          themeMode: shoppingListController.currentTheme,
          theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
          darkTheme:
              ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
        ),
      );
}
