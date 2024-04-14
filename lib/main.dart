import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/contants/custom-theme.dart';
import 'package:mobile_shopping_list_app/providers/shopping-list-provider.dart';
import 'package:mobile_shopping_list_app/providers/theme-provider.dart';
import 'package:provider/provider.dart';
import 'contants/app-route.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
          providers: [
            ChangeNotifierProvider(create: (context) => ThemeProvider()),
            ChangeNotifierProvider(create: (context) => ShoppingListProvider())
          ],
          child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) => MaterialApp(
                  debugShowCheckedModeBanner: false,
                  initialRoute: AppRoute.home.value,
                  routes: AppRoute.routesMap,
                  themeMode: themeProvider.themeMode,
                  theme: CustomTheme.lightTheme,
                  darkTheme: CustomTheme.darkTheme)));
}
