import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/control_model.dart';

final controlProvider = StreamProvider<ControlModel>((ref) {
  final controlRef = FirebaseDatabase.instance.ref('wormguard/control');

  return controlRef.onValue.map((event) {
    final value = event.snapshot.value;

    if (value == null) {
      return ControlModel(
        isAuto: true,
        updatedAt: 0,
      );
    }

    final data = Map<dynamic, dynamic>.from(value as Map);

    return ControlModel.fromMap(data);
  });
});

final controlServiceProvider = Provider<ControlService>((ref) {
  return ControlService();
});

class ControlService {
  final DatabaseReference _controlRef =
      FirebaseDatabase.instance.ref('wormguard/control');

  Future<void> updateAuto(bool isAuto) async {
    await _controlRef.update({
      'is_auto': isAuto,
      'updated_at': ServerValue.timestamp,
    });
  }
}