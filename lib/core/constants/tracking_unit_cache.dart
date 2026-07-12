import '../models/tracking_unit_model.dart';
import '../../features/daily_tracking/data/datasources/quran_local_data_source.dart';

/// In-memory cache of all [Tracking_Unit] rows from the Quran SQLite
/// database, loaded once at app startup.
///
/// This replaces the former ~10 000-line hardcoded constant list in
/// `tracking_unit_detail.dart`.  The cache preserves the same synchronous
/// lookup API so that existing callers can be migrated with minimal changes.
///
/// **Lifecycle:**
/// ```dart
/// // In main.dart (after configureDependencies):
/// await TrackingUnitCache.instance.initialize(sl<QuranLocalDataSource>());
/// ```
/// After that, synchronous lookups are always safe:
/// ```dart
/// TrackingUnitCache.instance.byIndex(n);   // 0-based, like trackingUnitDetail[n]
/// TrackingUnitCache.instance.byId(id);     // 1-based ID
/// ```
class TrackingUnitCache {
  TrackingUnitCache._();

  static final TrackingUnitCache instance = TrackingUnitCache._();

  /// Internal storage — 0-based index; entry at index i has id == i + 1.
  List<TrackingUnitDetailModel>? _rows;

  /// Returns true once [initialize] has successfully completed.
  bool get isInitialized => _rows != null;

  /// Total number of cached rows.
  int get length => _rows?.length ?? 0;

  // ---------------------------------------------------------------------------
  // Initialization
  // ---------------------------------------------------------------------------

  /// Loads every [Tracking_Unit] row from [dataSource] and caches them in
  /// ascending ID order.
  ///
  /// Subsequent calls are no-ops — the data is loaded only once.
  /// Unit IDs: 1 = juz (30 rows), 2 = hizb, 3 = half-hizb,
  ///           4 = quarter-hizb, 5 = page (604 rows).
  Future<void> initialize(QuranLocalDataSource dataSource) async {
    if (_rows != null) return;

    // Fetch all unit types concurrently.
    final results = await Future.wait([
      dataSource.getTrackingUnitsByType(1),
      dataSource.getTrackingUnitsByType(2),
      dataSource.getTrackingUnitsByType(3),
      dataSource.getTrackingUnitsByType(4),
      dataSource.getTrackingUnitsByType(5),
    ]);

    final allRows = results.expand((list) => list).toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    _rows = allRows
        .map(
          (row) => TrackingUnitDetailModel(
            id: row.id,
            unitId: row.unitId,
            fromSurahName: row.fromSurahName,
            fromPage: row.fromPage,
            fromAyah: row.fromAyah,
            toSurahName: row.toSurahName,
            toPage: row.toPage,
            toAyah: row.toAyah,
          ),
        )
        .toList();
  }

  // ---------------------------------------------------------------------------
  // Lookups
  // ---------------------------------------------------------------------------

  /// Returns the unit at **0-based** [index].
  ///
  /// Drop-in replacement for the former `trackingUnitDetail[index]`.
  TrackingUnitDetailModel byIndex(int index) {
    assert(
      _rows != null,
      'TrackingUnitCache has not been initialized. '
      'Call TrackingUnitCache.instance.initialize() before using the cache.',
    );
    return _rows![index];
  }

  /// Returns the unit with the given **1-based** [id].
  TrackingUnitDetailModel byId(int id) => byIndex(id - 1);
}
