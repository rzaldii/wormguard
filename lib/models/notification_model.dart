import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NotificationItem {
  final String title;
  final String description;
  final String standard;
  final IconData icon;
  final bool isPh;

  const NotificationItem({
    required this.title,
    required this.description,
    required this.standard,
    required this.icon,
    this.isPh = false,
  });
}

// Provider global untuk daftar notifikasi
final notificationProvider =
    StateProvider<List<NotificationItem>>((ref) => []);
