import 'package:shafeea_teach/core/l10n/app_strings.dart';

enum AttendanceType {

  present(1 , AppStrings.str_teach_13_1745, 'present'),
  absent(2 , AppStrings.str_teach_22_ae71, 'absent'),
  other( 3, 'UN', 'UN');

  final int id;
  final String labelAr;
  final String label;
  const AttendanceType( this.id,  this.labelAr, this.label);
  static AttendanceType fromId(int id) {
    return AttendanceType.values.firstWhere((e) => e.id == id, orElse: () => absent);
  }  static AttendanceType fromLabel(String label) {
    switch (label.toLowerCase()) {
      case AppStrings.str_teach_13_1745:
      case 'present':
        return AttendanceType.present;
      case AppStrings.str_teach_22_ae71:
      case 'absent':
        return AttendanceType.absent;
      default:
        return AttendanceType.other;
    }
  }
}
