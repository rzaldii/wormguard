class HistoryModel {
  final String id;
  final String type;
  final double beforeSoil;
  final double beforePh;
  final double afterSoil;
  final double afterPh;
  final int durationMs;
  final DateTime timestamp;

  HistoryModel({
    required this.id,
    required this.type,
    required this.beforeSoil,
    required this.beforePh,
    required this.afterSoil,
    required this.afterPh,
    required this.durationMs,
    required this.timestamp,
  });
}