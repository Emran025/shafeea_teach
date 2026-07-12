enum EducationLevel {
  unknown(
    0,
    'لا يستطيع القراءة والكتابة',
    'Uneducation',
  ),

  noFormalEducation(
    1,
    'لم يتلق تعليمًا نظاميًا',
    'No formal education',
  ),

  primaryEducation(
    2,
    'التعليم الابتدائي',
    'Primary education',
  ),

  lowerSecondaryEducation(
    3,
    'التعليم الإعدادي / المتوسط',
    'Lower secondary education',
  ),

  upperSecondaryEducation(
    4,
    'التعليم الثانوي',
    'Upper secondary education',
  ),

  postsecondaryNonTertiaryEducation(
    5,
    'تعليم بعد الثانوي غير جامعي',
    'Postsecondary non-tertiary education',
  ),

  shortCycleTertiaryEducation(
    6,
    'دبلوم / دبلوم مشارك',
    'Short-cycle tertiary education',
  ),

  bachelorsDegree(
    7,
    'بكالوريوس',
    "Bachelor's degree",
  ),

  mastersDegree(
    8,
    'ماجستير',
    "Master's degree",
  ),

  doctoralDegree(
    9,
    'دكتوراه',
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