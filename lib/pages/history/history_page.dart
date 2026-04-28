import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';

class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Riwayat')),
      body: historyAsync.when(
        data: (history) => ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: history.length,
          itemBuilder: (context, index) {
            final item = history[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(
                  item.type == 'soil' ? Icons.water_drop : Icons.science,
                  color: item.type == 'soil' ? Colors.blue : Colors.purple,
                ),
                title: Text(
                  item.type == 'soil'
                      ? 'Kelembaban: ${item.value.toStringAsFixed(1)}%'
                      : 'pH: ${item.value.toStringAsFixed(1)}',
                ),
                subtitle: Text('${item.timestamp.hour}:${item.timestamp.minute}'),
                trailing: Text('${item.timestamp.day}/${item.timestamp.month}'),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}