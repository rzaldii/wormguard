import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/sensor_model.dart';

final sensorDataProvider = StreamProvider<SensorData>((ref) {
  final sensorRef = FirebaseDatabase.instance.ref('wormguard/latest');

  return sensorRef.onValue.map((event) {
    final value = event.snapshot.value;

    if (value == null) {
      throw Exception('Data sensor belum tersedia di Firebase');
    }

    final data = Map<dynamic, dynamic>.from(value as Map);

    return SensorData.fromMap(data, 'latest');
  });
});