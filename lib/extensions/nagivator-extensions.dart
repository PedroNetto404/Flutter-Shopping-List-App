import 'package:flutter/material.dart';
import 'package:mobile_shopping_list_app/screens/listify-progress-screen.dart';

extension NavigatorExtensions on NavigatorState {
  void pushNamedWithLoading(String route, {bool canPopAll = false}) => canPopAll
      ? pushAndRemoveUntil(_getRoute(route), (route) => false)
      : push(_getRoute(route));

  MaterialPageRoute _getRoute(String route) => MaterialPageRoute(
      builder: (context) =>
          ListifyProgressScreen(nextScreenRoute: route, miliseconds: 3000));
}
