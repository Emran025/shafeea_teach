import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum EducationLevel {
  unknown(
    0,
    AppStrings.str_teach_23_d779,
    'Uneducation',
  ),

  noFormalEducation(
    1,
    AppStrings.str_teach_24_9ba4,
    'No formal education',
  ),

  primaryEducation(
    2,
    AppStrings.str_teach_25_e4ef,
    'Primary education',
  ),

  lowerSecondaryEducation(
    3,
    AppStrings.str_teach_26_71a5,
    'Lower secondary education',
  ),

  upperSecondaryEducation(
    4,
    AppStrings.str_teach_27_e09b,
    'Upper secondary education',
  ),

  postsecondaryNonTertiaryEducation(
    5,
    AppStrings.str_teach_28_18cd,
    'Postsecondary non-tertiary education',
  ),

  shortCycleTertiaryEducation(
    6,
    AppStrings.str_teach_29_bd90,
    'Short-cycle tertiary education',
  ),

  bachelorsDegree(
    7,
    AppStrings.str_teach_30_81e7,
    "Bachelor's degree",
  ),

  mastersDegree(
    8,
    AppStrings.str_teach_31_caed,
    "Master's degree",
  ),

  doctoralDegree(
    9,
    AppStrings.str_teach_32_b70f,
    'Doctoral degree',
  );

  final int id;
  final String labelAr;
  final String label;

  const EducationLevel(
    this.id,
    this.labelAr,
    this.label,
  );

  /// Find an [EducationLevel] by its database ID.
  static EducationLevel fromId(int id) {
    return EducationLevel.values.firstWhere(
      (e) => e.id == id,
      orElse: () => EducationLevel.unknown,
    );
  }

  /// Find an [EducationLevel] by Arabic or English label.
  static EducationLevel fromLabel(String value) {
    final normalized = value.trim().toLowerCase();

    for (final level in EducationLevel.values) {
      if (level.label.toLowerCase() == normalized ||
          level.labelAr == value.trim()) {
        return level;
      }
    }

    return EducationLevel.unknown;
  }
}