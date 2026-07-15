import 'package:intl/intl.dart';

class DateUtilsHelper {
  static int calculateAge(String birthDate) {
    final date = _parseFlexibleDate(birthDate);

    final today = DateTime.now();

    int age = today.year - date.year;

    if (today.month < date.month ||
        (today.month == date.month && today.day < date.day)) {
      age--;
    }

    return age;
  }

  static DateTime _parseFlexibleDate(String date) {
    final formats = [
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

    throw FormatException(
      'Invalid birth date format: $date',
    );
  }
}