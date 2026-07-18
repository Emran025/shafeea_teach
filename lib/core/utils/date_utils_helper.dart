import 'package:intl/intl.dart';

class DateUtilsHelper {
  /// Returns the age in full years, or `null` when [birthDate] is absent /
  /// empty / unparseable.  Callers must handle the null case in the UI.
  static int? calculateAge(String? birthDate) {
    if (birthDate == null || birthDate.trim().isEmpty) return null;

    final date = _parseFlexibleDate(birthDate.trim());
    if (date == null) return null;

    final today = DateTime.now();

    int age = today.year - date.year;

    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      age--;
    }

    return age;
  }

  /// Returns `null` instead of throwing when no format matches.
  static DateTime? _parseFlexibleDate(String date) {
    // Covers ISO-8601, DateTime.now().toString(), and UTC variants.
    final fast = DateTime.tryParse(date);
    if (fast != null) return fast;

    const formats = [
      'yyyy-MM-dd',
      'dd-MM-yyyy',
      'MM-dd-yyyy',
      'yyyy/MM/dd',
      'dd/MM/yyyy',
      'MM/dd/yyyy',
      'yyyy.MM.dd',
      'dd.MM.yyyy',
      'yyyyMMdd',
    ];

    for (final format in formats) {
      try {
        return DateFormat(format).parseStrict(date);
      } catch (_) {}
    }
    return null;
  }
}
