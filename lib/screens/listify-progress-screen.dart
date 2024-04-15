import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../constants/constants.dart';

class ListifyProgressScreen extends StatefulWidget {
  final AppRoute nextScreenRoute;
  final int miliseconds;

  const ListifyProgressScreen(
      {super.key, required this.nextScreenRoute, required this.miliseconds});

  @override
  State<ListifyProgressScreen> createState() => _ListifyProgressScreenState();
}

class _ListifyProgressScreenState extends State<ListifyProgressScreen> {
  late Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer(
        Duration(milliseconds: widget.miliseconds),
        () => Navigator.of(context)
            .pushReplacementNamed(widget.nextScreenRoute.value));
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>  const Scaffold(
          body: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                          Padding(
                            padding: EdgeInsets.only(right: 25),
                            child: Icon(FontAwesomeIcons.cartShopping, size: 100),
                          ),
                          SizedBox(height: 40),
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Carregando...')
                        ])));
}
