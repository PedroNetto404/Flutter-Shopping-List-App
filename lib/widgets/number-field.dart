import 'package:flutter/material.dart';
import 'package:flutter_masked_text2/flutter_masked_text2.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class NumberField extends StatelessWidget {
  final int precision;
  final String label;
  final String hint;
  final String? numberSymbol;
  final TextEditingController controller;
  final double? initialValue;

  late final MoneyMaskedTextController _maskedController;

  NumberField(
      {super.key,
      required this.controller,
      required this.precision,
      required this.label,
      required this.hint,
      this.numberSymbol,
      this.initialValue}) {
    _maskedController = MoneyMaskedTextController(
        decimalSeparator: ',',
        thousandSeparator: '.',
        leftSymbol: numberSymbol ?? '',
        initialValue: initialValue ?? 1,
        precision: precision);

    _maskedController.afterChange = _afterMaskedControllerChange;
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
          controller: _maskedController,
          keyboardType: TextInputType.number,
          validator: (value) => _maskedController.numberValue <= 0
              ? 'Valor deve ser maior que zero'
              : null,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              prefixIcon: const Icon(Icons.format_list_numbered),
              suffixIcon: _suffixButtons(context)),
        ),
      );

  Widget _suffixButtons(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                onPressed: () => _onDecrement(context),
                icon: const Icon(FontAwesomeIcons.circleMinus,
                    color: Colors.redAccent)),
            IconButton(
                onPressed: _onIncrement,
                icon: const Icon(FontAwesomeIcons.circlePlus,
                    color: Colors.greenAccent)),
          ],
        ),
      );

  void _afterMaskedControllerChange(String _, double rawValue) =>
      controller.text = rawValue.toStringAsFixed(precision);

  void _onDecrement(BuildContext context) {
    double value = _maskedController.numberValue - 1;
    if (value <= 0) return;

    _maskedController.updateValue(value);
  }

  void _onIncrement() =>
      _maskedController.updateValue(_maskedController.numberValue + 1);
}
