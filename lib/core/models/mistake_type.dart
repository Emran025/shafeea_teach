import 'package:shafeea_teach/core/l10n/app_strings.dart';
/// Enhanced enum representing the different types of recitation mistakes.
///
/// Each member has an `id` for database storage and a `labelAr` for display in the UI.
enum MistakeType {
  // id, Arabic Label
  none(0, AppStrings.str_teach_35_88ba),
  memory(1, AppStrings.str_teach_36_c74e),
  grammar(2, AppStrings.str_teach_37_8d7b),
  pronunciation(3, AppStrings.str_teach_38_f16f),
  timing(4, AppStrings.str_teach_39_057a);
  // You can easily add more types here in the future.
  
  final int id;
  final String labelAr;
  const MistakeType(this.id, this.labelAr);

  /// A utility method to find a [MistakeType] by its integer ID.
  ///
  /// This is useful when retrieving data from the database.
  /// Defaults to [MistakeType.none] if the id is not found.
  static MistakeType fromId(int id) {
    return MistakeType.values.firstWhere(
      (e) => e.id == id,
      orElse: () => none,
    );
  }
}