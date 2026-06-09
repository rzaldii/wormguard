import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:listview/models/notification_model.dart';

import '../models/sensor_model.dart';
import '../services/fcm_service.dart';
import 'sensor_provider.dart';

final sensorAlertProvider = Provider<void>((ref) {
  bool wasSoilAbnormal = false;
  bool wasPhAbnormal = false;

  void addNotificationToPage({
    required String title,
    required String description,
    required String standard,
    required IconData icon,
    bool isPh = false,
  }) {
    final notif = NotificationItem(
      title: title,
      description: description,
      standard: standard,
      icon: icon,
      isPh: isPh,
    );

    ref.read(notificationProvider.notifier).update((state) {
      return [notif, ...state];
    });
  }

  ref.listen<AsyncValue<SensorData>>(sensorDataProvider, (previous, next) {
    next.whenData((data) async {
      final soil = data.soilMoisture;
      final ph = data.ph;

      if (soil <= 0 || ph <= 0) return;

      final isSoilAbnormal = soil < 50;
      final isPhAbnormal = ph < 6 || ph > 7.5;

      // Kelembaban: notif hanya saat normal -> tidak normal
      if (isSoilAbnormal && !wasSoilAbnormal) {
        final title = 'Peringatan Kelembaban';
        final body = 'Kelembaban tanah rendah: ${soil.toStringAsFixed(0)}%';

        await FcmService.showLocalAlert(
          title: title,
          body: body,
        );

        addNotificationToPage(
          title: title,
          description: body,
          standard: 'Standar normal: 50% - 60%',
          icon: Icons.water_drop_outlined,
          isPh: false,
        );
      }

      // Reset kalau sudah normal lagi
      wasSoilAbnormal = isSoilAbnormal;

      // pH: notif hanya saat normal -> tidak normal
      if (isPhAbnormal && !wasPhAbnormal) {
        final status = ph < 6 ? 'terlalu asam' : 'terlalu basa';

        final title = 'Peringatan pH Air';
        final body = 'pH air $status: ${ph.toStringAsFixed(2)}';

        await FcmService.showLocalAlert(
          title: title,
          body: body,
        );

        addNotificationToPage(
          title: title,
          description: body,
          standard: 'Standar normal: pH 6.0 - 7.5',
          icon: Icons.science_outlined,
          isPh: true,
        );
      }

      // Reset kalau sudah normal lagi
      wasPhAbnormal = isPhAbnormal;
    });
  });
});