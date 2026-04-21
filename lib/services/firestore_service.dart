import 'dart:async';
import '../models/sensor_model.dart';

class FirestoreService {
  Stream<SensorData> getLatestSensorData() {
    return Stream.periodic(const Duration(seconds: 3), (_) {
      return SensorData(
        id: 'sensor1',
        soilMoisture: 35 + (DateTime.now().second % 40).toDouble(),
        ph: 5.5 + (DateTime.now().second % 30) / 10,
        timestamp: DateTime.now(),
      );
    }).asBroadcastStream();
  }

  Stream<List<Map<String, dynamic>>> getHistoryStream() {
    return Stream.periodic(const Duration(seconds: 5), (_) {
      return List.generate(5, (index) {
        return {
          'type': index % 2 == 0 ? 'soil' : 'ph',
          'value': index % 2 == 0 ? 45.0 : 6.8,
          'timestamp': DateTime.now().subtract(Duration(minutes: index * 10)),
        };
      });
    });
  }
}