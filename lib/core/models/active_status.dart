import 'package:shafeea_teach/core/l10n/app_strings.dart';
enum ActiveStatus {
  active(1, AppStrings.str_teach_17_231a, "Active"),
  inactive(2, AppStrings.str_teach_18_a1e5, "Inactive"),
  pending(3, AppStrings.str_teach_19_a338, "Pending"),
  stopped(4, AppStrings.str_teach_20_fc10, "Stopped"),
    unknown(0,'UN', "Unknown"),

  waiteing(5, AppStrings.str_teach_21_4bdb, "Waiteing");

  final int id;
  final String labelAr;
  final String label;
  const ActiveStatus(this.id, this.labelAr, this.label);

  static ActiveStatus fromId(int id) {
    return ActiveStatus.values.firstWhere(
      (e) => e.id == id,
      orElse: () => inactive,
    );
  }

  static ActiveStatus fromLabel(String label) {
    switch (label.toLowerCase()) {
      case AppStrings.str_teach_17_231a:
      case 'active':
        return ActiveStatus.active;
      case AppStrings.str_teach_18_a1e5:
      case 'inactive':
        return ActiveStatus.inactive;
      case AppStrings.str_teach_19_a338:
      case 'pending':
        return ActiveStatus.pending;
      case AppStrings.str_teach_20_fc10:
      case 'stopped':
        return ActiveStatus.pending;
      default:
        return ActiveStatus.waiteing;
    }
  }
}



