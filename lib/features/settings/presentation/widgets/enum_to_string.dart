import 'package:shafeea_teach/core/l10n/app_strings.dart';

import '../../domain/entities/import_export.dart';

String toDisplayString(dynamic anEnum) {
  switch (anEnum) {
    case EntityType.student:
      return AppStrings.str_teach_rem_322_8be8;
    case EntityType.teacher:
      return AppStrings.str_teach_rem_323_ed95;
    case EntityType.halaqa:
      return AppStrings.str_teach_rem_324_6134;
    case EntityType.followUpReport:
      return AppStrings.str_teach_rem_325_ef86;
    case DataExportFormat.csv:
      return 'CSV';
    case DataExportFormat.json:
      return 'JSON';
    case ConflictResolution.skip:
      return AppStrings.str_teach_rem_326_973c;
    case ConflictResolution.overwrite:
      return AppStrings.str_teach_rem_327_d298;
    default:
      return anEnum.toString().split('.').last;
  }
}
