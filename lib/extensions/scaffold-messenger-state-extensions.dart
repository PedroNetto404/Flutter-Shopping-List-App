import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

extension ScaffoldMessengerStateExtensions on ScaffoldMessengerState {
  void showErrorSnackBar(String message, {bool isException = false}) =>
      showSnackBar(_snackBarStructure(
          message,
          'Ops... ocorreu um erro!',
          isException
              ? FontAwesomeIcons.bug
              : FontAwesomeIcons.triangleExclamation,
          Colors.redAccent, 2500));

  void showSuccessSnackBar(String message, {int milisseconds = 3000}) => showSnackBar(_snackBarStructure(
      message, 'Sucesso!', FontAwesomeIcons.circleCheck, Colors.greenAccent, milisseconds));

  void showUnexpectedErrorSnackBar(error) =>
      showErrorSnackBar('Erro inesperado ocorrido... cod.: ${error.toString()}',
          isException: true);

  void showWarningSnackBar(String message) => showSnackBar(_snackBarStructure(
      message, 'Atenção!', FontAwesomeIcons.triangleExclamation, Colors.amber, 3000));

  static SnackBar _snackBarStructure(
          String message, String title, IconData icon, Color color, int miliseconds) =>
      SnackBar(
          showCloseIcon: true,
          closeIconColor: Colors.white,
          padding: const EdgeInsets.all(8),
          content: ListTile(
            leading: Icon(icon, color: Colors.white),
            title: Text(title,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            subtitle: Text(message,
                style: const TextStyle(overflow: TextOverflow.clip, color: Colors.white)),
          ),
          backgroundColor: color,
          duration: Duration(milliseconds: miliseconds));
}
