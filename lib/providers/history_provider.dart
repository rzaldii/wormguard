import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/history_model.dart';
// import '../services/firestore_service.dart';
import 'sensor_provider.dart'; // untuk firestoreServiceProvider

final historyListProvider = StreamProvider<List<HistoryModel>>((ref) {
  final service = ref.watch(firestoreServiceProvider);
  return service.getHistoryStream().map((list) {
    return list.map((item) {
      return HistoryModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        type: item['type'] as String,
        value: (item['value'] as num).toDouble(),
        timestamp: item['timestamp'] as DateTime,
      );
    }).toList();
  });
});