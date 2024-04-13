import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/custom-theme.dart';
import 'package:mobile_shopping_list_app/controllers/shopping-list-controller.dart';
import 'package:provider/provider.dart';
import 'contants/app-route.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(ChangeNotifierProvider(
      create: (context) => ShoppingListProvider(), child: const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => Consumer<ShoppingListProvider>(
        builder: (context, shoppingListController, child) => MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: AppRoute.home.value,
            routes: AppRoute.routesMap,
            themeMode: shoppingListController.currentTheme,
            theme: CustomTheme.lightTheme,
            darkTheme: CustomTheme.darkTheme),
      );
}
