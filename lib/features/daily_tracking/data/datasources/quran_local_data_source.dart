// lib/features/quran_reader/data/datasources/quran_local_data_source.dart

import 'dart:async';
import 'package:shafeea/features/daily_tracking/data/models/ayah_model.dart';
import 'package:shafeea/features/daily_tracking/data/models/surah_model.dart';

import '../../../../core/models/tracking_unit_model.dart';

/// The abstract contract for the local data source of Quran data.
///
/// This defines the methods that any implementation must provide, ensuring
/// a consistent API for the repository layer.
abstract class QuranLocalDataSource {
  /// Fetches a list of [AyahModel] for a specific page number from the local database.
  ///
  /// Throws a [CacheException] if there is an error accessing the database.
  Future<List<AyahModel>> getPageAyahs(int pageNumber);

  /// Fetches a list of [AyahModel] for a specific page number from the local database.
  ///
  /// Throws a [CacheException] if there is an error accessing the database.
  Future<List<AyahModel>> getMistakesAyahs(List<int> ayahsNumbers);

  /// Fetches the complete list of [SurahModel] from the local database.
  ///
  /// Throws a [CacheException] if there is an error accessing the database.
  Future<List<SurahModel>> getSurahsList();

  /// Fetches [Tracking_Unit] rows for a given [unitId], with surah names
  /// resolved via a JOIN against the [Sora] table.
  ///
  /// Unit IDs follow the [Unit] table convention:
  ///   1 = juz, 2 = hizb, 3 = half-hizb, 4 = quarter-hizb, 5 = page
  ///
  /// Throws a [CacheException] if the database cannot be accessed.
  Future<List<TrackingUnitDetailModel>> getTrackingUnitsByType(int unitId);
}
