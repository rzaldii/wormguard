import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/history_provider.dart';

class HistoryPage extends ConsumerStatefulWidget {
  const HistoryPage({super.key});

  @override
  ConsumerState<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends ConsumerState<HistoryPage> {
  static const Color _brown = Color(0xFF8B6B54);
  static const Color _bgGrey = Color(0xFFF0F0F0);

  int _selectedTab = 0;
  final List<String> _tabs = ['Penyemprotan air', 'Kelembaban tanah', 'pH Air'];

  @override
  Widget build(BuildContext context) {
    final historyAsync = ref.watch(historyListProvider);

    return Scaffold(
      backgroundColor: _bgGrey,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
              ),
            ),

            // ── Title ──
            const SizedBox(height: 12),
            const Text(
              'Riwayat',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: _brown,
              ),
            ),
            Text(
              'WormGuard',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[500],
                letterSpacing: 0.5,
              ),
            ),

            const SizedBox(height: 16),

            // ── Tab filter ──
            SizedBox(
              height: 36,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 7),
                itemCount: _tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 5),
                itemBuilder: (_, i) {
                  final selected = i == _selectedTab;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: selected ? _brown : Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: selected ? _brown : Colors.grey[300]!,
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _tabs[i],
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: selected ? Colors.white : Colors.black54,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── Content ──
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: historyAsync.when(
                  data: (history) {
                    final filtered = _filterHistory(history);
                    return Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: filtered.isEmpty
                          ? _buildEmpty()
                          : ListView.separated(
                              padding: const EdgeInsets.all(16),
                              itemCount: filtered.length,
                              separatorBuilder: (_, __) => Divider(
                                color: Colors.grey[100],
                                height: 1,
                              ),
                              itemBuilder: (_, i) => _buildItem(filtered[i]),
                            ),
                    );
                  },
                  loading: () => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  error: (err, _) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(child: Text('Error: $err')),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  List<dynamic> _filterHistory(List<dynamic> history) {
    switch (_selectedTab) {
      case 0: // Penyemprotan air
        return history.where((e) => e.type == 'pump').toList();
      case 1: // Kelembaban tanah
        return history.where((e) => e.type == 'soil').toList();
      case 2: // pH Air
        return history.where((e) => e.type == 'ph').toList();
      default:
        return history;
    }
  }

  Widget _buildItem(dynamic item) {
    final isSoil = item.type == 'soil';
    final isPh = item.type == 'ph';
    final isPump = item.type == 'pump';

    Color iconColor;
    IconData iconData;
    String label;

    if (isSoil) {
      iconColor = Colors.blue;
      iconData = Icons.water_drop_outlined;
      label = 'Kelembaban: ${item.value.toStringAsFixed(1)}%';
    } else if (isPh) {
      iconColor = Colors.purple;
      iconData = Icons.science_outlined;
      label = 'pH: ${item.value.toStringAsFixed(1)}';
    } else {
      iconColor = const Color(0xFF44824F);
      iconData = Icons.power_settings_new_rounded;
      label = 'Pompa: ${item.value == 1 ? "ON" : "OFF"}';
    }

    final time = item.timestamp as DateTime;
    final timeStr =
        '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    final dateStr = '${time.day}/${time.month}/${time.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(iconData, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                timeStr,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Text(
                dateStr,
                style: TextStyle(fontSize: 11, color: Colors.grey[400]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 8),
          Text(
            'Belum ada riwayat',
            style: TextStyle(color: Colors.grey[400], fontSize: 14),
          ),
        ],
      ),
    );
  }
}