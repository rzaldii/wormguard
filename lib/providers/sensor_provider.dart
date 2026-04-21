import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sensor_model.dart';
import '../services/firestore_service.dart';

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  return FirestoreService();
});

final sensorDataProvider = StreamProvider<SensorData>((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getLatestSensorData();
});

final historyProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getHistoryStream();
});