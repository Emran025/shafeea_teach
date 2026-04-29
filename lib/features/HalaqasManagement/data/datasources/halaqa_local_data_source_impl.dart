import 'dart:async';
import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:sqflite/sqflite.dart';
import 'package:shafeea/core/error/exceptions.dart';
import 'package:shafeea/core/models/monitoring_filter.dart';
import 'package:shafeea/core/models/user_role.dart';
import 'package:shafeea/features/auth/data/datasources/auth_local_data_source.dart';
import '../../../../core/models/active_status.dart';
import '../../../../core/models/report_frequency.dart';
import '../../../../core/models/sync_queue_model.dart';
import '../models/halaqa_model.dart';
import 'halaqa_local_data_source.dart';

/// The name of the table that stores user data, including halaqas.

/// The concrete implementation of [HalaqaLocalDataSource] using SQLite.
///
/// This class handles all direct database interactions for halaqa data,
/// such as querying, inserting, updating, and deleting records. It operates
/// exclusively with [HalaqaModel] objects.

/// Table and column name constants to prevent typos.
const String _kUsersTable = 'users';
const String _kHalqasTable = 'halqas';
const String _kPendingOperationsTable = 'pending_operations';
const String _kSyncMetadataTable = 'sync_metadata';
const String _kFrequenciesTable = 'frequencies';
const String _kDailyTrackingTable = 'daily_tracking';
const String _kHalqaStudentsTable = 'halqa_students';
const String _kFollowUpPlansTable = 'follow_up_plans';

@LazySingleton(as: HalaqaLocalDataSource)
final class HalaqaLocalDataSourceImpl implements HalaqaLocalDataSource {
  final Database _db;
  final AuthLocalDataSource _authLocalDataSource;

  /// A broadcast StreamController that acts as a simple notification bus.
  /// When data in the halaqas table changes (e.g., after a sync), we add an
  /// event to this controller to trigger all active listeners to re-fetch.
  final _dbChangeNotifier = StreamController<void>.broadcast();

  HalaqaLocalDataSourceImpl({
    required Database database,
    required AuthLocalDataSource authLocalDataSource,
  }) : _db = database,
       _authLocalDataSource = authLocalDataSource;

  // =========================================================================
  //                             Data Access Methods
  // =========================================================================

