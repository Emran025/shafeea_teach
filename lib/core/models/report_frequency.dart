import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum Frequency {
  daily(1, AppStrings.str_teach_6_79a5, "daily"),
  onceAWeek(2, AppStrings.str_teach_7_f3ad, "onceAWeek"),
  twiceAWeek(3, AppStrings.str_teach_8_5484, "twiceAWeek"),
  thriceAWeek(4, AppStrings.str_teach_9_d6b7, "thriceAWeek");

  final int id;
  final String labelAr;
  final String label;
  const Frequency(this.id, this.labelAr, this.label);

  static Frequency fromId(int id) {
    return Frequency.values.firstWhere((e) => e.id == id, orElse: () => daily);
  }

  static Frequency fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'onceAWeek':
      case AppStrings.str_teach_40_bfd7:
      case AppStrings.str_teach_7_f3ad:
        return Frequency.onceAWeek;
      case 'twiceAWeek':
      case AppStrings.str_teach_8_5484:
        return Frequency.twiceAWeek;
      case 'thriceAWeek':
      case AppStrings.str_teach_9_d6b7:
        return Frequency.thriceAWeek;
      default:
        return Frequency.daily;
    }
  }
}
