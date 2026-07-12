class TrackingUnitDetail {
  final int id;
  final int unitId;
  final String fromSurahName;
  final int fromPage;
  final int fromAyah;
  final String toSurahName;
  final int toPage;
  final int toAyah;

  TrackingUnitDetail({
    required this.id,
    required this.unitId,
    required this.fromSurahName,
    required this.fromPage,
    required this.fromAyah,
    required this.toSurahName,
    required this.toPage,
    required this.toAyah,
  });
}
