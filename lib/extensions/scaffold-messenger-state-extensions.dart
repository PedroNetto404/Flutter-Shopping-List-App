import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension ScaffoldMessengerStateExtensions on ScaffoldMessengerState {
  void showSnackBarError(String message, {bool isException = false}) =>
      showSnackBar(_snackBarStructure(
          message,
          'Ops... ocorreu um erro!',
          isException
              ? FontAwesomeIcons.bug
              : FontAwesomeIcons.triangleExclamation,
          Colors.redAccent));

  void showSuccessSnackBar(String message) => showSnackBar(_snackBarStructure(
      message, 'Sucesso!', FontAwesomeIcons.circleCheck, Colors.greenAccent));

  void showSnackBarUnexpectedError(error) =>
      showSnackBarError('Erro inesperado ocorrido... cod.: ${error.toString()}',
          isException: true);

  static SnackBar _snackBarStructure(
          String message, String title, IconData icon, Color color) =>
      SnackBar(
          content: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(title),
              ]),
              Text(message),
            ],
          ),
          backgroundColor: color,
          duration: const Duration(seconds: 3));
}
