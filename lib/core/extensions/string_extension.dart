extension StringExtension on String {
  /// Parse date from string (yyyy-MM-dd format)
  DateTime? toDateTime() {
    try {
      return DateTime.parse(this);
    } catch (e) {
      return null;
    }
  }
}
