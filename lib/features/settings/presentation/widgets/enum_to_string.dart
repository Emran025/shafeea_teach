import 'package:shafeea/core/l10n/app_strings.dart' as L10nStrings;

import '../../domain/entities/import_export.dart';

String toDisplayString(dynamic anEnum) {
  switch (anEnum) {
    case EntityType.student:
      return L10nStrings.AppStrings.studentData;
    case EntityType.teacher:
      return L10nStrings.AppStrings.teacherData;
    case EntityType.halaqa:
      return L10nStrings.AppStrings.circleData;
    case EntityType.followUpReport:
      return L10nStrings.AppStrings.followUpReports;
    case DataExportFormat.csv:
      return 'CSV';
    case DataExportFormat.json:
      return 'JSON';
    case ConflictResolution.skip:
      return L10nStrings.AppStrings.ignore;
    case ConflictResolution.overwrite:
      return L10nStrings.AppStrings.overwrite;
    default:
      return anEnum.toString().split('.').last;
  }
}
