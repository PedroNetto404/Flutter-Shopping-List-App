extension StringExtensions on String {
  String capitalize() => this[0].toUpperCase() + substring(1);

  bool equalsIgnoreCase(String other) => toLowerCase() == other.toLowerCase();
}