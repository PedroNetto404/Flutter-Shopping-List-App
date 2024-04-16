import 'package:camera/camera.dart';
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
              builder: (BuildContext context, ThemeProvider value,
                      Widget? child) =>
                  MaterialApp(
                      themeAnimationStyle: AnimationStyle(
                          curve: Curves.easeInOut,
                          duration: const Duration(milliseconds: 500), 
                          reverseDuration: const Duration(milliseconds: 500),
                          reverseCurve: Curves.easeInOut
                      ),
                      debugShowCheckedModeBanner: false,
                      initialRoute: AppRoute.home.value,
                      routes: AppRoute.routesMap,
                      onGenerateRoute: AppRoute.onGenerateRoute,
                      themeMode: value.themeMode,
                      theme: CustomTheme.lightTheme,
                      darkTheme: CustomTheme.darkTheme)));
}
