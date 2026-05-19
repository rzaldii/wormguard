import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/history_model.dart';

DateTime _parseTimestamp(dynamic raw) {
  if (raw == null) return DateTime.now();

  final value = raw is int ? raw : int.tryParse(raw.toString());

  if (value == null || value <= 0) return DateTime.now();

  if (value > 1000000000000) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  }

  if (value > 1000000000) {
    return DateTime.fromMillisecondsSinceEpoch(value * 1000);
  }

  return DateTime.now();
}

double _toDouble(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString()) ?? 0;
}

int _toInt(dynamic value) {
  if (value == null) return 0;
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value.toString()) ?? 0;
}

final historyListProvider = StreamProvider<List<HistoryModel>>((ref) {
  final historyRef = FirebaseDatabase.instance.ref('wormguard/history');

  return historyRef.onValue.map((event) {
    final value = event.snapshot.value;

    if (value == null) return [];

    final data = Map<dynamic, dynamic>.from(value as Map);
    final List<HistoryModel> historyList = [];

    data.forEach((key, value) {
      final item = Map<dynamic, dynamic>.from(value as Map);

      historyList.add(
        HistoryModel(
          id: key.toString(),
          type: item['type']?.toString() ?? 'spray',
          beforeSoil: _toDouble(item['beforeSoil']),
          beforePh: _toDouble(item['beforePh']),
          afterSoil: _toDouble(item['afterSoil']),
          afterPh: _toDouble(item['afterPh']),
          durationMs: _toInt(item['durationMs']),
          timestamp: _parseTimestamp(item['timestamp']),
        ),
      );
    });

    historyList.sort((a, b) => b.timestamp.compareTo(a.timestamp));

    return historyList;
  });
});