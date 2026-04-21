class SensorData {
  final String id;
  final double soilMoisture;
  final double ph;
  final DateTime timestamp;

  SensorData({
    required this.id,
    required this.soilMoisture,
    required this.ph,
    required this.timestamp,
  });

  factory SensorData.fromMap(Map<String, dynamic> map, String id) {
    return SensorData(
      id: id,
      soilMoisture: (map['soil_moisture'] ?? 0).toDouble(),
      ph: (map['ph'] ?? 7).toDouble(),
      timestamp: map['timestamp'] is DateTime 
          ? map['timestamp'] 
          : DateTime.parse(map['timestamp'].toString()),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soil_moisture': soilMoisture,
      'ph': ph,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  String get moistureStatus {
    if (soilMoisture < 40) return 'Kering';
    if (soilMoisture <= 70) return 'Normal';
    return 'Basah';
  }

  String get phStatus {
    if (ph < 6) return 'Asam';
    if (ph <= 7.5) return 'Netral';
    return 'Basa';
  }
}