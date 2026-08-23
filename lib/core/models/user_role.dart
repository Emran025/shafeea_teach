import 'package:shafeea_teach/core/l10n/app_strings.dart';
// lib/domain/entities/enums.dart

/// Represents user roles in the system.
enum UserRole {
  powerAdmin(1, "Power Admin"),
  supervisor(2, "Supervisor"),
  teacher(3, "Teacher"),
  student(4, "Student"),
  halaqa(5, "Halaqa"),
  unknown(0, "Unknown");

  final int id;
  final String label;
  const UserRole(this.id, this.label);

  static UserRole fromId(int id) {
    return UserRole.values.firstWhere((e) => e.id == id, orElse: () => unknown);
  }

  static UserRole fromLabel(String label) {
    switch (label.toLowerCase()) {
      case 'power admin':
      case AppStrings.str_teach_rem_3_c843:
        return UserRole.powerAdmin;
      case 'supervisor':
      case 'admin':
      case AppStrings.str_teach_2_2005:
        return UserRole.supervisor;
      case 'teacher':
      case AppStrings.str_teach_3_f36a:
      case AppStrings.str_teach_rem_4_faa1:
        return UserRole.teacher;
      case 'halaqa':
      case AppStrings.str_teach_5_7a63:
      case AppStrings.str_teach_rem_5_f960:
        return UserRole.halaqa;
      case 'student':
      case AppStrings.str_teach_4_a008:
      case AppStrings.str_teach_rem_6_36bc:
        return UserRole.student;
      default:
        return UserRole.unknown;
    }
  }
}
