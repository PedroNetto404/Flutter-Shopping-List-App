extension StringExtensions on String {
  String capitalize() => isEmpty || !startsWithAlpha()
      ? this
      : '${this[0].toUpperCase()}${substring(1)}';

  bool containsIgnoreCase(String other) =>
      toLowerCase().contains(other.toLowerCase());

  bool startsWithAlpha() => RegExp(r'^[a-zA-Z]').hasMatch(this);
}
