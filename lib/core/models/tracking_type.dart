import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum TrackingType {
  memorization(1, AppStrings.str_teach_41_a699, "Memorization"),
  review(2, AppStrings.str_teach_42_315e, "Review"),
  recitation(3, AppStrings.str_teach_43_abc4, "Recitation");

  final int id;
  final String labelAr;
  final String label;
  const TrackingType(this.id, this.labelAr, this.label);
  static TrackingType fromId(int id) {
    return TrackingType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => recitation,
    );
  }

  static TrackingType fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'memorization':
      case AppStrings.str_teach_41_a699:
        return TrackingType.memorization;
      case 'review':
      case AppStrings.str_teach_42_315e:
        return TrackingType.review;
      default:
        return TrackingType.recitation;
    }
  }
}
