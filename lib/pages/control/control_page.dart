import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/control_provider.dart';
import '../../widgets/custom_card.dart';
import '../../models/control_model.dart';  // <-- Tambahkan ini

class ControlPage extends ConsumerWidget {
  const ControlPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final control = ref.watch(controlProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Kontrol Perangkat')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomCard(
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Mode Otomatis'),
                    subtitle: Text(control.isAuto ? 'Aktif' : 'Manual'),
                    value: control.isAuto,
                    onChanged: (val) {
                      ref.read(controlProvider.notifier).state = 
                          ControlModel(isAuto: val, pumpStatus: control.pumpStatus);
                    },
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Status Pompa'),
                    trailing: Switch(
                      value: control.pumpStatus,
                      onChanged: control.isAuto 
                          ? null 
                          : (val) {
                              ref.read(controlProvider.notifier).state = 
                                  ControlModel(isAuto: control.isAuto, pumpStatus: val);
                            },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}