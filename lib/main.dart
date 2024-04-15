import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

import './constants/constants.dart';
import './providers/providers.dart';

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
            ChangeNotifierProvider(create: (context) => ShoppingListProvider()),
            ChangeNotifierProvider(create: (context) => AuthProvider())
          ],
          builder: (context, child) => Consumer2<ThemeProvider, AuthProvider>(
              builder: (context, themeProvider, authProvider, child) =>
                  MaterialApp(
                      themeAnimationCurve: Curves.easeOutCirc,
                      themeAnimationDuration: const Duration(milliseconds: 400),
                      debugShowCheckedModeBanner: false,
                      initialRoute: authProvider.isAuthenticated
                          ? AppRoute.shoppingList.value
                          : AppRoute.home.value,
                      onGenerateRoute: AppRoute.onGenerateRoute,
                      themeMode: themeProvider.themeMode,
                      theme: CustomTheme.lightTheme,
                      darkTheme: CustomTheme.darkTheme)));
}
