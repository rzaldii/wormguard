class SensorData {
  final String id;
  final double soilMoisture;
  final double ph;
  final bool pump;
  final int timestamp;

  SensorData({
    required this.id,
    required this.soilMoisture,
    required this.ph,
    required this.pump,
    required this.timestamp,
  });

  factory SensorData.fromMap(Map<dynamic, dynamic> map, String id) {
    return SensorData(
      id: id,
      soilMoisture: (map['soil'] ?? 0).toDouble(),
      ph: (map['ph'] ?? 7).toDouble(),
      pump: map['pump'] ?? false,
      timestamp: map['timestamp'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'soil': soilMoisture,
      'ph': ph,
      'pump': pump,
      'timestamp': timestamp,
    };
  }

  String get moistureStatus {
    if (soilMoisture < 50) return 'Kering';
    if (soilMoisture <= 60) return 'Normal';
    return 'Basah';
  }

  String get phStatus {
    if (ph < 6) return 'Asam';
    if (ph <= 7.5) return 'Netral';
    return 'Basa';
  }

  String get pumpStatus {
    return pump ? 'ON' : 'OFF';
  }
}