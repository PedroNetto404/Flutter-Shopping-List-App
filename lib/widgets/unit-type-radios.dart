import 'package:flutter/material.dart';

import '../models/enums/unit-type.dart';

class UnitTypeRadios extends StatefulWidget {
  final void Function(UnitType unitType) onChanged;
  final UnitType initialValue;

  const UnitTypeRadios({super.key, required this.onChanged, this.initialValue = UnitType.un});

  @override
  State<UnitTypeRadios> createState() => _UnitTypeRadiosState();
}

class _UnitTypeRadiosState extends State<UnitTypeRadios> {
  late UnitType _selectedUnitType;

  @override
  void initState() {
    super.initState();
    _selectedUnitType = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: UnitType.values
            .map((unitType) => _radioWithTitle(unitType))
            .toList(),
      );

  Widget _radioWithTitle(UnitType unitType) => Column(children: [
        Text(unitType.name.toUpperCase()),
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
