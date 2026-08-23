import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum Gender {
  // both(3, 'الجنسين', 'Both'),
  male(1, AppStrings.str_teach_33_6862, 'Male'),
  female(2, AppStrings.str_teach_34_6947, 'Female');

  final int id;
  final String labelAr;
  final String label;
  const Gender(this.id, this.labelAr, this.label);

  /// A utility method to find a [MistakeType] by its integer ID.
  ///
  /// This is useful when retrieving data from the database.
  /// Defaults to [Gender.none] if the id is not found.
  static Gender fromId(int id) {
    return Gender.values.firstWhere((e) => e.id == id, orElse: () => male);
  }

  static Gender fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'female':
      case 'Female':
      case AppStrings.str_teach_34_6947:
        return Gender.female;
      default:
        return Gender.male;
    }
  }
}
