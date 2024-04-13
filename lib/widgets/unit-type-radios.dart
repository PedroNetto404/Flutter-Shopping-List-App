import 'package:flutter/material.dart';

import '../models/enums/unit-type.dart';

class UnitTypeRadios extends StatefulWidget {
  final void Function(UnitType unitType) onChanged;

  const UnitTypeRadios({super.key, required this.onChanged});

  @override
  State<UnitTypeRadios> createState() => _UnitTypeRadiosState();
}

class _UnitTypeRadiosState extends State<UnitTypeRadios> {
  UnitType _selectedUnitType = UnitType.un;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: UnitType.values
            .map((unitType) => _radioWithTitle(unitType))
            .toList(),
      );

  Widget _radioWithTitle(UnitType unitType) => Column(children: [
        Text(unitType.name),
        Radio(
            value: unitType,
            groupValue: _selectedUnitType,
            onChanged: _onChanged)
      ]);

  void _onChanged(UnitType? unitType) => setState(() {
        _selectedUnitType = unitType!;
        widget.onChanged(_selectedUnitType);
      });
}
