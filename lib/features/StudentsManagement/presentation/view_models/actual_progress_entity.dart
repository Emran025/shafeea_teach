import '../../../../core/entities/tracking_unit.dart';
import '../../../../core/models/tracking_units.dart';

class ActualProgressEntity {
  final TrackingUnitTyps unit;
  final TrackingUnitDetail fromTrackingUnitId;
  final TrackingUnitDetail toTrackingUnitId;
  /// الكمية الفعلية المُنجزة محوَّلةً إلى وحدة الخطة (مثلاً: أجزاء أو أحزاب أو صفحات)
  final double actualAmount;
  const ActualProgressEntity({
    required this.unit,
    required this.fromTrackingUnitId,
    required this.toTrackingUnitId,
    required this.actualAmount,
  });
}
