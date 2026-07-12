import '../constants/tracking_unit_cache.dart';
import '../entities/tracking_unit.dart';

class TrackingUnitDetailModel {
  final int id;
  final int unitId;

  /// Arabic name of the surah where this unit starts (from [Sora.Name_ar]).
  final String fromSurahName;
  final int fromPage;
  final int fromAyah;

  /// Arabic name of the surah where this unit ends (from [Sora.Name_ar]).
  final String toSurahName;
  final int toPage;
  final int toAyah;

  TrackingUnitDetailModel({
    required this.id,
    required this.unitId,
    required this.fromSurahName,
    required this.fromPage,
    required this.fromAyah,
    required this.toSurahName,
    required this.toPage,
    required this.toAyah,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'unitId': unitId,
      'fromSurah': fromSurahName,
      'fromPage': fromPage,
      'fromAyah': fromAyah,
      'toSurah': toSurahName,
      'toPage': toPage,
      'toAyah': toAyah,
    };
  }

  factory TrackingUnitDetailModel.fromEntity(
    TrackingUnitDetail trackingUnitDetail,
  ) {
    return TrackingUnitDetailModel(
      id: trackingUnitDetail.id,
      unitId: trackingUnitDetail.unitId,
      fromSurahName: trackingUnitDetail.fromSurahName,
      fromPage: trackingUnitDetail.fromPage,
      fromAyah: trackingUnitDetail.fromAyah,
      toSurahName: trackingUnitDetail.toSurahName,
      toPage: trackingUnitDetail.toPage,
      toAyah: trackingUnitDetail.toAyah,
    );
  }

  /// Returns the unit at 0-based [trackingUnitDetailId] from the runtime cache.
  factory TrackingUnitDetailModel.fromId(int trackingUnitDetailId) {
    return TrackingUnitCache.instance.byIndex(trackingUnitDetailId);
  }

  /// Returns the unit [trackingUnitDetailId] steps ahead of this one.
  TrackingUnitDetailModel getNext({int trackingUnitDetailId = 1}) {
    return TrackingUnitCache.instance.byIndex(trackingUnitDetailId + id);
  }

  TrackingUnitDetail toEntity() {
    return TrackingUnitDetail(
      id: id,
      unitId: unitId,
      fromSurahName: fromSurahName,
      fromPage: fromPage,
      fromAyah: fromAyah,
      toSurahName: toSurahName,
      toPage: toPage,
      toAyah: toAyah,
    );
  }

  factory TrackingUnitDetailModel.fromJson(Map<String, dynamic> json) {
    return TrackingUnitDetailModel(
      id: json['id'] as int,
      unitId: json['unitId'] as int,
      fromSurahName: json['fromSurah'] as String,
      fromPage: json['fromPage'] as int,
      fromAyah: json['fromAyah'] as int,
      toSurahName: json['toSurah'] as String,
      toPage: json['toPage'] as int,
      toAyah: json['toAyah'] as int,
    );
  }
  factory TrackingUnitDetailModel.fromMap(Map<String, dynamic> map) {
    return TrackingUnitDetailModel(
      id: map['id'] as int,
      unitId: map['unit_id'] as int,
      fromSurahName: (map['from_surah_name'] as String? ?? '').replaceAll(
        'ۡ',
        'ْ',
      ),
      fromPage: map['from_page'] as int,
      fromAyah: map['from_ayah'] as int,
      toSurahName: (map['to_surah_name'] as String? ?? '').replaceAll('ۡ', 'ْ'),
      toPage: map['to_page'] as int,
      toAyah: map['to_ayah'] as int,
    );
  }
}