  /// Fetches the current list of halaqas from the database.
  /// This is a private helper to avoid code duplication.
  /// It returns a list of [HalaqaModel] objects.
  /// Throws a [CacheException] if the database query fails.
  Future<List<HalaqaModel>> _fetchCachedHalaqas() async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      final maps = await _db.query(
        _kHalqasTable,
        where: 'isDeleted = ? AND tenant_id = ?',
        whereArgs: [0, tenantId],
        orderBy: 'name ASC',
      );
      print(maps);
      return maps.map((map) => HalaqaModel.fromMap(map)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to fetch halaqas from cache: ${e.toString()}',
      );
    }
  }

  @override
  Stream<List<HalaqaModel>> watchAllHalaqas() {
    late StreamController<List<HalaqaModel>> controller;
    StreamSubscription? dbChangeSubscription;

    // This function is called when the stream is first listened to.
    void startListen() {
      // 1. Immediately fetch the current data and emit it.
      _fetchCachedHalaqas()
          .then((halaqas) => controller.add(halaqas))
          .catchError((e) => controller.addError(e));

      // 2. Listen for future database change notifications.
      dbChangeSubscription = _dbChangeNotifier.stream.listen((_) {
        // When a change occurs, re-fetch the data and emit it.
        _fetchCachedHalaqas()
            .then((halaqas) => controller.add(halaqas))
            .catchError((e) => controller.addError(e));
      });
    }

    // This function is called when the listener cancels their subscription.
    void stopListen() {
      dbChangeSubscription?.cancel();
    }

    controller = StreamController<List<HalaqaModel>>(
      onListen: startListen,
      onCancel: stopListen,
    );

    return controller.stream;
  }

  // =========================================================================
  //                             Synchronization Methods
  // =========================================================================

  @override
  Future<void> applySyncBatch({
    required List<HalaqaModel> updatedHalaqas,
    required List<HalaqaModel> deletedHalaqas,
  }) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      // Execute all database modifications within a single atomic transaction
      // to ensure data consistency. If any part fails, all changes are rolled back.
      await _db.transaction((txn) async {
        final batch = txn.batch();

        // --- Handle Upserts ---
        // Insert new records or replace existing ones with fresh data.
        for (final halaqa in updatedHalaqas) {
          final halaqaMap = halaqa.toMap();
          halaqaMap['tenant_id'] = tenantId;
          batch.insert(
            _kHalqasTable,
            halaqaMap,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }
        // --- Handle Soft Deletes ---
        // Mark records as deleted based on the sync response.
        for (final halaqa in deletedHalaqas) {
          batch.update(
            _kHalqasTable,
            {
              'isDeleted': 1,
              'lastModified': DateTime.now().millisecondsSinceEpoch,
            },
            where: 'id = ? AND tenant_id = ?',
            whereArgs: [int.tryParse(halaqa.id) ?? 0, tenantId],
          );
        }
        // Commit all operations in the batch at once.
        await batch.commit(noResult: true);
      });

      // After the transaction is successfully committed, notify all listeners
      // that the data has changed, triggering a UI refresh.
      _dbChangeNotifier.add(null);
    } on DatabaseException catch (e) {
      // If the transaction fails, wrap the low-level error in a domain-specific exception.
      throw CacheException(
        message: 'Failed to apply sync batch: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> queueSyncOperation({
    required String uuid,
    required String operation,
    Map<String, dynamic>? payload,
  }) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      await _db.insert(_kPendingOperationsTable, {
        'entity_uuid': uuid,
        'entity_type': UserRole.halaqa.label,
        'operation_type': operation,
        'payload': payload != null ? json.encode(payload) : null,
        'created_at': DateTime.now().millisecondsSinceEpoch,
        'tenant_id': tenantId,
      });
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to queue sync operation: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> getLastSyncTimestampFor() async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    final result = await _db.query(
      _kSyncMetadataTable,
      columns: ['last_server_sync_timestamp'],
      where: 'entity_type = ? AND tenant_id = ?',
      whereArgs: [UserRole.halaqa.label, tenantId],
    );
    if (result.isNotEmpty) {
      return result.first['last_server_sync_timestamp'] as int;
    }
    return 0;
  }

  @override
  Future<void> updateLastSyncTimestampFor(int timestamp) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    await _db.insert(_kSyncMetadataTable, {
      'entity_type': UserRole.halaqa.label,
      'last_server_sync_timestamp': timestamp,
      'tenant_id': tenantId,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  @override
  Future<void> markOperationAsCompleted(int operationId) async {
    // Implementation to DELETE from _kSyncQueueTable where id = operationId...
    throw UnimplementedError();
  }

  @override
  Future<void> upsertHalaqa(HalaqaModel halaqa) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      final halaqaMap = halaqa.toMap();
      halaqaMap['tenant_id'] = tenantId;
      await _db.insert(
        _kHalqasTable,
        halaqaMap,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to save halaqa (${halaqa.id}): ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteHalaqa(String halaqaId) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      // Perform a "soft delete" by marking the record as deleted.
      final rowsAffected = await _db.update(
        _kHalqasTable,
        {'isDeleted': 1, 'lastModified': DateTime.now().millisecondsSinceEpoch},
        where: 'id = ? AND tenant_id = ?',
        whereArgs: [int.tryParse(halaqaId) ?? 0, tenantId],
      );

      if (rowsAffected == 0) {
        // This is not necessarily an error, but could indicate a sync issue.
        // For robustness, we don't throw an exception here unless required.
        print(
          'Warning: Attempted to delete a non-existent halaqa with ID: $halaqaId',
        );
      }
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to delete halaqa ($halaqaId): ${e.toString()}',
      );
    }
  }

  @override
  Future<List<SyncQueueModel>> getPendingSyncOperations() async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      final maps = await _db.query(
        _kPendingOperationsTable,
        where: 'entity_type = ? AND status = ? AND tenant_id = ?',
        whereArgs: [UserRole.halaqa.label, 'pending', tenantId],
        orderBy: 'created_at ASC',
      );
      return maps.map(SyncQueueModel.fromMap).toList();
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to get pending operations: ${e.toString()}',
      );
    }
  }

  @override
  Future<void> deleteCompletedOperation(int operationId) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      await _db.delete(
        _kPendingOperationsTable,
        where: 'id = ? AND tenant_id = ?',
        whereArgs: [operationId, tenantId],
      );
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to delete completed operation: ${e.toString()}',
      );
    }
  }

  /// Fetches a single halaqa by their ID from the local database.
  /// Returns a [HalaqaModel] if found, or throws a [CacheException] if   not.
  @override
  Future<HalaqaModel> getHalaqaById(String halaqaId) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = "${user!.id}";
    try {
      final maps = await _db.query(
        _kHalqasTable,
        where: 'uuid = ? AND isDeleted = ? AND tenant_id = ?',
        whereArgs: [halaqaId, 0, tenantId],
      );

      if (maps.isEmpty) {
        throw CacheException(message: 'Halaqa not found with ID: $halaqaId');
      }

      return HalaqaModel.fromMap(maps.first);
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to fetch halaqa by ID ($halaqaId): ${e.toString()}',
      );
    }
  }

  // =========================================================================
  //                       NEW: Filtered Query Methods
  // =========================================================================

  /// Formats a [DateTime] as 'YYYY-MM-DD' for SQLite date comparisons.
  String _fmt(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  /// Maps a [Frequency] value to its expected reporting interval in days.
  ///
  /// Used in the SQLite expression:
  ///   `CAST(ROUND(JULIANDAY(date) - JULIANDAY(FP.createdAt)) AS INTEGER) % interval = 0`
  static int _intervalDays(Frequency freq) {
    switch (freq) {
      case Frequency.daily:
        return 1;
      case Frequency.onceAWeek:
        return 7;
      case Frequency.twiceAWeek:
        return 3;
      case Frequency.thriceAWeek:
        return 2;
    }
  }

  @override
  Future<List<HalaqaModel>> getHalaqasByStudentCriteria({
    ActiveStatus? studentStatus,
    DateTime? trackDate,
    Frequency? frequencyCode,
    MonitoringFilter monitoringFilter = MonitoringFilter.all,
  }) async {
    final user = await _authLocalDataSource.getUser();
    final tenantId = '${user!.id}';

    // ── Base WHERE fragment applied to every query ──
    // Always restrict to non-deleted halaqas/students belonging to this tenant.
    final baseWhere = StringBuffer(
      'H.isDeleted = 0 AND H.tenant_id = ? '
      'AND U.roleId = ? AND U.isDeleted = 0 AND U.tenant_id = ?',
    );
    final baseArgs = <Object?>[tenantId, UserRole.student.id, tenantId];

    if (studentStatus != null) {
      baseWhere.write(' AND U.status = ?');
      baseArgs.add(studentStatus.label);
    }

    // ── Build the mode-specific SQL ──
    String sql;
    final whereArgs = <Object?>[...baseArgs];

    if (trackDate != null && frequencyCode != null) {
      final formattedDate = _fmt(trackDate);
      final interval = _intervalDays(frequencyCode);

      switch (monitoringFilter) {
        // ── المتوقع: حلقات تحتوي على طالب واحد على الأقل مجدول تقريره اليوم ──
        case MonitoringFilter.expected:
          sql = '''
            SELECT DISTINCT H.*
            FROM $_kHalqasTable H
            JOIN $_kHalqaStudentsTable HS
              ON H.id = HS.halqaId AND HS.isDeleted = 0 AND HS.tenant_id = H.tenant_id
            JOIN $_kUsersTable U
              ON HS.studentId = U.id
            JOIN $_kFollowUpPlansTable FP
              ON HS.id = FP.enrollmentId AND FP.isDeleted = 0 AND FP.tenant_id = H.tenant_id
            WHERE $baseWhere
              AND FP.frequency = ?
              AND CAST(ROUND(JULIANDAY(?) - JULIANDAY(FP.createdAt)) AS INTEGER) % ? = 0
            ORDER BY H.name ASC
          ''';
          whereArgs
            ..add(frequencyCode.id)
            ..add(formattedDate)
            ..add(interval);

        // ── المرسل: حلقات فيها طالب رفع تقريره فعلاً بالتاريخ ──
        case MonitoringFilter.sent:
          sql = '''
            SELECT DISTINCT H.*
            FROM $_kHalqasTable H
            JOIN $_kHalqaStudentsTable HS
              ON H.id = HS.halqaId AND HS.isDeleted = 0 AND HS.tenant_id = H.tenant_id
            JOIN $_kUsersTable U
              ON HS.studentId = U.id
            JOIN $_kFollowUpPlansTable FP
              ON HS.id = FP.enrollmentId AND FP.isDeleted = 0 AND FP.tenant_id = H.tenant_id
            JOIN $_kDailyTrackingTable DT
              ON HS.id = DT.enrollmentId AND DT.tenant_id = H.tenant_id
            WHERE $baseWhere
              AND FP.frequency = ?
              AND CAST(ROUND(JULIANDAY(?) - JULIANDAY(FP.createdAt)) AS INTEGER) % ? = 0
              AND DT.trackDate = ?
            ORDER BY H.name ASC
          ''';
          whereArgs
            ..add(frequencyCode.id)
            ..add(formattedDate)
            ..add(interval)
            ..add(formattedDate);

        // ── المتبقي: حلقات فيها طالب مجدول ولم يرفع تقريره بعد ──
        case MonitoringFilter.remaining:
          // A halaqa appears here when it has AT LEAST ONE student whose
          // report is due today but has NOT submitted yet.
          sql = '''
            SELECT DISTINCT H.*
            FROM $_kHalqasTable H
            JOIN $_kHalqaStudentsTable HS
              ON H.id = HS.halqaId AND HS.isDeleted = 0 AND HS.tenant_id = H.tenant_id
            JOIN $_kUsersTable U
              ON HS.studentId = U.id
            JOIN $_kFollowUpPlansTable FP
              ON HS.id = FP.enrollmentId AND FP.isDeleted = 0 AND FP.tenant_id = H.tenant_id
            WHERE $baseWhere
              AND FP.frequency = ?
              AND CAST(ROUND(JULIANDAY(?) - JULIANDAY(FP.createdAt)) AS INTEGER) % ? = 0
              AND U.id NOT IN (
                SELECT DISTINCT HS2.studentId
                FROM $_kDailyTrackingTable DT2
                JOIN $_kHalqaStudentsTable HS2 ON DT2.enrollmentId = HS2.id
                WHERE DT2.trackDate = ? AND DT2.tenant_id = ?
              )
            ORDER BY H.name ASC
          ''';
          whereArgs
            ..add(frequencyCode.id)
            ..add(formattedDate)
            ..add(interval)
            ..add(formattedDate)
            ..add(tenantId);

        // ── all: تجميع الحلقات بمعيار التكرار فقط ──
        case MonitoringFilter.all:
          sql = '''
            SELECT DISTINCT H.*
            FROM $_kHalqasTable H
            JOIN $_kHalqaStudentsTable HS
              ON H.id = HS.halqaId AND HS.isDeleted = 0 AND HS.tenant_id = H.tenant_id
            JOIN $_kUsersTable U
              ON HS.studentId = U.id
            JOIN $_kFollowUpPlansTable FP
              ON HS.id = FP.enrollmentId AND FP.isDeleted = 0 AND FP.tenant_id = H.tenant_id
            WHERE $baseWhere
              AND FP.frequency = ?
              AND CAST(ROUND(JULIANDAY(?) - JULIANDAY(FP.createdAt)) AS INTEGER) % ? = 0
            ORDER BY H.name ASC
          ''';
          whereArgs
            ..add(frequencyCode.id)
            ..add(formattedDate)
            ..add(interval);
      }
    } else {
      // ── Fallback: no schedule logic, filter by status / trackDate only ──
      String joins =
          'JOIN $_kHalqaStudentsTable HS ON H.id = HS.halqaId AND HS.isDeleted = 0 '
          'JOIN $_kUsersTable U ON HS.studentId = U.id ';

      if (trackDate != null) {
        joins +=
            'JOIN $_kDailyTrackingTable DT ON HS.id = DT.enrollmentId AND DT.tenant_id = H.tenant_id ';
        baseWhere.write(' AND DT.trackDate = ?');
        whereArgs.add(_fmt(trackDate));
      }

      sql = '''
        SELECT DISTINCT H.*
        FROM $_kHalqasTable H
        $joins
        WHERE $baseWhere
        ORDER BY H.name ASC
      ''';
    }

    try {
      final maps = await _db.rawQuery(sql, whereArgs);
      return maps.map((map) => HalaqaModel.fromMap(map)).toList();
    } on DatabaseException catch (e) {
      throw CacheException(
        message: 'Failed to fetch filtered halaqas from cache: ${e.toString()}',
      );
    }
  }
}
