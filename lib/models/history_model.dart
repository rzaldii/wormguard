class HistoryModel {
  final String id;
  final String type; // 'soil', 'ph', 'spray'
  final double value;
  final DateTime timestamp;

  HistoryModel({
    required this.id,
    required this.type,
    required this.value,
    required this.timestamp,
  });
}