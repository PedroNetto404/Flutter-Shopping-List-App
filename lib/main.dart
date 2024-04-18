import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
          builder: (context, child) => Consumer<ThemeProvider>(
              builder: (BuildContext context, ThemeProvider themeProvider,
                      Widget? child) =>
                  MaterialApp(
                      debugShowCheckedModeBanner: false,
                      onGenerateRoute: AppRoute.onGenerateRoute,
                      builder: (context, child) => AnimatedTheme(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                          data: themeProvider.currentTheme,
                          child: child!))));
}
