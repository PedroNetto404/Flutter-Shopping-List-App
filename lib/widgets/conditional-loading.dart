import 'package:flutter/material.dart';

class ConditionalLoadingIndicator extends StatelessWidget {
  const ConditionalLoadingIndicator(
      {super.key, required this.predicate, required this.childBuilder});

  final bool Function() predicate;
  final Widget Function(BuildContext) childBuilder;

  @override
  Widget build(BuildContext context) => predicate()
      ? const Center(child: CircularProgressIndicator())
      : childBuilder(context);
}
