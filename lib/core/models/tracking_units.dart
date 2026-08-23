import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum TrackingUnitTyps {
  juz(1, AppStrings.str_teach_44_355d, "juz"),
  hizb(2, AppStrings.str_teach_45_0a04, "hizb"),
  halfHizb(3, AppStrings.str_teach_46_b643, "halfHizb"),
  quarterHizb(4, AppStrings.str_teach_47_dfe7, "quarterHizb"),
  page(5, AppStrings.str_teach_48_d56b, "page");

  final int id;
  final String labelAr;
  final String label;
  const TrackingUnitTyps(this.id, this.labelAr, this.label);

  static TrackingUnitTyps fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'juz':
      case AppStrings.str_teach_44_355d:
        return TrackingUnitTyps.juz;
      case 'hizb':
      case AppStrings.str_teach_45_0a04:
        return TrackingUnitTyps.hizb;
      case 'halfHizb':
      case AppStrings.str_teach_49_376e:
      case AppStrings.str_teach_rem_0_83e8:
        return TrackingUnitTyps.halfHizb;
      case 'quarterHizb':
      case AppStrings.str_teach_rem_1_1ed9:
      case AppStrings.str_teach_rem_2_c137:
        return TrackingUnitTyps.quarterHizb;
      default:
        return TrackingUnitTyps.page;
    }
  }

  static TrackingUnitTyps fromId(int id) {
    return TrackingUnitTyps.values.firstWhere(
      (e) => e.id == id,
      orElse: () => page,
    );
  }
}
