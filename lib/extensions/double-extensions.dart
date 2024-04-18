extension DoubleExtensions on double {
  String toCurrency() => 'R\$ ${toStringAsFixed(2)}';
}