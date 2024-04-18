extension DateTimeExtensions on DateTime {
  String toSouthAmericaFormat() {
    final day = this.day.toString().padLeft(2, '0');
    final month = this.month.toString().padLeft(2, '0');
    final year = this.year.toString();

    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');

    return '$day/$month/$year $hour:$minute';
  }
}